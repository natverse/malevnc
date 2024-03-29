% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/annotations.R
\name{manc_dvid_annotations}
\alias{manc_dvid_annotations}
\title{Return all DVID body annotations}
\usage{
manc_dvid_annotations(
  ids = NULL,
  node = "neutu",
  rval = c("data.frame", "list"),
  columns_show = NULL,
  cache = FALSE
)
}
\arguments{
\item{ids}{A set of body ids in any form understandable to
\code{\link{manc_ids}}}

\item{node}{A DVID node as returned by \code{\link{manc_dvid_node}}. The
default is to return the current active (unlocked) node being used through
neutu.}

\item{rval}{Whether to return a fully parsed data.frame (the default) or an R
list. The data.frame is easier to work with but typically includes NAs for
many values that would be missing in the list.}

\item{columns_show}{Whether to show all columns, or just with '_user', or '_time'
suffix. Accepted options are: 'user', 'time', 'all'.}

\item{cache}{Whether to cache the result of this call for 5 minutes.}
}
\value{
A \code{tibble} containing with columns including \itemize{

  \item bodyid as a \code{numeric} value

  \item status

  \item user

  \item naming_user

  \item instance

  \item status_user

  \item comment }

  NB only one \code{bodyid} is used regardless of whether the key-value
  returned has 0, 1 or 2 bodyid fields. When the \code{ids} are specified,
  missing ids will have a row containing the \code{bodyid} in question and
  then all other columns will be \code{NA}.
}
\description{
Return all DVID body annotations
}
\details{
See
  \href{https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1619201195032400}{this
   Slack post} from Stuart Berg for details.

  Note that the original api call was \code{<rootuuid>:master}, but I have
  now just changed this to \code{<neutu-uuid>} as returned by
  \code{\link{manc_dvid_node}}. This was because the range query stopped
  working 16 May 2021, probably because of a bad node.
}
\examples{
\donttest{
mdf=manc_dvid_annotations()
head(mdf)
table(mdf$status)

manc_dvid_annotations('DNp01')

\dontrun{
# compare live body annotations with version in clio
mdf.clio=manc_dvid_annotations('clio')
waldo::compare(mdf.clio, mdf)
}
}
}
