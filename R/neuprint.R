#' Login to MANC neuprint server
#'
#' @param server A neuprint server (a sensible default should be chosen)
#' @param dataset A neuprint dataset (a sensible default should be chosen based
#'   on which dataset has been specified for Clio/DVID)
#' @param token neuprint authorisation token obtained e.g. from
#'   neuprint.janelia.org website.
#' @param ... Additional arguments passed to \code{\link{neuprint_login}}
#'
#' @return a \code{\link{neuprint_connection}} object returned by
#'   \code{\link{neuprint_login}}
#' @export
#' @family manc-neuprint
#' @examples
#' \donttest{
#' vncc=manc_neuprint()
#' anchorids <- neuprintr::neuprint_ids("status:Anchor", conn=vncc)
#' # the last connection will be used by default
#' anchormeta <- neuprintr::neuprint_get_meta("status:Anchor")
#'
#' plot(cumsum(sort(anchormeta$pre, decreasing = TRUE)), ylab='Cumulative presynapses')
#' plot(cumsum(sort(anchormeta$post, decreasing = TRUE)), ylab='Cumulative postsynapses')
#' }
#' @importFrom neuprintr neuprint_login
manc_neuprint <- function(server = getOption('malevnc.neuprint'),
                          dataset = getOption('malevnc.neuprint_dataset'),
                          token = Sys.getenv("neuprint_token"),
                          ...) {
  neuprint_login(
    server=server,
    dataset=dataset,
    token=token,
    ...
  )
}


is.url <- function(x) {
  grepl("^http[s]{0,1}://[^.]{1,}\\.[^.]{2,}", x, perl = TRUE)
}

#' Flexible specification of manc body ids
#'
#' @description \code{manc_ids} provides a convenient way to extract body ids
#'   from a variety of objects as well as allowing text searches against
#'   type/instance information defined in neuprint.
#'
#' @param x A vector of body ids, data.frame (containing a bodyid column) or a
#'   neuroglancer URL.
#' @param integer64 whether to return ids with class bit64::integer64.
#' @inheritParams neuprintr::neuprint_ids
#' @inheritParams fafbseg::ngl_segments
#' @export
#' @family manc-neuprint
#' @seealso \code{\link{neuprint_ids}}
#' @examples
#' \donttest{
#' # search by type
#' manc_ids("DNp01")
#' # You can also do more complex queries using regular expressions
#' # introduced by a slash and specifying the field to be searched
#' dns=manc_ids("/type:DN.+")
#'
#' # you can also use Neo4J cypher queries by using the where: prefix
#' # note that each field of the neuron must prefixed with "n."
#' bignogroupids <-
#'   manc_ids("where:NOT exists(n.group) AND n.synweight>5000 AND n.class CONTAINS 'neuron'")
#' \dontrun{
#' # Finally you can use the same queries wherever you specify body ids
#' # NB if you want to be sure that regular neuprintr functions target
#' # the VNC dataset, use conn=manc_neuprint()
#' lrpairs.meta=neuprintr::neuprint_get_meta("/name:[0-9]{5,}_[LR]", conn=manc_neuprint())
#' }
#' }
#' @importFrom bit64 is.integer64 as.integer64
manc_ids <- function(x, mustWork=TRUE, as_character=TRUE, integer64=FALSE,
                     unique=TRUE, conn=manc_neuprint(), ...) {
  ids <- if(fafbseg:::is.ngscene(x) || (length(x)==1 && is.url(x)))
    fafbseg::ngl_segments(x, must_work = mustWork, as_character = as_character, ...)
  else if(!is.integer64(x)){
    # nb if we have integer64 input they must already be ids
    # so no need to send to neuprint
    neuprintr::neuprint_ids(x=x, conn=conn, mustWork = mustWork, unique=unique, ...)
  } else if(unique) unique(x) else x
  if(is.data.frame(x) && length(ids)!=nrow(x))
    stop("Unable to extract a vector of ",nrow(x), " body ids from x!")
  if(isTRUE(integer64)) as.integer64(ids)
  else if(as_character) as.character(ids)
  else as.numeric(ids)
}

