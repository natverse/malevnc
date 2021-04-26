manc_dvid_info <-
  memoise::memoise(cache = cachem::cache_mem(max_age = 3600),
                   function() {
  rootnode = "1ec355123bf94e588557a4568d26d258"
  u = sprintf("https://emdata5-avempartha.janelia.org/api/repo/%s/info",
             rootnode)
  info = try(jsonlite::fromJSON(readLines(u, warn = F)))
  if (inherits(info, 'try-error'))
   stop("Failed to read DVID summary information!")
  info
})


#' Return the latest DVID node
#'
#' @param type Whether to return the latest committed node (clio) or the active
#'   node being edited in neutu (the very latest) or the node in neuprint (a
#'   committed node that may lag behind clio)
#' @param cached Whether to return a cached value (updated every hour) or to
#'   force a new query.
#'
#' @return A UUID string
#' @export
#'
#' @examples
#' \donttest{
#' manc_dvid_node()
#' manc_dvid_node('neutu')
#' # force
#' manc_dvid_node('neuprint', cached=FALSE)
#' }
manc_dvid_node <- function(type=c("clio", "neutu", "neuprint"), cached=TRUE) {
  type=match.arg(type)
  if(type=='neuprint') {
    vncc=manc_neuprint()
    ds=neuprintr::neuprint_datasets(cache = cached, conn=vncc)
    node=ds$vnc$uuid
    if(is.null(node))
      stop("Unable to find neuprint node")
    return(node)
  }
  if(isFALSE(cached))
    memoise::forget(manc_dvid_info)
  info=manc_dvid_info()
  versions=sapply(info$DAG$Nodes, '[[', "VersionID")
  locked=sapply(info$DAG$Nodes, '[[', "Locked")
  # For clio ignore any unlocked node by setting the version to 0
  if(type=="clio")
    versions[!locked]=0
  names(info$DAG$Nodes)[which.max(versions)]
}

