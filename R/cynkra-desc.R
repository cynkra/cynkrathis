#' @title Register cynkra in `DESCRIPTION`
#' @description Add cynkra metadata to the package
#' @param role Role to add to cynkra. See `utils:::MARC_relator_db_codes_used_with_R`.
#' @rdname cynkra-desc
#' @export
register_cynkra <- function(role = c("fnd", "cph")) {
  check_desc_ror()
  desc::desc_add_author(
    "cynkra GmbH",
    role = role,
    email = "mail@cynkra.com",
    ror = "0335t7e62"
  )
}

#' @description Add cynkra's ROR when cynkra is already an author.
#' @rdname cynkra-desc
#' @export
add_cynkra_ror <- function() {
  check_desc_ror()
  # Looked up at run time: the CRAN release of desc does not export it yet,
  # and R CMD check would warn about a missing object.
  desc_add_ror <- getExportedValue("desc", "desc_add_ror")
  desc_add_ror("0335t7e62", given = "cynkra")
}

check_desc_ror <- function() {
  # Only the development version of desc supports ROR identifiers,
  # so install it from r-universe rather than from CRAN.
  rlang::check_installed(
    "desc",
    version = "1.4.3.9000",
    reason = "(the development version from r-lib/desc) to add a ROR identifier to `DESCRIPTION`.",
    action = function(pkg, ...) {
      utils::install.packages(pkg, repos = "https://r-lib.r-universe.dev")
    }
  )
}
