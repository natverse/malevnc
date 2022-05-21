# see https://gargle.r-lib.org/articles/gargle-auth-in-client-package.html

.auth <- gargle::init_AuthState(
  package     = "malevnc",
  auth_active = TRUE
)

.authinfo <- new.env()

#' Clio authorisation infrastructure using Google via the gargle package + JWT
#'
#' @details Clio store authorisation is a multi step process. You must first
#'   authenticate to Google who will return a token confirming your identity;
#'   this token only lasts ~30m. This Google token is then presented to a clio
#'   store endpoint to generate a long lived clio token, which is cached on disk
#'   (for up to 3 weeks at the time of writing). You can also specify a token
#'   via the \code{CLIO_TOKEN} environment variable - this is mainly provided as
#'   a convenience during continuous integration testing.
#'
#' @description \code{clio_auth} sets up the initial Google token that
#'   ultimately authorises malevnc to view and edit data in the clio-store for
#'   body annotations. This function is a wrapper around
#'   \code{gargle::\link{token_fetch}}. You should normally not need to use it
#'   directly, but it can be useful if you run into authorisation problems (see
#'   examples).
#'
#' @param email An optional email - must be the one linked to your Clio account
#'   (and therefore linked to a Google account). See
#'   \code{gargle::link{credentials_user_oauth2}} for details.
#' @param cache Whether to use an oauth cache (Expert use only, see
#'   \code{gargle::\link{gargle_oauth_cache}} for details).
#' @param ... Additional arguments passed to \code{gargle::\link{token_fetch}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get or refresh clio JWT token (with the associated email as an attribute)
#' clio_token()
#'
#' # regenerate token for specified email if you are getting 401 web errors
#' clio_auth("user@gmail.com", cache=FALSE)
#'
#' # To remember your preferred email (e.g. because you have >1 Google account)
#' usethis::edit_r_profile()
#' # then add this line, save and restart
#' options(malevnc.clio_email="user@gmail.com")
#' }
clio_auth <- function(email = getOption("malevnc.clio_email",
                                        gargle::gargle_oauth_email()),
                      cache = gargle::gargle_oauth_cache(),
                      ...) {
  # seems like we must force authentication on session startup
  if(is.null(.authinfo$expires))
    cache=FALSE
  app = httr::oauth_app(
    appname = 'malevnc',
    key = '838644154009-0e4sr9qgt3jp6k31u0m6jcsifapi62ap.apps.googleusercontent.com',
    secret = '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')
  token <-
    gargle::token_fetch(
      package = 'malevnc',
      email = getOption("malevnc.clio_email", gargle::gargle_oauth_email()),
      cache = cache,
      app=app,
      ...
    )
  # scopes = "https://www.googleapis.com/auth/datastore",
  if (!inherits(token, "Token2.0")) {
    store_token_expiry(NULL)
    stop(
      "Clio/Google auth failure. Do you have access rights to VNC clio?\n",
      "Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!"
    )
  }
  now=Sys.time()
  .auth$set_cred(token)
  .auth$set_auth_active(TRUE)
  store_token_expiry(token, now)
  invisible()
}

#' @rdname clio_auth
#' @description \code{clio_token} returns a long lived token to use for clio
#'   store queries. Experts may wish to use this to construct their own API
#'   requests.
#' @export
#' @importFrom jose jwt_split
clio_token <- function() {
  token=clio_fetch_token()
  decoded=jwt_split(token)
  payload=decoded$payload
  if(is.null(payload$email))
    stop("JWT token invalid: no email!")
  if(is.null(payload$exp))
    stop("JWT token invalid: no expiration!")

  exp=as.POSIXct(payload$exp, origin='1970-01-01', tz = 'UTC')
  time_left = difftime(exp, Sys.time(), units = 'hours')
  if(time_left < 4) {
    token = clio_fetch_token(force=TRUE)
  }
  attr(token, 'email')=payload$email
  token
}

