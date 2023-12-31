#' Install Aviator for a repository
#'
#' @description
#' Aviator is a GitHub app that provides a merge queue.
#' Compared to GitHub's native merge queue, it does not require branch protection.
#'
#' This function:
#' - installs the Aviator app for a repository (FIXME)
#' - creates a default configuraton and pushes it to the main branch
#'
#' @export
use_aviator <- function() {
  # FIXME: Check default branch, borrow from fledge
  stopifnot(gert::git_branch() == "main")
  stopifnot(nrow(gert::git_status(pathspec = c(".aviator/config.yml", ".Rbuildignore"))) == 0)
  stopifnot(nrow(gert::git_status(staged = TRUE)) == 0)

  path <- usethis::proj_get()
  dir.create(file.path(path, ".aviator"), recursive = TRUE, showWarnings = FALSE)

  unlink(".aviator/config.yml", force = TRUE)

  # To install app, use the equivalent of:
  # gh api -X PUT /user/installations/$(gh api '/orgs/{owner}/installations' -q '.installations[] | select(.app_slug == "aviator-app") | .id')/repositories/$(gh api '/repos/{owner}/{repo}' -q .id)
  # Need to find GitHub slug
  usethis::use_template(
    "aviator.yml",
    ".aviator/config.yml",
    ignore = TRUE,
    package = "cynkrathis"
  )

  if (nrow(gert::git_status(c(".aviator/config.yml", ".Rbuildignore"))) > 0) {
    cli::cli_alert("Pushing configuration to GitHub")
    gert::git_add(c(".aviator/config.yml", ".Rbuildignore"))
    gert::git_commit("chore: Add Aviator configuration")
    gert::git_push()
  }
  invisible()
}
