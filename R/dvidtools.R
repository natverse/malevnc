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
#' @param pyinstall whether to install python as well as the \code{dvidtools}
#'   package. Default none will not install.
#' @description \code{install_dvid_tools} installs the python dvid_tools module
install_dvid_tools <- function(pyinstall='none') {
  fafbseg:::check_package_available('reticulate')
  fafbseg::simple_python(pyinstall=pyinstall,
    pkgs = 'git+https://github.com/flyconnectome/dvid_tools@master')
}

#' Set DVID annotations for one or more ids.
#' @description \code{manc_set_dvid_instance} sets DVID type and/or instance
#'   (name) information for one or more ids. It also adds user information for
#'   each field.
#'
#' @param bodyid One or more body ids (only one for
#'   \code{manc_set_dvid_annotations})
#' @param user The DVID user. Defaults to \code{options("malevnc.dvid_user")}.
#' @param node The dvid node to use (defaults to 'neutu' i.e. current open node)
#' @param ... Additional arguments passed to \code{pbapply::pbmapply} when
#'   passing more than one bodyid.
#' @param type The authoritative type for a neuron
#' @param instance An instance, either a candidate type or an authoritative type with suffix to indicate side.
#' @param synonyms An alternative type for a neuron (e.g. one used in the past literature, one which is useful but unlikely to be the authoritative type etc).
#'
#' @return logical indicating success
#' @export
#'
#' @examples
#' \dontrun{
#' manc_set_dvid_instance(1234567, type='LHAD1g1')
#' }
manc_set_dvid_instance <- function(bodyid, instance=NULL, type=NULL,
                                   synonyms=NULL,
                                   user=getOption("malevnc.dvid_user"),
                                   node='neutu', ...) {

  if(is.null(user))
    stop("Please specify a user or set options(malevnc.dvid_user='<janelia_username>')")
  else if(isTRUE(grepl("@", user))) {
    stop("The DVID user should be a janelia username e.g. `jefferisg` rather than an email address!")
  } else if (length(user)>1)
    stopifnot(isTRUE(length(user)==length(bodyid)))

  if(length(bodyid)>1) {
    return(pbapply::pbmapply(manc_set_dvid_instance,
                      bodyid=bodyid,
                      instance=instance,
                      synonyms=synonyms,
                      type=type,
                      user=user,
                      MoreArgs = list(node=node), ...))
  }

  if(is.null(type) && is.null(type) && is.null(synonyms))
    stop("You must specify at least one of instance, type or synonyms!")

  annlist <- list()
  if(!is.null(instance))
    annlist <- list(instance=instance, "instance_user"=user)
  if(!is.null(type))
    annlist[c("type", "type_user")]=list(type, user)
  if(isTRUE(!is.na(synonyms) && nzchar(synonyms)))
    annlist[c("synonyms", "synonyms_user")]=list(synonyms, user)
  # annlist
  manc_set_dvid_annotations(bodyid, annlist, node=node)
}


