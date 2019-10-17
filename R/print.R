#' Generate S3 proto_net generic function
#' @param x An R object
#' @export
proto_net <- function(x) {
  UseMethod("proto_net")
}

#' Is this object a proto_net?
#' 
#' @template author-cc
#' 
#' @description Logical test for proto_net objects.
#' 
#' @param pn An R object.
#' @export
is_proto_net <- function (pn) {
  inherits(pn, "proto_net")
}

#' proto_net print method
#' 
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param x The object to print, should be "proto_net" class.
#' @param ... Extra arguments to pass to \code{print()}.
#' @export 
print.proto_net <- function(x, ...) {
  .print_header(x)
  lapply(names(x[["network"]][["metadata"]]),
         function(y) {
           .print_edge_class_attr(x[["network"]][["metadata"]][[y]])
         })  
  cat("\n")
  .print_edge_table(x[["network"]][["edges_table"]],
                    n = 3)
  cat("\n")
  .print_node_table(x[["network"]][["nodes_table"]])
}

#' @keywords internal
#' 
#' @title Print header line for \code{proto_net} object
#' 
#' @template author-cc
#' 
#' @param pn The object to print, should be "proto_net" class.
#' @param ... Extra arguments to pass to \code{print()}.
#' 
.print_header <- function(pn, ...) {
  if (!is_proto_net(pn)) {
    stop("Not a proto_net graph object.",
         call. = FALSE)
  }
  title <- paste(sep = "",
                 "PROTO_NET ",
                 pn[["reference"]][["name"]],
                 " Nodes:",
                 .count_nodes(pn),
                 " Edges:",
                 .count_edges(pn),
                 "\n")
  cat(title)
}

#' @keywords internal
#' 
#' @title Print metadata for all edge_classes
#' 
.print_edge_class_attr <- function(.list, ...) {
  if (!is.list(.list)) {
    stop("Not a list object.",
         call. = FALSE)
  }
  cat(
    .list[["edge_class"]],
    "\n"
    )
  cat(
    sep = "",
    " +",
    c("-", "B")[isTRUE(.list[["is_bimodal"]])+1],
    c("U", "D")[isTRUE(.list[["is_directed"]])+1],
    c("-", "D")[isTRUE(.list[["is_dynamic"]])+1],
    c("-", "W")[isTRUE(.list[["is_weighted"]])+1],
    " ",
    "E:", .list[["edge_count"]], " ",
    "N:", .list[["node_count"]], " ",
    "NC:", .list[["node_classes"]],
    "\n"
    )
  invisible(NULL)
}

#' @keywords internal
#' @title Print edge table
#' @importFrom utils head
#' 
.print_edge_table <- function(edge_table, n, ...) {
  if (!is.data.frame(edge_table)) {
    stop("The edge_table provides is not a data.frame.",
         call. = FALSE)
  }
  if (!is.numeric(n)) {
    stop("n provided is not a number.",
         call. = FALSE)
  }
  
  wanted <- c("from", "from_class", "to", "to_class", "edge_class")
  cat("Edge list: \n")
  print(
    head(
      edge_table[wanted],
      n
      ),
    row.names = FALSE
    )
  cat(NROW(edge_table)-n, "entries not printed. \n")
  cat(sep = "",
      " +",
      " Edge attributes: ",
      .print_edge_table_attrs(edge_table,
                              wanted = wanted),
      "\n")
}

#' @keywords internal
#' @title Print node table
#' 
.print_node_table <- function(node_table, max.print = 10) {
  # TODO getOption("max.print") rather than the current fix.
  if (!is.data.frame(node_table)) {
    stop("The node_table provides is not a data.frame.",
         call. = FALSE)
  }
  
  temp <- vapply(
    names(node_table),
    function(x) {
      paste0(
        x,
        "<",
        .refactor_classes(
          class(x)
          ),
        ">") 
    },
    FUN.VALUE = "character")
  
  if (length(temp) > max.print) {
    for_print <- paste(
      paste(temp[1:max.print],
            collapse =  " "),
      " ...",
      length(temp) - max.print,
      " attribute(s) not printed."
      )
  } else {
    for_print <- paste(temp, collapse = " ")
  }
  
  cat("Node list: \n")
  cat(
    sep = "",
    " +",
    " Node attributes: ",
    for_print
    )
}

#' @keywords internal
#' @title Print edge table attributes
#' 
.print_edge_table_attrs <- function(edge_table, wanted){
  if (!is.data.frame(edge_table)) {
    stop("The edge_table provides is not a data.frame.",
         call. = FALSE)
  }
  temp <- vapply(
        names(edge_table),
        function(x) {
          paste0(
            x,
            "<",
            .refactor_classes(
              class(x)
              ),
            ">"
          ) 
         },
        FUN.VALUE = "character")
  paste(temp[!names(temp) %in% wanted],
        collapse = " ")
}

#' @keywords internal
#' @title Count nodes
#' 
.count_nodes <- function(pn) {
  if (!is_proto_net(pn)) {
    stop("Not a proto_net graph object.",
         call. = FALSE)
  } 
  if (!"network" %in% names(pn)) {
    stop("network list item is not found in proto_net object.")
  }
  
  NROW(
    unique(
      pn[["network"]][["nodes_table"]][["name"]]
    )
  )
}

#' @keywords internal
#' @title Count edges
#' 
.count_edges <- function(pn) {
  if (!is_proto_net(pn)) {
    stop("Not a proto_net graph object.",
         call. = FALSE)
  } 
  if (!"network" %in% names(pn)) {
    stop("network list item is not found in proto_net object.")
  }
  NROW(
    unique(
      pn[["network"]][["edges_table"]]
    )
  )
}

#' @keywords internal
#' @title Refactor data classes
#'
.refactor_classes <- function(chr) {
  if(!is.character(chr)) {
    stop("Not a character to refactor.",
         call. = FALSE)
  }
  old_classes <- c("character", "numeric", "integer", "logical")
  new_classes <- factor(
    c("chr", "num", "int", "lgl")
    )
  as.character(
    new_classes[match(
      chr, old_classes)]
    )
}