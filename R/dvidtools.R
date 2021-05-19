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
    if(inherits(dt, "try-error"))
      stop("Could not import dvid/dvidtools module!")
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
