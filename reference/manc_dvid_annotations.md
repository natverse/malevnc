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
#> Error in manc_dvid_node("neutu"): The package option malevnc.dataset is unset. Please set or manually reload package!
head(mdf)
#> Error: object 'mdf' not found
table(mdf$status)
#> Error: object 'mdf' not found

manc_dvid_annotations('DNp01')
#> Error in neuprint_login(server = server, dataset = dataset, token = token,     ...): Sorry you must specify a neuprint server! See ?neuprint_login for details!

if (FALSE) { # \dontrun{
# compare live body annotations with version in clio
mdf.clio=manc_dvid_annotations('clio')
waldo::compare(mdf.clio, mdf)
} # }
# }
```
