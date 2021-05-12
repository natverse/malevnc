# simple get request
manc_get <- function(path, body=NULL, ...) {
  u=manc_serverurl(path, ...)
  if(!is.null(body))
    return(manc_get_body(u, body, ...))
  r=httr::GET(u)
  res=httr::stop_for_status(r)
  res2=httr::content(res, as='parsed', type='application/json')
  res2
}

manc_get_body <- function(url, body, ...) {
  bodyj <- if(is.character(body)) body else jsonlite::toJSON(body)
  viafile=nchar(bodyj)>10000
  if(viafile) {
    tf <- tempfile()
    on.exit(unlink(tf))
    writeLines(bodyj, con=tf)
    cmd=sprintf('curl -X GET --silent --data-binary "@%s" %s', tf, url)
  } else {
    cmd=sprintf('curl -X GET --silent --data "%s" %s', bodyj, url)
  }
  res=system(cmd, intern=T)
  res2=jsonlite::fromJSON(res, simplifyVector = T)
}
