#' Write fully equipped gitignore files
#'
#' @template commit
#' @description By making use of the gitignore.io API.
#' @export
init_gitignore <- function(commit = TRUE) {
  if (!requireNamespace("gitignore", quietly = TRUE)) {
    stop("Please install 'gitignore'.")
  }
  if (!requireNamespace("gert", quietly = TRUE)) {
    stop("Please install 'gert'.")
  }

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
