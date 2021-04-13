test_that("renv_install_local works", {
  cap <- capture.output(suppressMessages(renv_install_local()))
  rm(cap)

  renv_local <- switch(Sys.info()[["sysname"]],
    "Darwin" = "~/Library/Application Support/renv",
    "Windows" = "%LOCALAPPDATA%/renv",
    "Linux" = "~/.local/share/renv"
  )

  out <- list.files(renv_local, pattern = "cynkrathis_.*", full.names = TRUE)
  expect_match(
    list.files(renv_local, pattern = "cynkrathis_.*"),
    "cynkrathis_.*"
  )
  unlink(out, force = TRUE)
})
