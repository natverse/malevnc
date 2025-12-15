# Information about DVID nodes / return latest node

`manc_dvid_node` returns the latest DVID node in use with a specific
tool.

`manc_dvid_nodeinfo` returns a data.frame with information about the
DVID nodes available for the male VNC dataset.

## Usage

``` r
manc_dvid_node(type = c("clio", "neutu", "neuprint", "master"), cached = TRUE)

manc_dvid_nodeinfo(cached = TRUE)
```

## Arguments

- type:

  Whether to return the latest committed node (clio) or the active node
  being edited in neutu (the very latest) or the node in neuprint (a
  committed node that may lag behind clio). master is an alias for
  neutu.

- cached:

  Whether to return a cached value (updated every hour) or to force a
  new query.

## Value

A UUID string

## Examples

``` r
# \donttest{
manc_dvid_node()
#> Error in manc_dvid_node(): The package option malevnc.dataset is unset. Please set or manually reload package!
manc_dvid_node('neutu')
#> Error in manc_dvid_node("neutu"): The package option malevnc.dataset is unset. Please set or manually reload package!
# force
manc_dvid_node('neuprint', cached=FALSE)
#> Error in manc_dvid_node("neuprint", cached = FALSE): The package option malevnc.dataset is unset. Please set or manually reload package!
# }
```
