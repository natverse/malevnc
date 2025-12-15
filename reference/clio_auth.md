# Clio authorisation infrastructure using Google via the gargle package + JWT

`clio_auth` sets up the initial Google token that ultimately authorises
malevnc to view and edit data in the clio-store for body annotations.
This function is a wrapper around
[`gargle::token_fetch`](https://gargle.r-lib.org/reference/token_fetch.html).
You should normally not need to use it directly, but it can be useful if
you run into authorisation problems (see examples).

`clio_token` returns a long lived token to use for clio store queries.
Experts may wish to use this to construct their own API requests.

`clio_set_token` sets Clio token manually.

## Usage

``` r
clio_auth(
  email = getOption("malevnc.clio_email", gargle::gargle_oauth_email()),
  cache = gargle::gargle_oauth_cache(),
  ...
)

clio_token(force = FALSE)

clio_set_token(token, force = FALSE)
```

## Arguments

- email:

  An optional email - must be the one linked to your Clio account (and
  therefore linked to a Google account). See
  `gargle::link{credentials_user_oauth2}` for details.

- cache:

  Whether to use an oauth cache (Expert use only, see
  [`gargle::gargle_oauth_cache`](https://gargle.r-lib.org/reference/gargle_options.html)
  for details).

- ...:

  Additional arguments passed to
  [`gargle::token_fetch`](https://gargle.r-lib.org/reference/token_fetch.html)

- force:

  logical value that determines whether to override the existing token
  or not (default FALSE).

- token:

  character with a token value

## Details

Clio store authorisation is a multi step process. You must first
authenticate to Google who will return a token confirming your identity;
this token only lasts ~30m. This Google token is then presented to a
clio store endpoint to generate a long lived clio token, which is cached
on disk (for up to 3 weeks at the time of writing). You can also specify
a token via the `CLIO_TOKEN` environment variable - this is mainly
provided as a convenience during continuous integration testing.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get or refresh clio JWT token (with the associated email as an attribute)
clio_token()

# regenerate token for specified email if you are getting 401 web errors
clio_auth("user@gmail.com", cache=FALSE)

# To remember your preferred email (e.g. because you have >1 Google account)
usethis::edit_r_profile()
# then add this line, save and restart
options(malevnc.clio_email="user@gmail.com")
} # }
```
