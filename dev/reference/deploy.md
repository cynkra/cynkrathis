# Deployment helpers for internal minicran packages

**\[experimental\]**

Builds and deploys a local package to a git repository in a CRAN like
structure.

The resulting git repository can then be served via [RStudio
Connect](https://www.rstudio.com/products/connect/) and accessed as an
additional repository next to the main CRAN repository (by setting it
via `options(repos = )`). RStudio Connect can crawl the repository in a
defined internal when deploying the git repository via "Import from
git". Changes (i.e. new package versions) are picked up automatically.

This is an alternative to hosting and using a private instance of
[RStudio Package
Manager](https://www.rstudio.com/products/package-manager/).

The function executes the following tasks:

- Build a tarball of the package via
  [`pkgbuild::build()`](https://pkgbuild.r-lib.org/reference/build.html).

- Add the built package in a CRAN like structure to a temporary git
  clone of the upstream git repository via drat. “

- Render (and create if missing) the drat package website.

- Commit and push the changes to the git repository.

## Usage

``` r
deploy_minicran_package(drat_repo, commit_message = NULL, dry_run = FALSE)
```

## Arguments

- drat_repo:

  `[character]`  
  The git repository to deploy to. Can be any git vendor.

- commit_message:

  `[character]`  
  An optional git commit message. If not supplied, the message will be
  of the form `Update <pkg> to version <version>` with the values
  inferred from the DESCRIPTION file.

- dry_run:

  `[logical]`  
  When `TRUE`, the final git commit/push steps are skipped.

## Examples

``` r
if (FALSE) { # \dontrun{

deploy_minicran_package(drat_repo = "https://github.com/myuser/mydratrepo.git")
} # }
```
