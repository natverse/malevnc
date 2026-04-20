# Fetch neuprint metadata for MANC neurons

Fetch neuprint metadata for MANC neurons

## Usage

``` r
manc_neuprint_meta(
  ids = NULL,
  conn = manc_neuprint(),
  cache = NA,
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

- cache:

  whether to cache the query. When `cache=NA` (the default) queries are
  cached for neuprint snapshot versions (but not production datasets).
  See details.

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

This function will now cache neuprint queries when using a snapshot
release (which is assumed not to change). Snapshot releases are
identified by containing the string `":v"` as in `manc:v1.2.3`. The
cache currently lasts for 24h.

## See also

[`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

## Examples

``` r
# \donttest{
manc_neuprint_meta("DNp01")
#>   bodyid post  pre downstream upstream synweight             class description
#> 1  10000 2002 1027       4318     2002      6320 descending neuron Giant fiber
#> 2  10002 1902  933       3826     1902      5728 descending neuron Giant fiber
#>   entryNerve exitNerve group          name longTract ntAcetylcholineProb
#> 1        CvC      None 10000 DNlt002_CvC_R      none           0.5142120
#> 2        CvC      None 10000 DNlt002_CvC_L      none           0.4596285
#>   ntGabaProb ntGlutamateProb ntUnknownProb origin          location
#> 1  0.1707151       0.2175471    0.09752578  brain 24481,36044,67070
#> 2  0.1434814       0.2562304    0.14065966  brain 23217,35252,67070
#>   locationType predictedNtProb prefix      rootLocation rootSide    statusLabel
#> 1         neck       0.5142120     DN 24481,36044,67070      RHS Roughly traced
#> 2         neck       0.4596285     DN 23217,35252,67070      LHS Roughly traced
#>   subclass        synonyms systematicType  target transmission  type
#> 1       lt GF, Giant Fiber        DNlt002 LTct_RL   electrical DNp01
#> 2       lt GF, Giant Fiber        DNlt002 LTct_RL   electrical DNp01
#>          vfbId modality  tag somaSide cluster subcluster avgLocation birthtime
#> 1 VFB_jrcv07ps     <NA> <NA>     <NA>      NA         NA        <NA>      <NA>
#> 2 VFB_jrcv07pu     <NA> <NA>     <NA>      NA         NA        <NA>      <NA>
#>   hemilineage serial serialMotif somaNeuromere subclassabbr receptorType
#> 1        <NA>     NA        <NA>          <NA>         <NA>         <NA>
#> 2        <NA>     NA        <NA>          <NA>         <NA>         <NA>
#>   tosomaLocation source somaLocation status totalNtPredictions   predictedNt
#> 1           <NA>   <NA>         <NA> Traced               1027 acetylcholine
#> 2           <NA>   <NA>         <NA> Traced                933 acetylcholine
#>   celltypeTotalNtPredictions celltypePredictedNt      voxels fruDsx stuff  soma
#> 1                       1960       acetylcholine 38743961712   <NA>    NA FALSE
#> 2                       1960       acetylcholine 39414880927   <NA>    NA FALSE

# use of a full CYPHER query. NB Each field relating to the neuron must be
# be preceded by "n."
bignogroup <-
  manc_neuprint_meta("where:NOT exists(n.group) AND n.synweight>5000 AND n.class CONTAINS 'neuron'")
head(bignogroup)
#>   bodyid post pre downstream upstream synweight          class description
#> 1  28027  437 456       4868      437      5305 sensory neuron        <NA>
#> 2  19177  411 569       4629      411      5040 sensory neuron        <NA>
#> 3  20240  594 601       4447      594      5041 sensory neuron     unusual
#> 4  13967  912 644       4252      912      5164 sensory neuron        <NA>
#> 5  17446  724 655       4455      724      5179 sensory neuron        <NA>
#> 6 171382  746 541       4320      746      5066 sensory neuron        <NA>
#>   entryNerve exitNerve group            name longTract ntAcetylcholineProb
#> 1   MesoLN_R      <NA>    NA SNppxx_MesoLN_R      <NA>           0.5811309
#> 2     AbNT_R      <NA>    NA   SNxx23_AbNT_R      <NA>           0.9122434
#> 3   MetaLN_R      <NA>    NA SNxx29_MetaLN_R      <NA>           0.7210513
#> 4     AbNT_L      <NA>    NA   SNxx10_AbNT_L      <NA>           0.8687301
#> 5     AbNT_R      <NA>    NA   SNxx23_AbNT_R      <NA>           0.8022338
#> 6     AbNT_R      <NA>    NA   SNxx07_AbNT_R      <NA>           0.8937346
#>   ntGabaProb ntGlutamateProb ntUnknownProb           origin          location
#> 1 0.03783341      0.36905804   0.011977710 mesothoracic leg 25981,36162,29442
#> 2 0.03305553      0.04326012   0.011440937          abdomen  25729,12900,7969
#> 3 0.22840150      0.03870988   0.011837316 metathoracic leg 23896,22133,19804
#> 4 0.05167811      0.06977998   0.009811865          abdomen  22095,14384,8847
#> 5 0.07676595      0.09062613   0.030374181          abdomen  25555,14853,7796
#> 6 0.03987283      0.05699900   0.009393622          abdomen  27032,12900,7461
#>   locationType predictedNtProb prefix      rootLocation rootSide
#> 1         auto       0.5811309     SN 27866,36885,22115      RHS
#> 2         auto       0.9122434     SN     26421,8062,16      RHS
#> 3         auto       0.7210513     SN  32867,17818,7495      RHS
#> 4         auto       0.8687301     SN     25947,7375,16      LHS
#> 5         auto       0.8022338     SN     26876,7774,15      RHS
#> 6         user       0.8937346   <NA>     26665,8341,29      RHS
#>             statusLabel subclass             synonyms systematicType
#> 1 Prelim Roughly traced     <NA>                 <NA>         SNppxx
#> 2 Prelim Roughly traced     <NA>                 <NA>         SNxx23
#> 3 Prelim Roughly traced     <NA> ppk heat nociceptive         SNxx29
#> 4 Prelim Roughly traced     <NA>                 <NA>         SNxx10
#> 5 Prelim Roughly traced     <NA>                 <NA>         SNxx23
#> 6 Prelim Roughly traced     <NA>                 <NA>         SNxx07
#>          target transmission   type        vfbId       modality      tag
#> 1     LegNpT2_R         <NA> SNppxx VFB_jrcv0lmj proprioceptive 15.08.h3
#> 2           ANm         <NA> SNxx23 VFB_jrcv0esp        unknown     <NA>
#> 3 LegNpT3_R.ANm         <NA> SNxx29 VFB_jrcv0fm8        unknown     <NA>
#> 4           ANm         <NA> SNxx10 VFB_jrcv0arz        unknown     <NA>
#> 5           ANm         <NA> SNxx23 VFB_jrcv0dgm        unknown     <NA>
#> 6           ANm         <NA> SNxx07 VFB_jrcv3o8m        unknown     <NA>
#>   somaSide cluster subcluster avgLocation birthtime hemilineage serial
#> 1     <NA>      NA         NA        <NA>      <NA>        <NA>     NA
#> 2     <NA>      38         75        <NA>      <NA>        <NA>     NA
#> 3     <NA>      43         33        <NA>      <NA>        <NA>  20453
#> 4     <NA>      25         68        <NA>      <NA>        <NA>     NA
#> 5     <NA>      38         75        <NA>      <NA>        <NA>     NA
#> 6     <NA>      22         67        <NA>      <NA>        <NA>     NA
#>   serialMotif somaNeuromere subclassabbr receptorType tosomaLocation source
#> 1        <NA>          <NA>         <NA>         <NA>           <NA>   <NA>
#> 2        <NA>          <NA>         <NA>         <NA>           <NA>   <NA>
#> 3        <NA>          <NA>         <NA>         <NA>           <NA>   <NA>
#> 4        <NA>          <NA>         <NA>         <NA>           <NA>   <NA>
#> 5        <NA>          <NA>         <NA>         <NA>           <NA>   <NA>
#> 6        <NA>          <NA>         <NA>         <NA>           <NA>   <NA>
#>   somaLocation status totalNtPredictions   predictedNt
#> 1         <NA> Traced                456 acetylcholine
#> 2         <NA> Traced                569 acetylcholine
#> 3         <NA> Traced                601 acetylcholine
#> 4         <NA> Traced                644 acetylcholine
#> 5         <NA> Traced                655 acetylcholine
#> 6         <NA> Traced                541 acetylcholine
#>   celltypeTotalNtPredictions celltypePredictedNt     voxels fruDsx stuff  soma
#> 1                      45044           glutamate  225825889   <NA>    NA FALSE
#> 2                      18960       acetylcholine  589533979   <NA>    NA FALSE
#> 3                       9470       acetylcholine  566489384   <NA>    NA FALSE
#> 4                      11136       acetylcholine 1243780740   <NA>    NA FALSE
#> 5                      18960       acetylcholine  750977826   <NA>    NA FALSE
#> 6                      16834       acetylcholine  465918537   <NA>    NA FALSE
# }
if (FALSE) { # \dontrun{
# fetch all neurons
allneurons <- manc_neuprint_meta('where:exists(n.bodyId)')
# in theory you could do this, but it often seems to time out:
allsegs=neuprintr::neuprint_ids('where:exists(n.bodyId)', all_segments=TRUE)
} # }
```
