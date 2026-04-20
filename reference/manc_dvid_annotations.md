# Return all DVID body annotations

Return all DVID body annotations

## Usage

``` r
manc_dvid_annotations(
  ids = NULL,
  node = "neutu",
  rval = c("data.frame", "list"),
  columns_show = NULL,
  cache = FALSE
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.md).
  The default is to return the current active (unlocked) node being used
  through neutu.

- rval:

  Whether to return a fully parsed data.frame (the default) or an R
  list. The data.frame is easier to work with but typically includes NAs
  for many values that would be missing in the list.

- columns_show:

  Whether to show all columns, or just with '\_user', or '\_time'
  suffix. Accepted options are: 'user', 'time', 'all'.

- cache:

  Whether to cache the result of this call for 5 minutes.

## Value

A `tibble` containing with columns including

- bodyid as a `numeric` value

- status

- user

- naming_user

- instance

- status_user

- comment

NB only one `bodyid` is used regardless of whether the key-value
returned has 0, 1 or 2 bodyid fields. When the `ids` are specified,
missing ids will have a row containing the `bodyid` in question and then
all other columns will be `NA`.

## Details

See [this Slack
post](https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1619201195032400)
from Stuart Berg for details.

Note that the original api call was `<rootuuid>:master`, but I have now
just changed this to `<neutu-uuid>` as returned by
[`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.md).
This was because the range query stopped working 16 May 2021, probably
because of a bad node.

## Examples

``` r
# \donttest{
mdf=manc_dvid_annotations()
head(mdf)
#> # A tibble: 6 × 54
#>   bodyid class      description entry_nerve exit_nerve group instance long_tract
#>    <dbl> <chr>      <chr>       <chr>       <chr>      <dbl> <chr>    <chr>     
#> 1  10000 descendin… Giant fiber CvC         "None"     10000 DNlt002… none      
#> 2  10001 sensory n… NA          ProLN_R      NA           NA SNxxxx_… NA        
#> 3  10002 descendin… Giant fiber CvC         "None"     10000 DNlt002… none      
#> 4  10003 sensory n… NA          ProLN_L      NA           NA SNta29_… NA        
#> 5  10004 intrinsic… 13B in T2 … None        ""         10004 IN13B07… NA        
#> 6  10007 sensory n… NA          AbN3_R       NA           NA SNpp03_… NA        
#> # ℹ 46 more variables: nt_acetylcholine_prob <dbl>, nt_gaba_prob <dbl>,
#> #   nt_glutamate_prob <dbl>, nt_unknown_prob <dbl>, origin <chr>,
#> #   position <chr>, position_type <chr>, predicted_nt <chr>,
#> #   predicted_nt_prob <dbl>, prefix <chr>, root_position <chr>,
#> #   root_side <chr>, status <chr>, subclass <chr>, synonyms <chr>,
#> #   systematic_type <chr>, target <chr>, transmission <chr>, type <chr>,
#> #   user <chr>, vfb_id <chr>, modality <chr>, tag <chr>, soma_side <chr>, …
table(mdf$status)
#> 
#>                                   0.5assign                Anchor 
#>                   497                   892                   168 
#>                Orphan            PRT Orphan Prelim Roughly traced 
#>                   287                   245                  4896 
#>        Primary Anchor             RT Orphan        Roughly traced 
#>                     1                   314                 18304 
#>        Sensory Anchor           Soma Anchor           Unimportant 
#>                    45                     3                  1617 

manc_dvid_annotations('DNp01')
#> # A tibble: 2 × 54
#>   bodyid class      description entry_nerve exit_nerve group instance long_tract
#>    <dbl> <chr>      <chr>       <chr>       <chr>      <dbl> <chr>    <chr>     
#> 1  10000 descendin… Giant fiber CvC         None       10000 DNlt002… none      
#> 2  10002 descendin… Giant fiber CvC         None       10000 DNlt002… none      
#> # ℹ 46 more variables: nt_acetylcholine_prob <dbl>, nt_gaba_prob <dbl>,
#> #   nt_glutamate_prob <dbl>, nt_unknown_prob <dbl>, origin <chr>,
#> #   position <chr>, position_type <chr>, predicted_nt <chr>,
#> #   predicted_nt_prob <dbl>, prefix <chr>, root_position <chr>,
#> #   root_side <chr>, status <chr>, subclass <chr>, synonyms <chr>,
#> #   systematic_type <chr>, target <chr>, transmission <chr>, type <chr>,
#> #   user <chr>, vfb_id <chr>, modality <chr>, tag <chr>, soma_side <chr>, …

if (FALSE) { # \dontrun{
# compare live body annotations with version in clio
mdf.clio=manc_dvid_annotations('clio')
waldo::compare(mdf.clio, mdf)
} # }
# }
```
