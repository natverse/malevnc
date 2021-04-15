#' Read draco encoded 3D meshes from tarballs (as used by Janelia FlyEM)

#' @description the low-level \code{read_draco_meshes} reads meshes from tarballs
#' @param x A URL to a remote location or path to a file on disk
#'
#' @return A \code{\link{neuronlist}} object containing
#'   \code{rgl::\link[rgl]{mesh3d}} objects
#' @export
#'
#' @examples
#' \dontrun{
#' # NB you need VPN access for this
#' m=read_manc_meshes(23547362285)
#' plot3d(m)
#' clear3d()
#' plot3d(m, type='wire')
#' }
#' @rdname read_manc_meshes
read_draco_meshes <- function(x) {
  is.url <- function(x) {
    grepl("^(http|https)(://.*)",x)
  }
  if(is.url(x)) {
    tf=tempfile(fileext = 'tar')
    on.exit(unlink(tf))
    utils::download.file(x, tf)
    x=tf
  }
  td <- tempfile()
  dir.create(td)
  on.exit(unlink(td, recursive = T), add = TRUE)
  utils::untar(x, exdir = td)
  ff=dir(td, full.names = T)
  # check for empty meshes
  fs=file.size(ff)
  nzero=sum(fs==0)
  if(nzero>0) {
    warning("Dropping ", nzero, " empty meshes!")
    ff=ff[fs>0]
  }
  nl=nat::nlapply(ff, dracor::draco_decode)
  names(nl)=tools::file_path_sans_ext(basename(ff))
  nl
}


#' @description \code{read_manc_meshes} reads the meshes for a single MANC body id.
#'
#' @param id A manc bodyid
#' @param node the dvid node containing the dataset
#' @export
#' @rdname read_manc_meshes
read_manc_meshes <- function(id, node="aefff") {
  checkmate::checkIntegerish(id, lower=0, len = 1)
  url="http://emdata4.int.janelia.org:8450/api/node/%s/segmentation_sv_meshes/tarfile/%s"
  surl=sprintf(url, node, as.character(id))
  read_draco_meshes(surl)
}
