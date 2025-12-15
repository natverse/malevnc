# Set Clio body annotations

Set Clio body annotations

## Usage

``` r
manc_annotate_body(
  x,
  test = TRUE,
  version = NULL,
  write_empty_fields = FALSE,
  allow_new_fields = FALSE,
  designated_user = NULL,
  protect = c("user"),
  chunksize = 50,
  query = TRUE,
  ...
)
```

## Arguments

- x:

  A data.frame, list or JSON string containing body annotations. **End
  users are strongly recommended to use data.frames.**

- test:

  Whether to use the test clio store (recommended until you are sure you
  know what you are doing).

- version:

  Optional clio version to associate with this annotation. The default
  `NULL` uses the current version returned by the API.

- write_empty_fields:

  When `x` is a data.frame, this controls whether empty fields in `x`
  (i.e. `NA` or `""`) overwrite fields in the clio-store database (when
  they are not protected by the `protect` argument). The (conservative)
  default `write_empty_fields=FALSE` does not overwrite. If you do want
  to set fields to an empty value (usually the empty string) then you
  must set `write_empty_fields=TRUE`.

- allow_new_fields:

  Whether to allow creation of new clio fields. Default `FALSE` will
  produce an error encouraging you to check the field names.

- designated_user:

  Optional email address when one person is uploading annotations on
  behalf of another user. See **Users** section for details.

- protect:

  Vector of fields that will not be overwritten if they already have a
  value in clio store. Set to `TRUE` to protect all fields and to
  `FALSE` to overwrite all fields for which you provide data. See
  details for the rationale behind the default value of "user"

- chunksize:

  When you have many bodies to annotate the request will by default be
  sent 50 records at a time to avoid any issue with timeouts. You can
  increase for a small speed up if you find your setup is fast enough.
  Set to `Inf` to insist that all records are sent in a single request.
  **NB only applies when `x` is a data.frame**.

- query:

  Special query to pass to Clio API. If TRUE, then the default is passed
  with Clio version, FALSE means no query, and list is allowed for a
  customized behaviour.

- ...:

  Additional parameters passed to
  [`pbapply::pbsapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

## Value

`NULL` invisibly on success. Errors out on failure.

## Details

Clio body annotations are stored in a shared backend between DVID and
Clio (aka neurojson). There are [API (Swagger)
docs](https://clio-store-vwzoicitea-uk.a.run.app/docs#/default/post_annotations_v2_json_annotations__dataset__neurons_post).

Formerly they were in a [Google
Firestore](https://cloud.google.com/firestore) database. Further details
are provided in [basic docs from Bill
Katz](https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit).
Each body has an associated JSON list containing a set of standard user
visible fields. Some of these are constrained. See [Clio fields Google
sheet](https://docs.google.com/spreadsheets/d/1v8AltqyPCVNIC_m6gDNy6IDK10R6xcGkKWFxhmvCpCs/edit?usp=sharing)
for details.

It can take some time to apply annotations, so requests are chunked by
default in groups of 50.

A single column called `position` or 3 columns names x, y, z or X, Y, Z
in any form accepted by
[`xyzmatrix`](https://rdrr.io/pkg/nat/man/xyzmatrix.html) will be
converted to a position stored with each record. This is recommended
when creating records.

When `protect=TRUE` no data in Clio will be overwritten - only new data
will be added. When `protect=FALSE` all fields will overwritten by new
data for each non-empty value in `x`. If `write_empty_fields=TRUE` then
even empty fields in `x` will overwrite fields in the database. Note
that these conditions apply per record i.e. per neuron not per column of
data.

## Validation

Validation depends on how you provide your input data. If `x` is a
data.frame then each row is checked for some basics including the
presence of a bodyid, and empty fields are removed. In future we will
also check fields which are only allowed to take certain values.

When `x` is a character vector, it is checked to see that it is valid
JSON and that there is a bodyid field for each record. This intended
principally for developer use or to confirm that a specific JSON payload
has been applied. You probably should not be using it regularly or for
bulk upload.

When `x` is a list, no further validation occurs.

For these reasons, **it is strongly recommended that end users provide
`data.frame` input**.

## Users

Any modifications to columns in clio are associated with the email
address that used to authenticate to Clio. This happens transparently
with a `<field>_user` being added automatically when modifications are
made via the front-end or API. For example the `type` field has a
corresponding `type_user` field which can be displayed when
`manc_body_annotations(show.extra='user')`.

If you want to upload annotations on someone else's behalf you can now
specify a `designated_user`. This should be the email address registered
with their Clio account.

Formerly only two fields collected information about changes, `user` and
`last_modified_by`. These are now deprecated and should no longer be
set. Related to this, the default value of protect has remained `"user"`
to avoid modifying the `user` field until it is retired.

## See also

Other manc-annotation:
[`manc_body_annotations()`](https://natverse.org/malevnc/reference/manc_body_annotations.md),
[`manc_meta()`](https://natverse.org/malevnc/reference/manc_meta.md),
[`manc_point_annotations()`](https://natverse.org/malevnc/reference/manc_point_annotations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# note use of test server
manc_annotate_body(data.frame(bodyid=10002, class='Descending Neuron',
  description='Giant Fiber'), test=TRUE)

# if you give a list then you are responsible for validation
manc_annotate_body(list(bodyid=10002, class='Descending Neuron',
  description='Giant Fiber'), test=TRUE)

# don't overwrite any fields in database
manc_annotate_body(list(bodyid=10002, class='Descending Neuron',
  description='Giant Fiber'), test=TRUE, protect=TRUE)

# overwrite all fields in database except with empty values
manc_annotate_body(list(bodyid=10002, class='Descending Neuron',
  description='Giant Fiber'), test=TRUE, protect=FALSE)

#' # overwrite all fields in database even if supplied data has empty values
manc_annotate_body(list(bodyid=10002, class='',
  description='Giant Fiber'), test=TRUE, protect=FALSE, write_empty_fields = TRUE)
} # }
```
