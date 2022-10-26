#'
#' @importFrom fs dir_create
#' @export
use_cmakelists <- function(project = "NewProject") {
  new_cmakelist <- usethis::use_template(
    "CMakeLists.txt",
    "CMakeLists.txt",
    package = "cynkrathis",
    data = list(project = project),
    ignore = TRUE
  )
  if (!new_cmakelist) {
    return(invisible(FALSE))
  }

  invisible(TRUE)

  fs::dir_create("src")

  ext_files <- list.files(path = ".", pattern = ".*\\.(c|h|cpp)$")

  new_cmakelist_src <- usethis::use_template(
    "CMakeLists-src.txt",
    "src/CMakeLists.txt",
    package = "cynkrathis",
    data = list(project = project, ext_files = ext_files),
    ignore = TRUE
  )
  if (!new_cmakelist_src) {
    return(invisible(FALSE))
  }

  invisible(TRUE)
}
