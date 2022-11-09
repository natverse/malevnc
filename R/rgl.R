#' Set a standard viewpoint for MANC data
#'
#' @param viewpoint A string specifying an anatomical viewpoint (defaults to
#'   ventral)
#' @param template The template object implied by the \code{viewpoint}
#'   specification. Currently only the symmetric MANC template is supported.
#' @param returnparams When \code{FALSE} uses \code{par3d} to change the rgl
#'   device. When \code{TRUE} just returns the settings for you to use. See
#'   examples.
#' @inheritParams nat::nview3d
#' @details See
#'   \href{https://flyem-cns.slack.com/archives/C02GY69SY3H/p1660679361976619}{slack
#'   discussion} for details.
#'
#' @return When \code{returnparams} a named list
#' @export
#' @importFrom rgl par3d
#' @examples
#' # default parameters
#' manc_view3d(returnparams=TRUE)
#' \dontrun{
#' plot3d(MANC.tissue.surf.sym)
#' manc_view3d("ventral")
#' manc_view3d("dorsal")
#' manc_view3d("left")
#'
#' ## open a new window
#' # with regular rgl function
#' open3d(manc_view3d('ventral', returnparams=TRUE))
#' # with nat, allowing interactive pan
#' nopen3d(manc_view3d('ventral', returnparams=TRUE))
#' plot3d(MANC.tissue.surf.sym)
#' }
manc_view3d <- function(viewpoint=c("ventral", "dorsal", "left", "right"),
                        FOV=0, template=c("MANCsym"), extramat=NULL, returnparams=FALSE, ...) {
  viewpoint=match.arg(viewpoint)
  if(template!='MANCsym')
    stop("Only the symmetric MANC template is supported at present!")

  mats=list(
    dorsal = matrix(c(1,0,0,0,0,0.3420201,0.9396926,0,0,-0.9396926,0.3420201,0,0,0,0,1),
                    ncol = 4, byrow = TRUE),
    ventral = matrix(c(-1,0,0,0,0,0.3420201,0.9396926,0,0,0.9396926,-0.3420201,0,0,0,0,1),
                     ncol = 4, byrow = TRUE),
    right = matrix(c(-0,-0.9396926,0.3420201,0,0,0.3420201,0.9396926,0,-1,0,0,0,0,0,0,1),
                   ncol = 4, byrow = TRUE),
    left = matrix(c(0,0.9396926,-0.3420201,0,0,0.3420201,0.9396926,0,1,0,0,0,0,0,0,1),
                  ncol = 4, byrow = TRUE))

  um=mats[[viewpoint]]
  if (!is.null(extramat)) {
    stopifnot(identical(dim(extramat), c(4L, 4L)))
    um = um %*% extramat
  }
  if(returnparams)
    list(userMatrix = um, FOV = FOV, ...)
  else
    par3d(userMatrix = um, FOV = FOV, ..., no.readonly = TRUE)
}
