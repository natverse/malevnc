# Annotate an XYZ location in Clio as a soma or root

Annotate an XYZ location in Clio as a soma or root

## Usage

``` r
manc_annotate_soma(
  pos,
  tag = c("soma", "tosoma", "root"),
  user = getOption("malevnc.clio_email"),
  description = NULL,
  ...
)
```

## Arguments

- pos:

  XYZ positions in any raw MANC voxel coordinates in any form compatible
  with [`xyzmatrix`](https://rdrr.io/pkg/nat/man/xyzmatrix.html)

- tag:

  One tag (or as many as there are points) to define the annotation. See
  details.

- user:

  One user (or as many users as there are points) to define the
  annotation. See details.

- description:

  Either `NULL`, one value or as any as there are points.

- ...:

  Additional arguments passed to
  [`pbapply::pbmapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)
  and then to the private `clio_fetch` function.

## Value

the key for the new point annotation, invisibly

## Details

You should use the tags in the following order of preference

- soma:

  If there is a visible soma, use this tag.

- tosoma:

  If the soma is not in the dataset, but you know where it is, use this
  tag.

- root:

  If you are not sure where the soma is, but you want to specify a
  position to act as the root e.g. skeletonising the neuron, use this
  tag.

When annotating multiple points, you can provide either one user/tag or
you must provide a user tag for every point.

## Examples

``` r
if (FALSE) { # \dontrun{
manc_annotate_soma(cbind(31180, 17731, 31252))
} # }
```
