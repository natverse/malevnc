#' Read point annotations from DVID using neuprint authentication
#'
#' @param email The google email address used to authenticate with neuprint
#' @param node The DVID node identifier
#' @param raw Whether to return the raw \code{httr::\link[httr]{GET}} response
#'   (default \code{FALSE}) so that you can process it yourself rather than a
#'   pre-processed R list.
#' @param simplifyVector Whether to simplify lists to vectors (and data frames
#'   where appropriate). Default \code{TRUE}, see
#'   \code{jsonlite::\link[jsonlite]{fromJSON}} for details.
#' @param neuprint_connection A \code{\link[neuprintr]{neuprintr}} connection
#'   object returned by \code{\link[neuprintr]{neuprint_login}}. This includes
#'   the required authorisation information to connect to DVID.
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
#' json=httr::content(manc_user_annotations(raw=TRUE))
#' }
manc_user_annotations <- function(email = "jefferis@gmail.com",
                                  node = 'clio',
                                  raw = FALSE,
                                  simplifyVector=TRUE,
                                  neuprint_connection = NULL,
                                  tz="UTC") {
  if (is.null(neuprint_connection)) {
    if(!requireNamespace('neuprintr'))
      stop("Please install suggested package neuprintr!\n",
           'natmanager::install(pkgs="neuprintr")')
    neuprint_connection = manc_neuprint()
    neuprint_connection$config
  }
  node=manc_nodespec(node, several.ok = F)
  u = manc_serverurl(
    "api/node/%s/neuroglancer_todo/tag/user:%s?app=natverse&u=%s",
    node,
    email,
    email
  )
  resp = httr::GET(u, config = neuprint_connection$config)
  httr::stop_for_status(resp)
  if(raw)
    return(resp)
  else {
    df=httr::content(resp, 'parsed', type='application/json', simplifyVector = simplifyVector, flatten=T)
    names(df)=sub("Prop.","", names(df), fixed = T)
    df$timestamp=as.POSIXct(as.numeric(df$timestamp)/1e3,
                                 origin="1970-01-01", tz=tz)
    df
  }
}

list2df <- function(x, points=c('collapse', 'expand', 'list'),
                    lists=c("collapse", "list"), collapse=",", ...) {
  points=match.arg(points)
  lists=match.arg(lists)
  cns=unique(unlist(sapply(x, names, simplify = F)))

  collapse_col <- function(col) sapply(col, paste, collapse=collapse)
  l=list()
  for(i in cns) {
    raw_col = lapply(x, "[[", i)
    raw_col[sapply(raw_col, is.null)]=NA
    sublens=sapply(raw_col, length)
    if(all(sublens==1)){
      raw_col=unlist(raw_col, use.names = FALSE)
    } else if(grepl("^point", i) && all(sublens==3L)) {
      if(points=='expand') {
        raw_col=lapply(1:3, function(j) sapply(raw_col, "[[", j))
        names(raw_col) <- paste0(i, c("X","Y","Z"))
        l[names(raw_col)]=raw_col
        next
      } else if(points=='collapse')
        raw_col=collapse_col(raw_col)
    } else if(lists=='collapse')
      raw_col=collapse_col(raw_col)

    l[[i]]=raw_col
  }
  # l
  tibble::as_tibble(l, ...)
}


