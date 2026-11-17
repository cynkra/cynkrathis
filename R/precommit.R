#' Use precommit with that project
#'
#' @template commit
#' @export
init_precommit <- function(commit = TRUE) {
  if (!requireNamespace("precommit", quietly = TRUE)) {
    cli::cli_abort("Please install {.pkg precommit}.")
  }
  if (!requireNamespace("gert", quietly = TRUE)) {
    cli::cli_abort("Please install {.pkg gert}.")
  }

  # Not `precommit::use_precommit()`: R CMD check would load precommit,
  # whose R.cache dependency then creates a cache directory in the home
  # directory and triggers a NOTE.
  use_precommit <- getExportedValue("precommit", "use_precommit")
  use_precommit()

  if (commit == TRUE) {
    gert::git_add(c(".pre-commit-config.yaml", ".Rbuildignore"))
    gert::git_commit("use 'pre-commit' framework")
  }
}
