#' Use precommit with that project
#'
#' @template commit
#' @export
init_precommit <- function(commit = TRUE) {
  if (!requireNamespace("precommit", quietly = TRUE)) {
    stop("Please install 'precommit'.")
  }
  if (!requireNamespace("gert", quietly = TRUE)) {
    stop("Please install 'gert'.")
  }

  precommit::use_precommit()

  if (commit == TRUE) {
    gert::git_add(c(".pre-commit-config.yaml", ".Rbuildignore"))
    gert::git_commit("use 'pre-commit' framework")
  }
}
