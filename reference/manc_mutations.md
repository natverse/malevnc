# Get all the modifications associated with one or more DVID nodes

Get all the modifications associated with one or more DVID nodes

## Usage

``` r
manc_mutations(nodes = "neutu", include_first = NA, bigcols = FALSE, ...)
```

## Arguments

- nodes:

  One or more DVID nodes. Ranges can be specified as `"first:last"`. The
  special value `"all"` implies the full sequence from the root node.

- include_first:

  Whether to include the first node in a sequence. The default behaviour
  (when `=NA`) will ignore the first node in a range specified
  `first:last` but keep the root nodes for the special range of "all".

- bigcols:

  Whether to include big columns in the results. The CleavedSupervoxels
  column in particular is very large and probably is not that useful for
  many. Default `FALSE`.

- ...:

  Additional arguments passed to `pbapply`

## Value

A `tibble` with columns including:

- `Action`: merge, cleave, supervoxel-split

- `App`: Typically NeuTu/Neu3

- `Target`: For NeuTu the bodyid of the (larger) target object

- `Labels`: For NeuTu the bodyids of the (smaller) objects being merged
  into the (larger) target object.

- `CleavedLabel`: For Neu3 the label of the new smaller cleaved body

- `OrigLabel`: For Neu3 the label of the larger cleaved body (which
  should retain its id)

- `Timestamp`: Absolute time in UTC at which change was committed in
  `POSIXct` format.

- `Reltimestamp`: Relative timestamp (in seconds) referenced to the time
  at which new DVID node was opened.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
library(dplyr)
# find all mutations in neutu but not yet in clio
notin_neuprint=manc_mutations('neuprint:neutu')
subset(notin_neuprint, User!='bergs') %>%
  qplot(Timestamp, data=., bins=100, fill=Action)

library(ggplot2)

allmuts=manc_mutations('all')
qplot(Timestamp, fill=App, data=allmuts, bins=100)

allmuts %>%
  filter(User!='bergs') %>%
  qplot(Timestamp, data=., bins=100, fill=App)

subset(allmuts, User!='bergs') %>%
  qplot(Timestamp, data=., bins=100, fill=Action)
} # }
```
