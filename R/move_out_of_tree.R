#' A utility to move a directory out of the current package tree
#'
#' Useful for revdepcheck results and other large directories or files
#' that are not needed for the package to function.
#' The directory will be moved to a sibling directory of the
#' current package directory.
#'
#' @param path The directory or file to be moved out of tree.
#'   Must be a subdirectory of the current working directory.
#'
#' @export
move_out_of_tree <- function(path) {
  wd <- fs::path_wd()
  stopifnot(fs::path_common(c(wd, fs::path_abs(path))) == wd)

  me <- desc::desc_get("Package")
  oot_name <- paste0(me, "-", gsub("/", "-", path))
  oot_path <- fs::path_abs(fs::path("..", oot_name))
  stopifnot(!fs::file_exists(oot_path))

  fs::file_move(path, oot_path)
  fs::link_create(oot_path, path)
  cli::cli_inform("Created link from {.path {path}} to {.path {oot_path}}")
}
