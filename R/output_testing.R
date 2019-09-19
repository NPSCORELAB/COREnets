
test_output <- function(output) {
  if (!is.list(output) | length(output) != 2L) {
    stop("The output to test must be a list with a lenght = 2.",
         call. = FALSE)
  }
  metadata_test   <- check_metadata(output)
  edge_names_test <- check_edge_names_metadata(output)
  ### TODO GRAPH TEST WILL GO HERE
  edges_test      <- check_edges_table(output)
  nodes_test      <- check_nodes_table(output)
  
  if(!all(metadata_test)){
    print("ERROR: TDB 1")
  }
  message("No metadata fields missing!")
  
  if(!all(edge_names_test)){
    print("ERROR: TDB 2")
  }
  message("No missing metadata lists for the edges provided!")
  
  if(!all(edges_test)){
    print("ERROR: TDB 3")
  }
  message("All required edges fields are present and vector types are valid!")
  
  if(!all(nodes_test)){
    print("ERROR: TDB 4")
  }
  message("All required nodes fields are present and vector types are valid!")
}

check_metadata <- function(output) {
  if (!"metadata" %in% names(output)) {
    stop("The input provided does not include an element named 'metadata'",
         call. = FALSE)
  }
  
  tests <- list(
    title       = is.character,
    name        = is.character,
    tags        = is.character,
    description = is.character,
    abstract    = is.character,
    codebook    = is.data.frame,
    bibtex      = is.list,
    paper_link  = is.character
  )
  
  if (!all(names(tests) %in% names(output[["metadata"]])) ) {
    stop("Expected names do not match in the metadata.",
         call. = FALSE)
  }
  
  checked_types <- vapply(names(output[["metadata"]]),
                        function(x) tests[[x]](
                          output[["metadata"]][[x]]
                          ),
                        logical(1L)
                        )
  checked_types
}

check_edge_names_metadata <- function(output) {
  if (!"network" %in% names(output)) {
    stop("The input provided does not include an element named 'network'",
         call. = FALSE)
  }
  if (!"net_metadata" %in% names(output[["network"]])) {
    stop("There is no 'net_metadata' object within the 'network' element.",
    call. = FALSE)
  }
  
  edge_types <- output[["metadata"]][["codebook"]][["edge_type"]]
  
  checked_edge_lists <- vapply(
    .map_chr(output[["network"]][["net_metadata"]],
             names),
    function(x) x %in% edge_types,
    logical(1L)
    )
  
  checked_edge_lists
}

# TODO finish the edge_type_metadata test
# check_edge_type_metadata <- function(output) {
#   if ("network" %!in% names(output)) {
#     stop("The input provided does not include an element named 'network'",
#          call. = FALSE)
#   }
#   if ("net_metadata" %!in% names(output[["network"]])) {
#     stop("There is no 'net_metadata' object within the 'network' element.",
#          call. = FALSE)
#   }
#   graph_tests <- list(
#     is_bimodal   = is.logical,
#     is_directed  = is.logical,
#     is_dynamic   = is.logical,
#     is_weighted  = is.logical,
#     has_loops    = is.logical,
#     has_isolates = is.logical
#   )
#   edges_tests <- list(
#     count       = is.numeric,
#     are_dynamic = is.logical
#   )
#   nodes_tests <- list(
#     count         = is.numeric,
#     classes       = is.character,
#     classes_count = is.numeric
#   ) 
# }
# ###
# edge_types <- lapply(test[["network"]][["net_metadata"]],
#                      names)
# lapply(edge_types,
#        function(x) sapply(x,
#                           match(x, test))
#        )
# 
# lapply(test[["network"]][["net_metadata"]],
#        function(x) vapply(
#          .map_chr(test[["network"]][["net_metadata"]],
#                   names),
#          function(y) graph_tests[[y]](
#            test[["network"]][["net_metadata"]][[x]][[1]][[y]]
#          ),
#          logical(1L)
#          )
#        )
# test[["network"]][["net_metadata"]][[]][["Hang Out Together"]]
# 
# 
# 

check_edges_table <- function(output) {
  if (!"network" %in% names(output)) {
    stop("The input provided does not include an element named 'network'",
         call. = FALSE)
  }
  if (!"edges_table" %in% names(output[["network"]])) {
    stop("There is no 'edges_table' object within the 'network' element.",
         call. = FALSE)
  }
  
  tests <- list(
    from       = is.character,
    to         = is.character,
    from_class = is.character,
    to_class   = is.character,
    edge_type  = is.character  
    )
  
  if (!all(names(tests) %in% names(output[["network"]][["edges_table"]]))) {
    stop("One or more required fields is missing from the 'edges_table'.",
         call. = FALSE)
  }
  
  checked_types <- vapply(names(tests),
                          function(x) tests[[x]](
                            output[["network"]][["edges_table"]][[x]]
                          ),
                          logical(1L)
  )
  
  checked_types
}

check_nodes_table <- function(output) {
  if (!"network" %in% names(output)) {
    stop("The input provided does not include an element named 'network'",
         call. = FALSE)
  }
  if (!"nodes_table" %in% names(output[["network"]])) {
    stop("There is no 'nodes_table' object within the 'network' element.",
         call. = FALSE)
  }
  
  tests <- list(
    name       = is.character,
    node_class = is.character
  )
  
  if (!all(names(tests) %in% names(output[["network"]][["nodes_table"]]))) {
    stop("One or more required fields is missing from the 'nodes_table'.",
         call. = FALSE)
  }
  
  checked_types <- vapply(names(tests),
                          function(x) tests[[x]](
                            output[["network"]][["nodes_table"]][[x]]
                          ),
                          logical(1L)
  )
  
  checked_types
}
