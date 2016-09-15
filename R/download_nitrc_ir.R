#' @title Download NITRC Image Repository
#' @description Downloads an entire NITRC Image Repository,
#' wrapper function for \code{\link{download_nitrc_ir_url}}
#'
#' @param study study to be parsed, code see \code{\link{nitrc_ir_study}}
#' @param username Username for authentication of NITRC
#' @param password Password for authentication of NITRC
#' @param out_dir Output directory
#' @param verbose Print diagnostic messages
#'
#' @return Vector of names of the output files
#' @importFrom plyr llply
#' @export
download_nitrc_ir = function(
  study = c("ixi", "pd", "fcon_1000", "candi"),
  username,
  password,
  out_dir = ".",
  verbose = TRUE) {

  study = match.arg(study)
  L = nitrc_ir_study(study = study)

  df = L$df
  # demog = L$demog
  rm(list = "L")

  # df$url
  # sapply(, dler)
  res = llply(df$url, function(x) {
    rr = download_nitrc_ir_url(
      url = x,
      username = username,
      password = password,
      out_dir = ".",
      verbose = verbose)
  }, .progress = ifelse(verbose, "text", "none"))

  return(res)
}



