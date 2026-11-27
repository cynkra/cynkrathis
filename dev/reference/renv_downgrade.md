# Downgrade an renv project to a specific RSPM snapshot

**\[experimental\]**

This functions aims to be used within a "snapshot-centered project
workflow" and can be used to downgrade all packages to an RSPM snapshot
listed in `renv.lock`.

While the main purpose is downgrade packages which exist in a higher
version, this function can also be used to restore a clean state of the
project library outside of a downgrade scenario. Be aware of the
handling of packages installed from remote sources (see section
"Downgrading behavior").

Under the hood, it records all packages installed in the `renv` project
library and restores these with the RSPM snapshot found in Line 7 of
`renv.lock`.

## Usage

``` r
renv_downgrade()
```

## Value

Called for its side-effect.

## Downgrading behavior 🚧️

There are important differences to be aware of when downgrading packages
with respect to their installation source:

1.  If a package is not available on CRAN, `renv_downgrade()` will
    restore the version from the remote source just fine.

2.  If a package is available on CRAN and a remote snapshot (e.g. from
    GitHub) was referenced in `renv.lock`, `renv_downgrade()` will
    downgrade this package to its CRAN version of the respective
    snapshot and **not** keep the remote snapshot version.

## See also

renv_switch_r_version()

## Examples

``` r
if (FALSE) { # \dontrun{
renv_downgrade()
} # }
```
