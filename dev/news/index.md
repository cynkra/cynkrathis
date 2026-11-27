# Changelog

## cynkrathis 0.3.4.9001 (2026-11-02)

### Chore

- Auto-update from GitHub Actions.

  Run: <https://github.com/cynkra/cynkrathis/actions/runs/41371719503>

## cynkrathis 0.3.4.9000 (2026-11-01)

### Bug fixes

- Rm useless items.

### Features

- Export function.

- Add function for creating spring cleaning issue
  ([\#70](https://github.com/cynkra/cynkrathis/issues/70)).

- Add functions to register cynkra’s metadata in `DESCRIPTION`
  ([\#68](https://github.com/cynkra/cynkrathis/issues/68)).

### Chore

- Drop the local favicon copy, the template ships it
  ([\#80](https://github.com/cynkra/cynkrathis/issues/80)).

- Add air [@moodymudskipper](https://github.com/moodymudskipper).

- Edits by [@moodymudskipper](https://github.com/moodymudskipper).

- Rm the R version item
  [@moodymudskipper](https://github.com/moodymudskipper).

#### deps

- Update peter-evans/create-pull-request action to v6.

#### deps

- Update actions/cache action to v4
  ([\#64](https://github.com/cynkra/cynkrathis/issues/64)).

- Config update.

#### deps

- Update actions/checkout action to v4
  ([\#55](https://github.com/cynkra/cynkrathis/issues/55)).

#### deps

- Update peter-evans/create-pull-request action to v5
  ([\#56](https://github.com/cynkra/cynkrathis/issues/56)).

### Continuous integration

- Use the workflows from cynkratemplate
  ([\#81](https://github.com/cynkra/cynkrathis/issues/81)).

### Documentation

- Improve docs.

- Add ror link.

- Fix my mistake.

- Fix other occurrence of curly braces.

- Fix formatting that makes R CMD Check angry.

- Set BS version explicitly for now.

  <https://github.com/cynkra/cynkratemplate/issues/53>

- List pkgdown URL in DESCRIPTION
  ([\#49](https://github.com/cynkra/cynkrathis/issues/49)).

### Uncategorized

- Merge branch ‘main’ of github.com:cynkra/cynkrathis.

- Merge branch ‘main’ of github.com:cynkra/cynkrathis.

## cynkrathis 0.3.4 (2022-10-20)

- Update snapshots
- Use new cynkra pkgdown theme

## cynkrathis 0.3.3 (2021-07-12)

- [`renv_downgrade()`](https://cynkrathis.cynkra.com/dev/reference/renv_downgrade.md):
  Account for packages from remote sources and CRAN’s “recommended”
  packages

## cynkrathis 0.3.2 (2021-06-17)

- [`deploy_minicran_package()`](https://cynkrathis.cynkra.com/dev/reference/deploy.md)
  now also works if no global git config was set by copying the projects
  git config to the temporary drat directory
  ([\#21](https://github.com/cynkra/cynkrathis/issues/21))
- [`deploy_minicran_package()`](https://cynkrathis.cynkra.com/dev/reference/deploy.md)
  uses a fresh directory for each clone task now instead of reusing the
  previous one which might lead to conflicts
  ([\#22](https://github.com/cynkra/cynkrathis/issues/22))
- Add
  [`renv_install_local()`](https://cynkrathis.cynkra.com/dev/reference/renv_install_local.md),
  an {renv} helper which helps building local packages by moving them to
  the shared {renv} cache location for local packages and installing
  them - all in one step
- Add `renv_donwgrade()`, a helper for downgrading to old RSPM snapshots

## cynkrathis 0.3.1 (2021-06-01)

- [`deploy_minicran_package()`](https://cynkrathis.cynkra.com/dev/reference/deploy.md):
  compatibility with drat 0.2.0
- [`renv_switch_r_version()`](https://cynkrathis.cynkra.com/dev/reference/renv_switch_r_version.md):
  coerce `new_snapshot` date to character to prevent NA printing

## cynkrathis 0.3.0 (2021-03-17)

- add
  [`deploy_minicran_package()`](https://cynkrathis.cynkra.com/dev/reference/deploy.md)
  ([\#16](https://github.com/cynkra/cynkrathis/issues/16))

## cynkrathis 0.2.0 (2021-03-04)

- [`init_renv()`](https://cynkrathis.cynkra.com/dev/reference/init_renv.md):
  rewrite function:
  - Remove arguments `local_packages` and `additional_repos`
  - Rename argument `exclude_local` to `exclude`
  - Add argument `convenience_packages`
  - Use
    [`renv::scaffold()`](https://rstudio.github.io/renv/reference/scaffold.html)
    instead of
    [`renv::init()`](https://rstudio.github.io/renv/reference/init.html)
- [`renv_switch_r_version()`](https://cynkrathis.cynkra.com/dev/reference/renv_switch_r_version.md):
  - remove arguments `snapshot` and `update` because these do not play
    well when changing an R version in the same session and are also
    troublesome after automatic restarts

## cynkrathis 0.1.0 (2021-02-17)

- Initial public release.
