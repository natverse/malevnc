# simple get request
manc_get <- function(path, ...) {
  u=manc_serverurl(path, ...)
  r=httr::GET(u)
  res=httr::stop_for_status(r)
  res2=httr::content(res, as='parsed', type='application/json')
  res2
}
