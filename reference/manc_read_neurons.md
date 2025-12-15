# Read MANC skeletons via neuprint

Read MANC skeletons via neuprint

## Usage

``` r
manc_read_neurons(
  ids,
  units = c("raw", "microns", "nm"),
  connectors = FALSE,
  heal.threshold = Inf,
  conn = manc_neuprint(),
  ...
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- units:

  Units of the returned neurons (default `raw` ie 8nm voxels)

- connectors:

  whether or not to add synapse data to the retrieved skeletons in the
  format used by the `rcatmaid` package, for easy use with `rcatmaid` or
  `catnat` functions. This can be done for synapse-less skeletons using
  `neuprint_assign_connectors`

- heal.threshold:

  distance in raw units beyond which isolated fragments will not be
  merged onto the main skeleton. The default of `1000` implies 8000 nm
  for the hemibrain dataset. Use `Inf` to merge all fragments.

- conn:

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.md)
  to ensure that query is against the VNC dataset.

- ...:

  Additional arguments passed to
  [`neuprintr::neuprint_read_neurons`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html).

## Value

A [`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html) with
attached metadata

## Details

`manc_read_neurons` fetches metadata from neuprint but does not fetch
synapse locations by default as this is very time consuming. For
historical reasons the default units are in raw image voxels (i.e. 8nm
spacing, what flyem returns) but for most other functions such as
[`symmetric_manc`](https://natverse.org/malevnc/reference/mirror_manc.md)
you need units of microns.

## Examples

``` r
if (FALSE) { # \dontrun{
gfs=manc_read_neurons("DNp01")
gfs[,]

dna02.um=manc_read_neurons("DNa02", units='microns')
dna02.um.m=mirror_manc(dna02.um, units='microns')
plot3d(dna02.um)
plot3d(dna02.um.m, col='grey')
} # }
```
