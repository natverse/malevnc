# see https://dvidtools.readthedocs.io/en/latest/
# https://github.com/flyconnectome/dvid_tools
# https://emdata5.janelia.org/api/help/

#' Interface to the python dvid_tools module from Philipp Schlegel
#'
#' @param user Default DVID user names
#' @param node default DVID node to use for queries (see
#'   \code{\link{manc_dvid_node}})
#' @details The dvid_tools_module will be cached using \code{memoise}. You can
#'   modify the default user with the `$setup` method.
#'
#' @description \code{dvid_tools} provides a lower level and less specific
#'   interface to DVID that corresponding \code{manc_*} functions but does
#'   include some functionality that is not yet available.
#' @seealso \url{https://github.com/flyconnectome/dvid_tools},
#'   \url{https://github.com/flyconnectome/dvid_tools},
#'   \url{https://emdata5.janelia.org/api/help/} for further details.
#' @examples
#' \dontrun{
#' dt=dvid_tools()
#' dt
#' # nb must explicity use integers for bodyids
#' dt$get_annotation(bodyid = 10000L)
#'
#' # get detailed help
#' reticulate::py_help(dt$get_adjacency)
#' }
dvid_tools <- function(user=getOption("malevnc.dvid_user"),
                       node='neutu') {
  # if(is.null(user))
  #   stop("Please specify a user or set options(malevnc.dvid_user)")
  server = manc_server()
  node=manc_nodespec(node, several.ok = F)
  dt=dvid_tools_module()
  dt$setup(server, node, user)
  class(dt)=union("dvid_tools", class(dt))
  dt
}

dvid_tools_module <- memoise::memoise(function() {
  fafbseg:::check_reticulate()
  dt=try(reticulate::import('dvidtools'), silent = T)
  if(inherits(dt, "try-error")){
    dt=try(reticulate::import('dvid'), silent = T)
    if(inherits(dt, "try-error")) {
      stop("Could not import dvid/dvidtools module!",
           " Please install using install_dvid_tools()!")
    }
  }
  dt
})

#' @export
print.dvid_tools <- function(x, ...) {
  cat("dvid tools built in methods include:\n\n")
  print(names(x))
  cat("\nFor further details, see https://github.com/flyconnectome/dvid_tools\n")
  cat("and https://emdata5.janelia.org/api/help/")
}


dvid_tools_version <- function() {
  pydf=fafbseg:::py_report(pymodules = 'dvidtools', silent = T)
  if(is.null(pydf)) return(NA_character_)
  m=match("dvidtools", pydf$module)
  if(is.na(m))
    m=match("dvid", pydf$module)
  pydf$version[m]
}

#' @export
#' @rdname dvid_tools
#' @description \code{install_dvid_tools} installs the python dvid_tools module
install_dvid_tools <- function() {
  fafbseg:::check_package_available('reticulate')
  fafbseg::simple_python(pkgs = 'git+git://github.com/flyconnectome/dvid_tools@master')
}

manc_set_dvid_instance <- function(bodyid, instance, user=getOption("malevnc.dvid_user"), node='neutu') {
  if(is.null(user))
    stop("Please specify a user or set options(malevnc.dvid_user='<janelia_username>')")
  else if(isTRUE(grepl("@", user))) {
    stop("The DVID user should be a janelia username e.g. `jefferisg` rather than an email address!")
  }
  ann_dict=reticulate::dict(list(instance=instance, "naming user"=user))
  dt=dvid_tools(node = node)
  bodyidint=try(checkmate::asInt(bodyid, lower = 10000L), silent = TRUE)
  # deal with ids that are only valid as 64 bit ints
  if(inherits(bodyidint, 'try-error')) {
    stopifnot(requireNamespace('fafbseg'))
    bodyidlist=fafbseg:::rids2pyint(bodyid)
    stopifnot(inherits(bodyidlist, "python.builtin.list"))
    bodyidint=bodyidlist$pop()
    stopifnot(inherits(bodyidint, "python.builtin.int"))
  }
  dt$edit_annotation(bodyid = bodyidint, annotation = ann_dict, verbose=F)
}


#' Set LR matching groups for neurons in DVID and optionally Clio
#'
#' @param ids A set of ids belonging to the same group
#' @param dryrun When \code{TRUE}, the default, show what will
#'   happen rather than applying the annotations.
#' @param Force Whether to update DVID instances (and clio group) even when
#'   there is existing DVID instance information.
#' @param Partial Assigns only partial annotations to DVID instances
#'   that do not yet have annotation.
#' @param clio Whether
#'
#' @export
#' @examples
#' \dontrun{
#' # check it makes sense, dryrun=T
#' manc_set_lrgroup(c(12516, 12706))
#' # apply
#' manc_set_lrgroup(c(12516, 12706), dryrun=F)
#' }
manc_set_lrgroup <- function(ids, dryrun=TRUE, Force=FALSE,
                             Partial=FALSE, clio=TRUE) {
  m=manc_neuprint_meta(ids)
  # nb group is presently encoded in instance/name ...
  if (!all(is.na(m$name)) && !isTRUE(Partial) && !isTRUE(Force))
    stop("some ids already have a group")
  g=min(as.numeric(m$bodyid))
  checkmate::assert_integerish(g, lower = 10000, len=1)
  if (Partial) {
    m <- m[is.na(m$name),]
    ids <- m$bodyid
    if (ncol(m) == 0) return()
  }
  sides=m$somaSide
  if(any(is.na(sides)))
    sides=m$rootSide
  checkmate::assert_character(sides, len=length(ids), any.missing = F, min.chars = 1)
  sides=substr(sides,1,1)
  instances=paste0(g, "_", sides)
  checkmate::assert_character(instances, len=length(ids), any.missing = F)
  if(isTRUE(dryrun))
    print(data.frame(bodyid=m$bodyid, instance=instances))
  else {
    message("Applying DVID instance updates!")
    mapply(manc_set_dvid_instance, m$bodyid, instances)
    if(isTRUE(clio)) {
      message("Applying clio group updates!")
      manc_annotate_body(data.frame(bodyid=ids, group=g, stringsAsFactors = F), test=F)
    }
  }
}
