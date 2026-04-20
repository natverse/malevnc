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
tids=table(ids)
# are there many duplicate ids
table(tids)
#> tids
#>    1    2    3    4 
#> 3630   69    3    1 

dups=names(tids[tids>1])
if (FALSE) { # \dontrun{
manc_scene(ids=dups)
} # }
```
