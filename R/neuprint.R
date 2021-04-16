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
