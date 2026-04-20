# Return the size (in voxels) of specified bodies

Return the size (in voxels) of specified bodies

## Usage

``` r
manc_size(ids, node = "neutu", chunksize = 5000L, ...)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- node:

  A DVID node (defaults to the current neutu node, see
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.md))

- chunksize:

  Split requests into chunks of maximum this size

- ...:

  Additional arguments passed to `pbsapply`

## Value

Numeric vector of voxel sizes

## See also

[`manc_neuprint_meta`](https://natverse.org/malevnc/reference/manc_neuprint_meta.md)
which returns the size of objects recorded in neuprint. This is much
faster when up to date.

## Examples

``` r
manc_size(10056)
#> Warning: running command 'curl -X GET --silent --data "[10056]" https://emdata-drumindor.janelia.org/api/node/dabe640270a24993b0805a2b563a2db5/segmentation/sizes' had status 7
#> Error: lexical error: invalid char in json text.
#>                                        NA
#>                      (right here) ------^
# zero as doesn't exist
manc_size(10000056)
#> [1] 0
if (FALSE) { # \dontrun{
# try splitting up
ids=manc_size("class:Ascending Interneuron", chunksize=500L, cl=4)
} # }
```
