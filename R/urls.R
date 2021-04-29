#' Return a sample Neuroglancer scene URL for MANC dataset
#'
#' @details Neuroglancer scenes can be pasted into a variety of different
#'   variants. Use the \code{return.json} to get a JSON fragment that can be
#'   pasted into any neuroglancer instance using the closed curly bracket
#'   symbol.
#'
#'   In early 2021 we were using a Janelia server hosting neuroglancer that
#'   allowed annotation through a hybrid DVID backend. By April 2021 we were
#'   using \href{https://clio.janelia.org/}{Clio} for annotations.
#'
#'   The early 2021 server required authentication at
#'   \url{https://neuprint.janelia.org/} in order to use the annotation
#'   features. I recommend logging in and out of neuprint if you still get
#'   authentication errors from Neuroglancer when attempting to use the
#'   annotation layer.
#'
#'   Awkwardly the mesh and label field ROIs currently default to different
#'   colours.
#'
#' @param server Whether to use the Google server (newest version of
#'   neuroglancer) or Janelia server (required for annotation in early 2021, but now deprecated in favour of Clio?).
#' @param return.json Whether to return a JSON fragment defining the scene or
#'   (by default) a Neuroglancer URL.
#' @param ids A set of body ids to add to the neuroglancer scene
#'
#' @return A character vector containing a single Neuroglancer URL or a JSON
#'   fragment.
#' @export
#'
#' @examples
#' \dontrun{
#' browseURL(manc_scene())
#' # copy scene information to clipboard
#' clipr::read_clip(manc_scene(return.json = TRUE))
#' }
manc_scene <- function(ids=NULL, server=c("appspot", "janelia"), return.json=FALSE) {
  server=match.arg(server)
  url <- if(server=='appspot') {
    "https://neuroglancer-demo.appspot.com/#!%7B%22dimensions%22:%7B%22x%22:%5B8e-9%2C%22m%22%5D%2C%22y%22:%5B8e-9%2C%22m%22%5D%2C%22z%22:%5B8e-9%2C%22m%22%5D%7D%2C%22position%22:%5B26698.5%2C28383.5%2C51461.5%5D%2C%22crossSectionOrientation%22:%5B-1%2C0%2C0%2C0%5D%2C%22crossSectionScale%22:19.846210545520808%2C%22projectionOrientation%22:%5B-0.05418477579951286%2C0.8567216396331787%2C0.5039743781089783%2C-0.09540358930826187%5D%2C%22projectionScale%22:32470.390602140593%2C%22layers%22:%5B%7B%22type%22:%22image%22%2C%22source%22:%22precomputed://gs://flyem-vnc-2-26-213dba213ef26e094c16c860ae7f4be0/v3_emdata_clahe_xy/jpeg%22%2C%22tab%22:%22source%22%2C%22name%22:%22VNC%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22dvid://https://emdata5-avempartha.janelia.org/b3122098/segmentation%22%2C%22subsources%22:%7B%22skeletons%22:false%7D%7D%2C%22tab%22:%22source%22%2C%22segments%22:%5B%2210012%22%2C%2210021%22%5D%2C%22name%22:%22vnc-v0.2.2%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://https://spine.janelia.org/files/eric/201001-vnc%22%2C%22subsources%22:%7B%22bounds%22:true%2C%22properties%22:true%2C%22mesh%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22segments%22%2C%22segments%22:%5B%221%22%2C%2210%22%2C%2211%22%2C%2212%22%2C%2213%22%2C%2214%22%2C%2215%22%2C%2216%22%2C%2217%22%2C%2218%22%2C%2219%22%2C%2220%22%2C%2221%22%2C%2222%22%2C%2223%22%2C%2224%22%2C%2225%22%2C%2226%22%2C%2227%22%2C%2228%22%2C%223%22%2C%224%22%2C%225%22%2C%226%22%2C%227%22%2C%228%22%2C%229%22%5D%2C%22name%22:%22201001-vnc%22%2C%22visible%22:false%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-roi-d5f392696f7a48e27f49fa1a9db5ee3b/roi%22%2C%22subsources%22:%7B%22default%22:true%7D%2C%22enableDefaultSubsources%22:false%7D%2C%22tab%22:%22annotations%22%2C%22name%22:%22roi%22%2C%22visible%22:false%7D%5D%2C%22showDefaultAnnotations%22:false%2C%22showSlices%22:false%2C%22prefetch%22:false%2C%22layout%22:%224panel%22%2C%22selection%22:%7B%22position%22:%5B24993.8046875%2C36079.62109375%2C69419.5%5D%2C%22layers%22:%7B%7D%7D%7D"
  } else {
    "https://neuroglancer.janelia.org/#!%7B%22dimensions%22:%7B%22x%22:%5B8e-9%2C%22m%22%5D%2C%22y%22:%5B8e-9%2C%22m%22%5D%2C%22z%22:%5B8e-9%2C%22m%22%5D%7D%2C%22position%22:%5B23575%2C20589%2C33089%5D%2C%22crossSectionOrientation%22:%5B-0.2594539225101471%2C0.13549424707889557%2C-0.00940671470016241%2C0.9561571478843689%5D%2C%22crossSectionScale%22:0.5352614285189903%2C%22projectionOrientation%22:%5B-0.6798036694526672%2C-0.5268529057502747%2C0.320065438747406%2C0.39730486273765564%5D%2C%22projectionScale%22:37552.75673405884%2C%22layers%22:%5B%7B%22type%22:%22image%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://flyem-vnc-2-26-213dba213ef26e094c16c860ae7f4be0/v3_emdata_clahe_xy/jpeg%22%7D%2C%22tab%22:%22source%22%2C%22blend%22:%22default%22%2C%22name%22:%22Grayscale%22%7D%2C%7B%22type%22:%22segmentation%22%2C%22source%22:%7B%22url%22:%22precomputed://gs://vnc-v3-seg-3d2f1c08fd4720848061f77362dc6c17/rc4_wsexp%22%7D%2C%22tab%22:%22annotations%22%2C%22skeletonRendering%22:%7B%22mode2d%22:%22lines_and_points%22%2C%22mode3d%22:%22lines%22%7D%2C%22name%22:%22Segmentation%22%7D%2C%7B%22type%22:%22annotation%22%2C%22source%22:%7B%22url%22:%22dvid://https://hemibrain-dvid2.janelia.org/36e0b/neuroglancer_todo?usertag=true&auth=https://hemibrain-dvid2.janelia.org/api/server/token%22%7D%2C%22tab%22:%22source%22%2C%22tool%22:%22annotatePoint%22%2C%22selectedAnnotation%22:%7B%22id%22:%2223575_20589_33089%22%2C%22subsource%22:%22default%22%7D%2C%22tableFilterByTime%22:%22all%22%2C%22tableFilterByUser%22:%22mine%22%2C%22name%22:%22Todo%22%7D%5D%2C%22showSlices%22:false%2C%22selectedLayer%22:%7B%22layer%22:%22Todo%22%2C%22visible%22:true%7D%2C%22layout%22:%224panel%22%7D"
  }
  if(isTRUE(length(ids)>0)) {
    ngl_segments(url) <- ids
  }

  if(return.json) {
    if(!requireNamespace("fafbseg", quietly = TRUE))
      stop("Please install suggested fafbseg package!")
    fafbseg::ngl_decode_scene(url, return.json = TRUE)
  } else url
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
manc_serverurl <- function(path, ...) {
  path = sprintf(path, ...)
  url = file.path(manc_server(), path, fsep = '/')
}
