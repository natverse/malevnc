parse_svg <- function(f, outf=NULL, colpal=NULL, colids=names(colpal)) {
  if(!requireNamespace('xml2', quietly = TRUE))
    stop("Please install")

  x <- xml2::read_xml(f)
  xmc=xml2::xml_children(x)
  ids <- xml2::xml_attr(xmc, 'id')
  xmc=xmc[!is.na(ids)]
  ids=na.omit(ids)
  paths <- xml2::xml_children(xmc)
  if(length(paths)!=length(ids))
    stop("Unable to identify a single child for each path")
  styles=xml2::xml_attr(paths, 'style')
  if(length(styles)!=length(ids))
    stop("Unable to identify a single style attribute for each path")
  fillinfo=stringr::str_match(styles, 'fill:rgb\\(([0-9,]+)\\)')
  fillinfo.rgb=read.csv(text = fillinfo[,2], col.names = c('r', 'g', 'b'), header = F)
  fillinfo.hex=with(fillinfo.rgb/255, rgb(r,g,b))
  if(is.null(colpal))
    return(structure(fillinfo.hex, .Names=ids))
  else {
    m=match(colids, ids)
    if(any(is.na(m)))
      stop("Failed to find some supplied ids in the SVG file!")

    colrgb=col2rgb(colpal)
    coldf=as.data.frame(t(colrgb[,m,drop=F]))
    newfill=with(coldf, sprintf("fill:rgb(%d,%d,%d)", red, green, blue))
    for(i in seq_along(newfill)) {
      styles[i]=sub(fillinfo[m[i],1], newfill[i], styles[i], fixed = T)
    }
    xml2::xml_attr(paths, 'style')=styles
  }
  if(is.null(outf))
    x
  else {
    xml2::write_xml(x, outf)
    invisible(outf)
  }
}

#' Create SVG figure with leg muscles coloured based on supplied colour palette
#'
#' @param f Path to write out SVG file
#' @param colpal A vector of colours named by the leg muscles
#' @param colids The names of the muscles
#'
#' @return When \code{f} is missing, an object of class \code{xml_document} that
#'   can be further modified using the \code{xml2} package. Otherwise, the path
#'   \code{f}, invisibly.
#' @export
#' @importFrom grDevices col2rgb
#' @importFrom utils read.csv
#' @examples
#' \donttest{
#' pal=leg_muscle_palette()
#' pal
#' pal[]='white'
#' pal['Fe-reductor']='red'
#' \dontrun{
#' colour_leg_muscles(f='Fe-reductor.svg', colpal=pal)
#' }
#' }
colour_leg_muscles <- function(f=NULL, colpal=NULL, colids=names(colpal)) {
  inf=system.file('svg/Leg_muscle_figure.svg', package = 'malevnc')
  if(is.null(colpal))
    colpal=leg_muscle_palette()
  parse_svg(inf, outf = f, colpal=colpal, colids = colids)
}

#' @rdname colour_leg_muscles
#' @export
#' @description \code{leg_muscle_palette} returns the default palette for the
#'   leg muscles.
leg_muscle_palette <- function() {
  inf=system.file('svg/Leg_muscle_figure.svg', package = 'malevnc')
  parse_svg(inf)
}
