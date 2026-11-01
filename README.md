
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R-CMD-check](https://github.com/cynkra/cynkrathis/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cynkra/cynkrathis/actions/workflows/R-CMD-check.yaml)
[![Coverage
status](https://codecov.io/gh/cynkra/cynkrathis/branch/main/graph/badge.svg)](https://codecov.io/github/cynkra/cynkrathis?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/cynkrathis)](https://www.r-pkg.org/badges/version/cynkrathis)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CodeFactor](https://www.codefactor.io/repository/github/cynkra/cynkrathis/badge)](https://www.codefactor.io/repository/github/cynkra/cynkrathis)
<!-- badges: end -->

# cynkrathis

Package to simplify project scaffolding and common {renv} related tasks.

## cynkra RSPM snapshots

cynkra makes use of certain RStudio Package Manager (RSPM) snapshots
across projects. Usually each R Version is tied to a snapshot near it’s
release date. If a snapshot is considered unstable due to certain R
package version clashes, additional snapshots for specific R versions
can be listed.

``` r
head(cynkrathis::get_snapshots(), 10)
#>    id r_version r_release_date       date        type note
#> 48 NA     4.6.0     2026-04-24 2026-04-24 recommended     
#> 47 NA     4.5.3     2026-03-12 2026-03-12 recommended     
#> 46 NA     4.5.2     2025-11-01 2025-11-01 recommended     
#> 45 NA     4.5.1     2025-06-13 2025-06-13 recommended     
#> 44 NA     4.5.0     2025-04-11 2025-04-11 recommended     
#> 43 NA     4.4.3     2025-03-01 2025-03-01 recommended     
#> 42 NA     4.4.2     2024-11-01 2024-11-01 recommended     
#> 41 NA     4.4.1     2024-06-15 2024-06-15 recommended     
#> 40 NA     4.4.0     2024-04-24 2024-04-24 recommended     
#> 39 NA     4.3.3     2024-02-29 2024-02-29 recommended
```

## Initialize {renv} with a given RSPM snapshot

By default `init_renv()` will select the `"recommended"` snapshot of the
R version which is currently used.

``` r
cynkrathis::init_renv()
```

## Miscellaneous helpers

See the grouped [pkgdown
reference](https://cynkrathis.cynkra.com/reference/index.html).