#' Convenience wrapper for neuprint connection queries for VNC dataset
#'
#' @param ids A set of body ids in any form understandable to
#'   \code{\link{manc_ids}}
#' @param partners Either inputs or outputs. Redundant with \code{prepost}, but
#'   probably clearer.
#' @param conn Optional, a \code{\link{neuprint_connection}} object, which also
#'   specifies the neuPrint server. Defaults to \code{\link{manc_neuprint}()} to
#'   ensure that query is against the VNC dataset.
#' @param moredetails Whether to include additional metadata information such as
#'   hemilineage, side etc. Can take one of the values \code{c('minimal',
#'   'recommended', 'neuprint', 'all')}. In addition \code{TRUE} is a synonym
#'   for \code{'neuprint'} and \code{F} is a synonym for \code{'minimal'}.
#' @param ... additional arguments passed to
#'   \code{\link{neuprint_connection_table}}
#' @inheritParams neuprintr::neuprint_connection_table
#'
#' @return see \code{\link{neuprint_connection_table}}
#' @export
#' @family manc-neuprint
#' @examples
#' \donttest{
#' down=manc_connection_table("DNp01", partners='outputs')
#' \dontrun{
#' manc_scene(down$partner[1:8], open=TRUE)
#' }
#' }
manc_connection_table <- function(ids, partners=c("inputs", "outputs"),
                                  prepost = c("PRE", "POST"),
                                  moredetails="recommended",
                                  conn=manc_neuprint(), ...) {
  if(!missing(partners)) {
    partners=match.arg(partners)
    prepost=ifelse(partners=='inputs', "PRE", "POST")
  }
  ids=manc_ids(ids, conn=conn)
  res=neuprintr::neuprint_connection_table(ids, prepost = prepost, details=T, conn=conn, ...)
  res$partner=manc_ids(res$partner, unique=FALSE)
  if(is.na(moredetails))
    moredetails='recommended'
  if(is.logical(moredetails))
    moredetails=ifelse(moredetails, 'neuprint', 'minimal')
  moredetails=match.arg(moredetails, c("all", 'neuprint', 'minimal', 'recommended'))
  if(moredetails=='all') {
    details=manc_meta(res$partner, unique = F)
    stopifnot(all(res$partner==details$bodyid))
    res=cbind(res, details[setdiff(colnames(details), "bodyid")])
  } else if (moredetails!='minimal'){
    details=manc_neuprint_meta(unique(res$partner), conn=conn)
    if(moredetails=='recommended'){
      # details$predictedNtProb=round(details$predictedNtProb, 3)
      details=details[c("bodyid", "class", "group", "serial", "somaSide", "somaNeuromere", "hemilineage", "predictedNt", "predictedNtProb", "subclass")]
    }
    res=dplyr::left_join(res, details[c("bodyid", setdiff(colnames(details), colnames(res)))],
          by=c('partner'='bodyid'))
  }
  res
}

add_top_nt <- function(x, nts=c("acetylcholine","gaba","glutamate","neither")) {
  if(!all(nts %in% colnames(x)))
    return(x)

  top.col=max.col(x[nts], ties.method = "first")
  clean_nts=sub(".+\\.","", nts)
  x[,'top.nt']=factor(clean_nts[top.col])
  x[,'top.p']=do.call(pmax, as.list(x[nts]))
  x
}


#' Read MANC skeletons via neuprint
#'
#' @details \code{manc_read_neurons} fetches metadata from neuprint but does not
#'   fetch synapse locations by default as this is very time consuming.
#'
#' @inheritParams manc_connection_table
#' @inheritParams neuprintr::neuprint_read_neurons
#' @param ... Additional arguments passed to
#'   \code{neuprintr::\link{neuprint_read_neurons}}.
#'
#' @return A \code{\link{neuronlist}} with attached metadata
#' @export
#' @importFrom nat `data.frame<-`
#' @examples
#' \dontrun{
#' gfs=manc_read_neurons("DNp01")
#' gfs[,]
#' }
manc_read_neurons <- function(ids, connectors=FALSE, heal.threshold=Inf, conn=manc_neuprint(), ...) {
  ids=manc_ids(ids, conn=conn, as_character = T)
  nl=neuprintr::neuprint_read_neurons(ids, meta = F, connectors = connectors,
                                   heal.threshold=heal.threshold, conn=conn, ...)
  # we're fetching the metadata ourselves because of some wrinkles with
  # 1. missing metadata
  # 2. numeric ids that do not correctly format with as.character
  metadf=manc_neuprint_meta(names(nl), conn=conn)
  rownames(metadf)=metadf$bodyid
  data.frame(nl) <- metadf
  nl
}


