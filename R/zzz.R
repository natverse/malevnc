.onLoad <- function(libname, pkgname) {
  op.fanc <- list('malevnc.server'="https://emdata5-avempartha.janelia.org")

  op<-options()
  toset <- !(names(op.fanc) %in% names(op))
  if(any(toset)) options(op.fanc[toset])

  # TODO make MANC<->FANC/JRCVNC2018U bridging registrations available

  invisible()
}
