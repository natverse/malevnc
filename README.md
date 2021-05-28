# malevnc

<!-- badges: start -->
[![R-CMD-check](https://github.com/flyconnectome/malevnc/workflows/R-CMD-check/badge.svg)](https://github.com/flyconnectome/malevnc/actions)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://flyconnectome.github.io/malevnc/reference/)
<!-- badges: end -->

The goal of malevnc is to provide a package to support analysis on the Janelia
male VNC dataset aka (MANC). Note that this package points to private resources
made available by the male VNC project led by the FlyEM team at Janelia.
You will therefore need appropriate authorisation both to install the package
from github and access the data.

## Installation

You can install the development version of malevnc from github:

``` r
install.packages("natmanager")
natmanager::install(pkgs="flyconnectome/malevnc")
```

Note that you must have a GitHub Personal Access Token (PAT) set up in order
to install the library for as long as it remains private. Do :

```
natmanager::check_pat()
```

to check and follow the instructions if necessary to create. Should you run into any errors with that (there have been some significant changes at 
github recently), you can also try:

```
usethis::create_github_token()
```

See https://usethis.r-lib.org/articles/articles/git-credentials.html for the 
gory details.

### Authentication
Access to neuprint / Clio then depends on authorisation. For neuprint, please
see https://github.com/natverse/neuprintr#authentication; you only need to set
the `neuprint_token` environment variable. For Clio, you will prompted to 
authenticate via a Google OAuth "dance" in your web browser.

### Registrations

Running the symmetrising/bridging registrations currently depends on CMTK.
To use these you will need a CMTK installation.

* For MacOS X use the dmg from https://www.nitrc.org/projects/cmtk/
* For windows, I recommend Cygwin install. See https://natverse.org/nat/articles/Installation.html#cmtk-nat-on-windows for details.
* For Linux I recommend compiling or using [neurodebian](http://neuro.debian.net/pkgs/cmtk.html).

## Example

You can check everything is working like so:

``` r
library(nat)
library(malevnc)
plot3d(MANC.surf)
```

