#'
#' @export
use_gitpod <- function() {
  new_gitpod_dockerfile <- usethis::use_template(
    "gitpod.Dockerfile",
    ".gitpod.Dockerfile",
    package = "cynkrathis",
    ignore = TRUE
  )
  if (!new_gitpod_dockerfile) {
    return(invisible(FALSE))
  }

  invisible(TRUE)

  new_gitpod_yml <- usethis::use_template(
    "gitpod.yml",
    ".gitpod.yml",
    package = "cynkrathis",
    ignore = TRUE
  )
  if (!new_gitpod_yml) {
    return(invisible(FALSE))
  }

  invisible(TRUE)
}
