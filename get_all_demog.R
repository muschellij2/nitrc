rm(list = ls())
# download_nitric_ir
library(base64enc)
library(xml2)
library(httr)
source("credentials.R")
myusername = rawToChar(base64decode(myusername))
mypassword = rawToChar(base64decode(mypassword))

# study = "pd"
# study = "ixi"
study = "fcon_1000"


xml_file = paste0("inst/", study, "_all_data.xml")
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
df = xcat_reader(xml_file, all_mods)

# uri = df$url[2]
demog = read.csv(paste0("inst/", study, "_demog.csv"),
                 stringsAsFactors = FALSE)

#########################################################
# Getting map from NITRC to ID
#########################################################
uids = df[ df$mod %in% all_mods[1], ]
uids$mod = NULL

study_id = paste0(study, "_id")
uids[, study_id] = NA
rownames(uids) = NULL

#########################
# Quick function to get the names
#########################
get_header = function(uri,
                      username = myusername,
                      password = mypassword) {

  r = HEAD(uri,
           authenticate(user = myusername, password = mypassword))
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
# Running through IDs to get the study_ids
#########################
N = nrow(uids)
i = 1
for (i in seq(N)) {
  print(i)
  curr_id = uids[i, study_id]
  if (is.na(curr_id)) {
    uri = uids$url[i]
    uid = get_header(uri)
    curr_id = uids[i, study_id] = uid
  }
  if (is.na(curr_id)) {
    if (length(all_mods) > 1) {
      uri = gsub(all_mods[1], all_mods[2], uri)
      uid = get_header(uri)
      curr_id = uids[i, study_id] = uid
    }
  }
  if (is.na(curr_id)) {
    if (length(all_mods) > 2) {
      uri = gsub(all_mods[1], all_mods[2], uri)
      uid = get_header(uri)
      curr_id = uids[i, study_id] = uid
    }
  }
}

xuids = uids[, c("id", study_id)]
stopifnot(all(!is.na(xuids[, study_id])))
xuids$Subject = sub("(.*)_.*", "\\1", xuids[, study_id])
# xuids$Subject = as.numeric(xuids$Subject)

#########################
# Merging with demog
#########################
stopifnot(all(demog$Subject %in% xuids$Subject))
all_demog = merge(demog, xuids, by = "Subject", all.x = TRUE)

write.csv(all_demog,
          file = paste0("inst/", study, "_demog_all.csv"),
          row.names = FALSE)
