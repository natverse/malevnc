# Shorten a Neuroglancer URL using the Janelia FlyEM link shortener

Shorten a Neuroglancer URL using the Janelia FlyEM link shortener

## Usage

``` r
flyem_shorten_url(
  url,
  filename = NA_character_,
  title = NA_character_,
  method = c("default", "md5", "ms"),
  password = NULL,
  ...
)

flyem_expand_url(url, return = c("url", "json", "parsed"), ...)
```

## Arguments

- url:

  One or more URLs to shorten or expand

- filename:

  An optional filename to use in the shortened URL. You can also provide
  a URL in which case the terminal filename will be extracted.

- title:

  An optional title for the webpage

- method:

  An optional scheme for automatic naming of shortened URLs. See
  details.

- password:

  Optional password to allow rewriting of short URLs

- ...:

  Additional arguments passed to
  [`httr::POST`](https://httr.r-lib.org/reference/POST.html)

- return:

  When expanding, whether to return a long URL, an R list or a JSON text
  fragment.

## Value

For `flyem_shorten_url` a character vector containing a short URL. For
`flyem_expand_url` a character vector or list depending on the `return`
argument. If the input `url` argument is a named vector of length\>1,
then the output will also be named.

## Details

The default filename for these fragments consists of the date and time
to the nearest second. For this reason you will have trouble generating
many of these links in quick succession. To overcome this limitation,
you can specify your own filename. We also provide two convenience
naming methods: .

- **md5** An md5 hash of the URL+title e.g.
  `"9a35fc580f710f3a62b2809a10fe106d.json"` .

- **ms** Timestamp to the nearest millisecond e.g.
  `"1708773000.001.json"`

Note that this is an open endpoint so there are two potential security
concerns. URLs named by date/time can potentially be guessed and
inspected. Known URLs can be overwritten to point to a new location. If
these are concerns then the MD5 hash format has some advantages.

see the underlying [github
repo](https://github.com/janelia-flyem/flyem-shortener) for details.

## Examples

``` r
if (FALSE) { # \dontrun{
# this reads the URL from the clipboard
su=flyem_shorten_url(clipr::read_clip())
lu=flyem_expand_url(su)
fafbseg::ngl_decode_scene(lu)
# these give you the same result
browseURL(su)
browseURL(lu)

# Generate many unique short URLs based on an MD5 hash of the long URL
sus=flyem_shorten_url("<Long URLs>", method='md5')
} # }
```
