#' @title Download NITRC URL
#' @description Download URL from NITRC
#' @param username username for authentication
#' @param password password for authentication
#' @param nitrc_url URL to download
#' @param outfile output filename
#' @param fileext if \code{outfile = NULL},
#' @param overwrite Should the \code{outfile} be overwritten
#'
#' @return List of 2 elements, return of \code{GET}, and output filename
#' @export
#' @importFrom httr GET authenticate write_disk progress stop_for_status
download_nitrc_url = function(
  username,
  password,
  nitrc_url = "http://www.nitrc.org/frs/downloadlink.php/2204",
  outfile = NULL,
  fileext = ".tar.bz2",
  overwrite = FALSE) {

  if (is.null(outfile)) {
    outfile = tempfile(fileext = fileext)
  }
  r1 = GET(nitrc_url,
           authenticate(user = username, password = password,
                        type = "basic"),
           write_disk(outfile, overwrite = overwrite),
           progress())
  stop_for_status(r1)
  L = list(ret = r1,
           outfile = outfile)
  return(L)
}