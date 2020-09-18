#' Init renv infrastructure for cynkra client packages
#'
#' @param snapshot_id `[integer]`\cr
#'   A valid RSPM snapshot ID. By default the latest valid ID is chosen.
#'   List of valid IDs: TBD.
#' @param additonal_repos `[named character]`\cr
#'   Additional repos besides the RSPM one.
#'   Must be a named character vector.
#' @param local_packages `[list]`\cr
#'   Packages to exclude from the `renv::install()` call and to install
#'   from local sources.
#'   Needs the package name and an explicit version.
#'   This is useful for local package sources used in the project which are not
#'   available in one of the repos configured in the project.
#'
#' @param exclude_local `[named character]`\cr
#'   Local packages to exclude from `renv::install()`.
#'   Required if the package is only available locally.
#'   If `local_packages` was set, this argument can be ignored.
#' @details
#' During the process, the latest CRAN version of {renv} will be installed,
#' regardless of the chose snapshot ID.
#' @examples
#' init_renv(
#'   snapshot_id = 301,
#'   additonal_repos = c(e360 = "https://analytics.energie360.ch/drat"),
#'   local_packages = list("foo", "0.1.0")
#' )
#' @export
init_renv <- function(snapshot_id = NULL,
                      additional_repos = NULL,
                      local_packages = NULL,
                      exclude_local = NULL) {

  # clean any leftover renv artifacts (and .RProfile)
  unlink(c(".RProfile", "renv.lock", ".Renviron"))
  unlink("renv/", recursive = TRUE)

  # valid R versions are stored in snapshots/
  id_list <- get_valid_snapshots()
  valid_ids <- as.numeric(id_list$id)
  if (is.null(snapshot_id)) {
    # take latest snapshot ID
    snapshot_id <- tail(id_list, n = 1)$id
  }
  checkmate::assert_subset(snapshot_id, valid_ids)

  # some checks
  if (!is.null(additional_repos)) {
    checkmate::assert_character(additional_repos, names = "named")
  }
  checkmate::assert_double(snapshot_id)
  checkmate::assert_list(local_packages, len = 2, null.ok = TRUE)

  renv::init(
    bare = TRUE,
    restart = FALSE,
    settings = list(
      repos = c(
        CRAN = glue::glue("https://packagemanager.rstudio.com/cran/{snapshot_id}"),
        additional_repos
      )
    )
  )

  cat("RENV_CONFIG_AUTO_SNAPSHOT = TRUE
RENV_CONFIG_MRAN_ENABLED = FALSE",
    file = ".Renviron"
  )

  options(repos = c(
    CRAN = glue::glue("https://packagemanager.rstudio.com/cran/{snapshot_id}"),
    additional_repos
  ))

  # FIXME: check if we can make this better
  # otherwise new installations won't use the configured snapshot
  # write repos to .Rprofile
  if (!is.null(additional_repos)) {
    txt <- glue::glue('options(repos = c(
    CRAN = "https://packagemanager.rstudio.com/cran/{snapshot_id}",
    {names(additional_repos)} = "{additional_repos}"
))', .trim = FALSE)
  } else {
    txt <- glue::glue('options(repos = c(
    CRAN = "https://packagemanager.rstudio.com/cran/{snapshot_id}"
))')
  }
  cat(txt, file = ".Rprofile")

  # print projects renv path: Problem: The library needs to be empty, otherwise
  # the wrong versions are stored in it (from previous renv inits)
  renv_dir <- .libPaths()[1]
  unlink(renv_dir, recursive = TRUE)
  dir.create(renv_dir, recursive = TRUE, showWarnings = FALSE)

  # check if any .Rmd files exist to detect dependencies in .Rmd files via renv
  if (length(list.files(pattern = ".Rmd", recursive = TRUE) > 0)) {
    cli::cli_alert_info("Installing {.pkg rmarkdown} to scrape dependencies in .Rmd files.")
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
    deps <- setdiff(deps, local_packages[[1]])
  }
  if (!is.null(exclude_local)) {
    deps <- setdiff(deps, exclude_local)
  }
  renv::install(deps)

  # update renv
  av_pkgs <- available.packages(repos = "https://packagemanager.rstudio.com/cran/latest")
  renv_latest <- av_pkgs[rownames(av_pkgs) == "renv", "Version"]

  renv::snapshot(prompt = FALSE)

  if (!is.null(local_packages)) {
    pkgs <- local_packages[[1]]
    versions <- local_packages[[2]]
    purrr::walk2(pkgs, versions, ~ {
      renv::install(glue::glue("{.x}@{.y}"))
      renv::record(glue::glue("{.x}@{.y}"))
    })
  }

  renv::upgrade(version = renv_latest, prompt = FALSE)

  renv::restore(prompt = FALSE)
  renv::rehash(prompt = FALSE)

  if (Sys.getenv("RSTUDIO") == 1) {
    rstudioapi::restartSession()
  }

}
