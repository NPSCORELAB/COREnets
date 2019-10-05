
`%!in%` <- function(x, y){!(`%in%`(x,y))}

.map_chr <- function(.x, .f, ..., .n = 1L) {
  vapply(.x, .f, FUN.VALUE = character(.n), ...)
}


#' @keywords internal
#' 
#' @title Does a `proto_net` have loops?
#' 
#' Checks whether any `from` == `to` for the same edge.
#' 
#' @template param-proto_net
#'
.has_loops <- function(proto_net) {
  any(proto_net$network$edges_table$from == proto_net$network$edges_table$to)
}

#' @keywords internal
#' 
#' @title Is a `proto_net` multiplex?
#' 
#' Checks if there are duplicate unique rows or multiple `edge_class`es.
#' 
#' @template param-proto_net
#' 
.is_multiplex <- function(proto_net) {
  el_df <- proto_net$network$edges_table[, c("from", "to")]
  
  if (nrow(el_df) > nrow(unique(el_df))) {
    return(TRUE)
  }
  
  length(unique(proto_net$network$edges_table$edge_class)) > 1L
}


#' @keywords internal
#' 
#' @title Is a `proto_net` bimodal?
#' 
#' Checks `is_bimodal` in codebook.
#' 
#' @template param-proto_net
#' 
.is_bimodal <- function(proto_net) {
  proto_net$reference$codebook$is_bimodal
}


#' @keywords internal
#' 
#' @title `system.file()` wrapper
#' 
#' Use to access files in `inst/`!
#' 
#' @param file_path Path of target file relative to `/inst` (in development mode).
#' 
#' 
.corenets_sys_file <- function(file_path) {
  stopifnot(is.character(file_path) && length(file_path) == 1L)
  system.file(file_path, package = "COREnets", mustWork = TRUE)
}


#' @keywords internal
#' 
#' @title `readLines()`/`readr::read_lines()` wrapper
#' 
#' Use in place of `readr::read_lines()` or `base::readLines()` so we can 
#' more easily change dependencies later.
#' 
#' @param file_path Path of target file relative to `/inst` (in dev. mode).
#' @template param-dots
#' 
.corenets_read_lines <- function(file_path, ...) {
  readr::read_lines(file = file_path, ...)
}


#' @keywords internal
#' 
#' @title `readr::read_csv()` wrapper
#' 
#' Use in place of `readr::read_csv()` so we can 
#' more easily change dependencies later.
#' 
#' @param file_path Path of target file relative to `/inst` (in dev. mode).
#' @template param-dots 
#' 
.corenets_read_csv <- function(file_path, ...) {
  readr::read_csv(file = file_path, ...)
}


#' @keywords internal
#' 
#' @title `igraph::as_data_frame()` wrapper
#' 
#' Use in place of `igraph::as_data_frame()`/`igraph::get.data.frame()`.
#' 
#' @param igraph `<igraph>`
#' @param .names `<lgl>` Whether the `"from"` and `"to"` columns contain node
#'  `"name"`s or numerical indices.
#' 
.corenets_as_edge_df <- function(igraph, .names = TRUE) {
  if (.names) {
    return(igraph::as_data_frame(igraph))
  }
  
  el <- igraph::as_edgelist(igraph, names = FALSE)
  colnames(el) <- c("from", "to")
  cbind.data.frame(el, igraph::edge_attr(igraph), stringsAsFactors = FALSE)
}
