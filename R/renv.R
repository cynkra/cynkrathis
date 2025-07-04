#' Initialize renv infrastructure (cynkra way)
#'
#' @description
#' `r lifecycle::badge('experimental')`
#'
#' Initializes renv setup by setting a predefined RStudio Package
#' Manager (RSPM) snapshot.
#' Custom RSPM Snapshots can be configured via `snapshot_date`.
#'
#' @param snapshot_date `[Date]`\cr
#'   A valid RSPM snapshot date. By default the "recommended" date from
#'   `get_snapshots()` for the respective R version is chosen.
#' @param exclude `[character]`\cr
#'   Packages to exclude from `renv::install()`.
#'   Useful if a package is not available in the available repositories
#'   (check with `getOption("repos"`) to prevent `init_renv()` to fail.
#'   This should only be a temporary workaround - consider making local
#'   packages available in a minicran-like repository.
#' @param convenience_pkgs `[logical]`\cr
#'   Install additional opinionated convenience packages?
#'   The following packages would be installed:
#'
#'   - usethis
#'   - styler
#'   - gert
#'   - krlmlr/fledge
#'
#' @details
#' During the process, the latest CRAN version of renv will be installed,
#' regardless of the chosen snapshot ID.
#'
#' The heuristic for setting the correct RSPM binary repo currently only supports
#' Windows, macOS and Ubuntu 20.04.
#'
#' The initialization mostly runs in clean vanilla sessions started with
#' [callr::r_vanilla()].
#'
#' @importFrom utils tail available.packages
#' @importFrom rstudioapi restartSession
#' @examples
#' \dontrun{
#' init_renv()
#' }
#' @export
init_renv <- function(
    snapshot_date = NULL,
    exclude = NULL,
    convenience_pkgs = FALSE) {
  # clean any leftover renv artifacts (and .RProfile)
  unlink(c(".RProfile", "renv.lock", ".Renviron"))
  unlink("renv/", recursive = TRUE)

  # valid R versions are stored in snapshots/
  snapshots <- get_snapshots()
  valid_dates <- as.character(snapshots$date)

  # if no snapshot is given, infer it from the used R version
  if (is.null(snapshot_date)) {
    # get R version from current session
    r_version <- paste(R.Version()$major, R.Version()$minor, sep = ".")
    snapshot_date <- snapshots[
      snapshots$r_version == r_version &
        snapshots$type == "recommended",
      "date"
    ]
  }

  # assertions -----------------------------------------------------------------

  checkmate::assert_subset(as.character(snapshot_date), valid_dates)
  checkmate::assert_character(
    as.character(snapshot_date),
    len = 1,
    pattern = "[0-9]{4}-[0-9]{2}-[0-9]{2}"
  )

  # renv init ------------------------------------------------------------------

  # hard to set the correct binary path for all systems
  # on non-linux systems we default to https://packagemanager.rstudio.com/cran/
  # and on Linux systems we assume Ubuntu 20.04

  if (Sys.info()[["sysname"]] != "Linux") {
    repos <- c(
      CRAN = glue::glue(
        "https://packagemanager.rstudio.com/cran/{snapshot_date}"
      ) # nolint
    )
  } else {
    repos <- c(
      CRAN = glue::glue(
        "https://packagemanager.rstudio.com/cran/__linux__/focal/{snapshot_date}"
      ) # nolint
    )
  }

  # Necessary if we're already in an renv session
  local_remove_renv_envvars()

  # always install latest renv version
  av_pkgs <- utils::available.packages(
    repos = "https://packagemanager.rstudio.com/cran/latest"
  ) # nolint
  renv_latest <- av_pkgs[rownames(av_pkgs) == "renv", "Version"]

  cli::cli_alert_info("Scaffolding with repos = {.url {repos}}") # nolint
  renv::scaffold(project = ".", repos = repos)

  # Install the correct renv version in a new session
  cli::cli_alert_info("Starting R session to bootstrap {.package renv}") # nolint
  # https://github.com/r-lib/callr/issues/194
  callr::r_vanilla(
    user_profile = FALSE,
    show = TRUE,
    install_github_renv,
    args = list(
      renv_latest = renv_latest
    )
  )

  cli::cli_alert_info("Finalizing initialization of renv") # nolint
  callr::r_vanilla(
    user_profile = FALSE,
    show = TRUE,
    finish_init_renv,
    args = list(
      exclude = exclude,
      convenience_pkgs = convenience_pkgs,
      renv_latest = renv_latest
    )
  )

  if (Sys.getenv("RSTUDIO") == 1) {
    rstudioapi::restartSession()
  }
}

