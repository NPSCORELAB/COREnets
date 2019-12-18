.is_empty <- function(x) {
  length(x) == 0L
}

.compact <- function(.x) {
  Filter(length, .x)
}

.stop_or_false <- function(msg, throw, verbose) {
  if (throw) {
    stop(msg)
  } else {
    if (verbose) {
      message(msg)
    }
    FALSE
  }
} 

validate_reference <- function(proto_net, throw, verbose) {
  lens <- vapply(proto_net$reference, length, integer(1L))
  
  empties <- names(which(lens == 0L))
  if (!.is_empty(empties)) {
    msg <- c(
      "The following reference entries are empty:",
      paste("\n\t- ", empties)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  # TODO should BibTeX just be plain strings? what benefit are they as `bibentry`?
  scalar_names <- c("title", "name", "description", "abstract", "paper_link")
  bad_scalars <- names(which(lens[scalar_names] != 1L))
  if (!.is_empty(bad_scalars)) {
    msg <- c(
      "The following reference entries should only be a single element:",
      paste("\n\t-", bad_scalars)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  # TODO shoud BibTeX just be plain strings? what benefit are they as `bibentry`?
  chr_names <- c("title", "name", "description", "paper_link")
  bad_chrs <- names(
    which(!vapply(proto_net$reference[scalar_names], is.character, logical(1L)))
  )
  if (!.is_empty(bad_chrs)) {
    msg <- c(
      "The following references entries should be <chr>, but are not.",
      paste("\n\t-", bad_chrs)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  # TODO is there a benefit to these being data frames and not plain lists?
  if (!is.list(proto_net$reference$codebook)) {
    msg <- "The codebook is not a list."
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  TRUE
}


bad_metadata_types <- function(metadata, target_names, .p) {
  .compact(
    lapply(metadata, function(.x) {
      names(
        which(
          vapply(.x[target_names], 
                 function(.y) !.p(.y), logical(1L))
        )
      )
    })
  )
}


validate_metadata <- function(proto_net, throw, verbose) {
  target_length <- 10L
  bad_top_lvl_lengths <- names(
    which(
      vapply(proto_net$network$metadata, function(.x) length(.x) != target_length,
             logical(1L))
    )
  )
  if (!.is_empty(bad_top_lvl_lengths)) {
    msg <- c(
      sprintf("`target_length`: %s", target_length),
      "The following metadata entries do have the target_length",
      paste("\n\t-", bad_top_lvl_lengths)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  
  chr_names <- c("edge_class")
  lgl_names <- c("is_bimodal", "is_directed", "is_dynamic", "is_weighted",
                 "has_loops", "has_isolates")
  num_names <- c("edge_count", "node_count", "node_classes")
  
  bad_chrs <- bad_metadata_types(
    metadata = proto_net$network$metadata,
    target_names = chr_names,
    .p = is.character
  )
  if (!.is_empty(bad_chrs)) {
    msg <- c(
      "The following metadata entries should be of type character, but are not.",
      paste("\n\t-", bad_chrs)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  bad_lgls <- bad_metadata_types(
    metadata = proto_net$network$metadata,
    target_names = lgl_names,
    .p = is.logical
  )
  if (!.is_empty(bad_lgls)) {
    msg <- c(
      "The following metadata entries should be of type logical, but are not.",
      paste("\n\t-", bad_lgls)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  bad_nums <- bad_metadata_types(
    metadata = proto_net$network$metadata,
    target_names = num_names,
    .p = is.numeric
  )
  if (!.is_empty(bad_nums)) {
    msg <- c(
      "The following metadata entries should be of type `integer` or `double`, but are not.",
      paste("\n\t-", paste0("$network$metadata$", names(bad_nums), "$", unlist(bad_nums)))
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  TRUE
}


validate_nodes_table <- function(proto_net, throw, verbose) {
  df <- proto_net$network$nodes_table
  
  if (!is.data.frame(df)) {
    msg <- "The `nodes_table` is not a `data.frame`"
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  
  required_cols <- c("name", "node_class")
  missing_cols <- setdiff(required_cols, names(df))
  if (!.is_empty(missing_cols)) {
    msg <- c(
      "The following column names in the `nodes_table` are missing, but are required:",
      paste("\n\t-", missing_cols)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  chr_cols <- c("name", "node_class")
  bad_chrs <- names(
    which(
      !vapply(df[chr_cols], is.character, logical(1L))
    )
  )
  if (!.is_empty(bad_chrs)) {
    msg <- c(
      "The following column names in the `nodes_table` should be of type `character`, but are not.",
      paste("\n\t-", bad_chrs)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  lgl_cols <- names(df)[grepl("^is_", names(df))]
  bad_lgls <- names(
    which(
      !vapply(df[lgl_cols], is.logical, logical(1L))
    )
  )
  if (!.is_empty(bad_lgls)) {
    msg <- c(
      "The following column names in the `nodes_table` are prefixed \"is_\", but are not of type `logical`",
      paste("\n\t-", bad_lgls)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  TRUE
}


validate_edges_table <- function(proto_net, throw, verbose) {
  df <- proto_net$network$edges_table
  
  if (!is.data.frame(df)) {
    msg <- "The `edges_table` is not a `data.frame`"
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  required_cols <- c("from", "to", "from_class", "to_class", "edge_class")
  missing_cols <- setdiff(required_cols, names(df))
  if (!.is_empty(missing_cols)) {
    msg <- c(
      "The following column names in the `edges_table` are missing, but are required:",
      paste("\n\t-", missing_cols)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  chr_cols <- c("from", "to", "from_class", "to_class", "edge_class")
  bad_chrs <- names(
    which(
      !vapply(df[chr_cols], is.character, logical(1L))
    )
  )
  if (!.is_empty(bad_chrs)) {
    msg <- c(
      "The following column names in the `edges_table` should be of type `character`, but are not.",
      paste("\n\t-", bad_chrs)
    )
    return(.stop_or_false(msg, throw = throw, verbose = verbose))
  }
  
  TRUE
}



validate_proto_net <- function(proto_net, throw = TRUE, verbose = TRUE) {
  out <- list(c(
    is_valid_reference = validate_reference(proto_net, throw = throw, verbose = verbose),
    is_valid_metadata = validate_metadata(proto_net, throw = throw, verbose = verbose),
    is_valid_nodes_table = validate_nodes_table(proto_net, throw = throw, verbose = verbose),
    is_valid_edges_table = validate_edges_table(proto_net, throw = throw, verbose = verbose)
  ))
  
  names(out) <- proto_net$reference$name
  
  out
}


validate_all_proto_nets <- function(throw = TRUE, verbose = FALSE) {
  all_proto_nets <- lapply(list_data_sources(), get_data, validate = FALSE)
  init <- lapply(all_proto_nets, validate_proto_net, throw = throw, verbose = verbose)
  
  do.call(rbind, unlist(init, recursive = FALSE))
}

validation_matrix <- function(verbose = FALSE) {
  validate_all_proto_nets(throw = FALSE, verbose = verbose)
}


# validate_all_proto_nets(throw = FALSE)

