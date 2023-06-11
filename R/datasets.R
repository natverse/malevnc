flyem_dataset <- function(dataset) {
  cds=clio_datasets()
  dataset=match.arg(dataset, names(cds))
  cds[[dataset]]
}

choose_malevnc_dataset <- function(dataset=NULL,
                                   set=TRUE,
                                   use_clio=NA) {
  if(is.null(dataset))
    dataset=getOption("malevnc.dataset")
  if(is.null(dataset))
    dataset=Sys.getenv('MALEVNC_DATASET')
  if(is.null(dataset) || dataset=="")
    dataset='MANC'
  if(isTRUE(dataset=='MANC')){
    if(!isTRUE(use_clio)) {
      ops=list(
        malevnc.dataset=dataset,
        malevnc.neuprint='https://neuprint.janelia.org',
        malevnc.neuprint_dataset="manc:v1.0",
        malevnc.rootnode=NULL,
        malevnc.server=NULL
      )
      if(set) return(options(ops)) else return(ops)
    }
  } else {
    if(isFALSE(use_clio))
      stop("I must use_clio to get information about dataset:", dataset)
  }
  choose_flyem_dataset(dataset = dataset, set=set)
}

choose_flyem_dataset <- function(dataset=getOption("malevnc.dataset"), set=TRUE) {
  ds=flyem_dataset(dataset)
  s=flyem_servers4dataset(ds)
  r=flyem_rootnode4dataset(ds)
  nps=ds$neuprintHTTP$server
  if(!isTRUE(substr(nps,1, 8)=="https://"))
    nps=paste0("https://", nps)
  npd=ds$neuprintHTTP$dataset
  if(!is.null(ds$neuprintHTTP$version))
    npd=paste0(npd, sep=":", ds$neuprintHTTP$version)
  ops=list(malevnc.server=s$dvid,
           malevnc.rootnode=r,
           malevnc.dataset=dataset,
           malevnc.neuprint=nps,
           malevnc.neuprint_dataset=npd)
  if(set) options(ops) else ops
}

flyem_scene4dataset <- memoise::memoise(function(dataset=NULL) {
  ds <- if(is.character(dataset)) flyem_dataset(dataset) else dataset
  stopifnot(!is.null(ds$neuroglancer))
  sc=fafbseg::ngl_decode_scene(ds$neuroglancer)

  # there are some key layers here
  sc2=fafbseg::ngl_decode_scene(ds$versions[[1]]$neuroglancer)
  ll=c(sc$layers[1], sc2$layers[1], sc$layers[-1], sc2$layers[-1])
  fafbseg::ngl_layers(sc) <- ll
  sc
})

flyem_servers4dataset <- memoise::memoise(function(dataset=NULL) {
  sc=flyem_scene4dataset(dataset)
  dl=flyem_dvidlayer4scene(sc)
  u=dl$source$url
  dvid=sub("dvid-service=.*", "", u)
  dvid=sub("dvid://", "", dvid)
  dvid=sub("(https://[^/]+).*", "\\1", dvid)
  list(
    dvid=dvid,
    support=sub("&.*", "", sub(".*dvid-service=", "", u))
  )
})

flyem_dvidlayer4scene <- function(sc) {
  dvidlayer <- sapply(sc$layers, function(x) isTRUE(try(grepl("dvid", x$source$url), silent = T)))
  # if(sum(dvidlayer)!=1)
  #   warning("Unable to extract a unique DVID layer!")
  dl=sc$layers[[min(which(dvidlayer))]]
  dl
}

flyem_rootnode4dataset <- memoise::memoise(function(dataset=NULL) {
  ds <- if(is.character(dataset)) flyem_dataset(dataset) else dataset
  stopifnot(!is.null(ds$uuid))
  servers=flyem_servers4dataset(ds)
  u=sprintf("%s/api/repo/%s/info", servers$dvid, ds$uuid)
  info = try(jsonlite::fromJSON(readLines(u, warn = F)))
  stopifnot(!is.null(info$Root))
  info$Root
})
