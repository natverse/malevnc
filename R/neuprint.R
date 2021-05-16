#' Login to MANC neuprint server
#'
#' @param ... Additional arguments passed to \code{\link{neuprint_login}}
#'
#' @return a \code{\link{neuprint_connection}} object returned by \code{\link{neuprint_login}}
#' @export
#'
#' @examples
#' \donttest{
#' vncc=manc_neuprint()
#' anchorids <- neuprintr::neuprint_ids("status:Anchor", conn=vncc)
#' # the last connection will be used by default
#' anchormeta <- neuprintr::neuprint_get_meta("status:Anchor")
#'
#' plot(cumsum(sort(anchormeta$pre, decreasing = TRUE)), ylab='Cumulative presynapses')
#' plot(cumsum(sort(anchormeta$post, decreasing = TRUE)), ylab='Cumulative postsynapses')
#' }
manc_neuprint <- function(...) {
  neuprintr::neuprint_login(server='https://neuprint-pre.janelia.org', dataset = "vnc", token=Sys.getenv("neuprint_token"), ...)
}


is.url <- function(x) {
  grepl("^http[s]{0,1}://[^.]{1,}\\.[^.]{2,}", x)
}

#' Flexible specification of manc body ids
#'
#' @param x A vector of body ids, data.frame (containing a bodyid column) or a
#'   neuroglancer URL.
#' @param integer64 whether to return ids with class bit64::integer64.
#' @inheritParams neuprintr::neuprint_ids
manc_ids <- function(x, mustWork=TRUE, integer64=FALSE, conn=manc_neuprint(), ...) {
  ids <- if(fafbseg:::is.ngscene(x) || is.url(x))
    fafbseg::ngl_segments(x, must_work = mustWork, ...)
  else
    neuprintr::neuprint_ids(x=x, conn=conn, mustWork = mustWork, ...)
  if(isTRUE(integer64)) bit64::as.integer64(ids) else ids
}

#' Convenience wrapper for neuprint connection queries
#'
#' @param x Bodyids in any form understandable to
#' @param partners
#' @param prepost
#' @param conn
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' down=manc_connection_table(10001)
#' browseUrl(manc_scene(down[1:8]))
manc_connection_table <- function(x, partners=c("inputs", "outputs"),
                                  prepost = c("PRE", "POST"), conn=manc_neuprint(), ...) {
  if(!missing(partners)) {
    partners=match.arg(partners)
    prepost=ifelse(partners=='inputs', "PRE", "POST")
  }
  neuprintr::neuprint_connection_table(x, prepost = prepost, details=T, ...)
}

