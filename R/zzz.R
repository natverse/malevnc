.onLoad <- function(libname, pkgname) {
  op.manc <- list('malevnc.server'="https://emdata5-avempartha.janelia.org")

  op<-options()
  toset <- !(names(op.manc) %in% names(op))
  if(any(toset)) options(op.manc[toset])

  # TODO make MANC<->manc/JRCVNC2018U bridging registrations available

  invisible()
}
