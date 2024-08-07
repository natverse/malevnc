% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/neuprint.R
\name{manc_ids}
\alias{manc_ids}
\title{Flexible specification of manc body ids}
\usage{
manc_ids(
  x,
  mustWork = TRUE,
  as_character = TRUE,
  integer64 = FALSE,
  unique = TRUE,
  conn = manc_neuprint(),
  ...
)
}
\arguments{
\item{x}{A vector of body ids, data.frame (containing a bodyid column) or a
neuroglancer URL.}

\item{mustWork}{Whether to insist that at least one valid id is returned
(default \code{TRUE})}

\item{as_character}{Whether to return segments as character rather than
numeric vector (the default is character for safety).}

\item{integer64}{whether to return ids with class bit64::integer64.}

\item{unique}{Whether to ensure that only unique ids are returned (default
\code{TRUE})}

\item{conn}{optional, a neuprintr connection object, which also specifies the
neuPrint server. If NULL, the defaults set in your
\code{\link[=Startup]{.Rprofile}} or \code{\link[=Startup]{.Renviron}} are
used. See \code{\link[neuprintr]{neuprint_login}} for details.}

\item{...}{Additional arguments passed to \code{\link[neuprintr]{neuprint_search}}}
}
\description{
\code{manc_ids} provides a convenient way to extract body ids
  from a variety of objects as well as allowing text searches against
  type/instance information defined in neuprint.
}
\examples{
\donttest{
# search by type
manc_ids("DNp01")
# You can also do more complex queries using regular expressions
# introduced by a slash and specifying the field to be searched
dns=manc_ids("/type:DN.+")

# you can also use Neo4J cypher queries by using the where: prefix
# note that each field of the neuron must prefixed with "n."
bignogroupids <-
  manc_ids("where:NOT exists(n.group) AND n.synweight>5000 AND n.class CONTAINS 'neuron'")
\dontrun{
# Finally you can use the same queries wherever you specify body ids
# NB if you want to be sure that regular neuprintr functions target
# the VNC dataset, use conn=manc_neuprint()
lrpairs.meta=neuprintr::neuprint_get_meta("/name:[0-9]{5,}_[LR]", conn=manc_neuprint())
}
}
}
\seealso{
\code{\link{neuprint_ids}}

Other manc-neuprint: 
\code{\link{manc_connection_table}()},
\code{\link{manc_neuprint}()}
}
\concept{manc-neuprint}
