# Return point annotations from Clio store

Return point annotations from Clio store

## Usage

``` r
manc_point_annotations(
  groups = "UK Drosophila Connectomics",
  cache = FALSE,
  bodyid = TRUE,
  node = "clio",
  test = FALSE
)
```

## Arguments

- groups:

  Defines a group for which we would like to see all annotations. When
  NULL, only returns annotations for your own user.

- cache:

  Whether to cache the result of this call for 5 minutes.

- bodyid:

  Whether or not to compute the current bodyid from the location of the
  point annotation using
  [`manc_xyz2bodyid`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.md)
  (defaults to `TRUE`).

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.md).
  The default is to return the current active (unlocked) node being used
  through neutu.

- test:

  Whether to use the testing clio store database (useful when trying out
  new code).

## Value

A data.frame of annotations

## Details

There is an optional 5 minute cache of these lookups (recreated for each
new R session). The location of each point annotation will by default be
found using the
[`manc_xyz2bodyid`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.md)
function; this will also be cached when `cache=TRUE`. The default node
for these lookups is Clio i.e. you will get the bodyid reported in Clio.
You can also choose to lookup the id for any DVID node, by specifying
e.g. `node='neutu'` to get the absolute latest node. Of course in theory
bodyids with Clio annotations should not be changing ...

Note that under the hood this uses the `malevnc.dataset` option to
define the set of annotations to query. You should not normally be
setting this option yourself, but it does allow the same functions to
repurposed for other datasets e.g. CNS.

## See also

Other manc-annotation:
[`manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.md),
[`manc_body_annotations()`](https://natverse.org/malevnc/reference/manc_body_annotations.md),
[`manc_meta()`](https://natverse.org/malevnc/reference/manc_meta.md)

## Examples

``` r
if (FALSE) { # \dontrun{
mpa=manc_point_annotations()
head(mpa)
# get absolutely latest bodyids
head(manc_point_annotations(node='neutu'))
} # }
```
