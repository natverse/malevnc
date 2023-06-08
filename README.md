# malevnc

<img src="man/figures/manc-render-phubbard-200h.png" align="right" height="200" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/natverse/malevnc/workflows/R-CMD-check/badge.svg)](https://github.com/natverse/malevnc/actions)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://natverse.github.io/malevnc/reference/)
<!-- badges: end -->

The goal of malevnc is to provide a package to support analysis of the Drosophila Male Adult Nerve Cord dataset (aka MANC). You can read more about the MANC dataset and find links to a range of data and tools at https://www.janelia.org/project-team/flyem/manc-connectome.

## Installation

You can install the development version of malevnc from github:

``` r
install.packages("natmanager")
natmanager::install(pkgs="malevnc")
```
## Usage

### Dataset options
The package currently supports two distinct use cases / datasets

1. Access to the stable `MANC` connectome release for all general users
2. Access to an in progress `VNC` release for [flyconnectome](https://flyconnecto.me) and collaborators who need to update annotations etc.

Case 1 is now the default. If you need the second option then you must set

```
options(malevnc.dataset='VNC')
```

in your `.Rprofile` e.g. by doing

```
usethis::edit_r_profile()
```

### Authentication - Neuprint

Access to neuprint requires authentication. 
See https://github.com/natverse/neuprintr#authentication for details.

The recommendation is to set
the `neuprint_token` environment variable, which is available after logging in
to the neuprint website. 

### Authentication - Clio

You only need to authenticate to the Clio API if you are interacting with the
in progress pre-release dataset (`VNC`).
You do this via a Google OAuth "dance" in your web browser. 
Note that the Clio and neuprint tokens look similar, but are *not* the same.
Note also that the neuprint token appears to be indefinite while the Clio token
currently lasts 3 weeks.

### Registrations

Running the symmetrising/bridging registrations currently depends on CMTK.
To use these you will need a CMTK installation.

* For MacOS X use the dmg from https://www.nitrc.org/projects/cmtk/
* For windows, I recommend Cygwin install. See https://natverse.org/nat/articles/Installation.html#cmtk-nat-on-windows for details.
* For Linux I recommend compiling or using [neurodebian](http://neuro.debian.net/pkgs/cmtk.html).

Check that the natverse has found CMTK like so:

```
nat::cmtk.bindir()
nat::cmtk.dof2mat(version = T)
```

## Quick start

You can check everything is working like so:

``` r
library(nat)
library(malevnc)
plot3d(MANC.surf)

dnmeta=manc_neuprint_meta("class:descending")
dnmeta
```

To find out more, a quick tour round the [documentation website](https://natverse.org/malevnc/)

