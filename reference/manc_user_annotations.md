# Read point annotations from DVID using neuprint authentication

Read point annotations from DVID using neuprint authentication

## Usage

``` r
manc_user_annotations(
  email = "jefferis@gmail.com",
  node = "clio",
  raw = FALSE,
  simplifyVector = TRUE,
  neuprint_connection = NULL,
  tz = "UTC"
)
```

## Arguments

- email:

  The google email address used to authenticate with neuprint

- node:

  The DVID node identifier

- raw:

  Whether to return the raw
  `httr::`[`GET`](https://httr.r-lib.org/reference/GET.html) response
  (default `FALSE`) so that you can process it yourself rather than a
  pre-processed R list.

- simplifyVector:

  Whether to simplify lists to vectors (and data frames where
  appropriate). Default `TRUE`, see
  `jsonlite::`[`fromJSON`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)
  for details.

- neuprint_connection:

  A
  [`neuprintr`](https://natverse.org/neuprintr/reference/neuprintr-package.html)
  connection object returned by
  [`neuprint_login`](https://natverse.org/neuprintr/reference/neuprint_login.html).
  This includes the required authorisation information to connect to
  DVID.

- tz:

  Time zone for edit timestamps. Defaults to "UTC" i.e. Universal Time,
  Coordinated. Set to "" for your current timezone. See
  [`as.POSIXct`](https://rdrr.io/r/base/as.POSIXlt.html) for more
  details.

## Value

A data.frame

## Examples

``` r
# \donttest{
df=manc_user_annotations()
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
head(df)
#>                                               
#> 1 function (x, df1, df2, ncp, log = FALSE)    
#> 2 {                                           
#> 3     if (missing(ncp))                       
#> 4         .Call(C_df, x, df1, df2, log)       
#> 5     else .Call(C_dnf, x, df1, df2, ncp, log)
#> 6 }                                           
json=httr::content(manc_user_annotations(raw=TRUE))
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!
# }
```
