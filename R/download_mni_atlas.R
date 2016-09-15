#' @title Download MNI Atlas Zip file
#' @description Downloads a single MNI atlas from the MNI website
#' (http://nist.mni.mcgill.ca/?page_id=714)
#'
#' @param atlas Name of atlas to download.  See \code{\link{mni_atlas_links}}
#' @param out_dir Output directory, directory to download izp file
#' @param verbose Print diagnostic messages
#' @param overwrite Should the file be overwritten if it exists
#'
#' @return List of 2 elements, return of \code{GET}, and output filename
#' @export
#' @examples
#' download_mni_atlas("mni305", out_dir = tempdir())
download_mni_atlas = function(
  atlas = names(nitrc::mni_atlas_links),
  out_dir = ".",
  verbose = TRUE,
  overwrite = FALSE) {

  atlas = match.arg(atlas, choices = names(nitrc::mni_atlas_links))
  url = nitrc::mni_atlas_links[atlas]

  if (verbose) {
    message(url)
  }
  outfile = file.path(out_dir, basename(url))

  r = GET(url,
           write_disk(outfile, overwrite = overwrite),
           progress())

  L = list(ret = r,
           outfile = outfile)
  return(L)
}

