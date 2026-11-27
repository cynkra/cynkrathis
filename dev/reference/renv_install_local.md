# Build a local package and install it into an renv project

**\[experimental\]**

This is a wrapper around
[`pkgbuild::build()`](https://pkgbuild.r-lib.org/reference/build.html)
and
[`renv::install()`](https://rstudio.github.io/renv/reference/install.html)
to more easily make local packages available within renv projects.

The following steps are performed:

1.  Building the package found at argument `path` via
    [`pkgbuild::build()`](https://pkgbuild.r-lib.org/reference/build.html).

2.  Moving the built source into the renv cache. The cache location is
    determined by `Sys.getenv("RENV_PATHS_LOCAL")`.

3.  Installing the package from the cache location via
    [`renv::install()`](https://rstudio.github.io/renv/reference/install.html).

## Usage

``` r
renv_install_local(path = ".", quiet = FALSE, ...)
```

## Arguments

- path:

  `[character]`  
  The path to the package which should be built and installed.

- quiet:

  `[logical]`  
  Whether to suppress console output.

- ...:

    
  Passed down to
  [`pkgbuild::build()`](https://pkgbuild.r-lib.org/reference/build.html).
