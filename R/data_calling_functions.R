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
get_data <- function(dataset, quietly = TRUE) {
  if (!is.character(dataset) | length(dataset) != 1L) {
    stop("The dataset argument must be a scalar character.",
         call. = FALSE)
  }
    
  file_path <- sprintf("inst/datasets/%s/%s.R", dataset, dataset)
  
  if (!file.exists(file_path)) {
    stop("Can't find file: ", file_path, 
         call. = FALSE)
  }
  
  foo <- parse(
    text = readLines(file_path, warn = FALSE)
  )
  
  if (quietly) {
    withCallingHandlers(
      eval(foo),
      message = function(m) invokeRestart("muffleMessage"),
      warning = function(w) invokeRestart("muffleWarning")
    )
  } else {
    eval(foo)
  }
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