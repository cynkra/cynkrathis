#' Use precommit with that project
#'
#' @template commit
#' @importFrom precommit use_precommit
#' @export
init_precommit <- function(commit = TRUE) {

  precommit::use_precommit()

  if (commit == TRUE) {
    gert::git_add(c(".pre-commit-config.yml", ".Rbuildignore"))
    gert::git_commit("use 'pre-commit' framework")
  }
}
