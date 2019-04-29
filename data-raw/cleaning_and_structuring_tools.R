#' @title From Tibble to Adjacency or Incidence Matrix
#'
#' @description `to_adj_matrix` returns a `matrix` with the values tibble imported from an excel file.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .df, A `df` produced by the `read_xlsx` function
#'
#' @export
to_adj_matrix <- function(.df){
  if(is_tibble(.df)){
    .df <- as.matrix(.df)
    row.names(.df) <- .df[,1]
    .df <- .df[,-1]
    
    if(nrow(.df)==ncol(.df)){
      cat("Output will be adjacency matrix.")
      return(.df)
    }
    else{
      cat("Output will not be adjacency matrix, it may be an incidence matrix. Please revise your input.")
      return(.df)
    }
  }
  else{
    stop("Data provided is not a tibble.", call. = FALSE)
  }
}