# Called in a fresh vanilla R session
install_github_renv <- function(renv_latest) {
  source(".Rprofile")

  renv::install(paste0("rstudio/renv@", renv_latest))
  renv::snapshot()
}

# Called in a fresh vanilla R session
finish_init_renv <- function(exclude, convenience_pkgs, renv_latest) {
  source(".Rprofile")

  # print projects renv path: Problem: The library needs to be empty, otherwise
  # the wrong versions are stored in it (from previous renv inits)
  # renv_dir <- .libPaths()[1]
  # unlink(renv_dir, recursive = TRUE)
  # dir.create(renv_dir, recursive = TRUE, showWarnings = FALSE)

  # check if any .Rmd files exist to detect dependencies in .Rmd files via renv
  if (length(list.files(pattern = ".Rmd", recursive = TRUE) > 0)) {
    # Can't use cli here
    message("Installing rmarkdown to scrape dependencies in .Rmd files.") # nolint
    renv::install("rmarkdown")
  }

  # scrape dependencies of project and install them
  # FIXME this can be done better
  deps <- renv::dependencies(errors = "reported", dev = TRUE)$Package
  unavailable <- setdiff(deps, rownames(available.packages()))
  if (!all(unavailable %in% exclude)) {
    message(
      "Also excluding unavailable packages: ",
      paste0(setdiff(unavailable, exclude), collapse = ", ")
    )
    exclude <- unique(c(exclude, unavailable))
  }

  if (convenience_pkgs) {
    deps <- append(
      deps,
      c("usethis", "styler", "gert", "cynkra/fledge")
    )
  }

  if (!is.null(exclude)) {
    deps <- setdiff(deps, exclude)
  }

  # Avoid reinstalling renv
  deps <- setdiff(deps, "renv")

  renv::install(deps)

  message("Snapshotting installed packages.")
  renv::snapshot(prompt = FALSE)

  renv::rehash(prompt = FALSE)
}

local_remove_renv_envvars <- function(.local_envir = parent.frame()) {
  bad_env <-
    c(
      "RENV_PROJECT",
      "R_LIBS_USER"
    )
  new <- rlang::set_names(rlang::rep_along(bad_env, NA_character_), bad_env)

  withr::local_envvar(new, .local_envir = .local_envir)
}

