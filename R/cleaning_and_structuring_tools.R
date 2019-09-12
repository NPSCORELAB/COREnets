#' @title From Dataframe to Adjacency or Incidence Matrix
#'
#' @description `to_adj_matrix` returns a `matrix` with the values tibble 
#' imported from an excel file.
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .df, A `df` produced by the `read_xlsx` function.
#' @param .rownames, A column value for the row that will be reassigned as 
#' rownames and then removed from the data frame.
#'
#' @export
to_matrix <- function(.df, .rownames = 1) {
  if (!is.data.frame(.df)) {
    stop("Not a data frame.",
         call. = FALSE)
  }
  if (!is.numeric(.rownames)) {
    stop("rownames value provided in not numeric",
         call. = FALSE)
  }
  
  .df <- as.matrix(.df)
  row.names(.df) <- .df[, .rownames]
  .df <- .df[, -.rownames]
  
  if (NROW(.df) != NCOL(.df)) message("An incidence matrix will be returned")
  if (NROW(.df) == NCOL(.df)) message("An adjacency matrix will be returned.")
  
  .df
}

#' @title Graph Matrices as `igraph` graphs
#' 
#' @description `to_graph` returns an `igraph` object when provided with a 
#' matrix. The function evaluates the matrix and graphs either a bipartite 
#' graph or not.`
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .mat, A `matrix` produced by the `to_adj_matrix` function.
#' @param directed, Logical argument to specify whether or not a network is to 
#' graphed as directed or not.
#' 
#' @importFrom igraph graph_from_adjacency_matrix graph_from_incidence_matrix
#'
#' @export
to_graph <- function(.mat, .directed=FALSE, ...) {
  if (!is.matrix(.mat)==TRUE) {
    stop("Object provided is not a matrix.",
         call. = FALSE)
  }
  
  # Two-mode data
  if (NROW(.mat) != NCOL(.mat)) {
    g <- graph_from_incidence_matrix(.mat)
    return(g)
  }
  
  # One-mode
  g <- graph_from_adjacency_matrix(.mat,
                                   mode = ifelse(.directed == FALSE,
                                                 "undirected",
                                                 "directed"))
  g
}

#' @title Transform to one-mode
#' 
#' @description `to_one_mode` takes in an `igraph` object, tests if bipartite,
#' and proceeds to project the network. This evaluation can be also conducted on
#' one-mode networks, yet no action will occur.`
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param .g, An `igraph` object produced by the `to_graph` function.
#' @param project, Projection type for igraph to extract. "rows" will extract a 
#' one-mode matrix of rows-to-rows, while "columns" will extract a one-mode 
#' matrix of colums-to-columns.
#' 
#' @importFrom igraph is.bipartite bipartite.mapping is.igraph bipartite.projection V
#'
#' @export
to_one_mode <- function(.g, project = "rows", ...) {
  if (!is.igraph(.g)) {
    stop("Object provided is not an igraph object, try again.", call. = FALSE)
  }
  if (!is.character(project)) {
    stop("project value provided is not a string.",
         call. = FALSE)
  }

  valid_strings <- c("columns", "rows")

  if (!grepl(paste(valid_strings, collapse = "|"), x = project)) {
    stop("Project value invalid, only 'rows' and 'columns' strings are accepted.",
         call. = FALSE)
  }
  
  if (is.bipartite(.g)) {
    if (project == "rows") {
      .g <- bipartite.projection(.g)$proj1
    }
    if (project == "columns") {
      .g <- bipartite.projection(.g)$proj2
    }
  }

  .g
}

#' @title Read Multiple Tables from Excels
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @description `extract_xlsx` inspects excel documents for multiple tabs, then
#' proceeds to open these, and return all in a list as tibbles.
#'
#' @param .path, A path to the workbook with multiple relational and 
#' non-relational network data.
#' 
#' @importFrom readxl excel_sheets read_excel
#' @importFrom purrr map set_names
#' @importFrom magrittr %>%
#' 
#' @usage 
#' listed_df <- get_xlsx("datasets/Afghan Tribal Networks.xlsx")
#' 
#' @export
extract_xlsx <- function(.path) {
  if (!endsWith(basename(.path), "xlsx")) {
    stop("Path provided did not end with the .xlsx extension expected",
         call. = FALSE)
  }
  
  listed_tibbles <- .path %>%
    excel_sheets() %>%
    set_names() %>%
    map(
      ~ readxl::read_excel(path = .path, sheet = .x) %>%
        dplyr::as_tibble()
    )
  
  listed_tibbles
}

