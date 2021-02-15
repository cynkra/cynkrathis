
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![tic](https://github.com/cynkra/cynkrathis/workflows/tic/badge.svg?branch=master)](https://github.com/cynkra/cynkrathis/actions)
<!-- badges: end -->

# cynkrathis

Internal package to bootstrap R package infrastructure for client
projects.

## Get snapshots and some metadata information

``` r
cynkrathis::get_valid_snapshots()
#>        id r_version r_release_date       date                    type             note
#> 1     151     3.5.3     2019-03-11 2019-03-11                                         
#> 2     259     3.6.3     2020-02-29 2020-03-02                                         
#> 3     301     4.0.2     2020-06-22 2020-07-13                           dplyr >= 1.0.0
#> 4     314     4.0.2     2020-06-22 2020-08-24                           dplyr >= 1.0.0
#> 5     351     4.0.3     2020-10-10 2020-10-13             recommended rmarkdown >= 2.5
#> 6 1033374     4.0.3           <NA> 2021-01-27 dm >= 0.1.10, no hexbin             <NA>
```

## Initialize {renv} with a given RSPM snapshot

Choose the `"date"` column that is returned by `get_valid_snapshots()`.
For example, for R 3.6.3 this would be “2020-02-29”.

``` r
cynkrathis::init_renv(snapshot_date = "2020-02-29")
```
