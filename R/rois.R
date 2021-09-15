#' Simple summaries of which regions different neurons innervate
#'
#' @description \code{manc_leg_summary} summarises I/O in the main leg
#'   neuropils.
#' @param long Whether to return results in wide (default) or long format.
#' @inheritParams manc_connection_table
#'
#' @return a data.frame with one row per neuron (when \code{long=FALSE}) or one
#'   row per ROI/IO combination (when \code{long=TRUE}). Note that \code{out}
#'   columns refer to output synapses from the given bodyid onto downstream
#'   partners.
#' @export
#'
#' @examples
#' dnals=manc_leg_summary(c(10126, 10118))
#' dnals
#' manc_leg_summary(c(10126, 10118), long=TRUE)
#' heatmap(data.matrix(dnals[grep("_out", colnames(dnals))]),
#'   Colv = NA, scale = 'none')
#'
#' \donttest{
#' dnls=manc_leg_summary('class:Descending')
#' heatmap(data.matrix(dnls[grep("_out", colnames(dnls))]),
#'   Colv = NA, scale = 'none')
#' }
manc_leg_summary <- function(ids, long=FALSE, conn=manc_neuprint()) {
  ids=manc_ids(ids)
  res=neuprintr::neuprint_get_roiInfo(ids, conn = conn)
  legcols=grep("IntNp.*T[1-3].+stream", colnames(res), value = T)
  colstokeep=c("bodyid", legcols)
  res2=res[colstokeep]
  newlegcols=sub(".*(T[1-3]).+([LR]).+(down|up)stream", "\\1\\2_\\3", legcols)
  newlegcols=sub("down", "out", newlegcols)
  newlegcols=sub("up", "in", newlegcols)
  colnames(res2)[-1]=newlegcols
  goodlegcols=c("T1L_in", "T1L_out", "T1R_in", "T1R_out", "T2L_in", "T2L_out",
                "T2R_in", "T2R_out", "T3L_in", "T3L_out", "T3R_in", "T3R_out")
  missing=setdiff(goodlegcols, colnames(res2))
  res2[,missing]=0
  res2=res2[c("bodyid", goodlegcols)]
  res2[-1][is.na(res2[-1])]=0
  for(i in seq_along(res2)[-1]) res2[[i]]=as.integer(res2[[i]])
  res2$bodyid=as.numeric(res2$bodyid)
  if (isTRUE(long)) {
    if(!requireNamespace('tidyr'))
      stop("Please install suggested package tidyr!\n")
    res2 %>%
      tidyr::pivot_longer(cols = -1, values_to = 'weight') %>%
      mutate(
        soma_neuromere = substr(.data$name, 1, 2),
        side = substr(.data$name, 3, 3),
        polarity = sub(".+_", "", .data$name)
      ) %>%
      select(-.data$name)
  }
  else
    res2
}


#' @description \code{manc_side_summary} summarises connections within all of
#'   the ROIs that have an L or R designation.
#' @export
#' @rdname manc_leg_summary
#' @examples
#' manc_side_summary('Giant Fiber')
#' @importFrom dplyr mutate select
manc_side_summary <- function(ids, long=FALSE, conn=manc_neuprint()) {
  ids=manc_ids(ids, as_character = F)
  res=neuprintr::neuprint_get_roiInfo(ids, conn = conn)
  ldcols=grepl("\\(L\\).downstream", colnames(res))
  rdcols=grepl("\\(R\\).downstream", colnames(res))
  rucols=grepl("\\(R\\).upstream", colnames(res))
  lucols=grepl("\\(L\\).upstream", colnames(res))

  res2=data.frame(bodyid=as.numeric(res$bodyid),
                  L_in=as.integer(rowSums(res[lucols])),
                  L_out=as.integer(rowSums(res[ldcols])),
                  R_in=as.integer(rowSums(res[rucols])),
                  R_out=as.integer(rowSums(res[rdcols]))
                  )
  res2[-1][is.na(res2[-1])]=0
  if (isTRUE(long)) {
    res2 %>%
      tidyr::pivot_longer(cols = -1, values_to = 'weight') %>%
      mutate(
        side = substr(.data$name, 1, 1),
        polarity = sub(".+_", "", .data$name)
      ) %>%
      select(-.data$name)
  }
  else
    res2
}
