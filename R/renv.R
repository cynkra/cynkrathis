#' Init renv infrastructure (cynkra way)
#'
#' @description Initializes {renv} setup by setting a predefined RStudio Package
#' Manager (RSPM) snapshot.
#' Optionally more 'minicran' repositories can be configured via argument
#' `additional_repos`.
#' Custom RSPM Snapshots can be configured via `snapshot_date`.
#'
#' @param snapshot_date `[integer]`\cr
#'   A valid RSPM snapshot ID. By default the latest valid ID is chosen.
#'   List of valid IDs: TBD.
#' @param additional_repos `[named character]`\cr
#'   Additional repos besides the RSPM one.
#'   Must be a named character vector.
#' @param local_packages `[list]`\cr
#'   Packages to exclude from the `renv::install()` call and to install
#'   from local sources.
#'   Needs the package name and an explicit version.
#'   This is useful for local package sources used in the project which are not
#'   available in one of the repos configured in the project.
#' @param exclude_local `[named character]`\cr
#'   Local packages to exclude from `renv::install()`.
#'   Required if the package is only available locally.
#'   If `local_packages` was set, this argument can be ignored.
#' @details
#' During the process, the latest CRAN version of {renv} will be installed,
#' regardless of the chose snapshot ID.
#' @importFrom utils tail available.packages
#' @importFrom rstudioapi restartSession
#' @examples
#' \dontrun{
#' init_renv(
#'   snapshot_date = "2020-10-13",
#'   additional_repos = c(e360 = "https://analytics.energie360.ch/drat"),
#'   local_packages = structure(c(foo = "0.1.0", foo2 = "0.2.1"))
#' )
#' }
#' @export
init_renv <- function(snapshot_date = NULL,
                      additional_repos = NULL,
                      local_packages = NULL,
                      exclude_local = NULL) {

  # clean any leftover renv artifacts (and .RProfile)
  unlink(c(".RProfile", "renv.lock", ".Renviron"))
  unlink("renv/", recursive = TRUE)

  # valid R versions are stored in snapshots/
  snapshots <- get_valid_snapshots()
  valid_dates <- as.character(snapshots$date)

  if (is.null(snapshot_date)) {
    # get R version from current session
    r_version <- paste(R.Version()$major, R.Version()$minor, sep = ".")
    snapshot_date <- snapshots[snapshots$r_version == r_version, "date"]
  }

  # assertions -----------------------------------------------------------------
  if (!is.null(additional_repos)) {
    checkmate::assert_character(additional_repos, names = "named")
  }
  checkmate::assert_subset(snapshot_date, valid_dates)
  checkmate::assert_character(snapshot_date,
    len = 1,
    pattern = "[0-9]{4}-[0-9]{2}-[0-9]{2}"
  )
  checkmate::assert_named(local_packages)

  # renv init ------------------------------------------------------------------
  renv::init(
    bare = TRUE,
    restart = FALSE,
    settings = list(
      repos = c(
        CRAN = glue::glue("https://packagemanager.rstudio.com/cran/{snapshot_date}"), # nolint
        additional_repos
      )
    )
  )

  options(repos = c(
    CRAN = glue::glue("https://packagemanager.rstudio.com/cran/{snapshot_date}"), # nolint
    additional_repos
  ))

  # FIXME: check if we can make this better
  # otherwise new installations won't use the configured snapshot
  # write repos to .Rprofile
  if (!is.null(additional_repos)) {
    txt <- glue::glue('options(repos = c(
    CRAN = "https://packagemanager.rstudio.com/cran/{snapshot_date}",
    {names(additional_repos)} = "{additional_repos}"
))', .trim = FALSE)
  } else {
    txt <- glue::glue('options(repos = c(
    CRAN = "https://packagemanager.rstudio.com/cran/{snapshot_date}"
))\n')
  }
  cat(txt, file = ".Rprofile")

  # print projects renv path: Problem: The library needs to be empty, otherwise
  # the wrong versions are stored in it (from previous renv inits)
  renv_dir <- .libPaths()[1]
  unlink(renv_dir, recursive = TRUE)
  dir.create(renv_dir, recursive = TRUE, showWarnings = FALSE)

  # check if any .Rmd files exist to detect dependencies in .Rmd files via renv
  if (length(list.files(pattern = ".Rmd", recursive = TRUE) > 0)) {
    cli::cli_alert_info("Installing {.pkg rmarkdown} to scrape dependencies in .Rmd files.") # nolint
    renv::install("rmarkdown")
  }

  # FIXME:
  # place for default packages here that we want to have in every project, even
  # though they might not be used in scripts
  # - usethis
  # - styler
  # - gert

  # scrape dependencies of project and install them
  deps <- unique(renv::dependencies(progress = FALSE)$Package)

  if (!is.null(local_packages)) {
    deps <- setdiff(deps, names(local_packages))
  }
  if (!is.null(exclude_local)) {
    deps <- setdiff(deps, exclude_local)
  }
  renv::install(deps)

  # update renv
  av_pkgs <- utils::available.packages(repos = "https://packagemanager.rstudio.com/cran/latest") # nolint
  renv_latest <- av_pkgs[rownames(av_pkgs) == "renv", "Version"]

  renv::snapshot(prompt = FALSE)

  if (!is.null(local_packages)) {
    pkgs <- names(local_packages)
    versions <- local_packages
    purrr::walk2(pkgs, versions, ~ {
      renv::install(glue::glue("{.x}@{.y}"))
      renv::record(rlang::list2(!!.x := list(
        Package = .x,
        Version = .y,
        Source = "Local"
      )))
    })
  }

  renv::upgrade(version = renv_latest, prompt = FALSE)

  renv::restore(prompt = FALSE)
  renv::rehash(prompt = FALSE)

  if (Sys.getenv("RSTUDIO") == 1) {
    rstudioapi::restartSession()
  }
}

