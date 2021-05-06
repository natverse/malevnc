manc_dvid_info <-
  memoise::memoise(cache = cachem::cache_mem(max_age = 3600),
                   function() {
  rootnode = "1ec355123bf94e588557a4568d26d258"
  u = manc_serverurl("api/repo/%s/info", rootnode)
  info = try(jsonlite::fromJSON(readLines(u, warn = F)))
  if (inherits(info, 'try-error'))
   stop("Failed to read DVID summary information!")
  info
})


#' Return the latest DVID node
#'
#' @param type Whether to return the latest committed node (clio) or the active
#'   node being edited in neutu (the very latest) or the node in neuprint (a
#'   committed node that may lag behind clio). master is an alias for neutu.
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
manc_dvid_node <- function(type=c("clio", "neutu", "neuprint", "master"), cached=TRUE) {
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

# private for now, but when we have a spec we like we should make it public
manc_nodespec <- function(nodes, include_first=NA) {
  if(isTRUE(nodes=='all')) {
    nodes=manc_node_chain()
  } else {
    nodes=gsub("(master|neutu)", manc_dvid_node("neutu"), nodes)
    nodes=gsub("clio", manc_dvid_node('clio'), nodes)
    nodes=gsub("neuprint", manc_dvid_node('clio'), nodes)

    if(grepl(":", nodes)) {
      nn=unlist(strsplit(nodes, ":", fixed=T))
      stopifnot(length(nn)==2)
      # accept integer versions also
      rint=suppressWarnings(as.integer(nn[1]))
      if(isTRUE(rint<1e6)) nn[1]=rint
      hint=suppressWarnings(as.integer(nn[2]))
      if(isTRUE(hint<1e6)) nn[2]=hint

      nodes=manc_node_chain(root=nn[1], head=nn[2])
      if(is.na(include_first) || !include_first)
        nodes=nodes[-1]
    }
  }
  nodes
}

# return the chain of nodes between the root and the current head
# not too clever: someday we might want to use a proper graph traversal
# specifying the nodes
# can optionally specify a different root or head node
manc_node_chain <- function(root=NULL, head=NULL) {
  info=manc_dvid_info()
  dagdf=list2df(manc_dvid_info()$DAG$Nodes)
  dagdf=dagdf[order(dagdf$VersionID),,drop=F]
  dagdf=dagdf[nchar(dagdf$Children)>0 | !dagdf$Locked, ]

  if(!is.null(head)) {
    stopversion <- if(is.integer(head)) head
    else {
      stopifnot(head %in% dagdf$UUID)
      stopversion=dagdf$VersionID[match(head, dagdf$UUID)]
    }
    stopifnot(stopversion %in% dagdf$VersionID)
    dagdf=dagdf[dagdf$VersionID <= stopversion,]
  }
  if(!is.null(root)) {
    startversion <- if(is.integer(root)) root
    else {
      stopifnot(root %in% dagdf$UUID)
      startversion=dagdf$VersionID[match(root, dagdf$UUID)]
    }
    stopifnot(startversion %in% dagdf$VersionID)
    dagdf=dagdf[dagdf$VersionID >= startversion,]
  }
  dagdf$UUID
}
