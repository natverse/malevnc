# Check if group is complete

In other words if the `body_ids` argument contains all neurons in the
group.

## Usage

``` r
manc_check_group_complete(group_id, body_ids, conn = manc_neuprint())
```

## Arguments

- group_id:

  numeric/character with group id

- body_ids:

  vector with body ids to compare

- conn:

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)
  to ensure that query is against the VNC dataset.

## Value

logical `TRUE` if group is complete, `FALSE` otherwise.
