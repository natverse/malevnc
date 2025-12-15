# Download MANC (EM) to JRC (light level) registrations

John Bogovic and Stephan Saalfeld have constructed a series of [bridging
registrations](https://www.janelia.org/open-science/jrc-2018-brain-templates)
from both light level and EM brains imaged at HHMI Janelia Research
Campus. This function downloads the VNC registrations to your local
machine to allow you to convert data between this different template
spaces.

## Usage

``` r
download_manc_registrations()
```

## Details

It downloads publicly available registrations: MANC to JRC2018VNCM
<https://figshare.com/s/7f003353c24741136df3> JRC2018VNCM \<\>
JRC2018VNCU <https://figshare.com/s/42ad71eb14e7dd51e81a> RC2018VNCF
\<\> JRC2018VNCU <https://figshare.com/s/c4589cef9180e1dd4ee1>

It requires installation of a suggested dependency `nat.jrcbrains`.
These transformations operate in units of microns. Therefore, any point
coordinates must be converted to micron units before applying.

In order to use the registrations you need to load the `nat.jrcbrains`.

## References

See Bogovic et al. (2018)
[doi:10.1101/376384](https://doi.org/10.1101/376384)

## Examples

``` r
if (FALSE) { # \dontrun{
# one time install of optional package if you don't have it
if(!requireNamespace('nat.jrcbrains'))
  natmanager::install(pkgs = 'nat.jrcbrains')
# load this to use bridging registrations to JRC templates
library(nat.jrcbrains)

# one time download of large (~1.4 GB) bridging registrations
if(!"MANC" %in% allreg_dataframe()$reference)
  download_manc_registrations()

DNa02s=read_manc_meshes('DNa02')
# nb convert from nm to microns
DNa02s.jrcvnc2018u=xform_brain(DNa02s/1e3, reference = "JRCVNC2018U", sample="MANC")
plot3d(DNa02s.jrcvnc2018u)
plot3d(JRCVNC2018U)
} # }
```
