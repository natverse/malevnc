# see https://gargle.r-lib.org/articles/gargle-auth-in-client-package.html

.auth <- gargle::init_AuthState(
  package     = "malevnc",
  auth_active = TRUE
)

#' Clio authorisation infrastructure using Google via the gargle package
#'
#' @description \code{clio_auth} authorises malevnc to view and edit data in the
#'   clio-store for body annotations. This function is a wrapper around
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
  cred <-
    gargle::token_fetch(
      package = 'malevnc',
      email = getOption("malevnc.clio_email", gargle::gargle_oauth_email()),
      cache = cache,
      ...
    )
  # scopes = "https://www.googleapis.com/auth/datastore",
  if (!inherits(cred, "Token2.0")) {
    stop(
      "Clio/Google auth failure. Do you have access rights to VNC clio?\n",
      "Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!"
    )
  }
  .auth$set_cred(cred)
  .auth$set_auth_active(TRUE)
  invisible()
}

#' @rdname clio_auth
#' @description \code{clio_token} returns a token to use for clio store queries.
#'   Experts may wish to use this to construct their own API requests.
#' @param token.only Whether to return just the Bearer token as a character
#'   vector (default FALSE returns a \code{\link{Token2.0}} object).
#' @export
clio_token <- function(token.only=FALSE) {
  if (isFALSE(.auth$auth_active))
    return(NULL)

  if (!inherits(.auth$cred, "Token2.0"))
    clio_auth()
  if(token.only) .auth$cred$credentials$id_token else .auth$cred
}
