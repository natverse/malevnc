# Set a standard viewpoint for MANC data

Set a standard viewpoint for MANC data

## Usage

``` r
manc_view3d(
  viewpoint = c("ventral", "dorsal", "left", "right"),
  FOV = 0,
  template = c("MANCsym"),
  extramat = NULL,
  returnparams = FALSE,
  ...
)
```

## Arguments

- viewpoint:

  A string specifying an anatomical viewpoint (defaults to ventral)

- FOV:

  The Field of View (defaults to 0 =\> orthographic projection) (see
  [`par3d`](https://dmurdoch.github.io/rgl/dev/reference/par3d.html) for
  details).

- template:

  The template object implied by the `viewpoint` specification.
  Currently only the symmetric MANC template is supported.

- extramat:

  An optional extra transformation matrix to be applied after the one
  implied by the viewpoint argument.

- returnparams:

  When `FALSE` uses `par3d` to change the rgl device. When `TRUE` just
  returns the settings for you to use. See examples.

- ...:

  additional arguments passed to
  [`par3d`](https://dmurdoch.github.io/rgl/dev/reference/par3d.html)

## Value

When `returnparams` a named list

## Details

See [slack
discussion](https://flyem-cns.slack.com/archives/C02GY69SY3H/p1660679361976619)
for details.

## Examples

``` r
# default parameters
manc_view3d(returnparams=TRUE)
#> $userMatrix
#>      [,1]      [,2]       [,3] [,4]
#> [1,]   -1 0.0000000  0.0000000    0
#> [2,]    0 0.3420201  0.9396926    0
#> [3,]    0 0.9396926 -0.3420201    0
#> [4,]    0 0.0000000  0.0000000    1
#> 
#> $FOV
#> [1] 0
#> 
if (FALSE) { # \dontrun{
plot3d(MANC.tissue.surf.sym)
manc_view3d("ventral")
manc_view3d("dorsal")
manc_view3d("left")

## open a new window
# with regular rgl function
open3d(manc_view3d('ventral', returnparams=TRUE))
# with nat, allowing interactive pan
nopen3d(manc_view3d('ventral', returnparams=TRUE))
plot3d(MANC.tissue.surf.sym)
} # }
```
