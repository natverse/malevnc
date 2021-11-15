manc_dvid_info <-
  memoise::memoise(cache = cachem::cache_mem(max_age = 3600),
                   function(rootnode = getOption("malevnc.rootnode")) {
  u = manc_serverurl("api/repo/%s/info", rootnode)
  info = try(jsonlite::fromJSON(readLines(u, warn = F)))
  if (inherits(info, 'try-error'))
   stop("Failed to read DVID summary information!")
  info
})


manc_branch_versions <-
  memoise::memoise(cache = cachem::cache_mem(max_age = 3600),
                   function() {
                     rootnode = getOption("malevnc.rootnode")
                     u = manc_serverurl("api/repo/%s/branch-versions/master", rootnode)
                     info = try(jsonlite::fromJSON(readLines(u, warn = F)))
                     if (inherits(info, 'try-error'))
                       stop("Failed to read DVID branch versions information!")
                     info
                   })

#' Information about DVID nodes / return latest node
#'
#' @description \code{manc_dvid_node} returns the latest DVID node in use with a
#'   specific tool.
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
  dsname=getOption('malevnc.dataset')
  if(is.null(dsname))
    stop("The package option malevnc.dataset is unset. Please set or manually reload package!")

  if(type=='neuprint') {
    vncc=manc_neuprint()
    ds=neuprintr::neuprint_datasets(cache = cached, conn=vncc)
    node=ds[[tolower(dsname)]]$uuid
    if(is.null(node))
      stop("Unable to find neuprint node")
    return(node)
  }

  if(!isTRUE(cached))
    memoise::forget(manc_branch_versions)
  mbv=manc_branch_versions()
  if(type=='neutu') {
    return(mbv[1])
  }

  # For clio ignore any unlocked node by setting the version to 0
  if(type=="clio") {
    cds=clio_datasets(cached=cached)
    ds=cds[[dsname]]
    if(is.null(ds))
      stop("Unable to access ",dsname,
           " data set via clio. Please check your clio authorisation!")
    clio_uuid=ds$uuid
    if(is.null(clio_uuid))
      stop("Unable to identify ",dsname,
           " clio UUID from datasets reported by clio server!\n",
           "I recommend asking @katzw/@jefferis what's up on #clio-ui\n",
           "https://flyem-cns.slack.com/archives/C01MYQ1AQ5D")
    clio_node=mbv[pmatch(clio_uuid, mbv)]
    if(is.na(clio_node) && cached) {
      # can't find the node: most likely a DVID commit has just happened
      memoise::forget(manc_branch_versions)
      mbv=manc_branch_versions()
      clio_node=mbv[pmatch(ds$uuid, mbv)]
    }
    if(is.na(clio_node))
      stop("Unable to establish full length clio node: ", ds$uuid)
    clio_node
  }
}

#' @rdname manc_dvid_node
#' @export
#' @description \code{manc_dvid_nodeinfo} returns a data.frame with information
#'   about the DVID nodes available for the male VNC dataset.
manc_dvid_nodeinfo <- function(cached=TRUE) {
  if(isFALSE(cached))
    memoise::forget(manc_dvid_info)
  dvi=manc_dvid_info()
  mdn=list2df(dvi$DAG$Nodes)
  dplyr::arrange(mdn, .data$VersionID)
}

# Flexible specification of DVID nodes
manc_nodespec <- function(nodes, include_first=NA, several.ok=TRUE) {
  if(isTRUE(nodes=='all')) {
    nodes=manc_node_chain()
  } else {
    nodes=gsub("(master|neutu)", manc_dvid_node("neutu"), nodes)
    if(grepl("clio", nodes))
      nodes=gsub("clio", manc_dvid_node('clio'), nodes)
    if(grepl("neuprint", nodes))
      nodes=gsub("neuprint", manc_dvid_node('neuprint'), nodes)

    if(any(grepl(":", nodes))) {
      nn=unlist(strsplit(nodes, ":", fixed=T))
      stopifnot(length(nn)==2)
      # accept integer versions also
      rint=suppressWarnings(as.integer(nn[1]))
      nn[1] <- if(isTRUE(rint<1e6)) rint else expand_dvid_nodes(nn[1])
      hint=suppressWarnings(as.integer(nn[2]))
      nn[2] <- if(isTRUE(hint<1e6)) hint else expand_dvid_nodes(nn[2])
      nodes=manc_node_chain(root=nn[1], head=nn[2])
      if(is.na(include_first) || !include_first)
        nodes=nodes[-1]
    }
    nodes=expand_dvid_nodes(nodes)
  }
  if(length(nodes)==0)
    stop("No valid DVID nodes specified")
  else if(isFALSE(several.ok) && length(nodes)!=1)
    stop("Expecting a single DVID node not ", length(nodes), "!")
  nodes
}

expand_dvid_nodes <- function(nodes) {
  mnc=manc_node_chain()
  matches=pmatch(nodes, mnc)
  if(any(is.na(matches)))
    stop("Unable to identify some DVID nodes:", paste(nodes[is.na(matches)], collapse = ' '))
  mnc[matches]
}

# return the chain of nodes between the root and the current head
# using manc_branch_versions
# can optionally specify a different root or head node
manc_node_chain <- function(root=getOption('malevnc.rootnode'), head=NULL) {
  dagdf=manc_dvid_nodeinfo()
  dagdf=dagdf[order(dagdf$VersionID),,drop=F]
  dagdf=dagdf[nchar(dagdf$Children)>0 | !dagdf$Locked, ]
  # restrict to descendants of the current HEAD
  mbv=manc_branch_versions()
  dagdf=dagdf[dagdf$UUID %in% mbv, ]

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


# If we want to use drvid
manc_dv_conn <- function(node='neutu', ...) {
  fafbseg:::check_package_available('drvid')
  drvid::dv_conn(server = manc_server(),node = manc_nodespec(node), ...)
}
