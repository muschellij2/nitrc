#' @title NITRC Documents
#' @description Wraps \code{\link{nitrc_remote_data}} and
#' \code{\link{parse_nitrc_docs}} to return NITRC document information from
#' the projects
#'
#' @param ... arguments passed to \code{\link{nitrc_remote_data}}
#' @param long passed to \code{\link{parse_nitrc_docs}}
#'
#' @return \code{data.frame}, same as \code{\link{parse_nitrc_docs}}
#' @seealso \code{\link{parse_nitrc_docs}}
#' @export
nitrc_documents = function(..., long = FALSE){
  js = nitrc_remote_data(...)
  df = parse_nitrc_docs(js$projects, long = long)
  return(df)
}



