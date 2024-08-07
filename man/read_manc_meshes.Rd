% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meshes.R
\name{read_draco_meshes}
\alias{read_draco_meshes}
\alias{read_manc_meshes}
\title{Read draco encoded 3D meshes from tarballs (as used by Janelia FlyEM)}
\usage{
read_draco_meshes(x)

read_manc_meshes(ids, node = "clio", type = c("merged", "supervoxels"), ...)
}
\arguments{
\item{x}{A URL to a remote location or path to a file on disk}

\item{ids}{A set of body ids in any form understandable to
\code{\link{manc_ids}}}

\item{node}{the dvid node containing the dataset. See
\code{\link{manc_dvid_node}}}

\item{type}{Whether to return a single lower resolution mesh for each body id
(\code{'merged'}) or a \code{\link{neuronlist}} containing one high
resolution mesh for every supervoxel in a single bodyid
(\code{'supervoxels'}).}

\item{...}{Additional arguments passed to \code{\link{pbsapply}}. to}
}
\value{
A \code{\link{neuronlist}} object containing
  \code{rgl::\link[rgl]{mesh3d}} objects

a \code{\link{neuronlist}} containing one or more meshes
}
\description{
the low-level \code{read_draco_meshes} reads meshes from tarballs

\code{read_manc_meshes} reads the meshes for a single MANC body
  id.
}
\details{
There are currently two sets of meshes available: \itemize{

  \item \code{merged} A single mesh for the entire body, in legacy
  neuroglancer format. This is somewhat lower resolution.

  \item \code{supervoxels} All supervoxel meshes for a particular body,
  obtained as a .tar containing a .drc draco mesh for each supervoxel. Highly
  compressed but has more vertices.

  }

  The download size of these two objects is similar, but due to draco mesh
  compression the number of vertices / faces in the \code{supervoxels} meshes
  is 5-10x greater.

  In general we recommend using the \code{merged} format, especially as this
  means that you can fetch many meshes at once.
}
\examples{
\dontrun{
# NB you need VPN access for this
m=read_manc_meshes(23547362285)
plot3d(m)
clear3d()
plot3d(m, type='wire')
}
# Giant Fibre neurons
\donttest{
library(nat)
gfs=read_manc_meshes(c(10000,10002))
gfs.latest=read_manc_meshes(c(10000,10002), node="neutu")
plot3d(gfs)

n10373=read_manc_meshes(10373, type='supervoxels')
nclear3d()
# supervoxels appear in different colours
plot3d(n10373)
}
}