# if we need to get a new long-lived token
clio_fetch_token <- function(force=FALSE) {
  tokenfile=file.path(rappdirs::user_data_dir(appname = 'rpkg-malevnc'), 'flyem_token.json')
  if(!force && nzchar(CLIO_TOKEN <- Sys.getenv('CLIO_TOKEN')))
    return(CLIO_TOKEN)
  if(!force && file.exists(tokenfile))
    return(readLines(tokenfile))

  config = httr::add_headers(
    Authorization = paste("Bearer", google_token(token.only = T)))
  u=clio_url('v2/server/token')
  res=httr::POST(u, config = config)
  httr::stop_for_status(res)
  jwt=httr::content(res, as='parsed')
  tokendir=dirname(tokenfile)
  if(!file.exists(tokendir))
    dir.create(tokendir)
  writeLines(jwt, tokenfile)
  jwt
}

google_token <- function(token.only=FALSE) {
  if (isFALSE(.auth$auth_active))
    return(NULL)

  if (!inherits(.auth$cred, "Token2.0"))
    clio_auth()

  token=.auth$cred

  if(!is.null(.authinfo$expires)) {
    now <- Sys.time()
    # if we have less than a minute left, refresh
    if(difftime(.authinfo$expires, now, units='s')<60){
      token$refresh()
      store_token_expiry(token, now)
    }
  }

  if(token.only) .auth$cred$credentials$id_token else .auth$cred
}


store_token_expiry <- function(token=NULL, start=Sys.time()) {
  if(is.null(token))
    .authinfo$expires=NULL
  else
    .authinfo$expires=start+token$credentials$expires_in
  invisible()
}

# private function to talk to clio store
clio_fetch <- function(url, config=NULL, ..., body=NULL, query=NULL, json=FALSE) {
  if (is.null(config))
    config=c(httr::config(),
             httr::add_headers(Authorization = paste("Bearer", clio_token())))
  resp <- if(length(query)==0){
    httr::VERB(verb = ifelse(is.null(body), "GET", "POST"),
                    config=config,
                    url = url,
                    body = body,
                    ...)
  } else {
    httr::VERB(verb = ifelse(is.null(body), "GET", "POST"),
                    config=config,
                    url = url,
                    body = body,
                    query = query,
                    ...)

  }
  httr::stop_for_status(resp)
  res=httr::content(resp, as='text', type='application/json', encoding = 'UTF-8')
  if(json) res else jsonlite::fromJSON(res, bigint_as_char=TRUE)
}

clio_fetch_memo <- memoise::memoise(clio_fetch, ~memoise::timeout(5*60))

clio_url <- function(path, test=FALSE) {
  u <- if(test)
    "https://clio-test-7fdj77ed7q-uk.a.run.app"
  else
    "https://clio-store-vwzoicitea-uk.a.run.app"
  file.path(u, path, fsep = '/')
}

clio_fields <- function() {
  clio_fetch(clio_url("/v2/json-annotations/VNC/neurons/fields"))
}

validate_email <- function(email) {
  emailregex="(^[A-z0-9_.+-]+@[A-z0-9-]+\\.[A-z0-9.-]+$)"
  res=checkmate::checkCharacter(email, pattern = emailregex, len = 1)
  if(isTRUE(res)) return(email)
  stop("Invalid email address: ", email)
}

clio_email <- memoise::memoise(function(email=getOption("malevnc.clio_email")) {
  if(is.null(email)) {
    token=clio_token()
    email=attr(token, 'email')
    options(malevnc.clio_email=email)
  }
  validate_email(email)
  email
}, ~memoise::timeout(5*60))


clio_datasets <- function(cached=TRUE, json=FALSE) {
  if(cached)
    clio_fetch_memo(clio_url('v2/datasets'), json=json)
  else
    clio_fetch(clio_url('v2/datasets'), json=json)
}

clio_version <- function(version=NULL) {
  if(!is.null(version)) {
    vok=checkmate::assert_character(version, pattern = "^v[0-9.]")
    # this will trigger an error if it can't be parsed as x.y.z
    nv=numeric_version(sub("v","", version))
    return(version)
  }
  cds=clio_datasets()
  version=cds$VNC$tag
  if(is.null(version))
    stop("Unable to read clio version from API. Please specify manually and\n",
         "file a bug report at https://github.com/flyconnectome/malevnc/issues")
  version
}
