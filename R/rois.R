#' Simple summaries of which regions different neurons innervate
#'
#' @description \code{manc_leg_summary} summarises I/O in the main leg
#'   neuropils.
#' @param long Whether to return results in wide (default) or long format.
#' @inheritParams manc_connection_table
#'
#' @return a data.frame with one row per neuron (when \code{long=FALSE}) or one
#'   row per roi/IO combination (when \code{long=TRUE}).
#' @export
#'
#' @examples
#' dnals=manc_leg_summary(c(10126, 10118))
#' dnals
#' manc_leg_summary(c(10126, 10118), long=T)
#' heatmap(data.matrix(dnals[grep("_down", colnames(dnals))]),
#'   Colv = NA, scale = 'none')
#'
#' \donttest{
#' dnls=manc_leg_summary('class:Descending')
#' heatmap(data.matrix(dnls[grep("_down", colnames(dnls))]),
#'   Colv = NA, scale = 'none')
#' }
manc_leg_summary <- function(ids, long=FALSE, conn=manc_neuprint()) {
  ids=manc_ids(ids)
  res=neuprintr::neuprint_get_roiInfo(ids, conn = conn)
  legcols=grep("IntNp.*T[1-3].+stream", colnames(res), value = T)
  colstokeep=c("bodyid", legcols)
  res2=res[colstokeep]
  newlegcols=sub(".*(T[1-3]).+([LR]).+(down|up)stream", "\\1\\2_\\3", legcols)
  colnames(res2)[-1]=newlegcols
  goodlegcols=c("T1L_down", "T1L_up", "T1R_down", "T1R_up", "T2L_down", "T2L_up",
                "T2R_down", "T2R_up", "T3L_down", "T3L_up", "T3R_down", "T3R_up"
  )
  missing=setdiff(goodlegcols, colnames(res2))
  res2[,missing]=0
  res2=res2[c("bodyid", goodlegcols)]
  res2[-1][is.na(res2[-1])]=0
  for(i in seq_along(res2)[-1]) res2[[i]]=as.integer(res2[[i]])
  res2$bodyid=as.numeric(res2$bodyid)
  if (isTRUE(long)) {
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
manc_side_summary <- function(ids, long=FALSE, conn=manc_neuprint()) {
  ids=manc_ids(ids, as_character = F)
  res=neuprintr::neuprint_get_roiInfo(ids, conn = conn)
  ldcols=grepl("\\(L\\).downstream", colnames(res))
  rdcols=grepl("\\(R\\).downstream", colnames(res))
  rucols=grepl("\\(R\\).upstream", colnames(res))
  lucols=grepl("\\(L\\).upstream", colnames(res))

  res2=data.frame(bodyid=as.numeric(res$bodyid),
                  L_down=as.integer(rowSums(res[ldcols])),
                  L_up=as.integer(rowSums(res[lucols])),
                  R_down=as.integer(rowSums(res[rdcols])),
                  R_up=as.integer(rowSums(res[rucols]))
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
