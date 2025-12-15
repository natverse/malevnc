# Login to MANC neuprint server

Login to MANC neuprint server

## Usage

``` r
manc_neuprint(
  server = getOption("malevnc.neuprint"),
  dataset = getOption("malevnc.neuprint_dataset"),
  token = Sys.getenv("neuprint_token"),
  ...
)
```

## Arguments

- server:

  A neuprint server (a sensible default should be chosen)

- dataset:

  A neuprint dataset (a sensible default should be chosen based on which
  dataset has been specified for Clio/DVID)

- token:

  neuprint authorisation token obtained e.g. from neuprint.janelia.org
  website.

- ...:

  Additional arguments passed to `neuprint_login`

## Value

a `neuprint_connection` object returned by `neuprint_login`

## See also

Other manc-neuprint:
[`manc_connection_table()`](https://natverse.org/malevnc/reference/manc_connection_table.md),
[`manc_ids()`](https://natverse.org/malevnc/reference/manc_ids.md)

## Examples

``` r
# \donttest{
vncc=manc_neuprint()
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
anchorids <- neuprintr::neuprint_ids("status:Anchor", conn=vncc)
#> Error: object 'vncc' not found
# the last connection will be used by default
anchormeta <- neuprintr::neuprint_get_meta("status:Anchor")
#> Error in neuprint_login(conn): Sorry you must specify a neuprint server! See ?neuprint_login for details!

plot(cumsum(sort(anchormeta$pre, decreasing = TRUE)), ylab='Cumulative presynapses')
#> Error: object 'anchormeta' not found
plot(cumsum(sort(anchormeta$post, decreasing = TRUE)), ylab='Cumulative postsynapses')
#> Error: object 'anchormeta' not found
# }
```
