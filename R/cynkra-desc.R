#' @title Register cynkra in `DESCRIPTION`
#' @description Add cynkra metadata to the package
#' @param role Role to add to cynkra. See `utils:::MARC_relator_db_codes_used_with_R`.
#' @rdname cynkra-desc
#' @export
register_cynkra <- function(role = c("fnd", "cph")) {
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
  desc::desc_add_ror("0335t7e62", given = "cynkra")
}
