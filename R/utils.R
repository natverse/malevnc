check_package_available <- function(pkg) {
  if(!requireNamespace(pkg, quietly = TRUE)) {
    stop("Please install suggested package: ", pkg)
  }
}


#' Status report for the malevnc package
#'
#' @description \code{dr_manc} gives a very useful status report for the malevnc
#'   package.
#'
#'
#' @return Called for its side effect
#' @export
#'
#' @examples
#' \dontrun{
#' dr_manc()
#' }
dr_manc <- function() {
  check_package_available('sessioninfo')
  res=sessioninfo::package_info(pkgs = 'loaded')
  print(subset(res, res$package=='malevnc'))

  ds=choose_malevnc_dataset(set=F)
  if(isTRUE(ds$malevnc.dataset=="VNC")) {
    message("You are using the pre-release VNC dataset (VNC)")
  } else if(isTRUE(ds$malevnc.dataset=="MANC")) {
    message("You are using the public released VNC dataset (MANC)")
  }

  message("Dataset/auth status:")
  cds=try(clio_datasets())
  if(inherits(cds, "try-error"))
    message("Trouble connecting to clio to list datasets.")
  else {
    cat("* Successfully connected to clio to list datasets:\n")

    cdsl=sapply(cds, function(x) {
      cols=c("title", "tag", "description", "uuid")
      cols2=intersect(cols,names(x))
      l=x[cols2]
      l[setdiff(cols, cols2)]=NA
      as.data.frame(l)
    }, simplify = F)
    cdsdf=do.call(rbind, cdsl)
    print(cdsdf)

    ct=malevnc::clio_token()
    email=attr(ct, 'email')

    message('Clio is authenticated with email: ', email)
  }

  npds=try(neuprintr::neuprint_datasets(conn=manc_neuprint()))
  if(inherits(npds, "try-error"))
    message("\nTrouble connecting to neuprint for malevnc datasets.")
  else {
    cat("\n* Successfully connected to neuprint dataset:\n")
    print(manc_neuprint())
    cat(names(npds), "with last mod", npds[[1]]$`last-mod`,
        "and uuid",npds[[1]]$uuid, "\n")
  }

  message("Checking bridging registrations")
  jrcok=!inherits(try(check_jrcbrains(), silent = T), "try-error")
  if(!jrcok)
    cat("Missing suggested package to use bridging registrations\n",
    "natmanager::install(pkgs = 'nat.jrcbrains')")

  pp=manc_reg_paths()
  pmissing=pp[!file.exists(pp)]
  regok=TRUE
  if(length(pmissing)>0) {
    regok=FALSE
    cat("missing registration files:",
        paste(pmissing, collapse = ','))
  }
  if(jrcok && regok)
    cat("Registration files all present!\n")

  message("\nRelevant malevnc options:")
  print(options()[grepl("^malevnc", names(options()))])

  message("\nChecking Versions and direct package dependencies:")
  cat("R:", as.character(getRversion()),"\n")
  if(!requireNamespace('remotes'))
    warning("Please install the suggested remotes package to query dependencies")
  res=remotes::dev_package_deps(find.package("malevnc"))
  print(res)
}
