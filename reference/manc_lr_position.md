# Calculate the left-right position wrt to the symmetrised MANC midline

Calculate the left-right position wrt to the symmetrised MANC midline

## Usage

``` r
manc_lr_position(x, ...)
```

## Arguments

- x:

  An object containing XYZ vertex locations in microns, compatible with
  [`xyzmatrix`](https://rdrr.io/pkg/nat/man/xyzmatrix.html)

- ...:

  Additional arguments passed to
  [`xform`](https://rdrr.io/pkg/nat/man/xform.html)

## Value

A vector of point displacements in microns where 0 is at the midline and
positive values are to the fly's right.

## Examples

``` r
# \donttest{
library(nat)
#> Loading required package: rgl
#> Some nat functions depend on a CMTK installation. See ?cmtk and README.md for details.
#> 
#> Attaching package: ‘nat’
#> The following object is masked from ‘package:rgl’:
#> 
#>     wire3d
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, union
if(!is.null(cmtk.bindir())) {
lr=manc_lr_position(xyzmatrix(mancsomapos)/125)
# red for left, green for right (nautical convention)
points3d(xyzmatrix(mancsomapos), col=ifelse(lr<0, "red","green"))
plot3d(boundingbox(mancsomapos))
}
# }
```