#' Switch between R versions in renv projects
#' @importFrom checkmate assert_character
#' @importFrom rstudioapi restartSession
#' @importFrom cli cli_alert
#' @description This function switches between R versions in renv projects
#' which follow the 'cynkra RSPM snapshot' logic.
#' This is done by replacing the respective entries in `renv.lock`.
#'
#' The following tasks are executed
#'
#' - Replace the R Version in `renv.lock`
#' - Replace the RSPM snapshot in `renv.lock` with the one associated with the
#'   selected R Version
#' - (optional) execution of `renv::update()`
#' - (optional) execution of `renv::snapshot()`
#'
#' @seealso get_valid_snapshots
#' @export
#' @examples
#' renv_switch_r_version("4.0.4")
renv_switch_r_version <- function(version = NULL,
                                  update_packages = TRUE,
                                  snapshot = TRUE) {

  # assertions
  checkmate::assert_character(version,
    len = 1,
    pattern = "[0-9][.][0-9][.][0-9]"
  )

  # check if renv.lock exists
  if (!file.exists("renv.lock")) {
    cli::cli_alert_danger("We could not find an {.file renv.lock} file in the current working directory:

    {.file {getwd()}}

    Is this project using 'renv'?", wrap = TRUE)
    stop("No renv.lock found.")
  }

  cli::cli_alert("Replacing R Version and RSPM snapshot in {.file renv.lock}.")

  renvlock <- readLines("renv.lock")

  # replace R version
  renvlock[3] <- sprintf("    \"Version\": \"%s\",", version)

  snapshots <- get_valid_snapshots()
  new_snapshot <- snapshots[snapshots$r_version == version, c("date")]
  # replace RSPM snapshot
  renvlock[6:7] <- c(
    "        \"Name\": \"CRAN\",",
    sprintf(
      "        \"URL\": \"https://packagemanager.rstudio.com/cran/%s\"",
      new_snapshot
    )
  )

  writeLines(renvlock, "renv.lock")

  if (requireNamespace("rstudioapi", quietly = TRUE)) {
    cli::cli_alert("Restarting R session.")
    rstudioapi::restartSession()
  }

  if (update_packages) {
    cli::cli_alert("Calling {.fun renv::update} to update/downgrade all packages
    to the new snapshot.", wrap = TRUE)
    renv::update(prompt = FALSE)
  }

  if (snapshot) {
    cli::cli_alert("Calling {.fun renv::snapshot} to record the changed packages
    in {.file renv.lock}.", wrap = TRUE)
    renv::snapshot(prompt = FALSE)
  }

}
