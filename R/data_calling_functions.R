#' @title Get Data
#'
#' @description `get_data` returns a `list` with metadata and network 
#' object required to generate a sociogram.
#'
#' @template author-bk
#'
#' @param dataset `character(1L)` Name of the desired data set.
#' @param validate, `logical(1L)`, Default: `TRUE` Whether to run data validation routine.
#' @param quietly, `logical(1L)` Whether to muffle messages during data set construction.
#' @template param-dots
#'
#' @seealso [list_data_sources()], [get_description()]
#'
#' @export
get_data <- function(dataset, quietly = TRUE, validate = TRUE, ...) {
  if (!is.character(dataset) || length(dataset) != 1L) {
    stop("The dataset argument must be a scalar character.",
         call. = FALSE)
  }
  
  
  file_path <- tryCatch(
    .corenets_sys_file(sprintf("datasets/%s/%s.R", dataset, dataset)),
    error = function(e) NULL
  )
  
  
  if (is.null(file_path)) {
    msg <- c("Can't find file: \n\t-", dataset)
    
    suggestions <- agrep(dataset, list_data_sources(), ignore.case = TRUE, value = TRUE)
    if (!.is_empty(suggestions)) {
      msg <- c(msg, "\nDid you mean one of the following?", paste("\n\t-", suggestions))
    }
    
    stop(msg, call. = FALSE)
  }
  
  foo <- parse(
    text = .corenets_read_file(file_path)
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
  
  if (validate) {
    validate_proto_net(out)
  }
  
  structure(
    out,
    class = "proto_net"
  )
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
