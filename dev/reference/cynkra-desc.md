# Register cynkra in `DESCRIPTION`

Add cynkra metadata to the package

Add cynkra's ROR when cynkra is already an author.

## Usage

``` r
register_cynkra(role = c("fnd", "cph"), file = ".")

add_cynkra_ror(file = ".")
```

## Arguments

- role:

  Role to add to cynkra. See
  `utils:::MARC_relator_db_codes_used_with_R`.

- file:

  Path to the `DESCRIPTION` file or to the package directory.
