# Check if a bodyid still exists in the specified DVID node

Check if a bodyid still exists in the specified DVID node

## Usage

``` r
manc_islatest(
  ids,
  node = "neutu",
  method = c("auto", "size", "sparsevol"),
  ...
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- node:

  A DVID node (defaults to the current neutu node, see
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.md))

- method:

  Which DVID endpoint to use. Expert use only.

- ...:

  Additional arguments passed to `pbsapply` and then eventually to
  [`httr::HEAD`](https://httr.r-lib.org/reference/HEAD.html)

## Value

A logical vector indicating if the body exists (TRUE) or not (FALSE).

## Details

Note that the raw speed of this call is still quite slow (typically 5-30
bodies per second from Cambridge). When more than one body id is
provided this actually uses
[`manc_size`](https://natverse.org/malevnc/reference/manc_size.md) to
check if the body has \>0 voxels. This is a somewhat expensive operation
on the server but can be accept multiple ids. As a further speed-up,
when many ids are requested and `method="auto"` (the recommended
default) then the DVID status of bodies is checked. In theory only valid
bodies should have such a status ([see Slack
message](https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1621448634011800?thread_ts=1621434072.008700&cid=C01MYQ1AQ5D)).

## Examples

``` r
manc_islatest(10056)
#> Error in manc_dvid_node("neutu"): The package option malevnc.dataset is unset. Please set or manually reload package!

if (FALSE) { # \dontrun{
manc_islatest(10056:10058)

manc_islatest(10056:10058, "clio")
} # }
```
