# Simple summaries of which regions different neurons innervate

`manc_leg_summary` summarises I/O in the main leg neuropils.

`manc_side_summary` summarises connections within all of the ROIs that
have an L or R designation.

## Usage

``` r
manc_leg_summary(ids, long = FALSE, other = FALSE, conn = manc_neuprint())

manc_side_summary(ids, long = FALSE, conn = manc_neuprint())
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- long:

  Whether to return results in wide (default) or long format.

- other:

  Whether to return the sum of all other neuropils as an extra column
  `other`.

- conn:

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)
  to ensure that query is against the VNC dataset.

## Value

a data.frame with one row per neuron (when `long=FALSE`) or one row per
ROI/IO combination (when `long=TRUE`). Note that `out` columns refer to
output synapses from the given bodyid onto downstream partners.

## Examples

``` r
dnals=manc_leg_summary(c(10126, 10118))
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
dnals
#> Error: object 'dnals' not found
manc_leg_summary(c(10126, 10118), long=TRUE)
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
heatmap(data.matrix(dnals[grep("_out", colnames(dnals))]),
  Colv = NA, scale = 'none')
#> Error: object 'dnals' not found

# \donttest{
dnls=manc_leg_summary('class:descending')
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
heatmap(data.matrix(dnls[grep("_out", colnames(dnls))]),
  Colv = NA, scale = 'none')
#> Error: object 'dnls' not found
# }
manc_side_summary('DNp01')
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
```
