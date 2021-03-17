# cynkrathis 0.3.0 (2021-03-17)

- add `deploy_minicran_package()` (#16)

# cynkrathis 0.2.0 (2021-03-04)

- `init_renv()`: rewrite function: 
  - Remove arguments `local_packages` and `additional_repos`
  - Rename argument `exclude_local` to `exclude`
  - Add argument `convenience_packages`
  - Use `renv::scaffold()` instead of `renv::init()`
  
- `renv_switch_r_version()`:
   - remove arguments `snapshot` and `update` because these do not play well 
     when changing an R version in the same session and are also troublesome
     after automatic restarts


# cynkrathis 0.1.0 (2021-02-17)

- Initial public release.
