# Switch between R versions in renv projects

This function switches between R versions in renv projects which follow
the 'cynkra RSPM snapshot' logic. This means that each R version is tied
to a specific RSPM snapshot.

The function executes the following tasks:

- Replace the R Version in `renv.lock`.

- Replace the RSPM snapshot in `renv.lock` with the one associated with
  the selected R Version.

- (optional) execution of
  [`renv::update()`](https://rstudio.github.io/renv/reference/update.html).

- (optional) execution of
  [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html).

## Usage

``` r
renv_switch_r_version(version = NULL)
```

## Arguments

- version:

  `[character]`  
  The R version to upgrade to.

## Value

TRUE (invisibly)

## See also

get_snapshots

## Examples

``` r
if (FALSE) { # \dontrun{
renv_switch_r_version("4.0.4")
} # }
```
