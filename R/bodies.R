manc_last_modified <- function(ids, node=manc_dvid_node('neutu'), ...) {
  u=manc_serverurl('api/node/%s/%s/lastmod/%s', node, "segmentation", ids)
  l=pbapply::pbsapply(u, .manc_last_modified, simplify = F, ...)
  df=list2df(l)
  colnames(df)=gsub(" ", "_", colnames(df), fixed = T)
  df$bodyid=ids
  df
}

.manc_last_modified <- function(u) {
  r=httr::GET(u)
  res=httr::stop_for_status(r)
  res2=httr::content(res, as='parsed', type='application/json')
  res2
}


#' Get all the modifications associated with one or more DVID nodes
#'
#' @param nodes One or more DVID nodes. Ranges can be specified as
#'   \code{"first:last"}. The special value \code{"all"} implies the full
#'   sequence from the root node.
#' @param include_first Whether to include the first node in a sequence. The
#'   default behaviour (when \code{=NA}) will ignore the first node in a range
#'   specified \code{first:last} but keep the root nodes for the special range
#'   of "all".
#' @param bigcols Whether to include big columns in the results. The
#'   CleavedSupervoxels column in particular is very large and probably is not
#'   that useful for many. Default \code{FALSE}.
#' @param ... Additional arguments passed to pbapply
#'
#' @return A \code{tibble} with columns including: \itemize{
#'
#'   \item Action: merge, cleave, supervoxel-split
#'
#'   \item App: Typically NeuTu/Neu3
#'
#'   \item Target: For NeuTu the bodyid of the (larger) target object
#'
#'   \item Labels: For NeuTu the bodyids of the (smaller) objects being merged
#'   into the (larger) target object.
#'
#'   \item CleavedLabel: For Neu3 the label of the new smaller cleaved body
#'
#'   \item OrigLabel: For Neu3 the label of the larger cleaved body (which
#'   should retain its id)
#'
#'   \item Timestamp: Absolute time in UTC at which change was committed in
#'   \code{POSIXct} format.
#'
#'   \item Reltimestamp: Relative timestamp (in seconds) referenced to the time
#'   at which new DVID node was opened. }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(dplyr)
#' # find all mutations in neutu but not yet in clio
#' notin_neuprint=manc_mutations('neuprint:neutu')
#' subset(notin_neuprint, User!='bergs') %>%
#'   qplot(time, data=., bins=100, fill=Action)
#'
#' library(ggplot2)
#'
#' allmuts=manc_mutations('all')
#' qplot(Timestamp, fill=App, data=allmuts, bins=100)
#'
#' allmuts %>%
#'   filter(User!='bergs') %>%
#'   qplot(Timestamp, data=., bins=100, fill=App)
#'
#' subset(allmuts, User!='bergs') %>%
#'   qplot(Timestamp, data=., bins=100, fill=Action)
#' }
manc_mutations <- function(nodes="neutu", include_first=NA, bigcols=FALSE, ...) {
  nodes <- manc_nodespec(nodes, include_first=include_first)
  if(length(nodes)<1)
    stop("Must supply at least one node")
  if(length(nodes)>1) {
    l=pbapply::pblapply(nodes, manc_mutations, ...)
    df=dplyr::bind_rows(l)
    return(df)
  }
  # GET <api URL>/node/<UUID>/<data name>/mutations[?queryopts]
  res=manc_get("api/node/%s/%s/mutations", nodes, "segmentation")
  rr=list2df(res)
  if(!isTRUE(bigcols)) {
    bigcols="CleavedSupervoxels"
    rr=rr[setdiff(colnames(rr), bigcols)]
  }
  # make sure these are character vectors to keep bind_rows happy
  cols2fix=intersect(colnames(rr), c("Labels", "CleavedSupervoxels", "Split"))
  for(col in cols2fix) {
    mode(rr[[col]])='character'
  }
  if("Timestamp" %in% colnames(rr)) {
    ts=rr$Timestamp
    ts1=sub("(^.+ [+-][0-9]{1,4}) .+", "\\1", ts)
    ts1=strptime(ts1, format="%Y-%m-%d %H:%M:%OS %z", tz='UTC')
    rr$Timestamp=as.POSIXct(ts1)
    ts2=sub(".+m=\\+", "", ts)
    rr$Reltimestamp=as.numeric(ts2)
  }
  rr
}


#' Check if a bodyid still exists in the specified DVID node
#'
#' @details Note that this is still quite slow (5-10 bodies per second from Cambridge)

#' @param ids A set of body ids
#' @param node A DVID node (defaults to the current neutu node, see
#'   \code{\link{manc_dvid_node}})
#' @param ... Additional arguments passed to \code{\link{pbsapply}} and then
#'   eventually to \code{httr::\link{HEAD}}
#'
#' @return A logical vector indicating if the body exists (TRUE) or not (FALSE).
#' @export
#'
#' @examples
#' manc_islatest(10056)
#'
#' \dontrun{
#' manc_islatest(10056:10058)
#'
#' manc_islatest(10056:10058, manc_dvid_node("clio"))
#' }
manc_islatest <- function(ids, node=manc_dvid_node("neutu"), ...) {
  if(length(ids)>1) {
    res=pbapply::pbsapply(ids, manc_islatest, node=node, ...)
    return(res)
  }
  u=manc_serverurl("api/node/%s/segmentation/sparsevol/%s", node, ids)
  res=httr::HEAD(u, ...)
  httr::status_code(res)==200L
}


#' Retun the size (in voxels) of specified bodies
#'
#' @inheritParams manc_islatest
#' @return Numeric vector of voxel sizes
#' @export
#'
#' @examples
#' manc_size(10056)
manc_size <- function(ids, node=manc_dvid_node("neutu")) {
  # we don't want them to look like character
  bodyj=jsonlite::toJSON(bit64::as.integer64(ids))
  res=manc_get("api/node/%s/segmentation/sizes", body=bodyj, node)
  res
}