# Create SVG figure with leg muscles coloured based on supplied colour palette

`leg_muscle_palette` returns the default palette for the leg muscles.

## Usage

``` r
colour_leg_muscles(f = NULL, colpal = NULL, colids = names(colpal))

leg_muscle_palette()
```

## Arguments

- f:

  Path to write out SVG file

- colpal:

  A vector of colours named by the leg muscles

- colids:

  The names of the muscles

## Value

When `f` is missing, an object of class `xml_document` that can be
further modified using the `xml2` package. Otherwise, the path `f`,
invisibly.

## Examples

``` r
# \donttest{
pal=leg_muscle_palette()
pal
#> Tergopleural-Pleural-promotor      Pleural-remotor-abductor 
#>                     "#2280B8"                     "#7B2DBA" 
#>                      Tergotr.              Sternotrochanter 
#>                     "#EFE952"                     "#CCF750" 
#>     Sternal-posterior-rotator      Sternal-anterior-rotator 
#>                     "#AE22BA"                     "#33C0D0" 
#>              Sternal-adductor                   Tr-extensor 
#>                     "#145E67"                     "#FAA400" 
#>                     Tr-flexor                   Fe-reductor 
#>                     "#311EE2"                     "#F82401" 
#>                   Ti-extensor                     Ti-flexor 
#>                     "#FBC700"                     "#3456E2" 
#>                           LTM                Ti-acc.-flexor 
#>                     "#F0EAA3"                     "#22944D" 
#>                   Tr-reductor                          LTM1 
#>                     "#2CB54D"                     "#F0EAA3" 
#>                   Ta-extensor                     Ta-flexor 
#>                     "#397EE2"                     "#FCC87E" 
pal[]='white'
pal['Fe-reductor']='red'
if (FALSE) { # \dontrun{
colour_leg_muscles(f='Fe-reductor.svg', colpal=pal)
} # }
# }
```
