# malevnc

<!-- badges: start -->
<!-- badges: end -->

The goal of malevnc is to provide a package to support analysis on the Janelia
male VNC dataset aka (MANC)

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
library(malevnc)
plot3d(MANC.surf)
```
