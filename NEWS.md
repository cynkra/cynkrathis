<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# cynkrathis 0.3.1.9001 (2021-06-11)

- Add `renv_install_local()`, an {renv} helper which helps building local packages by moving them to the shared {renv} cache location for local packages and installing them - all in one step


# cynkrathis 0.3.1.9000 (2021-06-11)

- Add `renv_donwgrade()`, a helper for downgrading to old RSPM snapshots


# cynkrathis 0.3.1 (2021-06-01)

- `deploy_minicran_package()`: compatibility with drat 0.2.0
- `renv_switch_r_version()`: coerce `new_snapshot` date to character to prevent NA printing


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
