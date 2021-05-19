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
    utils::download.file(x, tf, quiet=!interactive())
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


#' @description \code{read_manc_meshes} reads the meshes for a single MANC body
#'   id.
#' @details There are currently two sets of meshes available: \itemize{
#'
#'   \item \code{merged} A single mesh for the entire body, in legacy
#'   neuroglancer format. This is somewhat lower resolution.
#'
#'   \item \code{supervoxels} All supervoxel meshes for a particular body,
#'   obtained as a .tar containing a .drc draco mesh for each supervoxel. Highly
#'   compressed but has more vertices.
#'
#'   }
#'
#'   The download size of these two objects is similar, but due to draco mesh
#'   compression the number of vertices / faces in the \code{supervoxels} meshes
#'   is 5-10x greater.
#'
#'   In general we recommend using the \code{merged} format, especially as this
#'   means that you can fetch many meshes at once.
#' @inheritParams manc_connection_table
#' @param type Whether to return a single lower resolution mesh for each body id
#'   (\code{'merged'}) or a \code{\link{neuronlist}} containing one high
#'   resolution mesh for every supervoxel in a single bodyid
#'   (\code{'supervoxels'}).
#' @param ... Additional arguments passed to \code{\link{pbsapply}}. to
#' @param node the dvid node containing the dataset. See
#'   \code{\link{manc_dvid_node}}
#' @return a \code{\link{neuronlist}} containing one or more meshes
#' @export
#' @importFrom nat as.neuronlist
#' @rdname read_manc_meshes
#' @examples
#' # Giant Fibre neurons
#' \donttest{
#' library(nat)
#' gfs=read_manc_meshes(c(10000,10002))
#' gfs.latest=read_manc_meshes(c(10000,10002), node="neutu")
#' plot3d(gfs)
#'
#' n10373=read_manc_meshes(10373, type='supervoxels')
#' nclear3d()
#' # supervoxels appear in different colours
#' plot3d(n10373)
#' }
read_manc_meshes <- function(ids, node="clio", type=c('merged', 'supervoxels'), ...) {
  type=match.arg(type)
  ids=manc_ids(ids, as_character = F)
  node=manc_nodespec(node, several.ok = F)
  if(type=='merged') {
    checkmate::checkIntegerish(ids, lower=1)
    res=pbapply::pbsapply(ids, read_manc_neuroglancer_mesh, node=node, ..., simplify = F)
    return(as.neuronlist(res, AddClassToNeurons=F))
  }
  checkmate::checkIntegerish(ids, lower=0, len = 1)

  surl=manc_serverurl("api/node/%s/segmentation_sv_meshes/tarfile/%s",
                      node, as.character(ids))
  read_draco_meshes(surl)
}

# read_neuroglancer_mesh(10373)
read_manc_neuroglancer_mesh <- function(id, node="clio") {
  node=manc_nodespec(node, several.ok = F)
  u=manc_serverurl(
    "api/node/%s/segmentation_meshes/key/%s.ngmesh?app=natverse",
    node, id)
  read_neuroglancer_mesh(u)
}

read_neuroglancer_mesh <- function(u, ...) {
  res=httr::GET(u, ...)
  httr::stop_for_status(res)
  bytes=httr::content(res, as='raw')
  decode_neuroglancer_mesh(bytes)
}

decode_neuroglancer_mesh <- function(bytes, format=c('mesh3d', "raw")) {
  format=match.arg(format)
  con=rawConnection(bytes)
  on.exit(close(con))

  nverts=readBin(con, what = 'int', size = 4, n=1)
  verts=readBin(con, what='numeric', n=nverts*3, size=4)
  nidxs=length(bytes)/4-1L-length(verts)
  idx=readBin(con, what='int', n=nidxs, size=4)

  if(format=='raw') {
    structure(list(
      v = matrix(verts, ncol = 3, byrow = T),
      i = matrix(idx, ncol = 3, byrow = T)
    ),
    class = 'ngmesh')
  } else{
    rgl::tmesh3d(
      matrix(verts, nrow=3, byrow = F),
      matrix(idx+1L, nrow=3, byrow = F),
      homogeneous = F)
  }
}
