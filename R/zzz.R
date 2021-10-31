.onLoad <- function(libname, pkgname) {
  op.manc <- list('malevnc.server'="https://emdata5-avempartha.janelia.org",
                  malevnc.rootnode="1ec355123bf94e588557a4568d26d258",
                  malevnc.dataset="VNC")

  op<-options()
  toset <- !(names(op.manc) %in% names(op))
  if(any(toset)) options(op.manc[toset])

  # TODO make MANC<->manc/JRCVNC2018U bridging registrations available

  invisible()
}