#' Switch between R versions in renv projects
#' @importFrom checkmate assert_character
#' @importFrom rstudioapi restartSession
#' @importFrom cli cli_alert
#' @description This function switches between R versions in renv projects
#' which follow the 'cynkra RSPM snapshot' logic.
#' This means that each R version is tied to a specific RSPM snapshot.
#'
#' The function executes the following tasks:
#'
#' - Replace the R Version in `renv.lock`.
#' - Replace the RSPM snapshot in `renv.lock` with the one associated with the
#'   selected R Version.
#' - (optional) execution of `renv::update()`.
#' - (optional) execution of `renv::snapshot()`.
#'
#' @param version `[character]`\cr
#'   The R version to upgrade to.
# @param update_packages `[logical]`\cr
#   Whether to update all packages to the new RSPM snapshot via
#  `renv::update()`.
# @param snapshot `[logical]`\cr
#   Whether to call `renv::snapshot()` after all packages have been updated.
# @details
#  When downgrading, the optional calls to `renv::update()` and
#  `renv::snapshot()` will not be executed
#  (even if specified via their arguments.)
#  Currently there is no easy way to downgrade all packages in renv projects
#  to a specific RSPM snapshot.
#  This should be a niche case anyhow and it is unclear if this will ever be
#  supported.
#  Note that this is different from restoring packages with renv per se for
#  which `renv::restore()` should be used.
#'
#' @seealso get_snapshots
#' @return TRUE (invisibly)
#' @export
#' @examples
#' \dontrun{
#' renv_switch_r_version("4.0.4")
#' }
renv_switch_r_version <- function(
    version = NULL
    # update_packages = FALSE,
    # snapshot = FALSE
    ) {
  # assertions
  checkmate::assert_character(
    version,
    len = 1,
    pattern = "[0-9][.][0-9][.][0-9]"
  )

  # check if we downgrade
  # r_version_local <- as.numeric(gsub(
  #   "[.]", "",
  #   paste(R.Version()$major, R.Version()$minor, sep = ".")
  # ))
  # r_version_new <- as.numeric(gsub("[.]", "", version))
  # if (r_version_new < r_version_local) {
  #   downgrade <- TRUE
  # } else {
  #   downgrade <- FALSE
  # }

  # check if renv.lock exists
  if (!file.exists("renv.lock")) {
    cli::cli_alert_danger(
      "We could not find an {.file renv.lock} file in the
    current working directory:

    {.file {getwd()}}

    Is this project using 'renv'?",
      wrap = TRUE
    )
    stop("No renv.lock found.")
  }

  cli::cli_alert("Replacing R Version and RSPM snapshot in {.file renv.lock}.")

  renvlock <- readLines("renv.lock")

  # replace R version
  renvlock[3] <- sprintf("    \"Version\": \"%s\",", version)

  snapshots <- get_snapshots()
  new_snapshot <- as.character(snapshots[
    snapshots$r_version == version &
      snapshots$type == "recommended",
    c("date")
  ])
  # replace RSPM snapshot
  renvlock[6:7] <- c(
    "        \"Name\": \"CRAN\",",
    sprintf(
      "        \"URL\": \"https://packagemanager.rstudio.com/cran/%s\"",
      new_snapshot
    )
  )

  cli::cli_alert_success("New R Version: {.field {version}}.")
  cli::cli_alert_success("New RSPM snapshot: {.field {new_snapshot}}.")

  writeLines(renvlock, "renv.lock")

  # FIXME this somehow causes "error occured during transmission" errors
  # if (requireNamespace("rstudioapi", quietly = TRUE)) {
  #   rstudioapi::restartSession()
  # }

  # when downgrading we do not call renv::update() or renv::snapshot()
  # if (downgrade) {
  #   cli::cli_alert_info("Detected a version downgrade.
  #   When downgrading, automatic package updates and snapshotting are not
  #   available.
  #   R packages need to be re-installed manually.", wrap = TRUE)
  # } else {
  #   if (update_packages) {
  #     cli::cli_alert("Calling {.fun renv::update} to update/downgrade all
  #     packages to the new RSPM snapshot.", wrap = TRUE)
  #     renv::update(prompt = FALSE)
  #   } else {
  #     cli::cli_alert_info("Don't forget to lift update your packages to the
  #     new RSPM snapshot via {.fun renv::update}.", wrap = TRUE)
  #   }
  #
  #   if (snapshot) {
  #     cli::cli_alert("Calling {.fun renv::snapshot} to record the changed
  #     packages in {.file renv.lock}.", wrap = TRUE)
  #     renv::snapshot(prompt = FALSE)
  #   } else {
  #     cli::cli_alert_info("Don't forget to snapshot your recent changes
  #     by calling {.fun renv::snapshot}.", wrap = TRUE)
  #   }
  # }

  return(invisible(TRUE))
}

