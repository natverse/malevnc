# Simplified (and symmetrized) tissue surface of MALEVNC

`MANC.tissue.surf.sym` is a symmetrised version of `MANC.tissue.surf`
using
[`symmetric_manc`](https://natverse.org/malevnc/reference/mirror_manc.md).

`MANC.nerves` contains meshes of 35 nerves: 17 symmetric pairs `(L)/(R)`
and `AbNT`. These were hand-drawn based on the MANC grayscale data,
guided by motor neuron and sensory neuron axon reconstructions.
Abbreviated names follow the conventions established in Court et al.,
2020 and are defined in Table 2 of Takemura et al., 2023.

## Usage

``` r
MANC.tissue.surf

MANC.tissue.surf.sym

MANC.nerves
```

## Format

An object of class `hxsurf` (inherits from `list`) of length 4.

An object of class `hxsurf` (inherits from `list`) of length 4.

An object of class `hxsurf` (inherits from `list`) of length 4.

## Examples

``` r
if (FALSE) { # \dontrun{
# Depends on nat
library(nat)
wire3d(MANC.tissue.surf)
wire3d(MANC.tissue.surf.sym)
} # }
if (FALSE) { # \dontrun{
# Depends on nat
library(nat)
plot3d(MANC.nerves)
} # }
# \donttest{
# Nerve names and their default colours
as.data.frame(MANC.nerves[c("RegionList", "RegionColourList")])
#>    RegionList RegionColourList
#> 1     AbN1(L)          #7300FF
#> 2     AbN1(R)          #9900FF
#> 3     AbN2(L)          #00FF73
#> 4     AbN2(R)          #00FFB3
#> 5     AbN3(L)          #00B3A2
#> 6     AbN3(R)          #009980
#> 7     AbN4(L)          #FF6300
#> 8     AbN4(R)          #FF9400
#> 9        AbNT          #D600FF
#> 10    ADMN(L)          #00CC60
#> 11    ADMN(R)          #009933
#> 12     CvN(L)          #FF00A0
#> 13     CvN(R)          #FF0080
#> 14  DMetaN(L)          #FF4500
#> 15  DMetaN(R)          #FF2200
#> 16   DProN(L)          #a7faf7
#> 17   DProN(R)          #bff5f3
#> 18  MesoAN(L)          #0084ff
#> 19  MesoAN(R)          #0095ff
#> 20  MesoLN(L)          #52FF00
#> 21  MesoLN(R)          #21FF00
#> 22  MetaLN(L)          #faed05
#> 23  MetaLN(R)          #fff830
#> 24    PDMN(L)          #FFBB00
#> 25    PDMN(R)          #FFDD00
#> 26     PrN(L)          #0e0114
#> 27     PrN(R)          #09020d
#> 28   ProAN(L)          #BBAA00
#> 29   ProAN(R)          #998800
#> 30   ProCN(L)          #f788f2
#> 31   ProCN(R)          #f274ec
#> 32   ProLN(L)          #FF0000
#> 33   ProLN(R)          #CC0000
#> 34   VProN(L)          #10FF00
#> 35   VProN(R)          #00CC00
# }
```
