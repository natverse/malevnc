# Fetch neuprint metadata for MANC neurons

Fetch neuprint metadata for MANC neurons

## Usage

``` r
manc_neuprint_meta(
  ids = NULL,
  conn = manc_neuprint(),
  roiInfo = FALSE,
  fields.regex.exclude = NULL,
  fields.regex.include = NULL,
  ...
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- conn:

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)
  to ensure that query is against the VNC dataset.

- roiInfo:

  whether to include the `roiInfo` field detailing synapse numbers in
  different locations. This is omitted by default as it is returned as a
  character vector of unprocessed JSON.

- fields.regex.exclude, fields.regex.include:

  Optional regular expressions to define fields to include or exclude
  from the returned metadata.

- ...:

  Additional arguments passed to `neuprint_get_meta`

## Value

A data.frame with one row for each (unique) id and NAs for all columns
except bodyid when neuprint holds no metadata.

## Details

When `ids = NULL` then a default set of bodies is selected using the
[`manc_dvid_annotations`](https://natverse.org/malevnc/reference/manc_dvid_annotations.md)
function. Since April 2025 this uses the `node='neuprint'`. This should
correspond to all neurons with an annotation. You can also use other
searches e.g. to fetch all neurons, see examples.

## See also

[`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

## Examples

``` r
# \donttest{
manc_neuprint_meta("DNp01")
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!

# use of a full CYPHER query. NB Each field relating to the neuron must be
# be preceded by "n."
bignogroup <-
  manc_neuprint_meta("where:NOT exists(n.group) AND n.synweight>5000 AND n.class CONTAINS 'neuron'")
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
head(bignogroup)
#> Error: object 'bignogroup' not found
# }
if (FALSE) { # \dontrun{
# fetch all neurons
allneurons <- manc_neuprint_meta('where:exists(n.bodyId)')
# in theory you could do this, but it often seems to time out:
allsegs=neuprintr::neuprint_ids('where:exists(n.bodyId)', all_segments=TRUE)
} # }
```
