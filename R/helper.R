#' Return metadata for RSPM snapshots
#'
#' @description
#'  A list of valid snapshot IDs and their corresponding data and R version.
#' @importFrom utils download.file
#' @importFrom gh gh
#' @importFrom jsonlite read_json
#' @export
get_valid_snapshots <- function() {

  # uses a valid GITHUB_PAT from the user with access to the org
  resp <- gh::gh("/repos/:owner/:repo/contents/:path",
    owner = "cynkra",
    repo = "cynkrathis",
    path = "snapshots/snapshots.json"
  )$download_url

  tmp <- tempfile()
  utils::download.file(resp, destfile = tmp, quiet = TRUE)
  tbl <- jsonlite::read_json(tmp,
    simplifyVector = TRUE
  )
  return(tbl)
}
