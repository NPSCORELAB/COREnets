#' @keywords internal
#' @title Testing for Expected Structures
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param output, A `list` object returned from the `get_data()` function.
#'
test_output <- function(output) {
  if (!is.list(output) | length(output) != 2L) {
    stop("The output to test must be a list with a lenght = 2.",
         call. = FALSE)
  }
  reference_test    <- check_reference(output)
  edge_classes_test <- check_edge_classes(output)
  metadata_test     <- check_metadata(output)
  edges_table_test  <- check_edges_table(output)
  nodes_table_test  <- check_nodes_table(output)
  
  if(!all(reference_test)) {
   warning(
     "Element(s): ",
     paste(
       names(
         which(
           !reference_test
           )
         ),
       collapse = " "
       ),
     " did not pass the check_reference() test."
     )
  }
  message("check_reference(): All 'reference' fields present and types are accurate.")
  
  if(!all(edge_classes_test)){
    warning(
      "Element(s): ",
      paste(
        names(
          which(
            !edge_classes_test
          )
        ),
        collapse = " "
      ),
      " did not pass the check_edges_classes() test."
    )
  }
  message("check_edges_classes(): Required 'edge_classes' are present in metadata and codebook.")
  
  if(!all(metadata_test)){
    error_metadata <- unlist(
      apply(metadata_test,
            2,
            function(x) names(
              which(
                !x
                )
              )
            )
      )
    warning("Element(s): ",
            paste(
              paste(
                names(error_metadata),
                error_metadata,
                sep = ": ",
                collapse = "; "),
              collapse = " "
            ),
            " did not pass the check_metadata() test.")
    
  }
  message("check_metadata(): All metadata fields present for expected edge classes.")
  
  if(!all(edges_table_test)){
    warning(
      "Element(s): ",
      paste(
        names(
          which(
            !edges_table_test
          )
        ),
        collapse = " "
      ),
      " did not pass the check_edges_table() test."
    )
  }
  message("check_edges_table(): All 'edges_table' elements are present and types are as expected.")
  
  if(!all(nodes_table_test)){
    warning(
      "Element(s): ",
      paste(
        names(
          which(
            !nodes_table_test
          )
        ),
        collapse = " "
      ),
      " did not pass the check_nodes_table() test."
    )
  }
  message("check_nodes_table(): All 'nodes_table' elements are present and types are as expected.")
  
  output
}


#' @keywords internal
#' @title Check `reference` element 
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param output, A `list` object returned from the `get_data()` function.
#'
check_reference <- function(output) {
  if (!"reference" %in% names(output)) {
    stop("The input provided does not include an element named 'reference'",
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
  
  if (!all(names(tests) %in% names(output[["reference"]])) ) {
    stop("Expected field names do not match in the reference.",
         call. = FALSE)
  }
  
  checked_types <- vapply(names(output[["reference"]]),
                        function(x) tests[[x]](
                          output[["reference"]][[x]]
                          ),
                        logical(1L)
                        )
  checked_types
}


#' @keywords internal
#' @title Check edge classes
#' 
#' @description Check matching edge classes against codebook
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param output, A `list` object returned from the `get_data()` function.
#'
check_edge_classes <- function(output) {
  if (!"network" %in% names(output)) {
    stop("The input provided does not include an element named 'network'",
         call. = FALSE)
  }
  if (!"metadata" %in% names(output[["network"]])) {
    stop("There is no 'metadata' object within the 'network' element.",
    call. = FALSE)
  }
  
  edge_types <- output[["reference"]][["codebook"]][["edge_class"]]
  
  checked_edge_lists <- vapply(
    .map_chr(output[["network"]][["metadata"]],
             "[[", 1),
    function(x) x %in% edge_types,
    logical(1L)
    )
  
  checked_edge_lists
}


#' @keywords internal
#' @title Check `metadata` elements
#' 
#' @description Checks metadata for each edge class 
#'
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param output, A `list` object returned from the `get_data()` function.
#'
check_metadata <- function(output) {
  if (!"network" %in% names(output)) {
    stop("The input provided does not include an element named 'network'",
         call. = FALSE)
  }
  if (!"metadata" %in% names(output[["network"]])) {
    stop("There is no 'metadata' object within the 'network' element.",
         call. = FALSE)
  }
  edge_class_tests <- list(
    edge_class   = is.character,
    is_bimodal   = is.logical,
    is_directed  = is.logical,
    is_dynamic   = is.logical,
    is_weighted  = is.logical,
    has_loops    = is.logical,
    has_isolates = is.logical,
    edge_count   = is.numeric,
    node_count   = is.numeric,
    node_classes = is.numeric
    )
  
  
  checked_edge_class_metadata <- vapply(
    names(output[["network"]][["metadata"]]),
    function(x) vapply(
      names(output[["network"]][["metadata"]][[x]]),
      function (y) edge_class_tests[[y]](
        output[["network"]][["metadata"]][[x]][[y]]
      ),
      logical(1L)
    ),
    logical(10L)
  )

  checked_edge_class_metadata
}


#' @keywords internal
#' @title Check `edges_table`
#' 
#' @description Checks `edges_table` element for column and content types.
#' 
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param output, A `list` object returned from the `get_data()` function.
#'
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
    edge_class = is.character  
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


#' @keywords internal
#' @title Check `nodes_table`
#' 
#' @description Checks `nodes_table` element for column and content types.
#' 
#' @author Christopher Callaghan, \email{cjcallag@@nps.edu}
#' 
#' @param output, A `list` object returned from the `get_data()` function.
#' 
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
