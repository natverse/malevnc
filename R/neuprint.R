#' Login to MANC neuprint server
#'
#' @param ... Additional arguments passed to \code{\link{neuprint_login}}
#'
#' @return a \code{\link{neuprint_connection}} object returned by \code{\link{neuprint_login}}
#' @export
#' @family manc-neuprint
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
#' @description \code{manc_ids} provides a convenient way to extract body ids
#'   from a variety of objects as well as allowing text searches against
#'   type/instance information defined in neuprint.
#'
#' @param x A vector of body ids, data.frame (containing a bodyid column) or a
#'   neuroglancer URL.
#' @param integer64 whether to return ids with class bit64::integer64.
#' @inheritParams neuprintr::neuprint_ids
#' @inheritParams fafbseg::ngl_segments
#' @export
#' @family manc-neuprint
#' @seealso \code{\link{neuprint_ids}}
#' @examples
#' \donttest{
#' # search by type
#' manc_ids("Giant Fiber")
#' # or against the instance (name)
#' manc_ids("name:10085")
#' # You can also do more complex queries using regular expressions
#' lrpairs=manc_ids("/name:[0-9]{5,}_[LR]")
#' \dontrun{
#' # Finally you can use the same queries wherever you specify body ids
#' # NB if you want to be sure that regular neuprintr functions target
#' # the VNC dataset, use conn=manc_neuprint()
#' lrpairs.meta=neuprintr::neuprint_get_meta("/name:[0-9]{5,}_[LR]", conn=manc_neuprint())
#' }
#' }
#' @importFrom bit64 is.integer64 as.integer64
manc_ids <- function(x, mustWork=TRUE, as_character=TRUE, integer64=FALSE, conn=manc_neuprint(), ...) {
  ids <- if(fafbseg:::is.ngscene(x) || all(is.url(x)))
    fafbseg::ngl_segments(x, must_work = mustWork, as_character = as_character, ...)
  else if(!is.integer64(x)){
    # nb if we have integer64 input they must already be ids
    # so no need to send to neuprint
    neuprintr::neuprint_ids(x=x, conn=conn, mustWork = mustWork, ...)
  }
  if(isTRUE(integer64)) as.integer64(ids)
  else if(as_character) as.character(ids)
  else as.numeric(ids)
}

#' Convenience wrapper for neuprint connection queries for VNC dataset
#'
#' @param ids A set of body ids in any form understandable to
#'   \code{\link{manc_ids}}
#' @param partners Either inputs or outputs. Redundant with \code{prepost}, but
#'   probably clearer.
#' @param conn Optional, a \code{\link{neuprint_connection}} object, which also
#'   specifies the neuPrint server. Defaults to \code{\link{manc_neuprint}()} to
#'   ensure that query is against the VNC dataset.
#' @param ... additional arguments passed to
#'   \code{\link{neuprint_connection_table}}
#' @inheritParams neuprintr::neuprint_connection_table
#'
#' @return see \code{\link{neuprint_connection_table}}
#' @export
#' @family manc-neuprint
#' @examples
#' \donttest{
#' down=manc_connection_table("Giant Fiber", partners='outputs')
#' \dontrun{
#' manc_scene(down$partner[1:8], open=TRUE)
#' }
#' }
manc_connection_table <- function(ids, partners=c("inputs", "outputs"),
                                  prepost = c("PRE", "POST"), conn=manc_neuprint(), ...) {
  if(!missing(partners)) {
    partners=match.arg(partners)
    prepost=ifelse(partners=='inputs', "PRE", "POST")
  }
  ids=manc_ids(ids, conn=conn)
  neuprintr::neuprint_connection_table(ids, prepost = prepost, details=T, conn=conn, ...)
}

