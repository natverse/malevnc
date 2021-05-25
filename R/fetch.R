# simple get request
manc_get <- function(path, urlargs=list(), as='parsed', ..., body=NULL) {
  u=manc_serverurl(path, urlargs=urlargs)
  if(!is.null(body))
    return(manc_get_body(u, body, as=as, ...))
  r=httr::GET(u)
  res=httr::stop_for_status(r)
  res2=httr::content(res, as=as, type='application/json', ...)
  res2
}

manc_get_body <- function(url, body, as='parsed', simplifyVector = T, ...) {
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
  if(as=='parsed')
    res2=jsonlite::fromJSON(res, simplifyVector = simplifyVector)
  else res
}
