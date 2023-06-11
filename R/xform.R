#' Mirror points or other 3D objects along the MANC midline
#'
#' @details These registration functions depend on an installation of the CMTK
#'   registration toolkit. See \code{\link[nat]{cmtk.bindir}} for details.
#' @param x 3D vertices (or object containing them) in MANC microns. Could be
#'   \code{\link{neuron}}, \code{\link{neuronlist}}, \code{\link{hxsurf}} etc.
#' @param level Which resolution level of the CMTK registrations to use. Higher
#'   number = higher resolution. This is for expert/testing purposes only - just
#'   stick with the default.
#' @param ... additional arguments passed to \code{\link{xform}} and friends
#'
#' @return Transformed points/object
#' @export
#'
#' @examples
#' \donttest{
#' # NB convert from raw coordinates to microns on input
#' hookr=cbind(33549, 45944, 50806)*c(8,8,8)/1000
#' hookl=cbind(8718, 40794, 52140)*c(8,8,8)/1000
#' hookrl=rbind(hookr, hookl)
#'
#' # mirror these positions
#' hookrl.m=mirror_manc(hookrl)
#' hookrl.m
#' # compute difference from
#' # transformed L to original R
#' # transformed R to original L
#' # distances are 1-8 microns in each axis, due to placement variations.
#' hookrl.m-hookrl[2:1, ]
#' }
#' \dontrun{
#' wire3d(MANC.surf, col='grey', lwd=.5)
#' points3d(hookrl, col=c("green", "red"), size=10)
#' points3d(hookrl.m, col=c("green", "red"), size=5)
#' # the lines will link the transformed points
#' segments3d(rbind(hookrl, hookrl.m)[c(1,3,2,4), ])
#'
#' # show the original surface and the mirrored surface
#' MANC.surf.m=mirror_manc(MANC.surf)
#' MANC.surf.m=mirror_manc(MANC.surf)
#' nclear3d()
#' plot3d(MANC.surf)
#' wire3d(MANC.surf.m)
#' }
#'
#' @importFrom nat reglist xform invert_reglist
#' @importFrom nat.templatebrains as.templatebrain mirror_brain
mirror_manc <- function(x, level=c(5,4), ...) {

  mirror_reg_f=mirror_manc_reglist(level = level)
  mirror_reg_r=mirror_manc_reglist("reverse", level = level)
  xt=xform(x, reg=mirror_reg_f, ... )
  xtm=mirror_brain(xt, brain = MANCsym, mirrorAxis = 'X', transform='flip', ...)
  xtmt=xform(xtm, reg=mirror_reg_r, ... )
  xtmt
}

#' @rdname mirror_manc
#' @description \code{symmetric_manc} transforms neurons, surfaces and other
#'   point data onto a symmetrised version of the MANC template brain,
#'   optionally mirroring across the midline.
#' @param mirror Whether to mirror across the midline when using
#'   \code{symmetric_manc}
#' @export
#' @examples
#' \dontrun{
#' symmetric_manc(MANC.surf)
#' # mirror across the midline in symmetric space also
#' MANCsym.surf.m=symmetric_manc(MANC.surf, mirror=T)
#'
#' # plot the two symmetric surfaces
#' plot3d(MANCsym.surf)
#' wire3d(MANCsym.surf.m)
#' }
symmetric_manc <- function(x, level=c(5,4), mirror=FALSE, ...) {

  mirror_reg_f=mirror_manc_reglist(level = level)
  xt=xform(x, reg=mirror_reg_f, ... )
  if(isTRUE(mirror))
    xt=mirror_brain(xt, brain = MANCsym, mirrorAxis = 'X', transform='flip')
  xt
}



#' Calculate the left-right position wrt to the symmetrised MANC midline
#'
#' @param x An object containing XYZ vertex locations in microns, compatible
#'   with \code{\link{xyzmatrix}}
#' @param ... Additional arguments passed to \code{\link{xform}}
#'
#' @return A vector of point displacements in microns where 0 is at the midline
#'   and positive values are to the fly's right.
#' @export
#' @importFrom nat xyzmatrix
#' @examples
#' \donttest{
#' library(nat)
#' if(!is.null(cmtk.bindir())) {
#' lr=manc_lr_position(xyzmatrix(mancsomapos)/125)
#' # red for left, green for right (nautical convention)
#' points3d(xyzmatrix(mancsomapos), col=ifelse(lr<0, "red","green"))
#' plot3d(boundingbox(mancsomapos))
#' }
#' }
manc_lr_position <- function(x, ...) {
  mirror_reg_f=mirror_manc_reglist(level=5)
  xyz=xyzmatrix(x)
  xyzt=xform(xyzmatrix(xyz), reg=mirror_reg_f, ... )
  xyzt2=mirror_brain(xyzt, brain = MANCsym, mirrorAxis = 'X', transform='flip')
  mldiff=xyzt[,1]-xyzt2[,1]
  mldiff
}

