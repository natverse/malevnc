#' Annotate an XYZ location in Clio as a soma or root
#'
#' @details You should use the tags in the following order of preference
#'   \itemize{
#'
#'   \item{soma}{ If there is a visible soma, use this tag.}
#'
#'   \item{tosoma}{ If the soma is not in the dataset, but you know where it is,
#'   use this tag.}
#'
#'   \item{root}{ If you are not sure where the soma is, but you want to specify
#'   a postiion to act as the root e.g. skeletonising the neuron, use this tag.}
#'
#'   }
#'
#'   When annotating multiple points, you can provide either one user/tag or you
#'   must provide a user tag for every point.
#'
#' @param pos XYZ positions in any raw MANC voxel coordinates in any form
#'   compatible with \code{\link{xyzmatrix}}
#' @param tag One tag (or as many as there are points) to define the annotation.
#'   See details.
#' @param user One user (or as many users as there are points) to define the
#'   annotation. See details.
#' @param description Either \code{NULL}, one value or as any as there are
#'   points.
#' @param ... Additional arguments passed to \code{pbapply::\link{pbmapply}} and
#'   then to the private \code{clio_fetch} function.
#'
#' @export
#' @return the key for the new point annotation, invisibly
#'
#' @examples
#' \dontrun{
#' manc_annotate_soma(cbind(31180, 17731, 31252))
#' }
manc_annotate_soma <- function(pos, tag=c("soma", "tosoma", "root"), user=getOption("malevnc.clio_email"), description=NULL, ...) {
  if(is.null(user))
    stop("The soma annotation must be associated with a user email!\n",
         "It is worth setting the option:\n",
         "options(malevnc.clio_email='<user@gmail.com>')\n",
         "to ")
  pos=xyzmatrix(pos)
  pointlist=lapply(seq_len(nrow(pos)), function(i) pos[i,])
  if(missing(tag))
    tag=match.arg(tag, several.ok = FALSE)
  else
    tag=match.arg(tag, several.ok = TRUE)
  if(length(tag)!=1 && length(tag)!=length(pointlist))
    stop("Please provide either one tag or as many tags as there are points!")
  if(length(user)!=1 && length(user)!=length(pointlist))
    stop("Please provide either one user or as many users as there are points!")
  if(length(description)>1 && length(description)!=length(pointlist))
    stop("Please provide either one description or as many as there are points!")
  # work around limitation of pbmapply
  if(is.null(description)) description=list(NULL)
  res=pbapply::pbmapply(manc_annotate_point, pointlist,
                   tags=tag, user=user,
                   description = description, ...)
  invisible(res)
}

manc_annotate_point <- function(pos, kind="point", tags=NULL, user=getOption("malevnc.clio_email"), description=NULL, ...) {
  url="https://clio-test-7fdj77ed7q-uk.a.run.app/v2/annotations/VNC"
  pos=checkmate::assert_numeric(c(pos), len = 3)
  body=list(kind="point",
            pos=c(pos),
            tags=I(tags), # NB this means it will be a list
            user=user)
  bodyj=jsonlite::toJSON(body, auto_unbox = TRUE)
  clio_fetch(url, body=bodyj, ...)
}
