#' @title Get Data
#'
#' @description `get_data` returns a `list` with metadata and network 
#' object required to generate a sociogram.
#'
#' @template author-bk
#'
#' @param dataset `<character>` Name of the desired data set.
#' @param quietly, `<logical>` Determines how to handle unusual conditions.
#' @param test `<logical>` Whether or not to run internal tests.
#' @template param-dots
#'
#' @seealso [list_data_sources()], [get_description()]
#'
#' @export
get_data <- function(dataset, quietly = TRUE, test = TRUE, ...) {
  if (!is.character(dataset) | length(dataset) != 1L) {
    stop("The dataset argument must be a scalar character.",
         call. = FALSE)
  }
  
  
  file_path <- .corenets_sys_file(
    sprintf("datasets/%s/%s.R", dataset, dataset)
  )
  
  
  if (!file.exists(file_path)) {
    stop("Can't find file: ", file_path, call. = FALSE)
  }
  
  foo <- parse(
    text = readr::read_lines(file_path)
  )
  

  if (quietly) {
    out <- withCallingHandlers(
      eval(foo),
      message = function(m) invokeRestart("muffleMessage"),
      warning = function(w) invokeRestart("muffleWarning")
    )
  } else {
    out <- eval(foo)
  }
  
  if (test) {
    suppressMessages(test_output(output = out))
  } else {
    out
  }
}


#' @title Read Data Description
#' 
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param dataset `<chr>` Name of desired data set.
#' 
#' @examples
#' get_description("drugnet")
#' 
#' 
#' @seealso [list_data_sources()], [get_data()]
#' 
#' @export
get_description <- function(dataset) {
  if (!is.character(dataset) | length(dataset) != 1L) {
    stop("The dataset argument must be a scalar character.",
         call. = FALSE)
  }
  file_path <- .corenets_sys_file(
    sprintf("datasets/%s/description.txt", dataset)
  )
  
  .corenets_read_lines(file_path)
}


#' @title List Available Data
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @examples 
#' list_data_sources()
#' 
#' @seealso [list_data_sources()], [get_description()]
#'
#' @export
list_data_sources <- function() {
  
  dir(.corenets_sys_file("datasets"))
  
}
