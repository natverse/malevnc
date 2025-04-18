#' Annotate an XYZ location in Clio as a soma or root
#'
#' @details You should use the tags in the following order of preference
#'   \describe{
#'
#'   \item{soma}{ If there is a visible soma, use this tag.}
#'
#'   \item{tosoma}{ If the soma is not in the dataset, but you know where it is,
#'   use this tag.}
#'
#'   \item{root}{ If you are not sure where the soma is, but you want to specify
#'   a position to act as the root e.g. skeletonising the neuron, use this tag.}
#'
#'   }
#'
#'   When annotating multiple points, you can provide either one user/tag or you
#'   must provide a user tag for every point.
#'
#' @param pos XYZ positions in any raw MANC voxel coordinates in any form
#'   compatible with \code{\link{xyzmatrix}}
#' @param tag One tag (or as many as there are points) to define the annotation.
#'   See details.
#' @param user One user (or as many users as there are points) to define the
#'   annotation. See details.
#' @param description Either \code{NULL}, one value or as any as there are
#'   points.
#' @param ... Additional arguments passed to \code{pbapply::\link{pbmapply}} and
#'   then to the private \code{clio_fetch} function.
#'
#' @export
#' @return the key for the new point annotation, invisibly
#'
#' @examples
#' \dontrun{
#' manc_annotate_soma(cbind(31180, 17731, 31252))
#' }
manc_annotate_soma <- function(pos, tag=c("soma", "tosoma", "root"), user=getOption("malevnc.clio_email"), description=NULL, ...) {
  if(is.null(user))
    stop("The soma annotation must be associated with a user email!\n",
         "It is worth setting the option:\n",
         "options(malevnc.clio_email='<user@gmail.com>')")
  pos=xyzmatrix(pos)
  pointlist=lapply(seq_len(nrow(pos)), function(i) pos[i,])
  if(missing(tag))
    tag=match.arg(tag, several.ok = FALSE)
  else
    tag=match.arg(tag, several.ok = TRUE)
  if(length(tag)!=1 && length(tag)!=length(pointlist))
    stop("Please provide either one tag or as many tags as there are points!")
  if(length(user)!=1 && length(user)!=length(pointlist))
    stop("Please provide either one user or as many users as there are points!")
  if(length(description)>1 && length(description)!=length(pointlist))
    stop("Please provide either one description or as many as there are points!")
  # work around limitation of pbmapply
  if(is.null(description)) description=list(NULL)
  res=pbapply::pbmapply(manc_annotate_point, pointlist,
                   tags=tag, user=user,
                   description = description, test=FALSE, ...)
  invisible(res)
}

manc_annotate_point <- function(pos, kind="point", tags=NULL, user=getOption("malevnc.clio_email"), description=NULL, protect=c('user'), update=TRUE, test=TRUE, ...) {
  dataset=getOption('malevnc.dataset', default = 'VNC')
  url=clio_url(path=glue("v2/annotations/{dataset}?replace={replace}{cond}",
                         replace=tolower(!update),
                         cond=ifelse(length(protect)>0,
                                     paste0("&conditional=",paste(protect, collapse = ',')))), test = test)
  pos=checkmate::assert_numeric(c(pos), len = 3)
  user=validate_email(user)
  body=list(kind="point",
            pos=c(pos),
            user=user)
  if(!is.null(tags)) body$tags=I(tags) # NB this means it will be a list)
  if(!is.null(description))
    body$description=description
  bodyj=jsonlite::toJSON(body, auto_unbox = TRUE)
  clio_fetch(url, body=bodyj, ...)
}


# extracts an int64 bodyid from a list
extract_int64_bodyid <- function(x, field="bodyid") {
  stopifnot(is.list(x) && !is.data.frame(x))
  # pre-allocate
  bodyids=rep(as.integer64(NA), length(x))
  # because sapply messes int64 class ...
  for(i in seq_along(x)) {
    bodyids[i]=x[[i]]$bodyid
  }
  bodyids
}

# see ?rlang::`dot-data`
utils::globalVariables(".data")

