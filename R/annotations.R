#' Read point annotations from DVID using neuprint authentication
#'
#' @param email The google email address used to authenticate with neuprint
#' @param node The DVID node identifier
#' @param raw Whether to return the raw \code{httr::\link[httr]{GET}} response
#'   (default \code{FALSE}) so that you can process it yourself rather than a
#'   pre-processed R list.
#' @param simplifyVector Whether to simplify lists to vectors (and data frames
#'   where appropriate). Default \code{TRUE}, see
#'   \code{jsonlite::\link[jsonlite]{fromJSON}} for details.
#' @param neuprint_connection A \code{\link[neuprintr]{neuprintr}} connection
#'   object returned by \code{\link[neuprintr]{neuprint_login}}. This includes
#'   the required authorisation information to connect to DVID.
#' @param tz Time zone for edit timestamps. Defaults to "UTC" i.e. Universal
#'   Time, Coordinated. Set to "" for your current timezone. See
#'   \code{\link{as.POSIXct}} for more details.
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' \donttest{
#' df=manc_user_annotations()
#' head(df)
#' json=httr::content(manc_user_annotations(raw=TRUE))
#' }
manc_user_annotations <- function(email = "jefferis@gmail.com",
                                  node = manc_dvid_node(),
                                  raw = FALSE,
                                  simplifyVector=TRUE,
                                  neuprint_connection = NULL,
                                  tz="UTC") {
  if (is.null(neuprint_connection)) {
    if(!requireNamespace('neuprintr'))
      stop("Please install suggested package neuprintr!\n",
           'natmanager::install(pkgs="neuprintr")')
    neuprint_connection = manc_neuprint()
    neuprint_connection$config
  }
  u = sprintf(
    "https://hemibrain-dvid2.janelia.org/api/node/%s/neuroglancer_todo/tag/user:%s?app=Neuroglancer&u=%s",
    node,
    email,
    email
  )
  resp = httr::GET(u, config = neuprint_connection$config)
  httr::stop_for_status(resp)
  if(raw)
    return(resp)
  else {
    df=httr::content(resp, 'parsed', type='application/json', simplifyVector = simplifyVector, flatten=T)
    names(df)=sub("Prop.","", names(df), fixed = T)
    df$timestamp=as.POSIXct(as.numeric(df$timestamp)/1e3,
                                 origin="1970-01-01", tz=tz)
    df
  }
}

list2df <- function(x, points=c('collapse', 'expand', 'list'),
                    lists=c("collapse", "list"), collapse=",", ...) {
  points=match.arg(points)
  lists=match.arg(lists)
  cns=unique(unlist(sapply(x, names, simplify = F)))

  collapse_col <- function(col) sapply(col, paste, collapse=collapse)
  l=list()
  for(i in cns) {
    raw_col = lapply(x, "[[", i)
    raw_col[sapply(raw_col, is.null)]=NA
    sublens=sapply(raw_col, length)
    if(all(sublens==1)){
      raw_col=unlist(raw_col)
    } else if(grepl("^point", i) && all(sublens==3L)) {
      if(points=='expand') {
        raw_col=lapply(1:3, function(j) sapply(raw_col, "[[", j))
        names(raw_col) <- paste0(i, c("X","Y","Z"))
        l[names(raw_col)]=raw_col
        next
      } else if(points=='collapse')
        raw_col=collapse_col(raw_col)
    } else if(lists=='collapse')
      raw_col=collapse_col(raw_col)

    l[[i]]=raw_col
  }
  # l
  tibble::as_tibble(l, ...)
}
