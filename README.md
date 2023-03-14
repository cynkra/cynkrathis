
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![tic](https://github.com/cynkra/cynkrathis/workflows/tic/badge.svg?branch=master)](https://github.com/cynkra/cynkrathis/actions)
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
#>    id r_version r_release_date       date        type                                note
#> 31 NA     4.2.1     2022-06-23 2022-08-26                                    pillar 1.8.1
#> 30 NA     4.2.1     2022-06-23 2022-08-10                                        dm 1.0.1
#> 29 NA     4.2.1     2022-06-23 2022-06-23 recommended                                    
#> 28 NA     4.2.0     2022-04-22 2022-06-21                                  RMariaDB 1.2.2
#> 27 NA     4.2.0     2022-04-22 2022-06-07                                    dbplyr 2.2.0
#> 26 NA     4.2.0     2022-04-22 2022-05-20                                     dplyr 1.0.9
#> 25 NA     4.2.0     2022-04-22 2022-04-22 recommended                                    
#> 24 NA     4.1.3     2022-03-10 2022-04-15                           vctrs 0.4.1, dm 0.2.8
#> 23 NA     4.1.3     2022-03-10 2022-03-10 recommended                                    
#> 22 NA     4.1.2     2021-11-01 2022-02-07             pillar 1.7.0, rlang 1.0.1, dm 0.2.7
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
