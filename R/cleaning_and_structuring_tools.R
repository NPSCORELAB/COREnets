#' @title From Dataframe to Adjacency or Incidence Matrix
#'
#' @description `to_adj_matrix` returns a `matrix` with the values tibble imported from an excel file.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .df, A `df` produced by the `read_xlsx` function.
#' @param .rownames, A column value for the row that will be reassigned as rownames and then removed from the data frame.
#'
#' @export
to_matrix <- function(.df, .rownames = 1) {
  if (!is.data.frame(.df)) {
    stop("Not a data frame.", call. = FALSE)
  }
  if (!is.numeric(.rownames)) {
    stop("rownames value provided in not numeric", call. = FALSE)
  }
  
  .df <- as.matrix(.df)
  row.names(.df) <- .df[ ,.rownames]
  .df <- .df[ ,-.rownames]
  
  if (NROW(.df) != NCOL(.df)) message("An incidence matrix will be returned")
  if (NROW(.df) == NCOL(.df)) message("An adjacency matrix will be returned.")
  
  .df
}

#' @title Graph Matrices as `igraph` graphs
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .mat, A `matrix` produced by the `to_adj_matrix` function.
#' @param directed, Logical argument to specify whether or not a network is to graphed as directed or not.
#' 
#' @importFrom igraph graph_from_adjacency_matrix graph_from_incidence_matrix
#'
#' @export
to_graph <- function(.mat, .directed=FALSE, ...) {
  if (!is.matrix(.mat)==TRUE) {
    stop("Object provided is not a matrix.", call. = FALSE)
  }
  
  # Two-mode data
  if (NROW(.mat) != NCOL(.mat)) {
    g <- graph_from_incidence_matrix(.mat)
  }
  
  # One-mode
  g <- graph_from_adjacency_matrix(.mat,
                                   mode = ifelse(.directed == FALSE,
                                                 "undirected",
                                                 "directed"))
  g
}

#' @title Transform to one-mode
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .g, An `igraph` object produced by the `to_graph` function.
#' @param project, Projection type for igraph to extract. "rows" will extract a one-mode matrix of rows-to-rows, while "columns" will extract a one-mode matrix of colums-to-columns.
#' 
#' @importFrom igraph is.bipartite bipartite.mapping is.igraph bipartite.projection V
#'
#' @export
to_one_mode <- function(.g, project="rows", ...) {
  if (!is.igraph(.g)) {
    stop("Object provided is not an igraph object, try again.", call. = FALSE)
  }
  if (!is.character(project) && project != "rows" | project != "columns") {
    stop("'project' value provided is not a string, only 'rows' and 'columns' strings are accepted.", call. = FALSE)
  }
  
  if (is.bipartite(g)) {
    if (project == "rows") {
      g <- bipartite.projection(.g)$proj1
    }
    if (project == "columns") {
      g <- bipartite.projection(.g)$proj2
    }
  }
  
  g
}

#' @title Read Relational Excels
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .path, A path to the workbook with multiple relational and non-relational network data.
#' 
#' @importFrom readxl excel_sheets read_excel
#' @importFrom purrr map set_names
#' @importFrom magrittr %>%
#' 
#' @usage 
#' listed_df <- get_xlsx("datasets/Afghan Tribal Networks.xlsx")
#' 
#' @export
extract_xlsx <- function(.path) {
  if (!endsWith(basename(.path), "xlsx")) {
    stop("Path provided did not end with the .xlsx extension expercted", call. = FALSE)
  }
  
  listed_tibbles <- .path %>%
    excel_sheets() %>%
    set_names() %>%
    map(
      ~ readxl::read_excel(path = .path, sheet = .x) %>%
        dplyr::as_tibble()
    )
  
  listed_tibbles
  }
