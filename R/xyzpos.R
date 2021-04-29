#' Find the bodyid for an XYZ location
#'
#' @param xyz location in raw pixels
#' @param node a DVID node
#' @param viafile whether to use a file to pass data to curl (expert use only)
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
#' library(fafbseg)
#' sc=manc_scene()
#' ngl_segments(sc) <- dups
#' }
manc_xyz2bodyid <- function(xyz, node = manc_dvid_node('neutu'), viafile=NA) {
  xyzmat=nat::xyzmatrix(xyz)
  if(!is.matrix(xyzmat) && is.numeric(xyzmat) && length(xyzmat)==3) {
    xyzmat=matrix(xyzmat, ncol=3)
  }
  xyzmat=round(xyzmat)
  mode(xyzmat)='integer'

  if(is.na(viafile))
    viafile=nrow(xyzmat)>4000

  if(viafile) {
    tf <- tempfile()
    on.exit(unlink(tf))
  }

  bodyj <- jsonlite::toJSON(xyzmat)
  url <- manc_serverurl('api/node/%s/segmentation/labels', node)
  if(viafile) {
    writeLines(bodyj, con=tf)
    cmd=sprintf('curl -X GET --silent --data-binary "@%s" %s', tf, url)
  } else {
    cmd=sprintf('curl -X GET --silent --data "%s" %s', bodyj, url)
  }
  res=system(cmd, intern=T)
  res2=jsonlite::fromJSON(res, simplifyVector = T)
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
