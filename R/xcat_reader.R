#' @title XML Category Reader from NITRC
#' @description Reads XML Category file from NITRC
#' @param xml_file XML file from NITRC
#' @param all_mods types of modalities in the data
#' @return \code{data.frame} of URL, ID, and mods
#' @export
#' @importFrom xml2 read_xml xml_find_all xml_attr
xcat_reader = function(xml_file, all_mods) {
  xx = read_xml(xml_file)

  all_entries = xml_find_all(xx, "//cat:entry")
  types = xml_attr(all_entries, "format")
  ltypes = tolower(types)
  stopifnot(all(ltypes %in% "zip"))
  rm(list = c("types", "ltypes"))

  uris = xml_attr(all_entries, "URI")
  ids = sub(".*experiments/(.*)/scans.*", "\\1", uris)
  mods = sub(".*scans/(.*)/files.*", "\\1", uris)
  umods = unique(mods)
  rm(list = c("all_entries", "xx"))

  stopifnot(all(umods %in% all_mods))

  df = data.frame(url = uris,
                  id = ids,
                  mod = mods,
                  stringsAsFactors = FALSE)
  rm(list = c("uris", "ids", "mods"))
  return(df)
}