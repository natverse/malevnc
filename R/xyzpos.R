#' Find the bodyid for an XYZ location
#'
#' @param xyz location in raw pixels
#' @param node a DVID node
#'
#' @return A character vector of body ids
#' @export
#'
#' @examples
#' ids=manc_xyz2bodyid(mancneckseeds)
#' tids=table(ids)
#' # are there many duplicate ids
#' table(tids)
#'
#' dups=names(tids[tids>1])
#' \dontrun{
#' manc_scene(ids=dups)
#' }
manc_xyz2bodyid <- function(xyz, node = manc_dvid_node('neutu')) {
  if(isFALSE(nzchar(Sys.which('curl'))))
    stop("manc_xyz2bodyid currently requires the curl command line tool to be present in your path!")
  if(!is.matrix(xyz) && is.numeric(xyz) && length(xyz)==3) {
    xyz=matrix(xyz, ncol=3)
  }
  xyzmat=nat::xyzmatrix(xyz)
  xyzmat=round(xyzmat)
  mode(xyzmat)='integer'

  res2=manc_get('api/node/%s/segmentation/labels', body=xyzmat, node)
  res2
}


## for historic interest
manc_xyz2bodyid.single <- function(xyz, node=manc_dvid_node('neutu'), ...){

  get_bodyid <- function(xyz, ...){
    url=manc_serverurl('api/node/%s/segmentation/label/%s_%s_%s',
                     node, xyz[1], xyz[2], xyz[3])
    resp=httr::GET(url, ...)
    httr::stop_for_status(resp)
    r=httr::content(resp, as='parsed', type='application/json', encoding = 'UTF-8')
    r$Label
  }
  if(is.vector(xyz)){
    get_bodyid(xyz=xyz, ...)
  }else if (is.matrix(xyz)){
    pbapply::pbapply(xyz, 1, get_bodyid, ...)
  } else if (is.data.frame(xyz)){
    xyz = nat::xyzmatrix(xyz)
    pbapply::pbapply(xyz, 1, get_bodyid, ...)
  }
}

# unfinished experiments with curl
# manc_xyz2bodyids <- function(xyz, node=manc_dvid_node('clio')) {
#   xyzmat=nat::xyzmatrix(xyz)
#   bodyj <- jsonlite::toJSON(xyzmat)
#   url <- manc_serverurl('api/node/%s/segmentation/labels', node)
#   h <- curl::new_handle()
#   curl::handle_setopt(h, .list = list(customrequest = "GET"))
#   curl::handle_setform(h, data=as.character(bodyj))
#   r <- curl::curl_fetch_memory(url, h)
#   r
# }