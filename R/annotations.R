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
  u = manc_serverurl(
    "api/node/%s/neuroglancer_todo/tag/user:%s?app=natverse&u=%s",
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
      raw_col=unlist(raw_col, use.names = FALSE)
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


#' Return all DVID body annotations
#' @details See
#'   \href{https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1619201195032400}{this
#'    Slack post} from Stuart Berg for details.
#'
#'   Note that the original api call was \code{<rootuuid>:master}, but I have
#'   now just changed this to \code{<neutu-uuid>} as returned by
#'   \code{\link{manc_dvid_node}}. This was because the range query stopped
#'   working 16 May 2021, probably because of a bad node.
#'
#' @param rval Whether to return a fully parsed data.frame (the default) or an R
#'   list. The data.frame is easier to work with but typically includes NAs for
#'   many values that would be missing in the list.
#' @param node A DVID node as returned by \code{\link{manc_dvid_node}}. The
#'   default is to return the current active (unlocked) node being used through
#'   neutu.
#'
#' @return A \code{tibble} containing with columns including \itemize{
#'
#'   \item bodyid
#'
#'   \item status
#'
#'   \item user
#'
#'   \item naming_user
#'
#'   \item instance
#'
#'   \item status_user
#'
#'   \item comment }
#'
#'   NB these are slightly modified from
#'
#' @export
#'
#' @examples
#' \donttest{
#' mdf=manc_dvid_annotations()
#' head(mdf)
#' table(mdf$status)
#'
#' \dontrun{
#' # compare live body annotations with version in clio
#' mdf.clio=manc_dvid_annotations(manc_dvid_node('clio'))
#' waldo::compare(mdf.clio, mdf)
#' }
#' }
manc_dvid_annotations <- function(node=manc_dvid_node('neutu'),
                                  rval=c("data.frame", "list")) {
  rval=match.arg(rval)
  u=manc_serverurl("api/node/%s/segmentation_annotations/keyrangevalues/0/Z?json=true", node)
  res=httr::GET(u)
  httr::stop_for_status(res)
  d=jsonlite::fromJSON(httr::content(res, as='text', encoding = 'UTF-8'), simplifyVector = F)
  df=list2df(d)
  cdf=sub("body ID", "bodyid", colnames(df), fixed = T)
  cdf=sub(" ", "_", cdf, fixed = T)
  names(df)=cdf
  attr(df, 'dvid_node')=node
  df
}


#' Return clio-store body annotations for set of ids or a flexible query
#'
#' @details Missing values in each output column are filled with NA. But if a
#'   whole column is missing from the results of a particular query then it will
#'   not appear at all.
#' @inheritParams manc_connection_table
#' @param query A json query string (see examples or documentation) or an R list
#'   with field names as elements.
#' @param config An optional httr::config (expert use only, must include a
#'   bearer token)
#' @param json Whether to return unparsed JSON rather than an R list (default
#'   \code{FALSE}).
#' @param ... Additional arguments passed to \code{pbapply::\link{pblapply}}
#'
#' @return An R data.frame or a character vector containing JSON (when
#'   \code{json=TRUE}).
#' @export
#'
#' @family manc-annotation
#' @seealso
#' \href{https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit}{basic
#' docs from Bill Katz}.
#' @examples
#' \dontrun{
#' manc_body_annotations(ids=11442)
#' manc_body_annotations(query='{"hemilineage": "0B"}')
#' manc_body_annotations(query=list(user="janedoe@gmail.com"))
#' manc_body_annotations(query=list(soma_side="RHS"))
#' manc_body_annotations(ids=manc_xyz2id(mancneckseeds))
#' }
manc_body_annotations <- function(ids=NULL, query=NULL, json=FALSE, config=NULL,
                                  ...) {
  nmissing=sum(is.null(ids), is.null(query))
  if(nmissing!=1)
    stop("you must provide exactly one of `ids` or `query` as input!")
  baseurl="https://clio-store-vwzoicitea-uk.a.run.app/v2/json-annotations/VNC/neurons"
  if(!is.null(ids)) {
    ids=manc_ids(ids)
    chunksize=1000
    if(length(ids)>chunksize) {
      chunknums=floor((seq_along(ids)-1)/chunksize)+1
      chunkedids=split(ids, chunknums)
      res=pbapply::pblapply(chunkedids, manc_body_annotations, json=json, config=config, ...)
      return(dplyr::bind_rows(res))
    }
    if(length(ids)>1)
      ids=paste(ids, collapse = ',')
    u=sprintf("%s/id-number/%s", baseurl, ids)
    body=NULL
  } else {
    u=sprintf("%s/query", baseurl)
    body <- if(is.list(query))
      jsonlite::toJSON(query, auto_unbox = TRUE)
    else {
      if(!isTRUE(jsonlite::validate(query)))
        stop("Query is not valid JSON!")
      query
    }
  }
  clio_fetch(u, body = body,
           query=list(changes = "false", id_field = "bodyid"),
           config = config, json = json)

}


#' Return point annotations from Clio store
#'
#' @param groups Defines a group for which we would like to see all annotations. When NULL, only returns annotations for your own user.
#'
#' @family manc-annotation
#' @return A data.frame of annotations
#' @export
#'
#' @examples
#' \dontrun{
#' mpa=manc_point_annotations()
#' head(mpa)
#' }
manc_point_annotations <- function(groups="UK Drosophila Connectomics") {

  u="https://clio-store-vwzoicitea-uk.a.run.app/v2/annotations/VNC"

  if(!is.null(groups)) {
    groups=gsub(" ", "+", groups)
    u=paste0(u, "?groups=", groups)
  }
  clio_fetch(u)
}