#' @title Build a local package and install it into an renv project
#' @description
#'
#' `r lifecycle::badge('experimental')`
#'
#' This is a wrapper around `pkgbuild::build()` and `renv::install()` to more
#' easily make local packages available within \pkg{renv} projects.
#'
#' The following steps are performed:
#'
#' 1. Building the package found at argument `path` via `pkgbuild::build()`.
#' 2. Moving the built source into the \pkg{renv} cache. The cache location is
#' determined by `Sys.getenv("RENV_PATHS_LOCAL")`.
#' 3. Installing the package from the cache location via `renv::install()`.
#' @param path `[character]`\cr
#'   The path to the package which should be built and installed.
#' @param quiet `[logical]`\cr
#'   Whether to suppress console output.
#' @param ... \cr
#'   Passed down to `pkgbuild::build()`.
#' @importFrom renv install
#' @export
renv_install_local <- function(path = ".", quiet = FALSE, ...) {
  if (path == ".") {
    path <- usethis::proj_get()
  }

  # this gets the root paths dynamically on each OS and honors renv env vars
  # like RENV_PATHS_LOCAL
  renv_local <- renv::paths$root()

  dir.create(renv_local, showWarnings = FALSE, recursive = TRUE)

  pkg_name <- desc::desc_get_field("Package")

  if (quiet) {
    cli::cli_alert_info(
      "Building package {.field {pkg_name}} and
      installing into {.field {renv_local}}.",
      wrap = TRUE
    )
  }
  pkg_source <- pkgbuild::build(
    path,
    dest_path = renv_local,
    quiet = quiet,
    ...
  )

  renv::install(pkg_source)
}

#' Downgrade an renv project to a specific RSPM snapshot
#'
#' @description
#'   `r lifecycle::badge('experimental')`
#'
#'   This functions aims to be used within a "snapshot-centered project
#'   workflow" and can be used to downgrade all packages to an RSPM snapshot listed in
#'   `renv.lock`.
#'
#'   While the main purpose is downgrade packages which exist in a higher
#'   version, this function can also be used to restore a clean state of the
#'   project library outside of a downgrade scenario.
#'   Be aware of the handling of packages installed from remote sources (see
#'   section "Downgrading behavior").
#'
#'   Under the hood, it records all packages installed in the `renv` project
#'   library and restores these with the RSPM snapshot found in Line 7 of
#'   `renv.lock`.
#'
#' @section Downgrading behavior 🚧️:
#'
#' There are important differences to be aware of when downgrading packages with respect to
#' their installation source:
#'
#' 1. If a package is not available on CRAN, `renv_downgrade()` will restore the
#' version from the remote source just fine.
#' 2. If a package is available on CRAN and a remote snapshot (e.g. from GitHub)
#' was referenced in `renv.lock`, `renv_downgrade()` will downgrade this package
#' to its CRAN version of the respective snapshot and **not** keep the remote
#' snapshot version.
#'
#' @return Called for its side-effect.
#' @export
#' @seealso renv_switch_r_version()
#'
#' @examples
#' \dontrun{
#' renv_downgrade()
#' }
renv_downgrade <- function() {
  requireNamespace("renv", quietly = TRUE)

  # check if renv.lock exists
  checkmate::assert_file("renv.lock")

  # to ensure repos is set correctly
  source(".Rprofile")

  # list all packages from renv library (should always be the renv lib
  # if renv.lock exists)
  installed_pkgs <- unname(utils::installed.packages(
    lib.loc = .libPaths()[1]
  )[, "Package"])

  # check only available packages on 'repos' set to avoid download failures
  # for non-avail pkgs (e.g. GitHub packages)
  avail_pkgs <- available.packages()[, "Package"]
  non_avail <- setdiff(installed_pkgs, avail_pkgs)
  # also include "recommended" pkgs as otherwise deployments to RSC may fail
  # e.g. if a recommended package version does not align with the RSPM
  # snapshot on RSC
  pkgs_to_install <- setdiff(
    c(
      installed_pkgs,
      names(which(
        available.packages(
          repos = c(CRAN = "https://cran.r-project.org")
        )[, "Priority"] ==
          "recommended",
      ))
    ),
    non_avail
  )

  snapshot_date <- stringr::str_extract(
    readLines("renv.lock", n = 7)[7],
    "[0-9]{4}-[0-9]{2}-[0-9]{2}"
  )
  cli::cli_alert_info(
    "Reinstalling all packages using RSPM snapshot
    {.field {snapshot_date}}.",
    wrap = TRUE
  )

  renv::install(pkgs_to_install)

  cli::cli_alert_success(
    "Successfully rebased all packages to RSPM snapshot
    {.field {snapshot_date}}.",
    wrap = TRUE
  )
  cli::cli_alert(
    "Now call {.fun renv::snapshot} to record the new package
    versions in {.file renv.lock}.",
    wrap = TRUE
  )
}
