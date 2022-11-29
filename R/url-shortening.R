#' Shorten a Neuroglancer URL using the Janelia FlyEM link shortener
#'
#' @param url An url to shorten or expand
#' @param filename An optional filename to use in the shortened URL (not yet
#'   supported)
#' @param return When expanding, whether to return a long URL, an R list or a
#'   JSON text fragment.
#' @param ... Additional arguments passed to \code{httr::POST}
#'
#' @return For \code{flyem_shorten_url} a character vector containing a short
#'   URL. For \code{flyem_expand_url} see a character vector or list depending
#'   on \code{return} argument.
#' @export
#' @details see
#'   \href{https://flyem-cns.slack.com/archives/C01BZB05M8C/p1669646269799509}{FlyEM
#'   CNS Slack} for more details.
#'
#' @examples
#' \dontrun{
#' su=flyem_shorten_url(manc_scene('group:10200'))
#' lu=flyem_expand_url(su)
#' fafbseg::ngl_decode_scene(lu)
#' # these give you the same result
#' browseURL(su)
#' browseURL(lu)
#' }
flyem_shorten_url <- function(url, filename=NULL, ...) {
  # body=list(url, filename=filename)
  # body=list(fafbseg::ngl_encode_url(url))
  stop("filename argument not yet supported!")
  body <- if(is.null(filename)) url else list(
    url,
    filename=filename
  )

  us='https://shortng-bmcp5imp6q-uc.a.run.app/shortng'
  res=httr::POST(url = us, body = body, encode = 'json', ...)
  httr::stop_for_status(res)
  httr::content(res, as='text')

}

#' @export
#' @rdname flyem_shorten_url
flyem_expand_url <- function(url, return=c("url", "json", "parsed"), ...) {
  pu=httr::parse_url(url)
  if(is.null(pu$fragment))
    stop("That doesn't look like a short URL. No fragment!")
  if(!isTRUE(substr(pu$fragment,1,6)=="!gs://"))
    stop("That doesn't look like a short URL. Fragment should start with: !gs://")
  path=substr(pu$fragment, 6, nchar(pu$fragment))

  gu="https://storage.googleapis.com"
  fullurl=paste0(gu, path)
  res=httr::GET(fullurl, ...)
  httr::stop_for_status(res)
  return=match.arg(return)
  resp=httr::content(res,
                     as = switch(return, parsed='parsed', 'text'),
                     type = "application/json", encoding = "UTF-8")
  if(return=='url') {
    pu$fragment=NULL
    bu=httr::build_url(pu)
    fafbseg::ngl_encode_url(resp,baseurl = bu)
  } else resp
}
