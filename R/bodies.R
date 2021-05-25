manc_last_modified <- function(ids, node='neutu', ...) {
  ids <- manc_ids(ids, integer64 = T)
  node=manc_nodespec(node)
  u=manc_serverurl('api/node/%s/%s/lastmod/%s', node, "segmentation", ids)
  l=pbapply::pbsapply(u, .manc_last_modified, simplify = F, ...)
  df=list2df(l)
  colnames(df)=gsub(" ", "_", colnames(df), fixed = T)
  # want them as numeric here
  df$bodyid=manc_ids(ids, as_character = F)
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
#' @param ... Additional arguments passed to \code{\link{pbapply}}
#'
#' @return A \code{tibble} with columns including: \itemize{
#'
#'   \item \code{Action}: merge, cleave, supervoxel-split
#'
#'   \item \code{App}: Typically NeuTu/Neu3
#'
#'   \item \code{Target}: For NeuTu the bodyid of the (larger) target object
#'
#'   \item \code{Labels}: For NeuTu the bodyids of the (smaller) objects being
#'   merged into the (larger) target object.
#'
#'   \item \code{CleavedLabel}: For Neu3 the label of the new smaller cleaved
#'   body
#'
#'   \item \code{OrigLabel}: For Neu3 the label of the larger cleaved body
#'   (which should retain its id)
#'
#'   \item \code{Timestamp}: Absolute time in UTC at which change was committed
#'   in \code{POSIXct} format.
#'
#'   \item \code{Reltimestamp}: Relative timestamp (in seconds) referenced to
#'   the time at which new DVID node was opened. }
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
    attr(df, 'dvid_node')=nodes
    return(df)
  }
  # GET <api URL>/node/<UUID>/<data name>/mutations[?queryopts]
  res=manc_get("api/node/%s/%s/mutations", urlargs=list(nodes, "segmentation"))
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
  attr(rr, 'dvid_node')=nodes
  rr
}


#' Check if a bodyid still exists in the specified DVID node
#'
#' @details Note that the raw speed of this call is still quite slow (typically
#'   5-30 bodies per second from Cambridge). When more than one body id is
#'   provided this actually uses \code{\link{manc_size}} to check if the body
#'   has >0 voxels. This is a somewhat expensive operation on the server but can
#'   be accept multiple ids. As a further speed-up, when many ids are requested
#'   and \code{method="auto"} (the recommended default) then the DVID status of
#'   bodies is checked. In theory only valid bodies should have such a status
#'   (\href{https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1621448634011800?thread_ts=1621434072.008700&cid=C01MYQ1AQ5D}{see
#'   Slack message}).
#' @inheritParams manc_connection_table
#' @param node A DVID node (defaults to the current neutu node, see
#'   \code{\link{manc_dvid_node}})
#' @param method Which DVID endpoint to use. Expert use only.
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
#' manc_islatest(10056:10058, "clio")
#' }
manc_islatest <- function(ids, node="neutu",
                          method=c("auto", "size", 'sparsevol'), ...) {
  method=match.arg(method)
  node=manc_nodespec(node, several.ok = F)
  ids=manc_ids(ids, integer64 = T)
  if(method=='auto' && isTRUE(length(ids)==1)) method="sparsevol"
  if(method=='sparsevol') {
    manc_islatest_sparsevol(ids, node = node, ...)
  } else {
    if(method=='auto' && length(ids)>200) {
      # short cut, see if they have a current DVID status
      mda=manc_dvid_annotations(node=node)
      res=logical(length(ids))
      found=ids %in% manc_ids(mda, integer64 = T)
      if(any(is.na(found)))
        stop("Unexpected NAs when matching body ids in manc_islatest")
      res[found]=T
      if(any(!found)) {
        # we still have some to check, we'll do them the old-fashioned way
        res[!found]=manc_islatest(ids[!found], node=node, method='size')
      }
      return(res)
    }
    sizes=manc_size(ids, node=node)
    # should be 0 when missing, but just in case
    sizes>0 & !is.na(sizes)
  }
}
manc_islatest_sparsevol <- function(ids, node, ...) {
  if(length(ids)>1) {
    # as character to protect class from being munged by sapply
    res=pbapply::pbsapply(as.character(ids), manc_islatest, node=node, ...)
    return(res)
  }
  u=manc_serverurl("api/node/%s/segmentation/sparsevol/%s", node, ids)
  res=httr::HEAD(u, ...)
  httr::status_code(res)==200L
}

#' Return the size (in voxels) of specified bodies
#'
#' @inheritParams manc_islatest
#' @return Numeric vector of voxel sizes
#' @export
#'
#' @examples
#' manc_size(10056)
#' # zero as doesn't exist
#' manc_size(10000056)
manc_size <- function(ids, node="neutu") {
  # we don't want them to look like character
  node=manc_nodespec(node, several.ok = F)
  bodyj=jsonlite::toJSON(manc_ids(ids, integer64 = T))
  sizes=manc_get("api/node/%s/segmentation/sizes", body=bodyj, urlargs=list(node))
  if(length(sizes)!=length(ids))
    stop("DVID sizes endpoint did not return the right number of elements!")
  sizes
}
