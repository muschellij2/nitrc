rm(list = ls())
# download_nitric_ir
library(base64enc)
library(xml2)
source("credentials.R")
myusername = rawToChar(base64decode(myusername))
mypassword = rawToChar(base64decode(mypassword))

xml_file = "inst/ixi_all_data.xml"
df = xcat_reader(xml_file)

all_demog = read.csv("inst/ixi_demog_all.csv", stringsAsFactors = FALSE)

################################################
#
################################################


library(httr)
uri = df$url[2]

#########################################################
# Getting map from NITRC to IXI ID
#########################################################
uids = df[ df$mod %in% "T2", ]
uids$mod = NULL
uids$ixi_id = NA
rownames(uids) = NULL
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

stopifnot(all(demog$Subject %in% xuids$Subject))
all_demog = merge(demog, xuids, by = "Subject", all.x = TRUE)

##########################################
# Function Down here
##########################################

dler = function(uri,
                username = myusername,
                password = mypassword,
                root_dir = ".",
                verbose = TRUE) {
  if (verbose) {
    message(uri)
  }
  outfile = file.path(tempdir(), "IXI_Image_Data.zip")
  if (file.exists(outfile)) {
    file.remove(outfile)
  }


  r1 = GET(uri,
           write_disk(outfile, overwrite = TRUE),
           authenticate(user = username, password = password, type = "basic"),
           progress())
  uname = r1$all_headers[[1]]$headers$`content-disposition`
  uname = sub('.*filename="(.*)".*', "\\1", uname)
  uname = sub("[.]zip$", "", uname)

  zz = unzip(outfile, list = TRUE)
  zz = zz$Name[ !grepl("SNAPSHOTS", zz$Name) ]
  id_dir = sub("(.*)scans.*", "\\1", zz)
  id_dir = unique(id_dir)
  id_dir = file.path(root_dir, id_dir)
  # .Platform$file.sep

  retfile = unzip(outfile, files = zz, exdir = id_dir, junkpaths = TRUE)
  return(retfile)
}

sapply(df$url[1:5], dler)