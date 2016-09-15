rm(list = ls())
# download_nitric_ir
library(base64enc)
library(xml2)
library(httr)
source("credentials.R")
username = rawToChar(base64decode(myusername))
password = rawToChar(base64decode(mypassword))

xml_file = "inst/ixi_all_data.xml"
df = xcat_reader(xml_file)

all_demog = read.csv("inst/ixi_demog_all.csv", stringsAsFactors = FALSE)

df = merge(df, all_demog, by = "id", all.x = TRUE)

################################################
#
################################################
uri = df$url[2]

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

  L = download_nitrc_url(
    username = username,
    password = password,
    nitrc_url = uri,
    outfile = outfile,
    fileext = ".zip",
    overwrite = TRUE)
  r1 = L$ret

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