# internal function to return a CMTK mirroring registration
mirror_manc_reglist <- function(direction=c("forward", "reverse"), level=c(5,4)) {
  if(length(level)>1) level=level[1]
  level=checkmate::asInt(level, lower=4L, upper = 5L)
  direction=match.arg(direction)
  pkg = utils::packageName()
  f1 = system.file(
    sprintf("reg/mancsym-4_warp.list/level-0%d.list", level),
    package = pkg, mustWork = TRUE
  )

  f2=system.file("reg/mancsym-4-flip_mancsym-4-halved.list",
                 package = pkg, mustWork = TRUE)
  # nb in CMTK direction is defined by the image transform which is the opposite
  # of the points transform, hence swap=T
  mirror_reg_f <- reglist(nat::cmtkreg(f1), nat::cmtkreg(f2), swap = c(T,T))
  if(direction=='forward') mirror_reg_f else invert_reglist(mirror_reg_f)
}

#' MANC symmetric template
#' @export
MANCsym = structure(
  list(
    name = "mancsym-4-symmetric",
    regName = "MANCsym",
    type = "Synthetic average brain from T-bar predictions based on MANC FIB sem data",
    sex = "M",
    dims = c(672L, 830L, 1280L),
    voxdims = c(0.512,
                0.512, 0.512),
    origin = c(0, 0, 0),
    BoundingBox = structure(
      c(0,
        343.552, 0, 424.448, 0, 654.848),
      .Dim = 2:3,
      class = "boundingbox"
    ),
    units = NULL,
    description = NULL,
    doi = NULL
  ),
  class = "templatebrain"
)

#' Download MANC (EM) to JRC (light level) registrations
#'
#' John Bogovic and Stephan Saalfeld have constructed a series of
#' \href{https://www.janelia.org/open-science/jrc-2018-brain-templates}{bridging
#' registrations} from both light level and EM brains imaged at HHMI Janelia
#' Research Campus. This function downloads the VNC registrations to your local
#' machine to allow you to convert data between this different template spaces.
#'
#' It downloads publicly available registrations: MANC to JRC2018VNCM
#' \url{https://figshare.com/s/7f003353c24741136df3} JRC2018VNCM <> JRC2018VNCU
#' \url{https://figshare.com/s/42ad71eb14e7dd51e81a} RC2018VNCF <> JRC2018VNCU
#' \url{https://figshare.com/s/c4589cef9180e1dd4ee1}
#'
#' It requires installation of a suggested dependency \code{nat.jrcbrains}.
#' These transformations operate in units of microns. Therefore, any point
#' coordinates must be converted to micron units before applying.
#'
#' In order to use the registrations you need to load the \code{nat.jrcbrains}.
#'
#' @export
#' @references See Bogovic et al. (2018) \doi{10.1101/376384}
#' @examples
#'
#' \dontrun{
#' # one time install of optional package if you don't have it
#' if(!requireNamespace('nat.jrcbrains'))
#'   natmanager::install(pkgs = 'nat.jrcbrains')
#' # load this to use bridging registrations to JRC templates
#' library(nat.jrcbrains)
#'
#' # one time download of large (~1.4 GB) bridging registrations
#' if(!"MANC" %in% allreg_dataframe()$reference)
#'   download_manc_registrations()
#'
#' DNa02s=read_manc_meshes('DNa02')
#' # nb convert from nm to microns
#' DNa02s.jrcvnc2018u=xform_brain(DNa02s/1e3, reference = "JRCVNC2018U", sample="")
#' plot3d(DNa02s.jrcvnc2018u)
#' plot3d(JRCVNC2018U)
#' }
#'
download_manc_registrations <- function() {
  check_jrcbrains()
  download_urls <- paste0(
    "https://ndownloader.figshare.com/files/",
    c(
      "38827794",
      "28908795?private_link=42ad71eb14e7dd51e81a",
      "28909212?private_link=c4589cef9180e1dd4ee1"
  ))
  names(download_urls) <- c(
    "JRCVNC2018M_MANC.h5",
    "JRCVNC2018M_JRC2018VNCU.h5",
    "JRCVNC2018U_JRC2018VNCF.h5"
  )
  nat.jrcbrains::download_saalfeldlab_registrations(
    download_urls = download_urls
  )
}

# checks whether nat.jrcbrains is installed
check_jrcbrains <- function() {
  if(!requireNamespace('nat.jrcbrains', quietly = TRUE))
    stop("You must install the nat.jrcbrains package in order to download registrations locally!\n",
         "  natmanager::install(pkgs = 'nat.jrcbrains')\n",
         "should do the trick. ",
         "Please see https://github.com/natverse/nat.jrcbrains for details.")
}
