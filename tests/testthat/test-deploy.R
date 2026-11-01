test_that("deploy_minicran_package()", {
  withr::local_options(usethis.quiet = TRUE)

  # A temporary local git repository stands in for the remote drat repository
  drat_repo <- withr::local_tempfile(pattern = "drat-")
  dir.create(drat_repo)
  gert::git_init(drat_repo)
  writeLines("# drat", file.path(drat_repo, "README.md"))
  gert::git_add("README.md", repo = drat_repo)
  gert::git_commit(
    "Initial commit",
    author = gert::git_signature("cynkrathis", "cynkrathis@example.com"),
    repo = drat_repo
  )

  # A minimal package to deploy, built in a temporary directory
  pkg <- withr::local_tempfile(pattern = "foo-")
  dir.create(pkg)
  writeLines(
    c("Package: foo", "Version: 1.0.0", "Encoding: UTF-8"),
    file.path(pkg, "DESCRIPTION")
  )
  withr::local_dir(pkg)

  # for some reason we need to roxygenise, otherwise covr fails
  roxygen2::roxygenize(".", roclets = c("rd"))

  expect_true(
    deploy_minicran_package(drat_repo, dry_run = TRUE)
  )
})