# Returns list with fields that are different from Clio
# annotations
#' @importFrom bit64 %in%
compute_clio_delta <- function(x, test=TRUE, write_empty_fields = FALSE) {
  body_ids <- extract_int64_bodyid(x)
  clio_annots <- manc_body_annotations(body_ids,
                                       update.bodyids = FALSE,
                                       test = test)
  if (length(clio_annots) == 0) return(x)
  clio_annots <- clio_annots %>% filter(!is.na(.data$bodyid))
  clio_annots$status <- NULL # not needed here
  # nothing to compare
  if (length(clio_annots) == 0) return(x)

  # nb making sure that we have 64 bit ids on each side
  diff_bodyids <- body_ids[!body_ids %in% manc_ids(clio_annots$bodyid, integer64 = T)]
  clio_annots <- clioannotationdf2list(clio_annots,
                                       write_empty_fields = write_empty_fields)
  # in case of missing body ids we add it to the list
  idxs=match(diff_bodyids, body_ids)
  if(any(is.na(idxs)))
    stop("Unable to find matches for some ids in annotation list")
  out_list=x[idxs]
  # check differences between fields of clio_annots and x
  delta_list <- lapply(clio_annots, function(from_cl) {
    idx <- match(from_cl$bodyid, body_ids)
    if(is.na(idx))
      stop("Unable to find a match for ", from_cl$bodyid, "in annotation list")
    to_cl <- x[[idx]]
    subset_to_cl <- lapply(names(to_cl), function(nm) {
      if (!(nm %in% names(from_cl)) ||
          # all.equal looks after length > 1 fields e.g. position
          !isTRUE(all.equal(to_cl[[nm]], from_cl[[nm]])))
        to_cl[[nm]]
      else
        NA
    })
    names(subset_to_cl) <- names(to_cl)
    subset_to_cl <- subset_to_cl[!is.na(subset_to_cl)]
    if (length(subset_to_cl) == 0)
      NA
    else {
      subset_to_cl['bodyid'] <- from_cl['bodyid']
      as.list(subset_to_cl)
    }
  })
  # remove empty lists
  delta_list <- delta_list[!is.na(delta_list)]
  out_list <- do.call(c, list(out_list, delta_list))
  out_list
}

# Returns default query list or extends the existing list
parse_query <- function(query, version) {
  default_query = list(version=clio_version(version))
  if (is.logical(query)) {
    if (isTRUE(query))
      query = default_query
    else
      query = NULL
  } else {
    if (!is.list(query))
      stop("query must be boolean or list.")
    default_query[names(query)] <- query
    query = default_query
  }
  query
}