#' Return all DVID body annotations
#' @details See
#'   \href{https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1619201195032400}{this
#'    Slack post} from Stuart Berg for details.
#'
#'   Note that the original api call was \code{<rootuuid>:master}, but I have
#'   now just changed this to \code{<neutu-uuid>} as returned by
#'   \code{\link{manc_dvid_node}}. This was because the range query stopped
#'   working 16 May 2021, probably because of a bad node.
#' @inheritParams manc_body_annotations
#' @param rval Whether to return a fully parsed data.frame (the default) or an R
#'   list. The data.frame is easier to work with but typically includes NAs for
#'   many values that would be missing in the list.
#' @param node A DVID node as returned by \code{\link{manc_dvid_node}}. The
#'   default is to return the current active (unlocked) node being used through
#'   neutu.
#' @param cache Whether to cache the result of this call for 5 minutes.
#' @param columns_show Whether to show all columns, or just with '_user', or '_time'
#' suffix.
#'
#' @return A \code{tibble} containing with columns including \itemize{
#'
#'   \item bodyid as a \code{numeric} value
#'
#'   \item status
#'
#'   \item user
#'
#'   \item naming_user
#'
#'   \item instance
#'
#'   \item status_user
#'
#'   \item comment }
#'
#'   NB only one \code{bodyid} is used regardless of whether the key-value
#'   returned has 0, 1 or 2 bodyid fields. When the \code{ids} are specified,
#'   missing ids will have a row containing the \code{bodyid} in question and
#'   then all other columns will be \code{NA}.
#'
#' @export
#'
#' @examples
#' \donttest{
#' mdf=manc_dvid_annotations()
#' head(mdf)
#' table(mdf$status)
#'
#' manc_dvid_annotations('Giant Fiber')
#'
#' \dontrun{
#' # compare live body annotations with version in clio
#' mdf.clio=manc_dvid_annotations('clio')
#' waldo::compare(mdf.clio, mdf)
#' }
#' }
manc_dvid_annotations <- function(ids=NULL, node='neutu',
                                  rval=c("data.frame", "list"),
                                  columns_show = NULL,
                                  cache=FALSE) {
  rval=match.arg(rval)
  if(!is.null(ids)) {
    if(rval!='data.frame')
      stop("You can only request a data.frame when specifying ids!")
    ids=manc_ids(ids, mustWork = T, unique=FALSE, as_character = F)
  }
  node=manc_nodespec(node, several.ok = F)
  mda <- if(cache) manc_dvid_annotations_memo(node=node, rval=rval)
  else .manc_dvid_annotations(node=node, rval=rval, show = columns_show)
  if(is.null(ids)) mda
  else {
    mda=mda[match(ids,mda$bodyid),,drop=F]
    # for the cases where there are no matching ids
    mda$bodyid=ids
    mda
  }
}

.manc_dvid_annotations <- function(node, rval, show = NULL) {
  path="api/node/%s/segmentation_annotations/keyrangevalues/0/Z?json=true"
  d=manc_get(path, urlargs = list(node), show = show,
             as = 'parsed', simplifyVector = F)
  df=list2df(d)
  df$bodyid=as.numeric(names(d))
  df[['body ID']]=NULL
  df=dplyr::select(df, 'bodyid', dplyr::everything())
  attr(df, 'dvid_node')=node
  df
}

manc_dvid_annotations_memo <- memoise::memoise(.manc_dvid_annotations,
                                               ~memoise::timeout(5*60))

#' Return clio-store body annotations for set of ids or a flexible query
#'
#' @details Missing values in each output column are filled with NA. But if a
#'   whole column is missing from the results of a particular query then it will
#'   not appear at all.
#'
#'   When neither \code{query} and \code{ids} are missing then we return all
#'   entries in the clio store database. This currently includes annotations for
#'   all body ids - even the ones that are no longer current.
#' @inheritParams manc_connection_table
#' @param query A json query string (see examples or documentation) or an R list
#'   with field names as elements.
#' @param update.bodyids Whether to update the bodyid associated with
#'   annotations based on the position field. The default value of this has been
#'   switched to \code{FALSE} as of Feb 2022.
#' @param config An optional httr::config (expert use only, must include a
#'   bearer token)
#' @param json Whether to return unparsed JSON rather than an R list (default
#'   \code{FALSE}).
#' @param test Whether to unset the clio-store test server (default
#'   \code{FALSE})
#' @param ... Additional arguments passed to \code{pbapply::\link{pblapply}}
#' @inheritParams manc_dvid_annotations
#' @return An R data.frame or a character vector containing JSON (when
#'   \code{json=TRUE}). Two additional fields will be added \itemize{
#'
#'   \item original.bodyid When \code{update.bodyids=TRUE} this field contains
#'   the original bodyid from Clio whereas \code{bodyid} contains the updated
#'   value implied by the position.
#'
#'   \item \code{auto} \code{TRUE} signals that the record contains only data
#'   automatically copied over from DVID without any manual annotation.
#'
#'   See
#'   \href{https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1628214375055400}{slack}
#'    for details of the position / position type fields. }
#' @export
#'
#' @family manc-annotation
#' @seealso
#' \href{https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit}{basic
#' docs from Bill Katz}.
#' @examples
#' \dontrun{
#' manc_body_annotations(ids=11442)
#' manc_body_annotations(query='{"hemilineage": "0B"}')
#' manc_body_annotations(query=list(user="janedoe@gmail.com"))
#' manc_body_annotations(query=list(soma_side="RHS"))
#' manc_body_annotations(ids=manc_xyz2bodyid(mancneckseeds))
#' # use clio node to ensure for bodyid consistency
#' manc_body_annotations(ids=
#'   manc_xyz2bodyid(mancneckseeds, node="clio"))
#'
#' # fetch all bodyids
#' mba=manc_body_annotations()
#' }
manc_body_annotations <- function(ids=NULL, query=NULL, json=FALSE, config=NULL,
                                  cache=FALSE, update.bodyids=FALSE, test=FALSE, ...) {
  dataset=getOption('malevnc.dataset', default = 'VNC')
  baseurl=clio_url(glue("v2/json-annotations/{dataset}/neurons"),
                   test=test)
  nmissing=sum(is.null(ids), is.null(query))
  FUN=if(cache) clio_fetch_memo else clio_fetch
  if(nmissing==2) {
    # fetch all annotations
    res=FUN(file.path(baseurl, 'all'), config = config, json = json)
    if(is.list(res$bodyid)) {
      lengths=sapply(res$bodyid, length)
      nbadlengths=sum(lengths!=1)
      if(nbadlengths>0) {
        warning("Dropping ", nbadlengths, " rows with bad ids in manc_body_annotations!")
        res=res[lengths==1,]
      }
      res$bodyid=unlist(res$bodyid, use.names = F)
    }
    res=updatebodyids(res, update.bodyids, cache = cache)
    return(res)
  } else if(nmissing!=1)
    stop("you can only provide one of `ids` or `query` as input!")

  if(!is.null(ids)) {
    ids=manc_ids(ids)
    if(length(ids)>1000 && !json) {
      # it's quicker to fetch all and then filter post hoc
      # but we can't do that with json
      mba=manc_body_annotations(cache=cache, config=config, update.bodyids=update.bodyids, test=test, ...)
      res=mba[match(ids, mba$bodyid),,drop=F]
      return(res)
    } else {
      chunksize=1000
      if(length(ids)>chunksize && !json) {
        chunknums=floor((seq_along(ids)-1)/chunksize)+1
        chunkedids=split(ids, chunknums)
        res=pbapply::pblapply(chunkedids, manc_body_annotations, json=json,
                              config=config, cache=cache, test=test,
                              update.bodyids=update.bodyids, ...)
        return(dplyr::bind_rows(res))
      }
      if(length(ids)>1)
        ids=paste(ids, collapse = ',')
      u=sprintf("%s/id-number/%s", baseurl, ids)
      body=NULL
    }
  } else {
    u=sprintf("%s/query", baseurl)
    body <- if(is.list(query))
      jsonlite::toJSON(query, auto_unbox = TRUE)
    else {
      if(!isTRUE(jsonlite::validate(query)))
        stop("Query is not valid JSON!")
      query
    }
  }

  res=FUN(
    u,
    body = body,
    query = list(changes = "false", id_field = "bodyid"),
    config = config,
    json = json
  )
  updatebodyids(res, update=update.bodyids, cache = cache)
}

