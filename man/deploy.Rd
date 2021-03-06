% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deploy.R
\name{deploy}
\alias{deploy}
\alias{deploy_minicran_package}
\title{Deployment helpers for internal minicran packages}
\usage{
deploy_minicran_package(drat_repo, commit_message = NULL, dry_run = FALSE)
}
\arguments{
\item{drat_repo}{\verb{[character]}\cr
The git repository to deploy to. Can be any git vendor.}

\item{commit_message}{\verb{[character]}\cr
An optional git commit message. If not supplied, the message will be of the
form \verb{Update <pkg> to version <version>} with the values inferred from the
DESCRIPTION file.}

\item{dry_run}{\verb{[logical]}\cr
When \code{TRUE}, the final git commit/push steps are skipped.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

Builds and deploys a local package to a git repository in a CRAN like
structure.

The resulting git repository can then be served via \href{https://www.rstudio.com/products/connect/}{RStudio Connect} and accessed as an
additional repository next to the main CRAN repository (by setting it via
\code{options(repos = )}).
RStudio Connect can crawl the repository in a defined internal when deploying
the git repository via "Import from git".
Changes (i.e. new package versions) are picked up automatically.

This is an alternative to hosting and using a private instance of
\href{https://www.rstudio.com/products/package-manager/}{RStudio Package Manager}.

The function executes the following tasks:
\itemize{
\item Build a tarball of the package via \code{pkgbuild::build()}.
\item Add the built package in a CRAN like structure to a temporary git clone of the upstream git repository via \pkg{drat}. ``
\item Render (and create if missing) the \pkg{drat} package website.
\item Commit and push the changes to the git repository.
}
}
\examples{
\dontrun{

deploy_minicran_package(drat_repo = "https://github.com/myuser/mydratrepo.git")
}

}
