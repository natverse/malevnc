# Convenience wrapper for neuprint connection queries for VNC dataset

Convenience wrapper for neuprint connection queries for VNC dataset

## Usage

``` r
manc_connection_table(
  ids,
  partners = c("inputs", "outputs"),
  prepost = c("PRE", "POST"),
  moredetails = "recommended",
  conn = manc_neuprint(),
  ...
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- partners:

  Either inputs or outputs. Redundant with `prepost`, but probably
  clearer.

- prepost:

  `PRE`: look for partners presynaptic (i.e upstream inputs) or `POST`:
  postsynaptic (downstream outputs) to the given `bodyids`. NB this is
  redundant to the `partners` argument and you should only use one.

- moredetails:

  Whether to include additional metadata information such as
  hemilineage, side etc. Can take one of the values
  `c('minimal', 'recommended', 'neuprint', 'all')`. In addition `TRUE`
  is a synonym for `'neuprint'` and `F` is a synonym for `'minimal'`.

- conn:

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)
  to ensure that query is against the VNC dataset.

- ...:

  additional arguments passed to `neuprint_connection_table`

## Value

see `neuprint_connection_table`

## See also

Other manc-neuprint:
[`manc_ids()`](https://natverse.org/malevnc/reference/manc_ids.md),
[`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)

## Examples

``` r
# \donttest{
down=manc_connection_table("DNp01", partners='outputs')
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
if (FALSE) { # \dontrun{
manc_scene(down$partner[1:8], open=TRUE)
} # }
# }
```
