# Create an issue containing a checklist of upkeep tasks

Bring your package up to current cynkra development standards.

## Usage

``` r
use_cynkra_upkeep_issue(repo = NULL)
```

## Arguments

- repo:

  GitHub repository, e.g. "cynkra/cynkrathis". By default, the
  repository associated to the current folder.

## Value

Nothing, used for its side-effect.

## Examples

``` r
if (FALSE) { # interactive()
use_cynkra_upkeep_issue()
# if using HTTPS or a fork
use_cynkra_upkeep_issue("tidyverse/tibble")
}
```
