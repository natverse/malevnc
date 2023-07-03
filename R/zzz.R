.onLoad <- function(libname, pkgname) {
  try(choose_malevnc_dataset(dataset = getOption("malevnc.dataset"), set=TRUE))

  # TODO make MANC<->manc/JRCVNC2018U bridging registrations available

  invisible()
}
