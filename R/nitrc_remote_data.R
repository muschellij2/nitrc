#' @title Download NITRC Remote Data Sources
#' @description Downloads the JSON object from the NITRC Remote Data Sources,
#' and parses it to a list.
#'
#' @param spec specification of data to extract.  Default is All.  See
#' \url{http://www.nitrc.org/plugins/mwiki/index.php/nitrc:NITRC_Remote_Data_Access}
#' for more information
#'
#' @return A list from \code{\link[jsonlite]{fromJSON}} of the parsed content
#' returned
#' @export
#'
#' @examples
#' res = nitrc_remote_data(spec = "589")
#' @importFrom httr GET content stop_for_status
nitrc_remote_data = function(spec = c("all", "",  "local", "incf")){
  spec = spec[1]
  link = "http://www.nitrc.org/export/site/projects.json.php"
  add_spec = ""
  if (spec != "") {
    add_spec = paste0("?spec=", spec)
  }
  url = paste0(link, add_spec)

  # tfile = tempfile()
  r = httr::GET(url)
  httr::stop_for_status(r)
  js = httr::content(r, type = "application/json")
  return(js)
}


