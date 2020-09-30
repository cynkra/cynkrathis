#' Init renv infrastructure for cynkra client packages
#'
#' @param snapshot_id `[integer]`\cr
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
#'   snapshot_id = 301,
#'   additional_repos = c(e360 = "https://analytics.energie360.ch/drat"),
#'   local_packages = structure(c(foo = "0.1.0", foo2 = "0.2.1"))
#' )
#' }
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
    snapshot_id <- utils::tail(id_list$id[id_list$type == "recommended"], n = 1)
  }

  # assertions -----------------------------------------------------------------
  if (!is.null(additional_repos)) {
    checkmate::assert_character(additional_repos, names = "named")
  }
  checkmate::assert_subset(snapshot_id, valid_ids)
  checkmate::assert_integerish(snapshot_id, len = 1)
  checkmate::assert_named(local_packages)

  # renv init ------------------------------------------------------------------
  renv::init(
    bare = TRUE,
    restart = FALSE,
    settings = list(
      repos = c(
        CRAN = glue::glue("https://packagemanager.rstudio.com/cran/{snapshot_id}"), # nolint
        additional_repos
      )
    )
  )

  cat("RENV_CONFIG_AUTO_SNAPSHOT = TRUE
RENV_CONFIG_MRAN_ENABLED = FALSE\n",
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