#' @description \code{manc_set_dvid_annotations} is a low level function to set
#'   arbitrary DVID annotations for exactly one body (expert use only!)
#'
#' @param annlist An R list containing key value pairs. Key names are not
#'   checked.
#'
#' @return logical indicating success
#' @export
#'
#' @examples
#' \dontrun{
#' manc_set_dvid_annotations(1234567, list(instance='LHAD1g1', instance_user=''))
#'
#' }
#' @rdname manc_set_dvid_instance
manc_set_dvid_annotations <- function(bodyid, annlist, node='neutu') {
  ann_dict=reticulate::dict(annlist)
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

#' Check if group is complete
#'
#' In other words if the \code{body_ids} argument contains all neurons in the
#' group.
#'
#' @param group_id numeric/character with group id
#' @param body_ids vector with body ids to compare
#' @param conn Optional, a \code{\link{neuprint_connection}} object, which also
#'   specifies the neuPrint server. Defaults to \code{\link{manc_neuprint}()} to
#'   ensure that query is against the VNC dataset.
#'
#' @return logical \code{TRUE} if group is complete, \code{FALSE} otherwise.
#'
#' @importFrom glue glue
#' @importFrom dplyr filter %>%
#' @importFrom dplyr .data
manc_check_group_complete <- function(group_id, body_ids,
                                      conn=manc_neuprint()) {
  #np_bids <- neuprintr::neuprint_search(glue("name:{group_id}_[LR]"), conn=conn, meta = F)
  dvid_annot <- manc_dvid_annotations()
  dvid_bids <- (dvid_annot %>%
                filter(grepl(glue("{group_id}_[LR]"), .data$instance)))$bodyid
  # normalize type for comparison
  dvid_bids <- as.character(dvid_bids)
  body_ids <- as.character(body_ids)
  all(dvid_bids %in% body_ids)
}

#' Set Left-Right matching groups for neurons in DVID and optionally Clio
#'
#' @details One important process in reviewing and annotating neurons is to
#'   compare neurons on the left and right side of the malevnc dataset. This can
#'   identify neurons that need further proof-reading fixes as well as grouping
#'   neurons that may eventually form agreed cell types. At the time of writing
#'   (21 Aug 2021) group information is stored in two locations: the DVID
#'   instance field and the Clio group field. DVID instance information is being
#'   periodically copied to Clio, but for the time being this is not automated.
#'   Furthermore it is not trivial to reconcile the two locations if they get
#'   out of sync. Therefore we have agreed that DVID will remain the master
#'   source of information for the time being.
#'
#'   DVID left-right groupings are stored in the instance field (for the
#'   hemibrain this was more specific than the type field and typically included
#'   side of brain information). The convention has been to store the lowest
#'   body id in a group followed by an underscore and then the side (\code{L} or
#'   \code{R}) or a letter \code{U} to indicate that the neuron is unpaired
#'   (sometimes this is \code{UNP}). In contrast the Clio group column just
#'   contains the lowest bodyid. At this point we assume that the selected
#'   bodyid will \emph{not} change if neurons are added to the group.
#'   \code{manc_set_lrgroup} will choose the lowest bodyid as the default when
#'   setting the group for a set of ids unless a specific \code{group} argument
#'   is passed.
#'
#'   Grouping neurons remains a subjective process: while many cases are
#'   obvious, there are always edge cases where experts disagree. Therefore it
#'   is not necessarily productive to spend extensive amounts of discussion once
#'   a designation has been made. Therefore \code{manc_set_lrgroup} tries to
#'   avoid overriding previous designations unless the user insists. This
#'   behaviour can be changed using the \code{Force} or \code{Partial}. As you
#'   might expect \code{Force=TRUE} just does what you ask regardless of any
#'   existing annotations. Use this sparingly and with caution.
#'
#'   \code{Partial=TRUE} is more nuanced and tries to do the right thing when
#'   extending a group for which some members already have annotations. The main
#'   limitation is that you must pass \emph{all} the members of the group in
#'   your call so that \code{manc_set_lrgroup} knows that you are trying to make
#'   a compatible annotation.
#'
#'   Here are some examples of group annotations: \itemize{
#'
#'   \item \code{10000_R}, \code{10000_L} for bodyids \code{10000, 10002} (the
#'   giant fibre neurons)
#'
#'   \item \code{13083_U} an unpaired neuron.
#'
#'   }
#' @param ids A set of body ids belonging to the same group
#' @param sides Optional character vector specifying the sides (L,R,U) for the
#'   given \code{ids}. Will be taken from neuprint by default.
#' @param dryrun When \code{TRUE}, the default, show what will happen rather
#'   than applying the annotations.
#' @param Force Whether to update DVID instances (and clio group) even when
#'   there is existing DVID instance information.
#' @param Partial Assigns group annotations (via DVID instances) only to neurons
#'   that do not yet have annotation.
#' @param group Set a specific group id rather than accepting the default.
#' @param clio Whether to set the Clio group field in addition to DVID.
#' @param user Janelia user name to associate with the DVID instance annotation
#'   (defaults to the value of options("malevnc.dvid_user"), but can be
#'   overridden by this argument. NB a user must be provided by one of these
#'   means. If the user has no Janelia id, just use an id of the form
#'   \code{<surname><firstinitial>} e.g. \code{jefferisg}.
#' @importFrom stats na.omit
#' @export
#' @examples
#' \dontrun{
#' # check it makes sense, dryrun=T
#' manc_set_lrgroup(c(12516, 12706))
#' # apply
#' manc_set_lrgroup(c(12516, 12706), dryrun=F)
#' }
#' @importFrom stats na.omit
manc_set_lrgroup <- function(ids, sides=NULL, dryrun=TRUE, Force=FALSE,
                             Partial=FALSE, group=NA, clio=TRUE,
                             user=getOption("malevnc.dvid_user")) {
  m=manc_neuprint_meta(ids)
  # nb group is presently encoded in instance/name ...
  if (!all(is.na(m$name)) && !isTRUE(Partial) && !isTRUE(Force))
    stop("some ids already have a group")
  g=min(as.numeric(m$bodyid))
  if (Partial) {
    if (sum(!is.na(m$group)) > 0) { # check if there are non-NA groups
      ng <- unique(na.omit(m$group))
      if (length(ng) == 1) { # check is there's singleton group
        if (!manc_check_group_complete(ng, ids)) # check if all ids are in group
          stop("Not all ids found in existing group, please review.")
        g <- ng
      }
      if (length(ng) > 1 && isFALSE(Force))
        stop("Existing groups are not consistent, please review.")
    }
    m <- m[is.na(m$name),]
    ids <- m$bodyid
    if (nrow(m) == 0) return()
  }
  if (!is.na(group))
    g <- group
  checkmate::assert_integerish(g, lower = 10000, len=1)
  if(is.null(sides)) {
    sides=m$somaSide
    if(any(is.na(sides)))
      sides=m$rootSide
  }
  checkmate::assert_character(sides, len=length(ids), any.missing = F, min.chars = 1)
  sides=substr(sides,1,1)
  instances=paste0(g, "_", sides)
  checkmate::assert_character(instances, len=length(ids), any.missing = F)
  if(isTRUE(dryrun))
    print(data.frame(bodyid=m$bodyid, instance=instances))
  else {
    message("Applying DVID instance updates!")
    mapply(manc_set_dvid_instance, m$bodyid, instances, MoreArgs=list(user=user))
    if(isTRUE(clio)) {
      message("Applying clio group updates!")
      manc_annotate_body(data.frame(bodyid=ids, group=g, stringsAsFactors = F), test=F)
    }
  }
}
