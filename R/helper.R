#' Return metadata for cynkra RSPM snapshots
#'
#' @description
#'  A list of curated cynkra RStudio Package Manager snapshot IDs and their
#'  metadata.
#' @importFrom utils download.file
#' @importFrom gh gh
#' @importFrom jsonlite read_json
#' @export
get_snapshots <- function() {

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

  tbl$date <- as.Date(tbl$date)
  tbl$r_release_date <- as.Date(tbl$r_release_date)

  # sort
  tbl <- tbl[order(tbl$date, decreasing = TRUE), ]

  return(tbl)
}
