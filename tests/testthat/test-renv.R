test_that("renv_install_local works", {
  tmp <- tempdir()
  options(usethis.quiet = TRUE)
  usethis::create_package(tmp, open = FALSE)

  cap <- capture.output(suppressMessages(renv_install_local(tmp)))
  rm(cap)

  renv_local <- switch(Sys.info()[["sysname"]],
    "Darwin" = "~/Library/Application Support/renv",
    "Windows" = "%LOCALAPPDATA%/renv",
    "Linux" = "~/.local/share/renv"
  )

  out <- list.files(renv_local, pattern = basename(tmp), full.names = TRUE)
  expect_match(
    list.files(renv_local, pattern = basename(tmp)),
    basename(tmp)
  )
  unlink(out, force = TRUE)
})
