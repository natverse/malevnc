#' @keywords internal
#' @import nat
#' @section Registration: For information about left-right mirroring and
#'   symmetrising registrations within MANC, please see
#'   \code{\link{mirror_manc}}.
#'
#'   For information about across-template registrations, please see
#'   \code{\link{download_manc_registrations}}.
#'
#' @section Package Options: \itemize{
#'
#'   \item \code{malevnc.dataset} A shortname defining the active dataset
#'   (usually\code{MANC}). See \code{\link{choose_malevnc_dataset}} for details.
#'
#'   \item \code{malevnc.server} The https URL to the main Janelia server
#'   hosting male VNC data.
#'
#'   }
#'
#' @examples
#' # List all package options
#' \dontrun{
#' options()[grepl("^malevnc", names(options()))]
#' }
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
