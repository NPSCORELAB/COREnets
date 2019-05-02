#' @title From Tibble to Adjacency or Incidence Matrix
#'
#' @description `to_adj_matrix` returns a `matrix` with the values tibble imported from an excel file.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .df, A `df` produced by the `read_xlsx` function.
#' 
#' @importFrom tibble is_tibble
#'
#' @export
to_matrix <- function(.df){
  if(is_tibble(.df) | is.data.frame(.df)){
    .df <- as.matrix(.df)
    row.names(.df) <- .df[,1]
    .df <- .df[,-1]
    
    if(nrow(.df)==ncol(.df)){
      cat("An adjacency matrix will be returned.")
      return(.df)
    }
    else{
      cat("An incidence matrix will be returned.")
      return(.df)
    }
  }
  else{
    stop("Data provided is not a tibble.", call. = FALSE)
  }
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
to_graph <- function(.mat, directed=FALSE, ...){
  if(is.matrix(.mat)) {
    if(nrow(.mat) == ncol(.mat)) {
      if(directed == FALSE){
        g <- graph_from_adjacency_matrix(.mat, mode = "undirected")
      }
      if(directed == TRUE) {
        g <- graph_from_adjacency_matrix(.mat, mode = "directed")
      }
    }
    if(nrow(.mat)!=ncol(.mat)) {
      g <- graph_from_incidence_matrix(.mat)
    }
  }
  else{
    stop("Object provided is not a matrix.", call. = FALSE)
  }
  return(g)
}

#' @title Transform to one-mode
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .g, An `igraph` object produced by the `to_graph` function.
#' @param auto, Set whether this function automatically transforms data or do you control it. This is a logical argument.
#' @param project, Projection type for igraph to extract. "rows" will extract a one-mode matrix of rows-to-rows, while "columns" will extract a one-mode matrix of colums-to-columns.
#' 
#' @importFrom igraph is.bipartite bipartite.mapping is.igraph bipartite.projection V
#'
#' @export
to_one_mode <- function(.g, auto=TRUE, project="rows", ...){
  if(!is.igraph(.g)){
    stop("Object provided is not an igraph object, try again.", call. = FALSE)
  }
  if(!is.logical(auto)){
    stop("'auto' value provided is not a logical, only TRUE and FALSE logicals are accepted.", call. = FALSE)
  }
  if(!is.character(project)){
    stop("'project' value provided is not a string, only 'rows' and 'columns' strings are accepted.", call. = FALSE)
  }
  if(project == "rows" | project == "columns"){
  if(is.igraph(.g)){
    if(auto==TRUE){
      if(is.bipartite(.g)==FALSE){
        return(.g)
      }
      if(is.bipartite(.g)==TRUE){
        if(project=="rows"){
          g <- bipartite.projection(.g)$proj1
        }
        if(project=="columns"){
          g <- bipartite.projection(.g)$proj2
        }
        return(g)
      }
    }
    if(auto==FALSE){
      if(is.bipartite(.g)==FALSE){
        cat("Graph is one-mode, no need to transform.")
        return(.g)
      }
      if(is.bipartite(.g)==TRUE){
        choice <- menu(c("Yes", "No"), title=paste("Your network", deparse(substitute(.g)), "tested as bipartite, is this true?"))
        if(choice==1){
          V(.g)$type <- bipartite.mapping(.g)$type
          type_choice <- menu(c("Row -- Row (proj1)", "Column -- Column (proj2)"), title=paste("Select how to project the two-mode network."))
          if(type_choice==1){
            g <- bipartite.projection(.g)$proj1
          }
          if(type_choice==2){
            g <- bipartite.projection(.g)$proj2
          }
          return(g)
        }
        if(choice==2){
          cat("Cool, not a bipartate network, so no need to transform it")
          return(.g)
        }
      }
    }
  }
  }
  else {
    stop("'project' value provided is not valid, only 'rows' and 'columns' strings are accepted.", call. = FALSE)
  }
  }

#' @title Read Relational Excels
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .path, A path to the workbook with multiple relational and non-relational network data.
#' 
#' @importFrom readxl excel_sheets read_excel
#' @importFrom tidyselect ends_with
#' @importFrom purrr map
#' 
#' @usage 
#' listed_df <- get_xlsx("datasets/Afghan Tribal Networks.xlsx")
#' 
#' @export
get_xlsx <- function(.path){
  if(endsWith(basename(.path), "xlsx")){
    sheets <- readxl::excel_sheets(.path)
    listed_dfs <- purrr::map(sheets, function(X) readxl::read_excel(.path, sheet = X))
    names(listed_dfs) <- sheets
    return(listed_dfs)
  }
}
