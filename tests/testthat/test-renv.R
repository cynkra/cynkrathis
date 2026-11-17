test_that("renv_install_local works", {
  withr::local_options(usethis.quiet = TRUE)

  # Keep the built tarball and the installed package out of the user's
  # renv root and library
  withr::local_envvar(RENV_PATHS_ROOT = withr::local_tempdir(pattern = "renv-"))
  withr::local_libpaths(withr::local_tempdir(pattern = "lib-"), action = "prefix")

  pkg <- file.path(withr::local_tempdir(), "testpkg")
  usethis::create_package(pkg, open = FALSE)

  cap <- capture.output(suppressMessages(renv_install_local(pkg)))
  rm(cap)

  expect_match(
    list.files(renv::paths$root(), pattern = "testpkg"),
    "testpkg"
  )
})
