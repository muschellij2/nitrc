rm(list = ls())
# download_nitric_ir
library(base64enc)
library(xml2)
library(httr)
source("credentials.R")
myusername = rawToChar(base64decode(myusername))
mypassword = rawToChar(base64decode(mypassword))

xml_file = "inst/ixi_all_data.xml"
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

stopifnot(all(umods %in% c("T2", "T1", "MRA", "PD", "DTI")))

df = data.frame(url = uris,
                id = ids,
                mod = mods,
                stringsAsFactors = FALSE)
rm(list = c("uris", "ids", "mods"))

# uri = df$url[2]
demog = read.csv("inst/ixi_demog.csv", stringsAsFactors = FALSE)

#########################################################
# Getting map from NITRC to IXI ID
#########################################################
uids = df[ df$mod %in% "T2", ]
uids$mod = NULL
uids$ixi_id = NA
rownames(uids) = NULL

#########################
# Quick function to get the names
#########################
get_header = function(uri,
                      username = myusername,
                      password = mypassword) {

  r = HEAD(uri,
           authenticate(user = myusername, password = mypassword),
           progress())
  if (r$status_code == 200) {

    uname = r$all_headers[[1]]$headers$`content-disposition`
    uname = sub('.*filename="(.*)".*', "\\1", uname)
    uname = sub("[.]zip$", "", uname)
  } else {
    uname = NA
  }
  return(uname)
}

#########################
# Running through IDs to get the ixi_ids
#########################
N = nrow(uids)
i = 1
for (i in seq(N)) {
  print(i)
  curr_id = uids$ixi_id[i]
  if (is.na(curr_id)) {
    uri = uids$url[i]
    uid = get_header(uri)
    curr_id = uids$ixi_id[i] = uid
  }
  if (is.na(curr_id)) {
    uri = gsub("T2", "T1", uri)
    uid = get_header(uri)
    curr_id = uids$ixi_id[i] = uid
  }
  if (is.na(curr_id)) {
    uri = gsub("T1", "DTI", uri)
    uid = get_header(uri)
    curr_id = uids$ixi_id[i] = uid
  }
}

xuids = uids[, c("id", "ixi_id")]
stopifnot(all(!is.na(xuids$ixi_id)))
xuids$Subject = sub("(.*)_.*", "\\1", xuids$ixi_id)
xuids$Subject = as.numeric(xuids$Subject)

#########################
# Merging with demog
#########################
stopifnot(all(demog$Subject %in% xuids$Subject))
all_demog = merge(demog, xuids, by = "Subject", all.x = TRUE)

write.csv(all_demog,
          file = "inst/ixi_demog_all.csv",
          row.names = FALSE)
