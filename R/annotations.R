#' Read point annotations from DVID using neuprint authentication
#'
#' @param email The google email address used to authenticate with neuprint
#' @param node The DVID node identifier
#' @param raw Whether to return the raw \code{httr::\link{GET}} response
#'   (default \code{FALSE}).
#' @param simplifyVector Whether to simplify lists to vectors (and data frames
#'   where appropriate). Default \code{TRUE}, see
#'   \code{jsonlite::\link{fromJSON}} for details.
#' @param neuprint_connection A \code{\link{neuprintr}} connection object
#'   returned by \code{neuprint_login}. This includes the required authorisation
#'   information to connect to DVID.
#' @param tz Time zone for edit timestamps. Defaults to "UTC" i.e. Universal
#'   Time, Coordinated. Set to "" for your current timezone. See
#'   \code{\link{as.POSIXct}} for more details.
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' \donttest{
#' df=manc_user_annotations()
#' head(df)
#' json=httr::content(manc_read_annotations(raw=TRUE))
#' }
manc_user_annotations <- function(email = "jefferis@gmail.com",
                                  node = "36e0b",
                                  raw = FALSE,
                                  neuprint_connection = NULL,
                                  tz="UTC") {
  if (is.null(neuprint_connection)) {
    if(!requireNamespace('neuprintr'))
      stop("Please install suggested package neuprintr!\n",
           'natmanager::install(pkgs="neuprintr")')
    neuprint_connection = neuprintr::neuprint_login(server = "https://neuprint.janelia.org")
    neuprint_connection$config
  }
  u = sprintf(
    # "https://hemibrain-dvid2.janelia.org/api/node/%s/neuroglancer_todo/tag/user:%s?app=Neuroglancer&u=%s",
    "https://hemibrain-dvid2.janelia.org/api/node/%s/neuroglancer_todo/tag/user:%s?app=Neuroglancer&u=%s",
    node,
    email,
    email
  )
  resp = httr::GET(u, config = neuprint_connection$config)
  httr::stop_for_status(resp)
  if(raw)
    return(resp)
  else {
    df=httr::content(resp, 'parsed', type='application/json', simplifyVector = T,flatten=T)
    names(df)=sub("Prop.","", names(df), fixed = T)
    df$timestamp=as.POSIXct(as.numeric(df$timestamp)/1e3,
                                 origin="1970-01-01", tz=tz)
    df
  }
}
