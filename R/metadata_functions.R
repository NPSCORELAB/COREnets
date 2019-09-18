#' @title Unnest Igraph Object by Edge Type
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @description `unnest_edge_types` extracts subnetworks based on the edge_type.
#'
#' @param g, An igraph object.
#' @param edge_type_name, String denoting edge type variable.
#' 
unnest_edge_types <- function(g, edge_type_name) {
  
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  if (!is.character(edge_type_name) || edge_type_name %!in% names(igraph::edge.attributes(g))) {
    stop("edge_type_attr_name must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  
  types <- unique(igraph::edge_attr(graph = g,
                                    name  = edge_type_name)
  )
  listed_graphs <- lapply(
    types,
    function(x) igraph::subgraph.edges(g,
                                       eids = which(
                                         igraph::E(g)$edge_type %in% x)
                          )
  )
  listed_graphs
}

#' @title Generate COREnets Graph Metadata
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param g, An `igraph` object.
#' @param codebook, A `data.frame` with metedata fields for each `edge_type` 
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
                                wanted_edge_type = unique(
                                  igraph::edge_attr(
                                    graph = g,
                                    name  = "edge_type")
                                  )
                                )
  
  metadata <- list(
    list(
      graph_metadata = list(
        is_bimodal   = fields[["is_bimodal"]],
        is_directed  = fields[["is_directed"]],
        is_dynamic   = fields[["is_dynamic"]],
        is_weighted  = fields[["is_weighted"]],
        has_loops    = test_loops(g),
        has_isolates = test_isolates(g)
      ),
      edges_metadata = list(
        count       = igraph::ecount(g),
        are_dynamic = fields[["is_dynamic"]]
        
        # TODO g? 
        # TODO igraph can't return sf objects
        # are_spatial = inherits(igraph::as_data_frame(g,
        # what = "edges"),
        # "sf")
      ),
      nodes_metadata = list(
        count         = igraph::vcount(g),
        classes       = get_node_classes(g),
        classes_count = length(get_node_classes(g))
        
        # TODO igraph can't retrun sf objects
        # are_spatial   = inherits(igraph::as_data_frame(g,
        # what = "vertices"),
        # "sf")
      )
    )
  )
  names(metadata) <- unique(
    igraph::edge_attr(
      graph = g,
      name  = "edge_type")
  )
  # Returns
  metadata
}


#' @title Return Metadata Fields from Codebook
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
get_codebook_fields <- function(codebook, wanted_edge_type) {
  if (!is.character(wanted_edge_type)) {
    stop("The edge_type argument provided is not a string.",
         call. = FALSE)
  }
  if (!is.data.frame(codebook)) {
    stop("The codebook provided is not a data.frame object.",
         call. = FALSE)
  }
  
  filtered_codebook <- codebook[codebook[["edge_type"]] == wanted_edge_type, ]
  
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
get_node_classes <- function(g, from_class = "from_class", to_class = "to_class") {
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  if (!is.character(from_class) || from_class %!in% names(igraph::edge.attributes(g))) {
    stop("from_class must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  if (!is.character(to_class) || to_class %!in% names(igraph::edge.attributes(g))) {
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
test_dynamic <- function(g) {
  if (!igraph::is_igraph(g)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  atts <- names(igraph::edge_attr(g))
  "edge_time" %in% atts
}
