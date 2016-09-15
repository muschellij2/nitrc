rm(list = ls())
# download_nitric_ir
library(base64enc)
library(xml2)
library(httr)
library(nitrc)
source("credentials.R")
myusername = rawToChar(base64decode(myusername))
mypassword = rawToChar(base64decode(mypassword))

# study = "parkdti"
# study = "ixi"
study = "fcon_1000"
# study = "candi"


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
if (study == "forrest") {
  all_mods = c("NULL")
}
if (study == "candi") {
  all_mods = c("anat")
}
df = xcat_reader(xml_file = xml_file, all_mods = all_mods)

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
get_nitrc_fname = function(uri,
                      username = myusername,
                      password = mypassword) {

  r = HEAD(uri,
           authenticate(user = myusername, password = mypassword))
  if (r$status_code == 200) {
    uname = r$all_headers[[1]]$headers$`content-disposition`
    uname = sub('.*filename="(.*)".*', "\\1", uname)
  } else {
    print("bad response")
    uname = NA
  }
  return(uname)
}
get_uname = function(...){
  uname = get_nitrc_fname(...)
  uname = sub("[.]zip$", "", uname)
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
    uid = get_uname(uri)
    curr_id = uids[i, study_id] = uid
  }
  if (is.na(curr_id)) {
    if (length(all_mods) > 1) {
      uri = gsub(all_mods[1], all_mods[2], uri)
      uid = get_uname(uri)
      curr_id = uids[i, study_id] = uid
    }
  }
  if (is.na(curr_id)) {
    if (length(all_mods) > 2) {
      uri = gsub(all_mods[2], all_mods[3], uri)
      uid = get_uname(uri)
      curr_id = uids[i, study_id] = uid
    }
  }
  if (is.na(curr_id)) {
    if (length(all_mods) > 3) {
      uri = gsub(all_mods[3], all_mods[4], uri)
      uid = get_uname(uri)
      curr_id = uids[i, study_id] = uid
    }
  }
}

xuids = uids[, c("id", study_id)]
stopifnot(all(!is.na(xuids[, study_id])))
if (study %in% c("pd", "ixi", "candi")) {
  xuids$Subject = sub("(.*)_.*", "\\1", xuids[, study_id])
} else {
  xuids$Subject = xuids[, study_id]
}
# xuids$Subject = as.numeric(xuids$Subject)

#########################
# Merging with demog
#########################
sd = setdiff(demog$Subject, xuids$Subject)
stopifnot(length(sd) == 0)
all_demog = merge(demog, xuids, by = "Subject", all.x = TRUE)

write.csv(all_demog,
          file = paste0("inst/", study, "_demog_all.csv"),
          row.names = FALSE)
