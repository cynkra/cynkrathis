test_that("register_cynkra() adds cynkra with its ROR", {
  dir <- local_description(
    'person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre"))'
  )

  register_cynkra(file = dir)

  authors <- get_authors(dir)
  expect_length(authors, 2)
  cynkra <- authors[[2]]
  expect_equal(cynkra$given, "cynkra GmbH")
  expect_equal(cynkra$email, "mail@cynkra.com")
  expect_equal(cynkra$role, c("fnd", "cph"))
  expect_equal(cynkra$comment, c(ROR = "0335t7e62"))
  expect_match(
    paste(readLines(file.path(dir, "DESCRIPTION")), collapse = "\n"),
    'comment = c(ROR = "0335t7e62")',
    fixed = TRUE
  )
})

test_that("register_cynkra() uses the roles it is given", {
  dir <- local_description(
    'person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre"))'
  )

  register_cynkra(role = "cph", file = dir)

  expect_equal(get_authors(dir)[[2]]$role, "cph")
})

test_that("register_cynkra() refuses to add cynkra twice", {
  dir <- local_description(
    'c(person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre")), person("cynkra GmbH", role = "fnd"))'
  )
  before <- readLines(file.path(dir, "DESCRIPTION"))

  expect_error(register_cynkra(file = dir), "already an author")
  expect_equal(readLines(file.path(dir, "DESCRIPTION")), before)
})

test_that("register_cynkra() requires a role", {
  dir <- local_description(
    'person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre"))'
  )

  expect_error(register_cynkra(role = character(), file = dir), "at least one role")
})

test_that("add_cynkra_ror() adds the ROR and keeps other comments", {
  dir <- local_description(
    'c(person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre"), comment = c(ORCID = "0000-0002-1416-3412")), person("cynkra GmbH", , , "mail@cynkra.com", role = "fnd", comment = "Funder"))'
  )

  add_cynkra_ror(file = dir)

  authors <- get_authors(dir)
  expect_equal(authors[[1]]$comment, c(ORCID = "0000-0002-1416-3412"))
  expect_equal(authors[[2]]$comment, c("Funder", ROR = "0335t7e62"))
  expect_equal(authors[[2]]$role, "fnd")
})

test_that("add_cynkra_ror() leaves an existing cynkra ROR alone", {
  dir <- local_description(
    'person("cynkra GmbH", role = "fnd", comment = c(ROR = "0335t7e62"))'
  )
  before <- readLines(file.path(dir, "DESCRIPTION"))

  add_cynkra_ror(file = dir)

  expect_equal(readLines(file.path(dir, "DESCRIPTION")), before)
})

test_that("add_cynkra_ror() refuses to overwrite a different ROR", {
  dir <- local_description(
    'person("cynkra GmbH", role = "fnd", comment = c(ROR = "000000000"))'
  )

  expect_error(add_cynkra_ror(file = dir), "different ROR")
  expect_equal(get_authors(dir)[[1]]$comment, c(ROR = "000000000"))
})

test_that("add_cynkra_ror() requires cynkra as an author", {
  dir <- local_description(
    'person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre"))'
  )

  expect_error(add_cynkra_ror(file = dir), "not an author")
})

test_that("add_cynkra_ror() requires a single cynkra entry", {
  dir <- local_description(
    'c(person("cynkra GmbH", role = "fnd"), person("cynkra", role = "cph"))'
  )

  expect_error(add_cynkra_ror(file = dir), "more than once")
})

test_that("add_cynkra_ror() requires Authors@R", {
  dir <- local_description(NULL)

  expect_error(add_cynkra_ror(file = dir), "no .*Authors@R")
})

test_that("both functions require a DESCRIPTION file", {
  dir <- withr::local_tempdir()

  expect_error(register_cynkra(file = dir), "Can't find")
  expect_error(add_cynkra_ror(file = dir), "Can't find")
})

test_that("both functions default to the working directory", {
  dir <- local_description(
    'person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre"))'
  )
  withr::local_dir(dir)

  register_cynkra(role = "fnd")

  expect_equal(get_authors(dir)[[2]]$comment, c(ROR = "0335t7e62"))
})
