#' @title Unnest Igraph Object by Edge Type
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @description `unnest_edge_classs` extracts subnetworks based on the edge_class.
#'
#' @param g, An igraph object.
#' @param edge_class_name, String denoting edge type variable.
#' 
unnest_edge_class <- function(g, edge_class_name) {
  
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  if (!is.character(edge_class_name) || !edge_class_name %in% names(igraph::edge.attributes(g))) {
    stop("edge_class_attr_name must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  
  types <- unique(igraph::edge_attr(graph = g,
                                    name  = edge_class_name)
  )
  listed_graphs <- lapply(
    types,
    function(x) igraph::subgraph.edges(g,
                                       eids = which(
                                         igraph::E(g)$edge_class %in% x)
                          )
  )
  listed_graphs
}

#' @title Generate COREnets Graph Metadata
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param g, An `igraph` object.
#' @param codebook, A `data.frame` with metedata fields for each `edge_class` 
#' in the graph object.
#'               
generate_graph_metadata <- function(g, codebook) {
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  if (!is.data.frame(codebook)) {
    stop("The codebook provided is not a data.frame object.",
         call. = FALSE)
  }
  
  fields <- get_codebook_fields(codebook = codebook,
                                wanted_edge_class = unique(
                                  igraph::edge_attr(
                                    graph = g,
                                    name  = "edge_class")
                                  )
                                )
  
  metadata <- list(
    edge_class   = unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class")),
    is_bimodal   = fields[["is_bimodal"]],
    is_directed  = fields[["is_directed"]],
    is_dynamic   = fields[["is_dynamic"]],
    is_weighted  = fields[["is_weighted"]],
    has_loops    = test_loops(g),
    has_isolates = test_isolates(g),
    edge_count   = as.numeric(igraph::ecount(g)),
    node_count   = as.numeric(igraph::vcount(g)),
    node_classes = as.numeric(length(get_node_classes(g)))
    )
  
  # Returns
  metadata
}

#' @title Return Metadata Fields from Codebook
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param codebook, A `data.frame` with metedata fields for each `edge_class` 
#' @param wanted_edge_class, A `character` matching a value in the `edge_class` variable in the codebook
#' 
get_codebook_fields <- function(codebook, wanted_edge_class) {
  if (!is.character(wanted_edge_class)) {
    stop("The edge_class argument provided is not a string.",
         call. = FALSE)
  }
  if (!is.data.frame(codebook)) {
    stop("The codebook provided is not a data.frame object.",
         call. = FALSE)
  }
  
  filtered_codebook <- codebook[codebook[["edge_class"]] == wanted_edge_class, ]
  
  if (NROW(filtered_codebook) != 1) {
    stop("Returned filtered_codebook contains unexpected number of rows.",
         call. = FALSE)
  }
  
  filtered_codebook
}


#' @title Testing for Loops
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param g, An `igraph` object. 
#' 
test_loops <- function(g) {
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  
  (TRUE %in% igraph::is.loop(g))
}


#' @title Testing for Isolates
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param g, An `igraph` object. 
#' 
test_isolates <- function(g) {
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  
  temp <- igraph::simplify(g,
                           remove.loops = TRUE)
  (0 %in% igraph::degree(temp))
}


#' @title Testing for Isolates
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param g, An `igraph` object.
#' @param from_class, A string pointer to variable containing the node class for the `from` column
#' @param to_class, A string pointer to variable containing the node class for the `to` column
#'
get_node_classes <- function(g, from_class = "from_class", to_class = "to_class") {
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  if (!is.character(from_class) || !from_class %in% names(igraph::edge.attributes(g))) {
    stop("from_class must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  if (!is.character(to_class) || !to_class %in% names(igraph::edge.attributes(g))) {
    stop("to_class must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  
  classes <- unique(
    c(
      igraph::edge_attr(graph = g,
                        name  = from_class),
      igraph::edge_attr(graph = g,
                        name  = to_class)
    )
  )
  classes
}

#' @title Testing for Dynamic Edges
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param g, An `igraph` object.
#'
test_dynamic <- function(g) {
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  atts <- names(igraph::edge_attr(g))
  "edge_time" %in% atts
}
