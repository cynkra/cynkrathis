local_description <- function(authors, .local_envir = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = .local_envir)
  lines <- c(
    "Package: testpkg",
    "Title: Test Package",
    "Version: 0.0.1",
    if (!is.null(authors)) paste0("Authors@R: ", authors),
    "Description: A test package.",
    "License: MIT"
  )
  writeLines(lines, file.path(dir, "DESCRIPTION"))
  dir
}

get_authors <- function(dir) {
  unclass(desc::desc_get_authors(file = dir))
}
