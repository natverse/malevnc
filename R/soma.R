#' Return the soma or root position of MANC bodyids
#'
#' @details Currently there are two sources of soma information, the
#'   \code{\link{mancsomapos}} data.frame distributed with the malevnc package
#'   and point annotations stored in Clio. The data.frame was the result of
#'   initial annotation work principally by Chris Ordish at FlyEM who marked two
#'   points to define a sphere. It contains some cases where the midpoint
#'   between the two marked points does not land on the intended soma; there are
#'   also cases where the segmentation inside the soma is not contiguous e.g.
#'   because the nucleus is a separate body.
#'
#'   Clio point annotations were added after predicting a set of objects without
#'   an annotated soma that might be intrinsic VNC neurons based on features
#'   such as pre- and post-synapse numbers, size, skeleton path length etc.
#'
#'   with a tag, described below.
#'
#'   There have consistently been a few cases of bodies with multiple annotated
#'   somata. These are sometimes due to annotation error.
#'
#'   \itemize{
#'
#'   \item soma tags are placed only on somata visible within the dataset
#'
#'   \item tosoma tags are placed on cell body fibres leading to the soma of an
#'   intrinsic neuron that may be missing (e.g. because of damage to the
#'   specimen or because of difficulty following the cell body fibre all the way
#'   to the soma due to segmentation issues.)
#'
#'   \item root tags are placed on a part of the neuron that is likely to be the
#'   closest part of the neuron to the soma within the image volume. Two example
#'   use cases are DNs or sensory neurons whose soma is outside the volume. }
#'
#' @param ids MANC bodyids in any form compatible with \code{\link{manc_ids}}.
#'   The default \code{ids=NULL} returns the position of all known soma points.
#' @param details Whether to include details such as bodyids in the return.
#' @param duplicates Whether to include cases where the same bodyid has multiple
#'   soma annotations. Default is to include duplicates when
#'   \code{details=TRUE}.
#' @param somatags Which annotations to include. The default is to include both
#'   \code{"soma"} and  \code{"tosoma"} tags (see details). \code{"all"} is an
#'   alias for \code{c("soma", "tosoma", "root")}.
#' @param node The DVID node to use for XYZ to bodyid lookups. See
#'   \code{\link{manc_xyz2bodyid}}.
#' @param cache whether to add a 5 min cache for the position lookups.
#' @param clio Whether to include point annotations from clio as well as the
#'   contents of \code{\link{mancsomapos}}.
#'
#' @return When \code{details=FALSE} an Nx3 matrix. When \code{TRUE}, a
#'   data.frame containing XYZ position, bodyid, source and tag
#' @export
#' @importFrom dplyr filter .data
#' @seealso supersedes \code{\link{mancsomapos}}
#' @examples
#' \donttest{
#' # just the XYZ position
#' manc_somapos(10000)
#' # with details including data source
#' manc_somapos(10000, details=TRUE)
#' }
manc_somapos <- function(ids=NULL, details=FALSE, duplicates=!details,
                         somatags=c("soma", "tosoma", "root", "all"),
                         node='neutu', cache=TRUE, clio=TRUE) {
  if(missing(somatags)) {
    somatags=c("soma", "tosoma")
  } else {
    somatags=match.arg(somatags, several.ok = TRUE)
    if(length(somatags)==1 && isTRUE(somatags=='all'))
      somatags=c("soma", "tosoma", "root")
  }
  if(!is.null(ids))
    ids=manc_ids(ids, mustWork = TRUE, unique=F, as_character = F)

  # this is just to make sure we get the package data object
  msp=get('mancsomapos', envir = as.environment('package:malevnc'))
  msp=msp[c("n", "X", "Y", "Z")]
  msp$bodyid=manc_xyz2bodyid(msp, node=node, cache = cache)
  msp$source='mancsomapos'
  msp$tag='soma'
  # we don't need to check Clio if we already found all ids
  if(!is.null(ids) && all(ids %in% msp$bodyid)) clio=FALSE
  if(isTRUE(clio)) {
    mpa=manc_point_annotations(cache=cache, bodyid=T, node=node)
    mpas=dplyr::filter(mpa, .data$tags %in% somatags)
    # add an additional offset to n for clio ids
    mpasdf=data.frame(n=seq_len(nrow(mpas))+1e5L,
                      tag=unlist(mpas$tags),
                      bodyid=mpas$bodyid,
                      source='clio')
    mpasdf=cbind(mpasdf, xyzmatrix(mpas$pos))
    msp=dplyr::bind_rows(msp, mpasdf)
  }
  if(isFALSE(duplicates))
    msp=msp[!duplicated(msp$bodyid),,drop=F]

  if(!is.null(ids)) {
    msp <- dplyr::left_join(data.frame(bodyid=ids), msp, by='bodyid')
    if(isFALSE(duplicates))
      stopifnot(all(msp$bodyid==ids))
  } else msp <- msp[union("bodyid", colnames(msp))]
  if(details) msp else xyzmatrix(msp)
}

#' @export
#' @rdname manc_somapos
#' @description \code{manc_rootpos} returns the root point of all neurons and is
#'   a convenience wrapper around \code{manc_somapos}.
manc_rootpos <- function(ids=NULL, details=FALSE, duplicates=!details,
                         node='neutu', cache=TRUE, clio=TRUE) {
  manc_somapos(ids=ids, details=details, duplicates=duplicates, node=node,
               cache=cache, clio=clio, somatags='all')
}