# update can be T/F or a bodyid
updatebodyids <- function(x, update=TRUE, cache=FALSE, add_auto=TRUE) {
  # first figure out if this is an "auto" entry without any manually entered
  # information
  if(add_auto && isTRUE(nrow(x)>0)) {
    manualfields=setdiff(colnames(x), c("bodyid", "status", "old_bodyids",
                                        "position", "position_type"))
    if(length(manualfields)==0) {
      # there are no manual columns, so all records are automatic
      x$auto=TRUE
    } else {
      empty_field <- function(x) {
        res = lapply(1:ncol(x), function(ny) {
           y = x[,ny]
           if(is.list(y)) is.na(y) | lengths(y)==0 else is.na(y)
         })
        names(res) <- colnames(x)
        as.data.frame(res)
      }
      rs=rowSums(empty_field(x[, manualfields, drop=F]))
      x$auto=rs==length(manualfields)
    }
  }

  # we can't do anything if we don't have position info
  if(isFALSE(update) || !isTRUE("position" %in% names(x)))
    return(x)
  if(!is.data.frame(x) || (!"bodyid" %in% colnames(x)))
    stop("Must have a data.frame with a bodyid column!")
  node <- manc_dvid_node(ifelse(isTRUE(update), 'neutu', update))

  xyz=xyzmatrix(x$position)
  goodpos=!is.na(xyz[,1])
  x$original.bodyid=x$bodyid
  x$bodyid[goodpos]=manc_xyz2bodyid(x$position[goodpos], cache = cache, node = node)
  x
}


