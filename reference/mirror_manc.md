# Mirror points or other 3D objects along the MANC midline

`symmetric_manc` transforms neurons, surfaces and other point data onto
a symmetrised version of the MANC template brain, optionally mirroring
across the midline.

## Usage

``` r
mirror_manc(x, level = c(5, 4), ...)

symmetric_manc(x, level = c(5, 4), mirror = FALSE, ...)
```

## Arguments

- x:

  3D vertices (or object containing them) in MANC space with **units of
  microns**. Could be
  [`neuron`](https://rdrr.io/pkg/nat/man/neuron.html),
  [`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html),
  [`hxsurf`](https://rdrr.io/pkg/nat/man/read.hxsurf.html) etc.

- level:

  Which resolution level of the CMTK registrations to use. Higher number
  = higher resolution. This is for expert/testing purposes only - just
  stick with the default.

- ...:

  additional arguments passed to
  [`xform`](https://rdrr.io/pkg/nat/man/xform.html) and friends

- mirror:

  Whether to mirror across the midline when using `symmetric_manc`

## Value

Transformed points/object

## Details

These registration functions depend on an installation of the CMTK
registration toolkit. See
[`cmtk.bindir`](https://rdrr.io/pkg/nat/man/cmtk.bindir.html) for
details.

## Examples

``` r
# \donttest{
# NB convert from raw coordinates to microns on input
hookr=cbind(33549, 45944, 50806)*c(8,8,8)/1000
hookl=cbind(8718, 40794, 52140)*c(8,8,8)/1000
hookrl=rbind(hookr, hookl)

# mirror these positions
hookrl.m=mirror_manc(hookrl)
#> Error in cmtk.bindir(check = TRUE): Cannot find CMTK. Please install from https://www.nitrc.org/projects/cmtk and make sure that it is your path!
hookrl.m
#> Error: object 'hookrl.m' not found
# compute difference from
# transformed L to original R
# transformed R to original L
# distances are 1-8 microns in each axis, due to placement variations.
hookrl.m-hookrl[2:1, ]
#> Error: object 'hookrl.m' not found
# }

if (FALSE) { # \dontrun{
# example of mirroring a neuron in original MANC space
dna02.um=manc_read_neurons("DNa02", units='microns')
dna02.um.m=mirror_manc(dna02.um, units='microns')
plot3d(dna02.um)
plot3d(dna02.um.m, col='grey')
} # }

if (FALSE) { # \dontrun{
wire3d(MANC.surf, col='grey', lwd=.5)
points3d(hookrl, col=c("green", "red"), size=10)
points3d(hookrl.m, col=c("green", "red"), size=5)
# the lines will link the transformed points
segments3d(rbind(hookrl, hookrl.m)[c(1,3,2,4), ])

# show the original surface and the mirrored surface
MANC.surf.m=mirror_manc(MANC.surf)
MANC.surf.m=mirror_manc(MANC.surf)
nclear3d()
plot3d(MANC.surf)
wire3d(MANC.surf.m)
} # }

if (FALSE) { # \dontrun{
symmetric_manc(MANC.surf)
# mirror across the midline in symmetric space also
MANCsym.surf.m=symmetric_manc(MANC.surf, mirror=T)

# plot the two symmetric surfaces
plot3d(MANCsym.surf)
wire3d(MANCsym.surf.m)
} # }
```
