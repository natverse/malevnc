# malevnc: Support for Working with Janelia FlyEM Male VNC Dataset

Provides support for analysis of the male Drosophila ventral nerve cord
dataset released in June 2023 by the Janelia FlyEM team in collaboration
with the Hess lab, Google and Drosophila Connectomics Group, Cambridge.
This includes reading of connectivity information, skeleton and mesh
representations of neurons and symmetrising and inter-template
registrations.

## Registration

For information about left-right mirroring and symmetrising
registrations within MANC, please see
[`mirror_manc`](https://natverse.org/malevnc/reference/mirror_manc.md).

For information about across-template registrations, please see
[`download_manc_registrations`](https://natverse.org/malevnc/reference/download_manc_registrations.md).

## Package Options

- `malevnc.dataset` A shortname defining the active dataset
  (usually`MANC`). See
  [`choose_malevnc_dataset`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.md)
  for details.

- `malevnc.server` The https URL to the main Janelia server hosting male
  VNC data.

## See also

Useful links:

- <https://github.com/natverse/malevnc>

- <https://natverse.org/malevnc/>

- Report bugs at <https://github.com/natverse/malevnc/issues>

## Author

**Maintainer**: Gregory Jefferis <jefferis@gmail.com>
([ORCID](https://orcid.org/0000-0002-0587-9355))

Authors:

- Dominik Krzeminski <dkk33@cam.ac.uk>
  ([ORCID](https://orcid.org/0000-0003-4568-0583))

## Examples

``` r
# List all package options
if (FALSE) { # \dontrun{
options()[grepl("^malevnc", names(options()))]
} # }
```