#' Set Clio body annotations
#'
#' @details Clio body annotations are stored in a shared backend between DVID
#'   and Clio (aka neurojson). There are
#'   \href{https://clio-store-vwzoicitea-uk.a.run.app/docs#/default/post_annotations_v2_json_annotations__dataset__neurons_post}{API
#'   (Swagger) docs}.
#'
#'   Formerly they were in a \href{https://cloud.google.com/firestore}{Google
#'   Firestore} database. Further details are provided in
#'   \href{https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit}{basic
#'    docs from Bill Katz}. Each body has an associated JSON list containing a
#'   set of standard user visible fields. Some of these are constrained. See
#'   \href{https://docs.google.com/spreadsheets/d/1v8AltqyPCVNIC_m6gDNy6IDK10R6xcGkKWFxhmvCpCs/edit?usp=sharing}{Clio
#'    fields Google sheet} for details.
#'
#'   It can take some time to apply annotations, so requests are chunked by
#'   default in groups of 50.
#'
#'   A single column called \code{position} or 3 columns names x, y, z or X, Y,
#'   Z in any form accepted by \code{\link{xyzmatrix}} will be converted to a
#'   position stored with each record. This is recommended when creating
#'   records.
#'
#'   When \code{protect=TRUE} no data in Clio will be overwritten - only new
#'   data will be added. When \code{protect=FALSE} all fields will overwritten
#'   by new data for each non-empty value in \code{x}. If
#'   \code{write_empty_fields=TRUE} then even empty fields in \code{x} will
#'   overwrite fields in the database. Note that these conditions apply per
#'   record i.e. per neuron not per column of data.
#'
#' @section Validation: Validation depends on how you provide your input data.
#'   If \code{x} is a data.frame then each row is checked for some basics
#'   including the presence of a bodyid, and empty fields are removed. In future
#'   we will also check fields which are only allowed to take certain values.
#'
#'   When \code{x} is a character vector, it is checked to see that it is valid
#'   JSON and that there is a bodyid field for each record. This intended
#'   principally for developer use or to confirm that a specific JSON payload
#'   has been applied. You probably should not be using it regularly or for bulk
#'   upload.
#'
#'   When \code{x} is a list, no further validation occurs.
#'
#'   For these reasons, \bold{it is strongly recommended that end users provide
#'   \code{data.frame} input}.
#'
#' @section Users: Any modifications to columns in clio are associated with the
#'   email address that used to authenticate to Clio. This happens transparently
#'   with a \code{<field>_user} being added automatically when modifications are
#'   made via the front-end or API. For example the \code{type} field has a
#'   corresponding \code{type_user} field which can be displayed when
#'   \code{manc_body_annotations(show.extra='user')}.
#'
#'   If you want to upload annotations on someone else's behalf you can now
#'   specify a \code{designated_user}. This should be the email address
#'   registered with their Clio account.
#'
#'   Formerly only two fields collected information about changes, \code{user}
#'   and \code{last_modified_by}. These are now deprecated and should no longer
#'   be set. Related to this, the default value of protect has remained
#'   \code{"user"} to avoid modifying the \code{user} field until it is retired.
#'
#' @param x A data.frame, list or JSON string containing body annotations.
#'   \bold{End users are strongly recommended to use data.frames.}
#' @param version Optional clio version to associate with this annotation. The
#'   default \code{NULL} uses the current version returned by the API.
#' @param test Whether to use the test clio store (recommended until you are
#'   sure you know what you are doing).
#' @param designated_user Optional email address when one person is uploading
#'   annotations on behalf of another user. See \bold{Users} section for
#'   details.
#' @param protect Vector of fields that will not be overwritten if they already
#'   have a value in clio store. Set to \code{TRUE} to protect all fields and to
#'   \code{FALSE} to overwrite all fields for which you provide data. See
#'   details for the rationale behind the default value of "user"
#' @param write_empty_fields When \code{x} is a data.frame, this controls
#'   whether empty fields in \code{x} (i.e. \code{NA} or \code{""}) overwrite
#'   fields in the clio-store database (when they are not protected by the
#'   \code{protect} argument). The (conservative) default
#'   \code{write_empty_fields=FALSE} does not overwrite. If you do want to set
#'   fields to an empty value (usually the empty string) then you must set
#'   \code{write_empty_fields=TRUE}.
#' @param chunksize When you have many bodies to annotate the request will by
#'   default be sent 50 records at a time to avoid any issue with timeouts. You
#'   can increase for a small speed up if you find your setup is fast enough.
#'   Set to \code{Inf} to insist that all records are sent in a single request.
#'   \bold{NB only applies when \code{x} is a data.frame}.
#' @param query Special query to pass to Clio API. If TRUE, then the default is
#'   passed with Clio version, FALSE means no query, and list is allowed for a
#'   customized behaviour.
#' @param allow_new_fields Whether to allow creation of new clio fields. Default
#'   \code{FALSE} will produce an error encouraging you to check the field
#'   names.
#' @param ... Additional parameters passed to \code{pbapply::\link{pbsapply}}
#'
#' @return \code{NULL} invisibly on success. Errors out on failure.
#' @family manc-annotation
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # note use of test server
#' manc_annotate_body(data.frame(bodyid=10002, class='Descending Neuron',
#'   description='Giant Fiber'), test=TRUE)
#'
#' # if you give a list then you are responsible for validation
#' manc_annotate_body(list(bodyid=10002, class='Descending Neuron',
#'   description='Giant Fiber'), test=TRUE)
#'
#' # don't overwrite any fields in database
#' manc_annotate_body(list(bodyid=10002, class='Descending Neuron',
#'   description='Giant Fiber'), test=TRUE, protect=TRUE)
#'
#' # overwrite all fields in database except with empty values
#' manc_annotate_body(list(bodyid=10002, class='Descending Neuron',
#'   description='Giant Fiber'), test=TRUE, protect=FALSE)
#'
#' #' # overwrite all fields in database even if supplied data has empty values
#' manc_annotate_body(list(bodyid=10002, class='',
#'   description='Giant Fiber'), test=TRUE, protect=FALSE, write_empty_fields = TRUE)
#' }
manc_annotate_body <- function(x, test=TRUE, version=NULL,
                               write_empty_fields=FALSE,
                               allow_new_fields=FALSE,
                               designated_user=NULL,
                               protect=c("user"), chunksize=50, query=TRUE, ...) {
  query=parse_query(query, version=version)
  dataset=getOption('malevnc.dataset', default = 'VNC')
  u=clio_url(path=glue('v2/json-annotations/{dataset}/neurons'),
             test = test)
  if(!is.null(designated_user)) {
    u=glue("{u}?designated_user={designated_user}")
  }
  fafbseg:::check_package_available('purrr')
  if(!is.character(x)) {
    if(is.data.frame(x)) {
      cf=clio_fields()
      new_fields=setdiff(colnames(x), cf)
      if(isFALSE(allow_new_fields)) {
        if(length(new_fields)>0)
          stop("If you are sure you want to add new fields: \n    ",
               paste(new_fields, collapse = ', '),
               "\nafter appropriate discussion then please set `allow_new_fields=TRUE`")
      }
      x <- clioannotationdf2list(x, write_empty_fields = write_empty_fields)
      if (length(x) > 0)
        x <- compute_clio_delta(x, test = test, write_empty_fields = write_empty_fields)

      if(length(x)>chunksize) {
        chunknums=floor((seq_along(x)-1)/chunksize)+1
        chunkedx=split(x, chunknums)
        res=pbapply::pbsapply(chunkedx, manc_annotate_body, version=version,
                          test=test, chunksize=Inf, protect=protect, ...)
        return(invisible(res))
      }
    } else if(!is.list(x))
      stop("x should be a data.frame, list or JSON character vector!")

    fields=unique(unlist(purrr::map(x, names)))
    if(is.null(fields)) fields = names(x)
    x=jsonlite::toJSON(x, auto_unbox = T, null = 'null')
  } else {
    if(!jsonlite::validate(x))
      stop("Invalid JSON")
    df=jsonlite::fromJSON(x)
    if(is.null(df$bodyid) || !all(sapply(df$bodyid, is.finite)))
      stop("Input JSON must contain a bodyid field for each record!")
    fields=colnames(df)
  }
  # protect arg gives errors unless field is present in POST body
  protect <- if(isTRUE(protect)) fields else intersect(protect, fields)
  if(!isFALSE(protect) && length(protect)>0 ) {
    query[['conditional']]=paste(protect, collapse=",")
  }
  # final check
  first=substr(x, 1, 1)
  last=substr(x, nchar(x), nchar(x))
  if(!isTRUE(first %in% c("{","[")) || !isTRUE(last %in% c("}","]") ))
    stop("Annotations do not form a JSON list. Please verify!")
  res=clio_fetch(u, config=NULL, body = x, query=query, encode='raw',
                 httr::content_type_json())
  invisible(res)
}

