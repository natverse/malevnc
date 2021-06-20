#' Return a Neuroglancer scene URL for MANC dataset
#'
#' @description The default behaviour is to generate a rich neuroglancer scene
#'   with including any passed \code{ids} using the current Clio DVID node. This
#'   means that meshes should be in sync. See
#'   \href{https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1619825198227100?thread_ts=1619816902.216600&cid=C01MYQ1AQ5D}{this
#'    slack} post from Stuart Berg for more details.
#' @details Neuroglancer scenes can be pasted into a variety of different
#'   variants. Use the \code{return.json} to get a JSON fragment that can be
#'   pasted into any neuroglancer instance using the closed curly bracket
#'   symbol.
#'
#'   See
#'   \href{https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1624033684227400}{slack}
#'   for why \url{https://clio-ng.janelia.org/} is the recommended base Url
#'   (chosen when \code{server='clio'}).
#'
#' @section scenes: The following scenes (named by the approximate date that we
#'   started using them) are available. \itemize{
#'
#'   \item \code{2021-05-05} Like \code{2021-05-04} but with a voxelwise ROI
#'   segmentation layer copied over from \code{2021-04-01}.

#' \item \code{2021-05-04} Added nerves and full VNC (cell body rind) surface
#' mesh. See
#' \href{https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1620164087077600}{Slack
#' message from Stuart Berg}. GSXEJ added the ROIs to
#'
#' \item \code{2021-04-01} With VNC ROIs. By April 2021 we were using
#' \href{https://clio.janelia.org/}{Clio} for annotations.
#'
#' \item \code{2021-02-01} In early 2021 we were using a Janelia server hosting
#' neuroglancer that allowed annotation through a hybrid DVID backend.
#'
#' The early 2021 server required authentication at
#' \url{https://neuprint.janelia.org/} in order to use the annotation features.
#' I recommend logging in and out of neuprint if you still get authentication
#' errors from Neuroglancer when attempting to use the annotation layer.
#'
#' }
#'
#' @param ids A set of body ids to add to the neuroglancer scene in any form
#'   compatible with \code{\link{manc_ids}}
#' @param node A DVID node e.g. as returned by \code{manc_dvid_node}. The
#'   (recommended) default behaviour is to use the current Clio node.
#' @param open When \code{TRUE} opens the URL in your browser.
#' @param server Whether to use Janelia's Clio branch, the Google server (newest
#'   version of neuroglancer) or the Janelia server (required for annotation in
#'   early 2021, but now deprecated in favour of Clio). 99% of the time you
#'   should keep the default.
#' @param return.json Whether to return a JSON fragment defining the scene or
#'   (by default) a Neuroglancer URL.
#' @param basescene Which neuroglancer scene url to use as a base. You can also
#'   supply your own URL.
#'
#' @return A character vector containing a single Neuroglancer URL or a JSON
#'   fragment.
#' @export
#'
#' @examples
#' \dontrun{
#' browseURL(manc_scene())
#' # copy scene information with a sample neuron to the clipboard
#' clipr::write_clip(manc_scene(ids=13749))
#'
#' # JSON fragment that could be copied into Clio
#' clipr::write_clip(manc_scene(return.json = TRUE))
#'
#' }
manc_scene <- function(ids=NULL, node='clio',
                       open=FALSE,
                       basescene=c("2021-05-05", "2021-05-04", "2021-04-01", "2021-02-01"),
                       server=c("clio","appspot", "janelia"), return.json=FALSE) {
  server=match.arg(server)
  node=manc_nodespec(node, several.ok = F)
  if(!requireNamespace("fafbseg", quietly = TRUE))
    stop("Please install suggested fafbseg package!")

  if(length(basescene)>1 || isTRUE(nchar(basescene)<20)) {
    basescene=match.arg(basescene)
  }
  url <-
    switch(
      basescene,
      "2021-05-05" = "https://neuroglancer.janelia.org/#!%7B%22dimensions%22:%7B%22x%22:%5B8e-9%2C%22m%22%5D%2C%22y%22:%5B8e-9%2C%22m%22%5D%2C%22z%22:%5B8e-9%2C%22m%22%5D%7D%2C%22position%22:%5B24025.0546875%2C15677.3818359375%2C38077.546875%5D%2C%22crossSectionScale%22:5.65540137456763%2C%22projectionOrientation%22:%5B-0.7735966444015503%2C-0.012402527965605259%2C0.024922285228967667%2C0.6330665349960327%5D%2C%22projectionScale%22:91572.00243774979%2C%22layers%22:%5B%7B%22type%22:%22image%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-2-26-213dba213ef26e094c16c860ae7f4be0/v3_emdata_clahe_xy/jpeg%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22name%22:%22grayscale-jpeg%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22dvid://https://emdata5-avempartha.janelia.org/d5620e7b865d49638be28e4115b6206f/segmentation%22%2C%22subsources%22:%7B%22default%22:true%2C%22meshes%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22name%22:%22dvid-segmentation%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/all-vnc-roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22pick%22:false%2C%22selectedAlpha%22:0%2C%22saturation%22:0%2C%22meshSilhouetteRendering%22:4.4%2C%22segments%22:%5B%221%22%5D%2C%22name%22:%22all-tissue%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22pick%22:false%2C%22selectedAlpha%22:0%2C%22saturation%22:0.5%2C%22segments%22:%5B%2210%22%2C%2211%22%2C%2212%22%2C%2213%22%2C%2214%22%2C%2215%22%2C%2216%22%2C%2217%22%2C%2218%22%2C%2219%22%2C%2220%22%2C%2221%22%2C%2222%22%2C%2223%22%2C%2224%22%2C%2225%22%2C%2226%22%2C%2227%22%2C%224%22%2C%225%22%2C%226%22%2C%227%22%2C%228%22%2C%229%22%5D%2C%22name%22:%22neuropils%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22pick%22:false%2C%22saturation%22:0.55%2C%22objectAlpha%22:0.5%2C%22meshSilhouetteRendering%22:3.7%2C%22segments%22:%5B%2210%22%2C%2211%22%2C%2212%22%2C%2213%22%2C%2214%22%2C%2215%22%2C%2216%22%2C%2217%22%2C%2218%22%2C%2219%22%2C%2220%22%2C%2221%22%2C%2222%22%2C%2223%22%2C%2224%22%2C%2225%22%2C%2226%22%2C%2227%22%2C%224%22%2C%225%22%2C%226%22%2C%227%22%2C%228%22%2C%229%22%5D%2C%22name%22:%22roi%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/nerve-roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22pick%22:false%2C%22objectAlpha%22:0.1%2C%22segments%22:%5B%221%22%2C%2210%22%2C%2211%22%2C%2212%22%2C%2213%22%2C%2214%22%2C%2215%22%2C%2216%22%2C%2217%22%2C%2218%22%2C%2219%22%2C%222%22%2C%2220%22%2C%2221%22%2C%2222%22%2C%2223%22%2C%2224%22%2C%2225%22%2C%2226%22%2C%2227%22%2C%2228%22%2C%2229%22%2C%223%22%2C%2230%22%2C%2231%22%2C%224%22%2C%225%22%2C%226%22%2C%227%22%2C%228%22%2C%229%22%5D%2C%22name%22:%22nerves%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/rc5_wsexp%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22source%22%2C%22name%22:%22rc5-supervoxels%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/mask%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22pick%22:false%2C%22name%22:%22voxel-classes%22%2C%22visible%22:false%7D%5D%2C%22showSlices%22:false%2C%22prefetch%22:false%2C%22selectedLayer%22:%7B%22layer%22:%22dvid-segmentation%22%2C%22visible%22:true%7D%2C%22layout%22:%223d%22%7D",
      "2021-04-01" = "https://neuroglancer-demo.appspot.com/#!%7B%22dimensions%22:%7B%22x%22:%5B8e-9%2C%22m%22%5D%2C%22y%22:%5B8e-9%2C%22m%22%5D%2C%22z%22:%5B8e-9%2C%22m%22%5D%7D%2C%22position%22:%5B23770.91796875%2C37525.58984375%2C40561.5%5D%2C%22crossSectionScale%22:98.91246128138968%2C%22projectionOrientation%22:%5B0%2C0.7071067690849304%2C-0.7071067690849304%2C0%5D%2C%22projectionScale%22:71933.83876611631%2C%22layers%22:%5B%7B%22type%22:%22image%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-2-26-213dba213ef26e094c16c860ae7f4be0/v3_emdata_clahe_xy/jpeg%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22source%22%2C%22name%22:%22grayscale-jpeg%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22dvid://https://emdata5-avempartha.janelia.org/963e5a2b380c4c119d5b27d6eac2fb59/segmentation%22%2C%22subsources%22:%7B%22default%22:true%2C%22meshes%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22name%22:%22dvid-segmentation%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/rc5_wsexp%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22source%22%2C%22name%22:%22rc5-supervoxels%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22pick%22:false%2C%22tab%22:%22segments%22%2C%22saturation%22:0.55%2C%22objectAlpha%22:0.5%2C%22meshSilhouetteRendering%22:3.7%2C%22segments%22:%5B%2210%22%2C%2211%22%2C%2212%22%2C%2213%22%2C%2214%22%2C%2215%22%2C%2216%22%2C%2217%22%2C%2218%22%2C%2219%22%2C%2220%22%2C%2221%22%2C%2222%22%2C%2223%22%2C%2224%22%2C%2225%22%2C%2226%22%2C%2227%22%2C%224%22%2C%225%22%2C%226%22%2C%227%22%2C%228%22%2C%229%22%5D%2C%22name%22:%22roi%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/nBreak-v1%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22source%22%2C%22name%22:%22nBreak-v1%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/mask%22%2C%22tab%22:%22source%22%2C%22segmentQuery%22:%22sneaky%20comment%20here:%201:oob%202:trachea%203:glia%204:cell%20bodies%205:neuropil%22%2C%22name%22:%22voxel-classes%22%2C%22visible%22:false%7D%5D%2C%22showAxisLines%22:false%2C%22showSlices%22:false%2C%22prefetch%22:false%2C%22selectedLayer%22:%7B%22visible%22:true%2C%22layer%22:%22dvid-segmentation%22%7D%2C%22layout%22:%223d%22%7D",
      "2021-05-04" = "https://neuroglancer.janelia.org/#!%7B%22dimensions%22:%7B%22x%22:%5B8e-9%2C%22m%22%5D%2C%22y%22:%5B8e-9%2C%22m%22%5D%2C%22z%22:%5B8e-9%2C%22m%22%5D%7D%2C%22position%22:%5B25298.650390625%2C20862.474609375%2C47448.1484375%5D%2C%22crossSectionScale%22:5.65540137456763%2C%22projectionOrientation%22:%5B-0.8629626631736755%2C-0.08522867411375046%2C0.09002278000116348%2C0.4898238480091095%5D%2C%22projectionScale%22:91572.00243774979%2C%22layers%22:%5B%7B%22type%22:%22image%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-2-26-213dba213ef26e094c16c860ae7f4be0/v3_emdata_clahe_xy/jpeg%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22name%22:%22grayscale-jpeg%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22dvid://https://emdata5-avempartha.janelia.org/d5620e7b865d49638be28e4115b6206f/segmentation%22%2C%22subsources%22:%7B%22default%22:true%2C%22meshes%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22name%22:%22dvid-segmentation%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/all-vnc-roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22pick%22:false%2C%22selectedAlpha%22:0%2C%22saturation%22:0%2C%22meshSilhouetteRendering%22:4.4%2C%22segments%22:%5B%221%22%5D%2C%22name%22:%22all-tissue%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22pick%22:false%2C%22selectedAlpha%22:0%2C%22saturation%22:0.5%2C%22segments%22:%5B%2210%22%2C%2211%22%2C%2212%22%2C%2213%22%2C%2214%22%2C%2215%22%2C%2216%22%2C%2217%22%2C%2218%22%2C%2219%22%2C%2220%22%2C%2221%22%2C%2222%22%2C%2223%22%2C%2224%22%2C%2225%22%2C%2226%22%2C%2227%22%2C%224%22%2C%225%22%2C%226%22%2C%227%22%2C%228%22%2C%229%22%5D%2C%22name%22:%22neuropils%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/nerve-roi%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22pick%22:false%2C%22objectAlpha%22:0.1%2C%22segments%22:%5B%221%22%2C%2210%22%2C%2211%22%2C%2212%22%2C%2213%22%2C%2214%22%2C%2215%22%2C%2216%22%2C%2217%22%2C%2218%22%2C%2219%22%2C%222%22%2C%2220%22%2C%2221%22%2C%2222%22%2C%2223%22%2C%2224%22%2C%2225%22%2C%2226%22%2C%2227%22%2C%2228%22%2C%2229%22%2C%223%22%2C%2230%22%2C%2231%22%2C%224%22%2C%225%22%2C%226%22%2C%227%22%2C%228%22%2C%229%22%5D%2C%22name%22:%22nerves%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/rc5_wsexp%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22source%22%2C%22name%22:%22rc5-supervoxels%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/mask%22%2C%22subsources%22:%7B%22default%22:true%2C%22properties%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22pick%22:false%2C%22name%22:%22voxel-classes%22%2C%22visible%22:false%7D%5D%2C%22showSlices%22:false%2C%22prefetch%22:false%2C%22selectedLayer%22:%7B%22layer%22:%22dvid-segmentation%22%2C%22visible%22:true%7D%2C%22layout%22:%223d%22%7D",
      "2021-02-01" = "https://neuroglancer.janelia.org/#!%7B%22dimensions%22:%7B%22x%22:%5B8e-9%2C%22m%22%5D%2C%22y%22:%5B8e-9%2C%22m%22%5D%2C%22z%22:%5B8e-9%2C%22m%22%5D%7D%2C%22position%22:%5B23575%2C20589%2C33089%5D%2C%22crossSectionOrientation%22:%5B-0.2594539225101471%2C0.13549424707889557%2C-0.00940671470016241%2C0.9561571478843689%5D%2C%22crossSectionScale%22:0.5352614285189903%2C%22projectionOrientation%22:%5B-0.6798036694526672%2C-0.5268529057502747%2C0.320065438747406%2C0.39730486273765564%5D%2C%22projectionScale%22:37552.75673405884%2C%22layers%22:%5B%7B%22type%22:%22image%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-2-26-213dba213ef26e094c16c860ae7f4be0/v3_emdata_clahe_xy/jpeg%22%7D%2C%22tab%22:%22source%22%2C%22blend%22:%22default%22%2C%22name%22:%22Grayscale%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/rc4_wsexp%22%7D%2C%22tab%22:%22annotations%22%2C%22skeletonRendering%22:%7B%22mode2d%22:%22lines_and_points%22%2C%22mode3d%22:%22lines%22%7D%2C%22name%22:%22Segmentation%22%7D%2C%7B%22type%22:%22annotation%22%2C%22source%22:%7B%22url%22:%22dvid://https://hemibrain-dvid2.janelia.org/36e0b/neuroglancer_todo?usertag=true&auth=https://hemibrain-dvid2.janelia.org/api/server/token%22%7D%2C%22tab%22:%22source%22%2C%22tool%22:%22annotatePoint%22%2C%22selectedAnnotation%22:%7B%22id%22:%2223575_20589_33089%22%2C%22subsource%22:%22default%22%7D%2C%22tableFilterByTime%22:%22all%22%2C%22tableFilterByUser%22:%22mine%22%2C%22name%22:%22Todo%22%7D%5D%2C%22showSlices%22:false%2C%22selectedLayer%22:%7B%22layer%22:%22Todo%22%2C%22visible%22:true%7D%2C%22layout%22:%224panel%22%7D",
      basescene
    )
  if(!is.null(ids)) ids <- manc_ids(ids)
  url <- if(isTRUE(basescene=='2021-02-01')) {
    if(isTRUE(length(ids)>0))
      fafbseg::ngl_segments(url) <- ids
    url
  } else {
    sc=fafbseg::ngl_decode_scene(url)
    if(!isTRUE(nzchar(sc$layers$`dvid-segmentation`$source$url)))
      stop("Unable to find DVID segmentation layer in URL")
    dvidurl=paste0("dvid://", manc_serverurl("%s/segmentation", node))
    sc$layers$`dvid-segmentation`$source$url=dvidurl
    if(isTRUE(length(ids)>0))
      fafbseg::ngl_segments(sc) <- ids
    burl <- switch(server,
                   janelia="https://neuroglancer.janelia.org",
                   google="https://neuroglancer-demo.appspot.com",
                   "https://clio-ng.janelia.org/"
                   )
    # burl=sub("(https://[^/]+).+", "\\1", url)
    fafbseg::ngl_encode_url(sc, baseurl = burl)
  }

  if(return.json) {
    fafbseg::ngl_decode_scene(url, return.json = TRUE)
  } else {
    if(isTRUE(open)) {
      utils::browseURL(url)
      invisible(url)
    } else url
  }
}

manc_server <-
  memoise::memoise(function(server = getOption("malevnc.server")) {
    if (is.null(server))
      stop("Please use options(malevnc.server) to set the URL of the emdata server!")
    pu=tryCatch(httr::parse_url(server), error=function(e)
      stop("Unable to parse malevnc.server URL:", server))
    server_down <- is.null(curl::nslookup(pu$hostname, error = FALSE))
    if (server_down) {
      internet_ok <- !is.null(curl::nslookup("google.com", error = FALSE))
      if(internet_ok)
        stop("Cannot reach malevnc server. Please check `options('malevnc.server')")
      else
        stop("Cannot reach malevnc server or google. Please check your internet connection!")
    }

    server
    }, cache = cachem::cache_mem(max_age = 60 * 15))

# utility function to generate URLs on emdata5.
# Will do sprintf string interpolation if required
manc_serverurl <- function(path, ..., urlargs=NULL) {
  path <- if(length(urlargs)>0)
    do.call(sprintf, c(list(path), urlargs))
  else
    sprintf(path, ...)
  url = file.path(manc_server(), path, fsep = '/')
}