#' Return point annotations from Clio store
#'
#' @details There is an optional 5 minute cache of these lookups (recreated for
#'   each new R session). The location of each point annotation will by default
#'   be found using the \code{\link{manc_xyz2bodyid}} function; this will also
#'   be cached when \code{cache=TRUE}. The default node for these lookups is
#'   Clio i.e. you will get the bodyid reported in Clio. You can also choose to
#'   lookup the id for any DVID node, by specifying e.g. \code{node='neutu'} to
#'   get the absolute latest node. Of course in theory bodyids with Clio
#'   annotations should not be changing ...
#'
#'   Note that under the hood this uses the \code{malevnc.dataset} option to
#'   define the set of annotations to query. You should not normally be setting
#'   this option yourself, but it does allow the same functions to repurposed
#'   for other datasets e.g. CNS.
#'
#' @param groups Defines a group for which we would like to see all annotations.
#'   When NULL, only returns annotations for your own user.
#' @param bodyid Whether or not to compute the current bodyid from the location
#'   of the point annotation using \code{\link{manc_xyz2bodyid}} (defaults to
#'   \code{TRUE}).
#' @param test Whether to use the testing clio store database (useful when
#'   trying out new code).
#' @inheritParams manc_xyz2bodyid
#'
#' @family manc-annotation
#' @return A data.frame of annotations
#' @export
#'
#' @examples
#' \dontrun{
#' mpa=manc_point_annotations()
#' head(mpa)
#' # get absolutely latest bodyids
#' head(manc_point_annotations(node='neutu'))
#' }
manc_point_annotations <- function(groups="UK Drosophila Connectomics", cache=FALSE,
                                   bodyid=TRUE, node='clio', test=FALSE) {

  dataset=getOption('malevnc.dataset', default = 'VNC')
  u=clio_url(glue("v2/annotations/{dataset}"), test = test)

  if(!is.null(groups)) {
    groups=gsub(" ", "+", groups)
    u=paste0(u, "?groups=", groups)
  }
  res <- if(cache) clio_fetch_memo(u) else clio_fetch(u)
  if(!is.null(res$prop$timestamp)) {
    res$timestamp=as.POSIXct(as.numeric(res$prop$timestamp)/1e3, origin="1970-01-01", tz="UTC")
  }
  res=res[setdiff(names(res), "prop")]
  if(isTRUE(bodyid))
    res$bodyid=manc_xyz2bodyid(res$pos, cache=cache, node=node)
  res
}

#' Return full metadata from Clio/DVID for MANC bodyids (cached by default)
#'
#' @details This function will the latest per bodyid metadata using
#'   \code{\link{manc_dvid_annotations}} and
#'   \code{\link{manc_body_annotations}}. Since obtaining this information can
#'   take 5-10s even for a single id, it is by default cached with a 5 min
#'   timeout. The second call for the same request should be more or less
#'   instantaneous, while a different set of ids should still return much
#'   faster. Annotations are returned for the 'neutu' i.e. latest DVID node by
#'   default.
#'
#' @param ids bodyids specified in any form accepted by \code{\link{manc_ids}}
#' @param unique Whether to remove any duplicate ids from the results.
#' @param cache Whether to use a cache with a 5 min lifetime, default
#'   \code{TRUE}.
#' @inheritParams manc_body_annotations
#' @inheritParams manc_xyz2bodyid
#' @export
#' @family manc-annotation
#'
#' @return A data.frame with columns determined by
#'   \code{\link{manc_dvid_annotations}} and
#'   \code{\link{manc_body_annotations}}. All columns from
#'   \code{manc_dvid_annotations} will have the prefix \code{dvid_} (except for
#'   the single \code{bodyid} column). In addition a column \code{dvid_group}
#'   will be generated by parsing the \code{dvid_instance} column. This will
#'   have more up to date LR match information than the clio \code{group} field.
#'
#' @examples
#' \dontrun{
#' manc_meta('Giant Fiber')
#' manc_meta(10002)
#' }
manc_meta <- function(ids=NULL, cache=TRUE, unique=FALSE, node='neutu', update.bodyids=FALSE) {
  mda=manc_dvid_annotations(ids = ids, cache=cache, node=node)
  cols2rename=colnames(mda)!='bodyid'
  colnames(mda)[cols2rename]=paste0("dvid_", colnames(mda)[cols2rename])
  if(isTRUE(update.bodyids)) update.bodyids=node
  mba=manc_body_annotations(ids, cache=cache, update.bodyids = update.bodyids)
  # prefer DVID annotations when dup columns exist
  # mba=mba[union("bodyid", setdiff(colnames(mba), colnames(mda)))]
  m <- if(isTRUE(nrow(mba)>0))
    merge(mda, mba, by='bodyid', sort = FALSE, all.x = T, all.y = T)
  else mda
  m$bodyid=manc_ids(m$bodyid, as_character = T) # to be sure
  if(!is.null(ids)) {
    df=data.frame(bodyid=manc_ids(ids, unique=unique, as_character = T))
    m=dplyr::left_join(df,m, by='bodyid')
  }
  m$dvid_group=stringr::str_match(m$dvid_instance, "^([0-9]{5,})_[LRU]")[,2]
  m
}
