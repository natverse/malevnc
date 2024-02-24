#'Shorten a Neuroglancer URL using the Janelia FlyEM link shortener
#'
#'@details The default filename for these fragments consists of the date and
#'  time to the nearest second. For this reason you will have trouble generating
#'  many of these links in quick succession. To overcome this limitation, you
#'  can specify your own filename. We also provide two convenience naming
#'  methods:
#'. \itemize{
#'    \item \bold{md5} An md5 hash of the URL+title e.g. \code{"9a35fc580f710f3a62b2809a10fe106d.json"}
#'.   \item \bold{ms} Timestamp to the nearest millisecond e.g. \code{"1708773000.001.json"}
#'   }
#'
#'  Note that this is an open endpoint so there are two potential security
#'  concerns. URLs named by date/time can potentially be guessed and inspected.
#'  Known URLs can be overwritten to point to a new location. If these are
#'  concerns then the MD5 hash format has some advantages.
#'
#'@param url One or more URLs to shorten or expand
#'@param filename An optional filename to use in the shortened URL. You can also
#'  provide a URL in which case the terminal filename will be extracted.
#'@param title An optional title for the webpage
#'@param method An optional scheme for automatic naming of shortened URLs. See
#'  details.
#'@param return When expanding, whether to return a long URL, an R list or a
#'  JSON text fragment.
#'@param ... Additional arguments passed to \code{httr::POST}
#'
#'@return For \code{flyem_shorten_url} a character vector containing a short
#'  URL. For \code{flyem_expand_url} a character vector or list depending on the
#'  \code{return} argument. If the input \code{url} argument is a named vector
#'  of length>1, then the output will also be named.
#'@export
#'@details see
#'   \href{https://flyem-cns.slack.com/archives/C01BZB05M8C/p1669646269799509}{FlyEM
#'    CNS Slack} for more details.
#'
#' @examples
#' \dontrun{
#' # this reads the URL from the clipboard
#' su=flyem_shorten_url(clipr::read_clip())
#' lu=flyem_expand_url(su)
#' fafbseg::ngl_decode_scene(lu)
#' # these give you the same result
#' browseURL(su)
#' browseURL(lu)
#'
#' # Generate many unique short URLs based on an MD5 hash of the long URL
#' sus=flyem_shorten_url("<Long URLs>", method='md5')
#' }
flyem_shorten_url <- function(url, filename=NA_character_, title=NA_character_,
                              method=c("default", "md5", "ms"), ...) {
  method=match.arg(method)
  if(length(url)>1) {
    named=!is.null(names(url))
    res <- pbapply::pbmapply(flyem_shorten_url, url=url,
                        filename=filename, title=title, ...,
                        MoreArgs = list(method=method), USE.NAMES = named)
    return(res)
  }
  if(is.na(title)) title=NULL
  if(method=='md5') {
    md5=digest::digest(list(url, title), algo = 'md5')
    filename=paste0(md5, ".json")
  } else if(method=='ms') {
    ts=format(round(as.numeric(Sys.time()), digits = 3), digits=15, scientific = F)
    filename=paste0(ts, '.json')
  } else {
    # convert URL to filename as a convenience
    if(isTRUE(grepl("^http(s){0,1}://", filename)))
      filename=basename(filename)
  }
  if(is.na(filename)) filename=NULL
  body <- if(is.null(filename) && is.null(title)) url else {
    list(filename=filename, text=url, title=title)
  }
  us='https://shortng-bmcp5imp6q-uc.a.run.app/shortng'
  res=httr::POST(url = us, body = body, encode = 'multipart', ...)
  httr::stop_for_status(res)
  httr::content(res, as='text')
}

#' @export
#' @rdname flyem_shorten_url
flyem_expand_url <- function(url, return=c("url", "json", "parsed"), ...) {
  return=match.arg(return)
  if(length(url)>1) {
    named=!is.null(names(url))
    res=pbapply::pbsapply(url, flyem_expand_url, return=return, ..., USE.NAMES = named)
    return(res)
  }
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
  resp=httr::content(res,
                     as = switch(return, parsed='parsed', 'text'),
                     type = "application/json", encoding = "UTF-8")
  if(return=='url') {
    pu$fragment=NULL
    bu=httr::build_url(pu)
    fafbseg::ngl_encode_url(resp,baseurl = bu)
  } else resp
}
