# Set DVID annotations for one or more ids.

`manc_set_dvid_instance` sets DVID type and/or instance (name)
information for one or more ids. It also adds user information for each
field.

`manc_set_dvid_annotations` is a low level function to set arbitrary
DVID annotations for exactly one body (expert use only!)

## Usage

``` r
manc_set_dvid_instance(
  bodyid,
  instance = NULL,
  type = NULL,
  synonyms = NULL,
  user = getOption("malevnc.dvid_user"),
  node = "neutu",
  ...
)

manc_set_dvid_annotations(bodyid, annlist, node = "neutu")
```

## Arguments

- bodyid:

  One or more body ids (only one for `manc_set_dvid_annotations`)

- instance:

  An instance, either a candidate type or an authoritative type with
  suffix to indicate side.

- type:

  The authoritative type for a neuron

- synonyms:

  An alternative type for a neuron (e.g. one used in the past
  literature, one which is useful but unlikely to be the authoritative
  type etc).

- user:

  The DVID user. Defaults to `options("malevnc.dvid_user")`.

- node:

  The dvid node to use (defaults to 'neutu' i.e. current open node)

- ...:

  Additional arguments passed to
  [`pbapply::pbmapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)
  when passing more than one bodyid.

- annlist:

  An R list containing key value pairs. Key names are not checked.

## Value

logical indicating success

logical indicating success

## Examples

``` r
if (FALSE) { # \dontrun{
manc_set_dvid_instance(1234567, type='LHAD1g1')
} # }
if (FALSE) { # \dontrun{
manc_set_dvid_annotations(1234567, list(instance='LHAD1g1', instance_user=''))

} # }
```
