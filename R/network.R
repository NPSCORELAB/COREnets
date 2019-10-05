#' Build a `network` object from a `proto_net`
#' 
#' @param proto_net Any `{COREnets}` data set obtained via `get_data()`.
#' 
#' @return `<network>`
#' 
#' @template author-bk
#' 
#' @examples 
#' drugnet_proto_net <- get_data("drugnet")
#' 
#' core_as_network(drugnet_proto_net)
#' 
#' # currently supported networks ==============================================
#' core_as_network(get_data("anabaptists"))
#' 
#' core_as_network(get_data("cocaine_smuggling_acero"))
#' 
#' core_as_network(get_data("cocaine_smuggling_jake"))
#' 
#' core_as_network(get_data("cocaine_smuggling_juanes"))
#' 
#' core_as_network(get_data("cocaine_smuggling_mambo"))
#' 
#' core_as_network(get_data("harry_potter_death_eaters"))
#' 
#' core_as_network(get_data("harry_potter_dumbledores_army"))
#' 
#' core_as_network(get_data("montreal_street_gangs"))
#' 
#' core_as_network(get_data("november17"))
#' 
#' core_as_network(get_data("siren"))
#' 
#' @importFrom network add.edges network.initialize set.vertex.attribute
#' 
#' @export
core_as_network <- function(proto_net) {
  if (.is_multiplex(proto_net) | any(.is_bimodal(proto_net))) {
    stop("Multimodal and/or multiplex objects are not yet supported.", 
         call. = FALSE)
  }
  
  out <- network.initialize(
    n = nrow(proto_net$network$nodes_table), 
    directed = proto_net$reference$codebook$is_directed,
    hyper = FALSE,
    loops = .has_loops(proto_net),
    multiple = .is_multiplex(proto_net),
    bipartite = .is_bimodal(proto_net)
  )

  edge_df <- proto_net$network$edges_table
  
  edge_df[, c("from", "to")] <- lapply(edge_df[, c("from", "to")], function(x) {
    as.integer(factor(x, levels = proto_net$network$nodes_table$name))
  })
  
  nw_edge_attr_names <- setdiff(names(edge_df), c("from", "to"))

  if (length(nw_edge_attr_names)) {
    names_eval <- rep(
      list(as.list(nw_edge_attr_names)), nrow(edge_df)
    )
    
    edge_df$row_index <- seq_len(nrow(edge_df))
    
    vals_eval <- unname(
      lapply(
        split(edge_df[, nw_edge_attr_names],
              f = edge_df$row_index),
        function(.x) {
          .x$row_index <- NULL
          as.list(.x)
          }
      )
    )
    
  } else {
    names_eval <- NULL
    vals_eval <- NULL
  }
  
  if (length(names_eval)) {
    out <- add.edges(
      x = out,
      tail = as.integer(edge_df[[1L]]),
      head = as.integer(edge_df[[2L]]),
      names.eval = names_eval,
      vals.eval = vals_eval
    )
    
  } else {
    out <- add.edges(
      x = out,
      tail = edge_df[[1L]],
      head = edge_df[[2L]]
    )
    
  }
  
  for (i in seq_along(proto_net$network$nodes_table)) {
    target_col <- names(proto_net$network$nodes_table)[[i]]
    if (target_col == "name") {
      target_col <- "vertex.names"
    }
    
    out <- set.vertex.attribute(
      x = out,
      attrname = target_col,
      value = proto_net$network$nodes_table[[i]]
    )
  }
  
  out
}
