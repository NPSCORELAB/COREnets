#' @title Get Data
#'
#' @description `get_data` returns a `list` with metadata and network 
#' object required to generate a sociogram.
#'
#' @author Brendan Knapp, \email{brendan.knapp@@nps.edu}
#'
#' @param dataset, the name of the dataset desired.
#'
#' @export
get_data <- function(dataset) {
  
  if (!is.character(dataset)) {
    stop("The dataset argument must be a character.",
         call. = FALSE)
  }
    
  file_path <- sprintf("inst/datasets/%s/%s.R", dataset, dataset)
  
  foo <- parse(text = readLines(file_path,
                                warn = FALSE)
               )
  
  eval(expr = foo)
}

#' @title List Available Data
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @export
list_data_sources <- function() {
  
  list.dirs(path = "inst/datasets/",
            full.names = FALSE,
            recursive = FALSE)
  
}