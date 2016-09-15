#' @title NITRC Image Repository Study
#' @description Parses the necessary information for the specified NITRC
#' Image Repository (IR) Study
#' @param study study to be parsed
#' ixi = IXI,
#' pd = High-quality diffusion-weighted imaging of Parkinson's disease
#' fcon_1000 = 1000 Functional Connectomes
#' candi = CANDI Share: Schizophrenia Bulletin 2008
#'
#' @return List of a data.frame of the files to download and the demographics
#' @export
#'
#' @examples
#' \dontrun{
#' x = nitrc_ir_study("ixi")
#' }
#' @importFrom utils read.csv
#'
nitrc_ir_study = function(
  study = c("ixi", "pd", "fcon_1000", "candi")) {
  make_file = function(x) {
    system.file(x, package = "nitrc")
  }
  study = match.arg(study)
  if (study == "ixi") {
    all_mods = c("T2", "T1", "MRA", "PD", "DTI")
  }
  if (study == "pd") {
    all_mods = c("DWI", "Normalized+TDI+Map")
  }
  if (study == "fcon_1000") {
    all_mods = c("NULL", "mprage_anonymized",
                 "func_rest", "mprage_skullstripped")
  }
  if (study == "forrest") {
    all_mods = c("NULL")
  }
  if (study == "candi") {
    all_mods = c("anat")
  }
  xml_file = paste0(study, "_all_data.xml")
  xml_file = make_file(xml_file)

  df = xcat_reader(xml_file = xml_file, all_mods = all_mods)
  csv = make_file(paste0(study, "_demog_all.csv"))
  demog = read.csv(csv, stringsAsFactors = FALSE)

  L = list(df = df,
           demog = demog)
  return(L)

}