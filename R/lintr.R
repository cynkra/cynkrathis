#' Initialize lintr config
#' @importFrom usethis use_package use_tidy_description
#' @export
init_lintr <- function() {
  writeLines("linters: with_defaults(
  commented_code_linter = NULL,
  object_usage_linter = NULL,
  line_length_linter = NULL)
", ".lintr")
  usethis::use_package("lintr", "suggests")
  usethis::use_tidy_description()
  gert::git_add(c("DESCRIPTION", ".lintr"))
  gert::git_commit("add .lintr config")
}