#' Fetch neuprint metadata for MANC neurons
#'
#' @inheritParams manc_connection_table
#' @param roiInfo whether to include the \code{roiInfo} field detailing synapse
#'   numbers in different locations. This is omitted by default as it is
#'   returned as a character vector of unprocessed JSON.
#' @param fields.regex.exclude,fields.regex.include Optional regular expressions
#'   to define fields to include or exclude from the returned metadata.
#' @param ... Additional arguments passed to \code{\link{neuprint_get_meta}}
#' @return A data.frame with one row for each (unique) id and NAs for all
#'   columns except bodyid when neuprint holds no metadata.
#' @export
#' @seealso \code{\link{manc_ids}}
#'
#' @examples
#' \donttest{
#' manc_neuprint_meta("DNp01")
#'
#' # use of a full CYPHER query. NB Each field relating to the neuron must be
#' # be preceded by "n."
#' bignogroup <-
#'   manc_neuprint_meta("where:NOT exists(n.group) AND n.synweight>5000 AND n.class CONTAINS 'neuron'")
#' head(bignogroup)
#' }
manc_neuprint_meta <- function(ids=NULL, conn=manc_neuprint(), roiInfo=FALSE, fields.regex.exclude=NULL, fields.regex.include=NULL, ...) {
  if(is.null(ids))
    ids=manc_dvid_annotations(cache=T)
  ids=manc_ids(ids, integer64=T)
  fields=mnp_fields(conn=conn)
  if(!isTRUE(roiInfo))
    fields=setdiff(fields, "roiInfo")
  metadf=neuprintr::neuprint_get_meta(ids, conn=conn, possibleFields=fields, ...)
  metadf$bodyid=as.integer64(metadf$bodyid)
  dfids=data.frame(bodyid=ids)
  fixeddf=dplyr::left_join(dfids, metadf, by='bodyid')
  # convert to character to handle larger than maxint *and* 100,000
  # which formats to 1e+5 when numeric
  fixeddf$bodyid=as.character(fixeddf$bodyid)
  fixeddf <- add_top_nt(fixeddf)
  fixeddf
}

mnp_fields <- memoise::memoise(function(conn=manc_neuprint(), regex.exclude=NULL, regex.include=NULL) {
  allfields=neuprintr::neuprint_get_fields("", negateFields = T, conn=conn)
  if(is.null(regex.include))
    regex.include="^[a-z]{2}"
  if(!is.null(regex.include))
    allfields=grep(regex.include, allfields, value = T)
  if(!is.null(regex.exclude))
    allfields=grep(regex.exclude, allfields, value = T, invert = T)
  allfields
})

manc_download_swcs <- function(ids, outdir, node='neutu', df=NULL, OmitFailures=T, Force=FALSE, ...) {
  ids=manc_ids(ids, unique=T)
  urls=manc_serverurl("/api/node/%s/segmentation_skeletons/key/%s_swc",
                      manc_nodespec(node), ids)
  if(!file.exists(outdir))
    dir.create(outdir)
  destfiles=file.path(outdir, paste0(ids, ".swc"))
  # pbapply::pbmapply(curl::curl_download, urls, destfiles, MoreArgs = ...)
  fakenl=nat::as.neuronlist(seq_along(urls))
  downloadfun <- function(i, ourforce=Force, ...) {
    df=destfiles[i]
    if(!ourforce && file.exists(df))
      return(NA_character_)
    curl::curl_download(urls[i], destfile = df, ...)
    df
  }
  nl <- nat::nlapply(fakenl, downloadfun, OmitFailures=OmitFailures, ...)
  unlist(nl)
}


swc2mutids <- function(ff) {
  if(length(ff)==1 && isTRUE(file.info(ff)$isdir))
    ff=dir(ff, pattern = 'swc$', full.names = T)
  readl3 <- function(x) {
    tryCatch(readLines(x, n=3)[3], error=function(e) {
      warning(e)
      NA_character_
    })
  }
  l3=sapply(ff, readl3)
  mids=stringr::str_match(l3, "(mutation id).*?(\\d+)")[,3]
  mids
}
