test_that("deploy_minicran_package()", {
  options(usethis.quiet = TRUE)

  repo_name <- "/cynkrathis-drat-test"
  repo_url <- sprintf("https://github.com/pat-s%s", repo_name)

  # dir <- paste0(tempdir(), repo_name)
  # usethis::create_project(dir, open = FALSE)

  # withr::with_dir(dir, {
  #   usethis::use_git()
  #   usethis::use_github()
  # })


  # for some reason we need to roxygenise, otherwise covr fails
  cat("Package: foo\n", file = "DESCRIPTION")
  cat("Version: 1.0.0\n", file = "DESCRIPTION", append = TRUE)
  cat("Encoding: UTF-8\n", file = "DESCRIPTION", append = TRUE)
  roxygen2::roxygenize(".", roclets = c("rd"))

  expect_true(
    deploy_minicran_package(repo_url,
      dry_run = TRUE
    )
  )

  unlink("DESCRIPTION")

  # for local testing
  # gh::gh("DELETE https://api.github.com/repos/{username}/{reponame}",
  # username = gh::gh_whoami()$login,
  # reponame = repo_name,
  # .token = "<token with delete_repo scope here>)
})
