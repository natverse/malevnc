# Choose active male VNC / FlyEM dataset

`choose_malevnc_dataset` chooses the dataset that will be used by the
male VNC package.

`choose_flyem_dataset` is a generic function underneath
`choose_malevnc_dataset`. It is intended primarily for developers of
other packages.

## Usage

``` r
choose_malevnc_dataset(dataset = NULL, set = TRUE, use_clio = NA)

choose_flyem_dataset(dataset = getOption("malevnc.dataset"), set = TRUE)
```

## Arguments

- dataset:

  Character vector specifying dataset name. Default value of `NULL` will
  respect package options or choose default dataset if none set.

- set:

  Whether to set the relevant package options or just to return the,

- use_clio:

  Whether to use clio to list datasets (expert use only; default of
  `use_clio=NA` should do the right thing).

## Value

A list of options (when `set=FALSE`) or the *previous* value of those
options, mimicking the behaviour of
[`options`](https://rdrr.io/r/base/options.html).

## Details

For `choose_malevnc_dataset` the `dataset` will be one of `MANC`
(release) or `VNC` (pre-release) dataset. Note the latter will only be
available for authenticated collaborators of the FlyEM team. When
`dataset=NULL` the options("malevnc.dataset") will be checked, then the
environment variable `MALEVNC_DATASET` and finally the default value
(MANC i.e. released dataset) will be selected.

## Examples

``` r
if (FALSE) { # \dontrun{
# switch dataset
op <- choose_malevnc_dataset("MANC")
on.exit(options(op))
# reset the previous state
options(op)
} # }
```
