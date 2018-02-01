#' @title Parse Documents from NITRC List
#' @description Parses the list of projects from \code{\link{nitrc_remote_data}} to a
#' \code{data.frame} of documents
#'
#' @param proj List of projects returned from \code{\link{nitrc_remote_data}}
#' @param long logical indicator if the \code{data.frame} should be returned
#' long or wide
#'
#' @return \code{data.frame}
#' @export
#'
#' @examples \dontrun{
#' js = nitrc_remote_data(spec = "all")
#' proj = js$projects
#' doc_df = parse_nitrc_docs(proj)
#'}
#' @importFrom tidyr spread
#' @importFrom reshape2 melt
#' @importFrom dplyr filter mutate "%>%"
parse_nitrc_docs = function(proj, long = FALSE)  {

  variable = value = NULL
  rm(list = c("variable", "value"))
  docs = lapply(proj, function(x) {
    x$document_groups
  })

  # doc_names = c("id", "name", "documents")

  make_mat = function(r){
    n = names(r)
    r = matrix(r, nrow = 1)
    colnames(r) = n
    r = r[, c("id", "name", grep("^documents", n, value = TRUE)), drop = FALSE]
    r = as.data.frame(r, stringsAsFactors = FALSE)
    add = FALSE
    if (ncol(r) == 2) {
      add = TRUE
    }
    r = reshape2::melt(r, id.vars = c("id", "name"))
    if (add) {
      r$variable = r$value = NA
    }
    return(r)
  }
  # x = docs[[798]]
  ##################################
  # Get the documents into a data.frame
  ##################################
  doc_df = lapply(docs, function(x) {
    if (length(x) == 0) {
      mat = data.frame(id = NA, name = NA, value = NA, variable = NA)
    } else {
      mat = lapply(x, unlist)
      mat = lapply(mat, make_mat)
      mat = do.call("rbind", mat)
    }
    mat
  })

  ##################################
  # Add project information
  ##################################
  doc_df = mapply(function(ind, df, project) {
    df$proj_ind = ind
    df$proj_name = project$name
    df$proj_id = project$id
    return(df)
  }, seq_along(doc_df), doc_df, proj, SIMPLIFY = FALSE)

  # bind it all together
  doc_df = do.call("rbind", doc_df)
  doc_df = doc_df %>%
    filter(!is.na(value))
  var_names = c("documents.creation_date", "documents.description", "documents.id",
                "documents.title", "documents.update_date", "documents.url")
  stopifnot(all(sort(unique(doc_df$variable)) %in% var_names))

  doc_df = doc_df %>%
    mutate(variable = sub("^documents[.]", "", variable))

  if (!long) {
    doc_df = doc_df %>%
      filter(variable %in% c("description", "title", "url"))

    doc_df = tidyr::spread(doc_df, variable, value )
  }
  return(doc_df)
}
