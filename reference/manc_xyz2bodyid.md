# Find the bodyid for an XYZ location

Find the bodyid for an XYZ location

## Usage

``` r
manc_xyz2bodyid(xyz, node = "neutu", cache = FALSE)
```

## Arguments

- xyz:

  location in raw MANC pixels

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.md).
  The default is to return the current active (unlocked) node being used
  through neutu.

- cache:

  Whether to cache the result of this call for 5 minutes.

## Value

A character vector of body ids (0 is missing somas / missing locations)

## Examples

``` r
ids=manc_xyz2bodyid(mancneckseeds)
#> Error in manc_dvid_node("neutu"): The package option malevnc.dataset is unset. Please set or manually reload package!
tids=table(ids)
#> Error: object 'ids' not found
# are there many duplicate ids
table(tids)
#> Error: object 'tids' not found

dups=names(tids[tids>1])
#> Error: object 'tids' not found
if (FALSE) { # \dontrun{
manc_scene(ids=dups)
} # }
```
