flyem_dataset <- function(dataset) {
  cds=clio_datasets()
  dataset=match.arg(dataset, names(cds))
  cds[[dataset]]
}

#' Choose active male VNC / FlyEM dataset
#'
#' @description \code{choose_malevnc_dataset} chooses the dataset that will be
#'   used by the male VNC package.
#' @details For \code{choose_malevnc_dataset} the \code{dataset} will be one of
#'   \code{MANC} (release) or \code{VNC} (pre-release) dataset. Note the latter
#'   will only be available for authenticated collaborators of the FlyEM team.
#'   When \code{dataset=NULL} the options("malevnc.dataset") will be checked,
#'   then the environment variable \code{MALEVNC_DATASET} and finally the
#'   default value (MANC i.e. released dataset) will be selected.
#'
#' @param dataset Character vector specifying dataset name. Default value of
#'   \code{NULL} will respect package options or choose default dataset if none
#'   set.
#' @param set Whether to set the relevant package options or just to return the,
#' @param use_clio Whether to use clio to list datasets (expert use only;
#'   default of \code{use_clio=NA} should do the right thing).
#'
#' @return A list of options (when \code{set=FALSE}) or the \emph{previous}
#'   value of those options, mimicking the behaviour of \code{\link{options}}.
#' @export
#'
#' @examples
#' \dontrun{
#' # switch dataset
#' op <- choose_malevnc_dataset("MANC")
#' on.exit(options(op))
#' # reset the previous state
#' options(op)
#' }
choose_malevnc_dataset <- function(dataset=NULL,
                                   set=TRUE,
                                   use_clio=NA) {
  if(is.null(dataset))
    dataset=getOption("malevnc.dataset")
  if(is.null(dataset))
    dataset=Sys.getenv('MALEVNC_DATASET')
  if(is.null(dataset) || dataset=="")
    dataset='MANC'
  if(isTRUE(dataset=='MANC')){
    if(!isTRUE(use_clio)) {
      ops=list(
        malevnc.dataset=dataset,
        malevnc.neuprint='https://neuprint.janelia.org',
        malevnc.neuprint_dataset="manc:v1.2.1",
        malevnc.rootnode=NULL,
        malevnc.server="https://manc-dvid.janelia.org",
        malevnc.rootnode='1ec355123bf94e588557a4568d26d258'
      )
      if(set) return(options(ops)) else return(ops)
    }
  } else {
    if(isFALSE(use_clio))
      stop("I must use_clio to get information about dataset:", dataset)
  }
  choose_flyem_dataset(dataset = dataset, set=set)
}

#' @rdname choose_malevnc_dataset
#' @export
#' @description \code{choose_flyem_dataset} is a generic function underneath
#'   \code{choose_malevnc_dataset}. It is intended primarily for developers of
#'   other packages.
choose_flyem_dataset <- function(dataset=getOption("malevnc.dataset"), set=TRUE) {
  ds=flyem_dataset(dataset)
  s=flyem_servers4dataset(ds)
  r=flyem_rootnode4dataset(ds)
  nps=ds$neuprintHTTP$server
  if(!isTRUE(substr(nps,1, 8)=="https://"))
    nps=paste0("https://", nps)
  npd=ds$neuprintHTTP$dataset
  if(!is.null(ds$neuprintHTTP$version))
    npd=paste0(npd, sep=":", ds$neuprintHTTP$version)
  ops=list(malevnc.server=s$dvid,
           malevnc.rootnode=r,
           malevnc.dataset=dataset,
           malevnc.neuprint=nps,
           malevnc.neuprint_dataset=npd)
  if(set) options(ops) else ops
}

flyem_scene4dataset <- memoise::memoise(function(dataset=NULL) {
  ds <- if(is.character(dataset)) flyem_dataset(dataset) else dataset
  stopifnot(!is.null(ds$neuroglancer))
  sc=fafbseg::ngl_decode_scene(ds$neuroglancer)

  # there are some key layers here, but not always present
  if(is.null(ds$versions[[1]]$neuroglancer))
    return(sc)
  sc2=fafbseg::ngl_decode_scene(ds$versions[[1]]$neuroglancer)
  ll=c(sc$layers[1], sc2$layers[1], sc$layers[-1], sc2$layers[-1])
  if(!is.null(ds$orderedLayers) && all(ds$orderedLayers %in% names(ll))) {
    # reorder layers based on clio config information putting preferred ones first
    ll=ll[union(ds$orderedLayers, names(ll))]
  }
  fafbseg::ngl_layers(sc) <- ll
  sc
})

flyem_servers4dataset <- memoise::memoise(function(dataset=NULL) {
  sc=flyem_scene4dataset(dataset)
  dl=flyem_dvidlayer4scene(sc)
  if(is.null(dl)) {
    dvid=dataset$dvid
    return(list(dvid=dvid, support=NULL))
  }
  u=if(is.character(dl$source)) dl$source else dl$source$url
  dvid=sub("dvid-service=.*", "", u)
  dvid=sub("dvid://", "", dvid)
  dvid=sub("(https://[^/]+).*", "\\1", dvid)
  list(
    dvid=dvid,
    support=sub("&.*", "", sub(".*dvid-service=", "", u))
  )
})

flyem_dvidlayer4scene <- function(sc) {
  dvidlayer <- sapply(sc$layers, function(x) isTRUE(try(grepl("dvid", x$source$url), silent = T)))
  if(sum(dvidlayer)<1) {
    # try again just with source
    dvidlayer <- sapply(sc$layers, function(x) isTRUE(try(grepl("dvid", x$source), silent = T)))
  }
  #   warning("Unable to extract a unique DVID layer!")
  if(!any(dvidlayer)) return(NULL)
  dl=sc$layers[[min(which(dvidlayer))]]
  dl
}

flyem_rootnode4dataset <- memoise::memoise(function(dataset=NULL) {
  ds <- if(is.character(dataset)) flyem_dataset(dataset) else dataset
  stopifnot(!is.null(ds$uuid))
  servers=flyem_servers4dataset(ds)
  u=sprintf("%s/api/repo/%s/info", servers$dvid, ds$uuid)
  info = try(jsonlite::fromJSON(readLines(u, warn = F)))
  stopifnot(!is.null(info$Root))
  info$Root
})
