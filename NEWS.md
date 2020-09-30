# cynkrathis 0.0.0.9006 (2020-09-30)

- `init_renv(local_packages = )` now requires a named vector instead of a list
- Fix `init_renv()` without arguments (#4).


# cynkrathis 0.0.0.9005 (2020-09-29)

- `init_renv()`: add newline when writing .Rprofile and .Renviron


# cynkrathis 0.0.0.9004 (2020-09-18)

- add `init_tic()`
- add `init_gitignore()`
- add `init_precommit()`

# cynkrathis 0.0.0.9003 (2020-09-18)

- assert valid snapshot ids from upstream JSON file
- `init_renv()`: write renv settings as env vars instead of passing them via renv::init()


# cynkrathis 0.0.0.9002 (2020-09-17)

- `init_renv()`: Add `exclude_local()` argument


# cynkrathis 0.0.0.9001 (2020-09-17)

- `init_renv()`: add param `local_packages()`


