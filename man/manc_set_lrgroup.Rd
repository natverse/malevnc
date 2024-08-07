% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dvidtools.R
\name{manc_set_lrgroup}
\alias{manc_set_lrgroup}
\title{Set Left-Right matching groups for neurons in DVID and optionally Clio}
\usage{
manc_set_lrgroup(
  ids,
  sides = NULL,
  dryrun = TRUE,
  Force = FALSE,
  Partial = FALSE,
  group = NA,
  clio = TRUE,
  user = getOption("malevnc.dvid_user")
)
}
\arguments{
\item{ids}{A set of body ids belonging to the same group}

\item{sides}{Optional character vector specifying the sides (L,R,U) for the
given \code{ids}. Will be taken from neuprint by default.}

\item{dryrun}{When \code{TRUE}, the default, show what will happen rather
than applying the annotations.}

\item{Force}{Whether to update DVID instances (and clio group) even when
there is existing DVID instance information.}

\item{Partial}{Assigns group annotations (via DVID instances) only to neurons
that do not yet have annotation.}

\item{group}{Set a specific group id rather than accepting the default.}

\item{clio}{Whether to set the Clio group field in addition to DVID.}

\item{user}{Janelia user name to associate with the DVID instance annotation
(defaults to the value of options("malevnc.dvid_user"), but can be
overridden by this argument. NB a user must be provided by one of these
means. If the user has no Janelia id, just use an id of the form
\code{<surname><firstinitial>} e.g. \code{jefferisg}.}
}
\description{
Set Left-Right matching groups for neurons in DVID and optionally Clio
}
\details{
One important process in reviewing and annotating neurons is to
  compare neurons on the left and right side of the malevnc dataset. This can
  identify neurons that need further proof-reading fixes as well as grouping
  neurons that may eventually form agreed cell types. At the time of writing
  (21 Aug 2021) group information is stored in two locations: the DVID
  instance field and the Clio group field. DVID instance information is being
  periodically copied to Clio, but for the time being this is not automated.
  Furthermore it is not trivial to reconcile the two locations if they get
  out of sync. Therefore we have agreed that DVID will remain the master
  source of information for the time being.

  DVID left-right groupings are stored in the instance field (for the
  hemibrain this was more specific than the type field and typically included
  side of brain information). The convention has been to store the lowest
  body id in a group followed by an underscore and then the side (\code{L} or
  \code{R}) or a letter \code{U} to indicate that the neuron is unpaired
  (sometimes this is \code{UNP}). In contrast the Clio group column just
  contains the lowest bodyid. At this point we assume that the selected
  bodyid will \emph{not} change if neurons are added to the group.
  \code{manc_set_lrgroup} will choose the lowest bodyid as the default when
  setting the group for a set of ids unless a specific \code{group} argument
  is passed.

  Grouping neurons remains a subjective process: while many cases are
  obvious, there are always edge cases where experts disagree. Therefore it
  is not necessarily productive to spend extensive amounts of discussion once
  a designation has been made. Therefore \code{manc_set_lrgroup} tries to
  avoid overriding previous designations unless the user insists. This
  behaviour can be changed using the \code{Force} or \code{Partial}. As you
  might expect \code{Force=TRUE} just does what you ask regardless of any
  existing annotations. Use this sparingly and with caution.

  \code{Partial=TRUE} is more nuanced and tries to do the right thing when
  extending a group for which some members already have annotations. The main
  limitation is that you must pass \emph{all} the members of the group in
  your call so that \code{manc_set_lrgroup} knows that you are trying to make
  a compatible annotation.

  Here are some examples of group annotations: \itemize{

  \item \code{10000_R}, \code{10000_L} for bodyids \code{10000, 10002} (the
  giant fibre neurons)

  \item \code{13083_U} an unpaired neuron.

  }
}
\examples{
\dontrun{
# check it makes sense, dryrun=T
manc_set_lrgroup(c(12516, 12706))
# apply
manc_set_lrgroup(c(12516, 12706), dryrun=F)
}
}
