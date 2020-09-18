#' Write fully equipped gitignore files
#'
#' @template commit
#' @importFrom gitignore gi_fetch_templates
#' @importFrom gert git_add git_commit
#' @description By making use of the gitignore.io API.
#' @export
init_gitignore <- function(commit = TRUE) {

  gitignore::gi_fetch_templates("r", append_gitignore = TRUE)
  # docs/ not included in the used backends of gitignore
  write("docs/", ".gitignore", append = TRUE)
  gitignore::gi_fetch_templates("visualstudiocode", append_gitignore = TRUE)
  gitignore::gi_fetch_templates("macos", append_gitignore = TRUE)
  gitignore::gi_fetch_templates("windows", append_gitignore = TRUE)

  if (commit == TRUE) {
    gert::git_add(".gitignore")
    gert::git_commit("add `.gitignore`")
  }
}
