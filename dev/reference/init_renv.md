# Initialize renv infrastructure (cynkra way)

**\[experimental\]**

Initializes renv setup by setting a predefined RStudio Package Manager
(RSPM) snapshot. Custom RSPM Snapshots can be configured via
`snapshot_date`.

## Usage

``` r
init_renv(snapshot_date = NULL, exclude = NULL, convenience_pkgs = FALSE)
```

## Arguments

- snapshot_date:

  `[Date]`  
  A valid RSPM snapshot date. By default the "recommended" date from
  [`get_snapshots()`](https://cynkrathis.cynkra.com/dev/reference/get_snapshots.md)
  for the respective R version is chosen.

- exclude:

  `[character]`  
  Packages to exclude from
  [`renv::install()`](https://rstudio.github.io/renv/reference/install.html).
  Useful if a package is not available in the available repositories
  (check with `getOption("repos"`) to prevent `init_renv()` to fail.
  This should only be a temporary workaround - consider making local
  packages available in a minicran-like repository.

- convenience_pkgs:

  `[logical]`  
  Install additional opinionated convenience packages? The following
  packages would be installed:

  - usethis

  - styler

  - gert

  - krlmlr/fledge

## Details

During the process, the latest CRAN version of renv will be installed,
regardless of the chosen snapshot ID.

The heuristic for setting the correct RSPM binary repo currently only
supports Windows, macOS and Ubuntu 20.04.

The initialization mostly runs in clean vanilla sessions started with
[`callr::r_vanilla()`](https://callr.r-lib.org/reference/r_vanilla.html).

## Examples

``` r
if (FALSE) { # \dontrun{
init_renv()
} # }
```
