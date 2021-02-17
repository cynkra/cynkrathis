
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![tic](https://github.com/cynkra/cynkrathis/workflows/tic/badge.svg?branch=master)](https://github.com/cynkra/cynkrathis/actions)
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
cynkrathis::get_snapshots()
#>        id r_version r_release_date       date        type
#> 6 1390593     4.0.4     2021-02-16 2021-02-16 recommended
#> 5 1033374     4.0.3           <NA> 2021-01-27            
#> 4     351     4.0.3     2020-10-10 2020-10-13 recommended
#> 3     314     4.0.2     2020-06-22 2020-08-24            
#> 2     301     4.0.2     2020-06-22 2020-07-13            
#> 1     259     3.6.3     2020-02-29 2020-03-02            
#>                                                                note
#> 6 dm 0.1.12, odbc 1.3.0, testthat 3.0.2, lifecycle 1.0.0, no hexbin
#> 5                            dm >= 0.1.10, no hexbin, odbc >= 1.3.0
#> 4                                                  rmarkdown >= 2.5
#> 3                                                    dplyr >= 1.0.0
#> 2                                                    dplyr >= 1.0.0
#> 1
```

## Initialize {renv} with a given RSPM snapshot

By default `init_renv()` will select the `"recommended"` snapshot of the
R version which is currently used.

``` r
cynkrathis::init_renv()
```

## Miscellaneous helpers

See the grouped [pkgdown
reference](https://cynkra.github.io/cynkrathis/reference/index.html).
