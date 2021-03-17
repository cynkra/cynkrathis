test_that("deploy_minicran_package()", {
  repo_name <- "cynkrathis-drat-test"
  dir <- paste0(tempdir(), repo_name)
  usethis::create_project(dir, open = FALSE)

  withr::with_dir(dir, {
    usethis::use_git()
    usethis::use_github()
  })

  expect_success(
    deploy_minicran_package("https://github.com/pat-s/drat-test",
      dry_run = TRUE
    )
  )

  # for local testing
  # gh::gh("DELETE https://api.github.com/repos/{username}/{reponame}",
  # username = gh::gh_whoami()$login,
  # reponame = repo_name,
  # .token = "<token with delete_repo scope here>)
})
