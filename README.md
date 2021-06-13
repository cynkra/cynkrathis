
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
#>         id r_version r_release_date       date        type                                                              note
#> 12 2976243     4.1.0     2021-05-18 2021-05-18 recommended                              dm 0.2.1, tibble 3.1.2, pillar 1.6.1
#> 11 2866992     4.0.5     2021-03-31 2021-05-12                                                                              
#> 10 2511902     4.0.5     2021-03-31 2021-04-23 recommended                                                                  
#> 9  2080338     4.0.5     2021-03-31 2021-03-31                                                                   vctrs 0.3.7
#> 8  1987521     4.0.4     2021-03-26 2021-03-26                                                                   dplyr 1.0.5
#> 7  1570705     4.0.4     2021-02-26 2021-02-26                                                                   renv 0.13.0
#> 6  1390593     4.0.4     2021-02-16 2021-02-16 recommended dm 0.1.12, odbc 1.3.0, testthat 3.0.2, lifecycle 1.0.0, no hexbin
#> 5  1033374     4.0.3           <NA> 2021-01-27                                        dm >= 0.1.10, no hexbin, odbc >= 1.3.0
#> 4      351     4.0.3     2020-10-10 2020-10-13 recommended                                                  rmarkdown >= 2.5
#> 3      314     4.0.2     2020-06-22 2020-08-24                                                                dplyr >= 1.0.0
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
