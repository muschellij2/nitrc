#' @title NITRC Packages
#' @description Wraps \code{\link{nitrc_remote_data}} and
#' \code{\link{parse_nitrc_packs}} to return NITRC package information from
#' the projects
#'
#' @param ... arguments passed to \code{\link{nitrc_remote_data}}
#'
#' @return \code{data.frame}, same as \code{\link{parse_nitrc_packs}}
#' @seealso \code{\link{parse_nitrc_packs}}
#' @export
nitrc_packages = function(...){
  js = nitrc_remote_data(...)
  df = parse_nitrc_packs(js$projects)
  return(df)
}



