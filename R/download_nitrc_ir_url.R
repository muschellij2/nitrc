#' @title Download NITRC Single Image Repository URL
#' @description Downloads a single URL from a NITRC Image Repository,
#' wrapper function for \code{\link{download_nitrc_url}}
#'
#' @param url URL of file to download
#' @param username Username for authentication of NITRC
#' @param password Password for authentication of NITRC
#' @param out_dir Output directory
#' @param verbose Print diagnostic messages
#' @param ... additional options to pass to \code{\link{download_nitrc_url}}
#'
#' @return Vector of names of the output files
#' @export
#' @importFrom utils unzip
download_nitrc_ir_url = function(
  url,
  username,
  password,
  out_dir = ".",
  verbose = TRUE, ...) {

  if (verbose) {
    message(url)
  }
  outfile = file.path(tempdir(), "Image_Data.zip")
  if (file.exists(outfile)) {
    file.remove(outfile)
  }

  download_nitrc_url(
    username = username,
    password = password,
    nitrc_url = url,
    outfile = outfile,
    fileext = ".zip",
    overwrite = TRUE, ...)
  # r1 = L$ret

  zz = unzip(outfile, list = TRUE)
  zz = zz$Name
  # zz = zz$Name[ !grepl("SNAPSHOTS", zz$Name) ]
  id_dir = sub("(.*)scans.*", "\\1", zz)
  id_dir = unique(id_dir)
  id_dir = file.path(out_dir, id_dir)

  retfile = unzip(outfile, files = zz,
                  exdir = id_dir, junkpaths = TRUE)
  return(retfile)
}

