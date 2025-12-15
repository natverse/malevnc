# Return the soma or root position of MANC bodyids

`manc_rootpos` returns the root point of all neurons and is a
convenience wrapper around `manc_somapos`.

## Usage

``` r
manc_somapos(
  ids = NULL,
  details = FALSE,
  duplicates = !details,
  somatags = c("soma", "tosoma", "root", "all"),
  node = "neutu",
  cache = TRUE,
  clio = TRUE
)

manc_rootpos(
  ids = NULL,
  details = FALSE,
  duplicates = !details,
  node = "neutu",
  cache = TRUE,
  clio = TRUE
)
```

## Arguments

- ids:

  MANC bodyids in any form compatible with
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md). The
  default `ids=NULL` returns the position of all known soma points.

- details:

  Whether to include details such as bodyids in the return.

- duplicates:

  Whether to include cases where the same bodyid has multiple soma
  annotations. Default is to include duplicates when `details=TRUE`.

- somatags:

  Which annotations to include. The default is to include both `"soma"`
  and `"tosoma"` tags (see details). `"all"` is an alias for
  `c("soma", "tosoma", "root")`.

- node:

  The DVID node to use for XYZ to bodyid lookups. See
  [`manc_xyz2bodyid`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.md).

- cache:

  whether to add a 5 min cache for the position lookups.

- clio:

  Whether to include point annotations from clio as well as the contents
  of
  [`mancsomapos`](https://natverse.org/malevnc/reference/mancsomapos.md).

## Value

When `details=FALSE` an Nx3 matrix. When `TRUE`, a data.frame containing
XYZ position, bodyid, source and tag

## Details

Currently there are three sources of soma information, the
[`mancsomapos`](https://natverse.org/malevnc/reference/mancsomapos.md)
data.frame distributed with the malevnc package, a key value annotation
stored in DVID and and point annotations stored in Clio. Currently DVID
is considered the main repository of information with updates to clio.

The
[`mancsomapos`](https://natverse.org/malevnc/reference/mancsomapos.md)
data.frame was the result of initial annotation work principally by
Chris Ordish at FlyEM who marked two points to define a sphere. It
contains some cases where the midpoint between the two marked points
does not land on the intended soma; there are also cases where the
segmentation inside the soma is not contiguous e.g. because the nucleus
is a separate body. These annotations were reviewed by FlyEM in June
2021 (see e.g. [Slack June
3rd](https://flyem-cns.slack.com/archives/G01FFQ00UAX/p1622732606077900?thread_ts=1622708364.074600&cid=G01FFQ00UAX)
and [Slack June
10th](https://flyem-cns.slack.com/archives/G01FFQ00UAX/p1623306812116500)).

Clio point annotations were added after predicting a set of objects
without an annotated soma that might be intrinsic VNC neurons based on
features such as pre- and post-synapse numbers, size, skeleton path
length etc. These point annotation include "tosoma" positions not
represented in DVID.

- soma tags are placed only on somata visible within the dataset

- tosoma tags are placed on cell body fibres leading to the soma of an
  intrinsic neuron that may be missing (e.g. because of damage to the
  specimen or because of difficulty following the cell body fibre all
  the way to the soma due to segmentation issues.)

- root tags are placed on a part of the neuron that is likely to be the
  closest part of the neuron to the soma within the image volume. Two
  example use cases are DNs or sensory neurons whose soma is outside the
  volume.

## See also

supersedes
[`mancsomapos`](https://natverse.org/malevnc/reference/mancsomapos.md)

## Examples

``` r
# \donttest{
# just the XYZ position
manc_somapos(10000)
#> Error in manc_dvid_node("neutu"): The package option malevnc.dataset is unset. Please set or manually reload package!
# with details including data source
manc_somapos(10000, details=TRUE)
#> Error in manc_dvid_node("neutu"): The package option malevnc.dataset is unset. Please set or manually reload package!
# }
```
