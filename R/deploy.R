#' @title Deployment helpers for internal minicran packages
#' @description
#'
#' `r lifecycle::badge('experimental')`
#'
#' Builds and deploys a local package to a git repository in a CRAN like
#' structure.
#'
#' The resulting git repository can then be served via [RStudio
#' Connect](https://www.rstudio.com/products/connect/) and accessed as an
#' additional repository next to the main CRAN repository (by setting it via
#' `options(repos = )`).
#' RStudio Connect can crawl the repository in a defined internal when deploying
#' the git repository via "Import from git".
#' Changes (i.e. new package versions) are picked up automatically.
#'
#' This is an alternative to hosting and using a private instance of
#' [RStudio Package Manager](https://www.rstudio.com/products/package-manager/).
#'
#'   The function executes the following tasks:
#'   - Build a tarball of the package via `pkgbuild::build()`.
#'   - Add the built package in a CRAN like structure to a temporary git clone of the upstream git repository via \pkg{drat}. ``
#'   - Render (and create if missing) the \pkg{drat} package website.
#'   - Commit and push the changes to the git repository.
#'
#' @param drat_repo `[character]`\cr
#'   The git repository to deploy to. Can be any git vendor.
#' @param commit_message `[character]`\cr
#'   An optional git commit message. If not supplied, the message will be of the
#'   form `Update <pkg> to version <version>` with the values inferred from the
#'   DESCRIPTION file.
#' @param dry_run `[logical]`\cr
#'   When `TRUE`, the final git commit/push steps are skipped.
#'
#' @examples
#' \dontrun{
#'
#' deploy_minicran_package(drat_repo = "https://github.com/myuser/mydratrepo.git")
#' }
#'
#' @name deploy
#' @export
deploy_minicran_package <- function(drat_repo,
                                    commit_message = NULL,
                                    dry_run = FALSE) {
  requireNamespace("drat", quietly = TRUE)
  requireNamespace("withr", quietly = TRUE)
  requireNamespace("pkgbuild", quietly = TRUE)
  requireNamespace("rsconnect", quietly = TRUE)
  requireNamespace("rmarkdown", quietly = TRUE)
  requireNamespace("desc", quietly = TRUE)

  drat_dir <- clone_drat_dir(drat_repo)

  default_branch <- gert::git_info(drat_dir)$shorthand

  cli::cli_alert("Building package.")
  built <- pkgbuild::build(dest_path = tempdir(check = TRUE), quiet = TRUE)

  pkgname <- desc::desc_get("Package")
  pkgversion <- desc::desc_get_version()

  # copy git config in case config is not set globally
  file.copy(".git/config", paste0(drat_dir, "/.git/config"), overwrite = TRUE)

  withr::with_dir(
    drat_dir,
    withr::with_options(
      c(dratBranch = NULL),
      {
        cli::cli_alert("Initiating deploy to {.url {drat_repo}}.")

        drat::insertPackage(built,
          repodir = drat_dir, commit = FALSE,
          action = "archive"
        )

        check_for_drat_website_files()
        rmarkdown::render_site(quiet = TRUE)

        # this is needed for RSC to install the packages from Bitbucket
        rsconnect::writeManifest(
          contentCategory = "site",
          appFiles = c("index.html", "src")
        )

        if (is.null(commit_message)) {
          commit_message <- sprintf(
            "Update '%s' to version %s",
            pkgname, pkgversion
          )
        }

        if (dry_run) {
          cli::cli_alert_info("{.code dry_run = TRUE}, not committing/pushing
            to git repository.", wrap = TRUE)
        } else {
          gert::git_add(".")
          gert::git_commit(commit_message)
          gert::git_push(verbose = FALSE)
        }

        cli::cli_alert_info("The package will be available in the minicran
          repository in latest 15 mins.
          If you want to speed things up, synchronize the RStudio Connect
          app manually.", wrap = TRUE)

        cli::cli_alert_success("Deployment successful. Git log:")
        print(gert::git_log(max = 1), repo = drat_dir)

        unlink(drat_dir, recursive = TRUE)
      }
    )
  )

  invisible(TRUE)
}

clone_drat_dir <- function(drat_repo) {
  path <- paste0(tempdir(), "/drat")
  cli::cli_alert("Attempting to create a temporary git clone of
      {.url {drat_repo}}. Your password might be needed for
      authentication.", wrap = TRUE)
  cli::cli_alert_info("Depending on the repository size, cloning might
      take a while.", wrap = TRUE)
  gert::git_clone(drat_repo, path = path)

  return(invisible(path))
}


check_for_drat_website_files <- function() {
  if (!file.exists("_site.yml")) {
    writeLines(
      'name: "drat"
output_dir: "."
navbar:
  title: "Extra packages"
left:
  - text: "Home"
href: index.html
exclude: ["drat", "src", "manifest.json"]',
      "_site.yml"
    )
  }

  if (!file.exists("index.Rmd")) {
    writeLines(
      '---
title: minicran repository
layout: post
---

# minicran repository

[`drat`](https://github.com/eddelbuettel/drat) minicran package repository.

## File listing

```{r echo=FALSE}
cat(readLines("src/contrib/PACKAGES"), sep = "\\n")
```',
      "index.Rmd"
    )
  }
}
