#' Find the bodyid for an XYZ location
#'
#' @param xyz location in raw MANC pixels
#' @inheritParams manc_dvid_annotations
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
manc_xyz2bodyid <- function(xyz, node = 'neutu', cache=FALSE) {
  node=manc_nodespec(node, several.ok = F)
  if(isFALSE(nzchar(Sys.which('curl'))))
    stop("manc_xyz2bodyid currently requires the curl command line tool to be present in your path!")
  if(!is.matrix(xyz) && is.numeric(xyz) && length(xyz)==3) {
    xyz=matrix(xyz, ncol=3)
  }
  xyzmat=nat::xyzmatrix(xyz)
  xyzmat=round(xyzmat)
  mode(xyzmat)='integer'

  FUN=if(cache) manc_get_memo else manc_get
  res2=FUN('api/node/%s/segmentation/labels', body=xyzmat,
                urlargs=list(node), cache=cache)
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
