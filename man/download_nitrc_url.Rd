% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_nitrc_url.R
\name{download_nitrc_url}
\alias{download_nitrc_url}
\title{Download NITRC URL}
\usage{
download_nitrc_url(username, password,
  nitrc_url = "http://www.nitrc.org/frs/downloadlink.php/2204",
  outfile = NULL, fileext = ".tar.bz2", overwrite = FALSE)
}
\arguments{
\item{username}{username for authentication}

\item{password}{password for authentication}

\item{nitrc_url}{URL to download}

\item{outfile}{output filename}

\item{fileext}{if \code{outfile = NULL},}

\item{overwrite}{Should the \code{outfile} be overwritten}
}
\value{
List of 2 elements, return of \code{GET}, and output filename
}
\description{
Download URL from NITRC
}
