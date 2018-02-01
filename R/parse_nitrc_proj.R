#' @title Parse Project Information from NITRC List
#' @description Parses the list of projects from \code{\link{nitrc_remote_data}} to a
#' \code{data.frame} of projects with attributes
#'
#' @param proj List of projects returned from \code{\link{nitrc_remote_data}}
#' @param add_attr Should attributes be added (this will replicate multiple
#' records to the same ID)
#' @return \code{data.frame}
#' @export
#'
#' @examples \dontrun{
#' js = nitrc_remote_data(spec = "all")
#' proj = js$projects
#' doc_df = parse_nitrc_proj(proj)
#'}
#' @importFrom dplyr recode
parse_nitrc_proj = function(proj, add_attr = FALSE)  {


  na_mat = function(cnames) {
    df = matrix(nrow = 1, ncol = length(cnames))
    colnames(df) = cnames
    df = data.frame(df)
    return(df)
  }
  remove_null = function(x) {
    if (length(x) == 0) {
      x = NA
    }
    return(x)
  }

  attr_names = c("attr_id", "attr_name")
  proj_names = c("id", "name", "homepage", "unix_name", "description",
                 "review_url", "source", "news_rss_url")
  p = lapply(proj, function(x){
    a = x$attributes
    x = x[proj_names]
    if (length(a) == 0){
      a = na_mat(proj_names)
    } else {
      a = lapply(a, unlist)
      a = lapply(a, function(x) {
        x = t(x)
        x = as.data.frame(x, stringsAsFactors = FALSE)
        x
      })
      a = do.call("rbind", a)
      colnames(a) = dplyr::recode(colnames(a),
                                  "id" = "attr_id",
                                  "fullname" = "attr_name")
    }
    x = lapply(x, remove_null)
    x = as.data.frame(x, stringsAsFactors = FALSE)
    if (add_attr) {
      x = merge(a, x, all = TRUE)
    }

    return(x)
  })
  p = do.call("rbind", p)
  colnames(p) = dplyr::recode(colnames(p),
                              "id" = "proj_id",
                              "name" = "proj_name")

  return(p)
}