#' @title Unnest Igraph Object by Edge Type
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @description `unnest_edge_types` extracts subnetworks based on the edge_type.
#'
#' @param igraph_graph, An igraph object.
#' @param edge_type_attr_name, String denoting edge type variable.
#' 
#' @importFrom igraph edge_attr subgraph.edges is_igraph edge.attributes
#' 
#' @usage 
#' df <- data.frame(from = c("a", "a", "b"), to = c("a", "b", "c"), from_class = "agent", to_class = "agent", edge_type = c("self", "foo", "bar"))
#' unnest_edge_types(g, "edge_type")
#' 
#' @export
unnest_edge_types <- function(igraph_graph, edge_type_attr_name) {
  
  if (!is_igraph(igraph_graph)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  if (!is.character(edge_type_attr_name) || edge_type_attr_name %!in% names(edge.attributes(igraph_graph))) {
    stop("edge_type_attr_name must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  
  types <- unique(igraph::edge_attr(graph = igraph_graph,
                                    name  = edge_type_attr_name)
                  )
  listed_graphs <- lapply(types,
         function(x) subgraph.edges(igraph_graph,
                                    eids = which(
                                      E(igraph_graph)$edge_type %in% x)
                                    )
         )
  listed_graphs
}

#' @title Generate COREnets Graph Metadata
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#'
#' @param igraph_graph, An igraph object.
#' 
#' @importFrom igraph is_bipartite is_directed any_multiple is_weighted ecount vcount as_data_frame
#' 
#' @usage 
#' df <- data.frame(from = c("a", "a", "b"), to = c("a", "b", "c"), from_class = "agent", to_class = "agent", edge_type = c("self", "foo", "bar"))
#' g <- graph_from_data_frame(df)
#' unnest_edge_types(g, "edge_type") %>%
#'    purrr::map(~.x %>%
#'               generate_graph_metadata)
#'               
#' @export
generate_graph_metadata <- function(igraph_graph) {
  metadata <- list(
    list(
      graph_metadata = list(
        is_bimodal   = igraph::is_bipartite(igraph_graph),
        is_directed  = igraph::is_directed(igraph_graph),
        is_multiplex = igraph::any_multiple(igraph_graph),
        is_weighted  = igraph::is_weighted(igraph_graph),
        has_loops    = test_loops(igraph_graph),
        has_isolates = test_isolates(igraph_graph)
      ),
      edges_metadata = list(
        edges_count = ecount(igraph_graph),
        are_edges_spatial =  inherits(igraph::as_data_frame(g,
                                                            what = "edges"),
                                      "sf")
      ),
      nodes_metadata = list(
        nodes_count         = vcount(igraph_graph),
        nodes_classes       = get_node_classes(igraph_graph),
        nodes_classes_count = length(get_node_classes(igraph_graph)),
        nodes_spatial       = inherits(igraph::as_data_frame(igraph_graph,
                                                             what = "vertices"),
                                       "sf")
      )
      )
    )
  names(metadata) <- unique(igraph::edge_attr(graph = igraph_graph,
                                              name  = "edge_type")
  )
  # Returns
  metadata
}

#' @title Testing for Loops
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @importFrom igraph is_igraph is.loop
#' 
#' @export
test_loops <- function(igraph_graph) {
  if (!is_igraph(igraph_graph)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  
  (TRUE %in% is.loop(igraph_graph))
}

#' @title Testing for Isolates
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @importFrom igraph is_igraph simplify degree
#' 
#' @export
test_isolates <- function(igraph_graph) {
  if (!is_igraph(igraph_graph)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  
  temp <- igraph::simplify(igraph_graph,
                   remove.loops = TRUE)
  (0 %in% degree(temp))
}


#' @title Testing for Isolates
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @importFrom igraph is_igraph edge_attr
#'
get_node_classes <- function(igraph_graph, from_class = "from_class", to_class = "to_class") {
  if (!is_igraph(igraph_graph)) {
    stop("Graph provided is not and igraph object.",
         call. = FALSE)
  }
  if (!is.character(from_class) || from_class %!in% names(edge.attributes(igraph_graph))) {
    stop("from_class must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  if (!is.character(to_class) || to_class %!in% names(edge.attributes(igraph_graph))) {
    stop("to_class must as string and a valid edge attribute for the graph object.",
         call. = FALSE)
  }
  
  classes <- unique(
    c(
      edge_attr(graph = igraph_graph,
                name  = from_class),
      edge_attr(graph = igraph_graph,
                name  = to_class)
  )
  )
  # Return
  classes
}


