#' Init renv infrastructure for cynkra client packages
#'
#' @param snapshot_id `[integer]`\cr
#'   A valid RSPM snapshot ID. By default the latest valid ID is chosen.
#'   List of valid IDs: TBD.
#' @param additonal_repos `[named character]`\cr
#'   Additional repos besides the RSPM one.
#'   Must be a named character vector.
#'
#' @details
#' During the process, the latest CRAN version of {renv} will be installed,
#' regardless of the chose snapshot ID.
#' @examples
#' init_renv(
#'   snapshot_id = 301,
#'   additonal_repos = c(e360 = "https://analytics.energie360.ch/drat")
#' )
#' @export
init_renv <- function(snapshot_id = NULL, additional_repos = NULL) {

  # FIXME: scrape from upstream JSON file
  # - for every R version short after release: snapshot
  # if (is.null(snapshot_id)) {
  #   # take latest snapshot ID
  #   snapshot_id =
  # }

  # some checks
  if (!is.null(additional_repos)) {
    checkmate::assert_character(additional_repos, names = "named")
  }
  checkmate::assert_double(snapshot_id)

  renv::init(
    bare = TRUE,
    restart = FALSE,
    settings = list(
      renv.config.auto.snapshot = TRUE,
      renv.config.mran.enabled = FALSE,
      repos = c(
        CRAN = glue::glue("https://packagemanager.rstudio.com/cran/{snapshot_id}"),
        additional_repos
      )
    )
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
    CRAN = "https://packagemanager.rstudio.com/cran/{snapshot_id}))"')
  }
  cat(txt, file = ".Rprofile", append = TRUE)

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
  renv::install(deps)

  # update renv
  av_pkgs = available.packages(repos = "https://packagemanager.rstudio.com/cran/latest")
  renv_latest = av_pkgs[rownames(av_pkgs) == "renv",  "Version"]

  renv::upgrade(version = renv_latest, prompt = FALSE)
  renv::record(glue::glue("renv@{renv_latest}"))

  renv::snapshot(prompt = FALSE)

  if (Sys.getenv("RSTUDIO") == 1) {
    rstudioapi::restartSession()
  }
}
