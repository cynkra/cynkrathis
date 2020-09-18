#' Initialize tic CI structure
#'
#' @template commit
#' @importFrom tic use_tic use_tic_badge use_update_tic gha_add_secret
#' @export
init_tic <- function(commit = TRUE) {

  if (Sys.getenv("TIC_UPDATE") == "") {
    stop("Env var 'TIC_UPDATE' must be set to init `tic::use_update_tic()`.")
  }

  tic::use_tic(
    wizard = FALSE, linux = "ghactions", mac = "ghactions",
    windows = "ghactions", deploy = "ghactions"
  )

  tic::use_tic_badge("ghactions")
  tic::use_update_tic()
  tic::gha_add_secret(Sys.getenv("TIC_UPDATE"), "TIC_UPDATE")

  if (commit == TRUE) {
    gert::git_add(c(
      ".github/workflows/tic.yml",
      ".github/workflows/update-tic.yml",
      "tic.R",
      ".Rbuildignore",
      ".gitignore"
    ))

  }
}
