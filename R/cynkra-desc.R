#' @title Register cynkra in `DESCRIPTION`
#' @description Add cynkra metadata to the package
#' @param role Role to add to cynkra. See `utils:::MARC_relator_db_codes_used_with_R`.
#' @param file Path to the `DESCRIPTION` file or to the package directory.
#' @rdname cynkra-desc
#' @export
register_cynkra <- function(role = c("fnd", "cph"), file = ".") {
  if (!is.character(role) || length(role) == 0) {
    cli::cli_abort("{.arg role} must name at least one role.")
  }
  checked <- tryCatch(
    utils::person("cynkra GmbH", role = role)$role,
    warning = function(w) NULL
  )
  if (length(checked) != length(role)) {
    cli::cli_abort(c(
      "{.arg role} must contain only valid roles, not {.val {role}}.",
      i = "See {.code utils:::MARC_relator_db_codes_used_with_R}."
    ))
  }
  role <- checked

  path <- description_path(file)
  desc <- desc::description$new(path)
  if (!desc$has_fields("Authors@R")) {
    cli::cli_abort("{.file {path}} has no {.field Authors@R} field.")
  }
  if (length(find_cynkra(desc)) > 0) {
    cli::cli_abort(c(
      "cynkra is already an author in {.file {path}}.",
      i = "Use {.fn add_cynkra_ror} to add its ROR identifier."
    ))
  }

  desc$add_author(
    given = "cynkra GmbH",
    role = role,
    email = "mail@cynkra.com",
    comment = c(ROR = cynkra_ror)
  )
  desc$write()
  invisible(desc)
}

#' @description Add cynkra's ROR when cynkra is already an author.
#' @rdname cynkra-desc
#' @export
add_cynkra_ror <- function(file = ".") {
  path <- description_path(file)
  desc <- desc::description$new(path)
  if (!desc$has_fields("Authors@R")) {
    cli::cli_abort("{.file {path}} has no {.field Authors@R} field.")
  }

  idx <- find_cynkra(desc)
  if (length(idx) == 0) {
    cli::cli_abort(c(
      "cynkra is not an author in {.file {path}}.",
      i = "Use {.fn register_cynkra} to add it."
    ))
  }
  if (length(idx) > 1) {
    cli::cli_abort("cynkra is listed more than once in {.file {path}}.")
  }

  authors <- unclass(desc$get_authors())
  comment <- authors[[idx]]$comment
  ror <- comment[toupper(names(comment)) %in% "ROR"]
  if (length(ror) > 0) {
    if (!identical(unname(ror), cynkra_ror)) {
      cli::cli_abort(
        "cynkra already has a different ROR identifier, {.val {ror}}, in {.file {path}}."
      )
    }
    return(invisible(desc))
  }

  authors[[idx]]$comment <- c(comment, ROR = cynkra_ror)
  class(authors) <- "person"
  desc$set_authors(authors)
  desc$write()
  invisible(desc)
}

cynkra_ror <- "0335t7e62"

description_path <- function(file) {
  if (dir.exists(file)) {
    file <- file.path(file, "DESCRIPTION")
  }
  if (!file.exists(file)) {
    cli::cli_abort("Can't find {.file {file}}.")
  }
  file
}

find_cynkra <- function(desc) {
  name <- vapply(
    unclass(desc$get_authors()),
    function(author) paste(c(author$given, author$family), collapse = " "),
    character(1)
  )
  which(grepl("^cynkra", name, ignore.case = TRUE))
}
