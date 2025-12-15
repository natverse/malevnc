# Flexible specification of manc body ids

`manc_ids` provides a convenient way to extract body ids from a variety
of objects as well as allowing text searches against type/instance
information defined in neuprint.

## Usage

``` r
manc_ids(
  x,
  mustWork = TRUE,
  as_character = TRUE,
  integer64 = FALSE,
  unique = TRUE,
  conn = manc_neuprint(),
  ...
)
```

## Arguments

- x:

  A vector of body ids, data.frame (containing a bodyid column) or a
  neuroglancer URL.

- mustWork:

  Whether to insist that at least one valid id is returned (default
  `TRUE`)

- as_character:

  Whether to return segments as character rather than numeric vector
  (the default is character for safety).

- integer64:

  whether to return ids with class bit64::integer64.

- unique:

  Whether to ensure that only unique ids are returned (default `TRUE`)

- conn:

  optional, a neuprintr connection object, which also specifies the
  neuPrint server. If NULL, the defaults set in your
  [`.Rprofile`](https://rdrr.io/r/base/Startup.html) or
  [`.Renviron`](https://rdrr.io/r/base/Startup.html) are used. See
  [`neuprint_login`](https://natverse.org/neuprintr/reference/neuprint_login.html)
  for details.

- ...:

  Additional arguments passed to
  [`neuprint_search`](https://natverse.org/neuprintr/reference/neuprint_search.html)

## See also

`neuprint_ids`

Other manc-neuprint:
[`manc_connection_table()`](https://natverse.org/malevnc/reference/manc_connection_table.md),
[`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)

## Examples

``` r
# \donttest{
# search by type
manc_ids("DNp01")
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
# You can also do more complex queries using regular expressions
# introduced by a slash and specifying the field to be searched
dns=manc_ids("/type:DN.+")
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!

# you can also use Neo4J cypher queries by using the where: prefix
# note that each field of the neuron must prefixed with "n."
bignogroupids <-
  manc_ids("where:NOT exists(n.group) AND n.synweight>5000 AND n.class CONTAINS 'neuron'")
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
if (FALSE) { # \dontrun{
# Finally you can use the same queries wherever you specify body ids
# NB if you want to be sure that regular neuprintr functions target
# the VNC dataset, use conn=manc_neuprint()
lrpairs.meta=neuprintr::neuprint_get_meta("/name:[0-9]{5,}_[LR]", conn=manc_neuprint())
} # }
# }
```