clioannotationdf2list <- function(x, write_empty_fields=FALSE) {
  if(isFALSE('bodyid' %in% colnames(x)))
    stop("Your dataframe must contain a bodyid column")
  if(!all(fafbseg:::valid_id(x$bodyid)))
    stop("Your dataframe must contain valid bodyids for every row")
  x$bodyid=manc_ids(x$bodyid, integer64 = TRUE)

  # Handle any special fields

  # position as 3 cols rather than a single one
  xyzcols = c("x", "y", "z", "X", "Y", "Z")
  if(!"position" %in% colnames(x) &&
     isTRUE(sum(xyzcols %in% colnames(x))==3)){
    x[['position']]=xyzmatrix(x)
    x=x[setdiff(colnames(x), xyzcols)]
  }

  if("position" %in% colnames(x) && !all(is.na(x[['position']])) ) {
    px=x[['position']]
    if(is.character(px) || is.matrix(px)) {
      if(is.character(px))
        px=xyzmatrix(px)
      px=unname(px)
      checkmate::assert_matrix(px, nrows = nrow(x), ncols = 3,
                               mode = "numeric")
      x[['position']]=lapply(seq_len(nrow(px)), function(i) {
        pxmi=px[i,]
        if(any(is.na(pxmi))) list() else pxmi
      })
    } else if(is.list(px)) {
      # convert any matrices etc to vectors without names
      px=purrr::map(px, c)
      lens=sapply(px, length)
      if(!all(lens %in% c(0,3))) {
        stop("`position` column must contain 0 or 3 elements per entry")
      }
      # If we want to clear the position field we should send json []
      # x[['position']][lens==0]=list()
      for(i in which(lens==0)) px[[i]]=list()
      x[['position']]=px
    } else{
      stop("`position` must be a character vector or list with 3-vectors")
    }
  }

  # turns it into a list of lists
  i64cols=sapply(x, inherits, 'integer64')
  x=purrr::transpose(x)
  fix_bodyid <- function(x, cols='bodyid') {for(col in cols) class(x[[col]]) <-'integer64'; x}
  x=purrr::map(x, fix_bodyid, cols=which(i64cols))
  purge_empty <- function(x) purrr::keep(x, .p=function(x) length(x)>0 && !any(is.na(x)) && any(nzchar(x)))
  if(!write_empty_fields)
    x=purrr::map(x, purge_empty)
  # drop any empty records or (more plausibly) ones with just bodyid
  x=purrr::keep(x, function(y) length(y)>1)
  x
}
