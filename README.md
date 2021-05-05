# malevnc

<!-- badges: start -->
[![R-CMD-check](https://github.com/flyconnectome/malevnc/workflows/R-CMD-check/badge.svg)](https://github.com/flyconnectome/malevnc/actions)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://flyconnectome.github.io/malevnc/reference/)
<!-- badges: end -->

The goal of malevnc is to provide a package to support analysis on the Janelia
male VNC dataset aka (MANC). Note that this package points to private resources
made available by the male VNC project led by the FlyEM team at Janelia.
Please do not share with anyone who does not have permissions to access the VNC
neuprint dataset.

## Installation

You can install the development version of malevnc from github:

``` r
install.packages(natmanager)
natmanager::install(pkgs="flyconnectome/malevnc")
```

Note that you must have a GitHub Personal Access Token (PAT) set up in order
to install the library for as long as it remains private. Do :

```
natmanager::check_pat()
```

to check and follow the instructions if necessary to create. 
See https://usethis.r-lib.org/articles/articles/git-credentials.html for the 
gory details.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(nat)
library(malevnc)
plot3d(MANC.surf)
```

