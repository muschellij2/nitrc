

#' @title Parse Packages from NITRC List
#' @description Parses the list of projects from \code{\link{nitrc_remote_data}} to a
#' \code{data.frame} of packages
#'
#' @param proj List of projects returned from \code{\link{nitrc_remote_data}}
#' @return \code{data.frame}
#' @export
#'
#' @examples \dontrun{
#' js = nitrc_remote_data(spec = "all")
#' proj = js$projects
#' doc_df = parse_nitrc_packs(proj)
#'}
#' @importFrom tidyr spread
#' @importFrom reshape2 melt
#'
parse_nitrc_packs = function(proj)  {

  packs = lapply(proj, function(x) {
    x$packages
  })


  # i = 1

  # pack = packs[[2]]

  na_mat = function(cnames) {
    df = matrix(nrow = 1, ncol = length(cnames))
    colnames(df) = cnames
    df = data.frame(df)
    return(df)
  }

  doc_df = lapply(packs, function(pack) {
    # print(i)

    cnames = c("id", "name", "type", "processor", "download_count", "url",
               "release_id", "release_name", "package_id", "package_name")
    blank_rel_ids = na_mat(cnames)

    if (length(pack) == 0) {
      rels = blank_rel_ids
    } else {

      #####################################
      # Getting Package information
      #####################################
      # sub_pack = pack[[1]]
      remove_null = function(x) {
        if (length(x) == 0) {
          x = NA
        }
        return(x)
      }

      #####################################
      # Getting the releases
      #####################################
      rels = lapply(pack, function(sub_pack) {
        # xx$releases
        # })
        id = remove_null(sub_pack$id)
        name = remove_null(sub_pack$name)
        stopifnot(length(id) == 1)
        stopifnot(length(name) == 1)
        df = data.frame(id = id, name = name, stringsAsFactors = FALSE)

        r = sub_pack$releases
        # rel_ids = lapply(rels, function(r) {

        if (length(r) == 0 ) {
          return(blank_rel_ids)
        }
        ids = lapply(r, function(xx) {
          id = remove_null(xx$id)
          name = remove_null(xx$name)
          stopifnot(length(id) == 1)
          stopifnot(length(name) == 1)

          files = lapply(xx$files, unlist)
          file_fields = c("id", "name", "type", "processor",
                          "download_count", "url")
          if (length(files) == 0) {
            files = na_mat(file_fields)
          } else {
            files = lapply(files, function(xxx) {
              xxx = xxx[file_fields]
              xxx = matrix(xxx, nrow = 1)
              colnames(xxx) = file_fields
              xxx = data.frame(xxx, stringsAsFactors = FALSE)
              xxx
            })
            files = do.call("rbind", files)
          }
          files$release_id = id
          files$release_name = name
          return(files)
        })
        ids = do.call("rbind", ids)
        ids$package_id = df$id
        ids$package_name = df$name
        return(ids)
      })
      rels = do.call("rbind", rels)
    }
    # i <<- i + 1
    rels
  })

  doc_df = mapply(function(ind, df, project) {
    df$proj_ind = ind
    df$proj_name = project$name
    df$proj_id = project$id
    return(df)
  }, seq_along(doc_df), doc_df, proj, SIMPLIFY = FALSE)

  doc_df = do.call("rbind", doc_df)
  doc_df = doc_df %>%
    filter(!is.na(url))

  return(doc_df)
}
