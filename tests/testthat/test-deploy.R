test_that("deploy_minicran_package()", {

  options(usethis.quiet = TRUE)

  repo_name <- "/cynkrathis-drat-test"
  dir <- paste0(tempdir(), repo_name)
  usethis::create_project(dir, open = FALSE)

  # withr::with_dir(dir, {
  #   usethis::use_git()
  #   usethis::use_github()
  # })

  expect_true(
    deploy_minicran_package(sprintf("https://github.com/pat-s%s", repo_name),
      dry_run = TRUE
    )
  )

  # for local testing
  # gh::gh("DELETE https://api.github.com/repos/{username}/{reponame}",
  # username = gh::gh_whoami()$login,
  # reponame = repo_name,
  # .token = "<token with delete_repo scope here>)
})
