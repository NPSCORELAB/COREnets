#' Build an `igraph` object from a `proto_net`
#' 
#' @param proto_net Any `{COREnets}` data set.
#' 
#' @return `igraph`
#' 
#' @template author-bk
#' 
#' @examples 
#' drugnet_proto_net <- get_data("drugnet")
#' 
#' core_as_igraph(drugnet_proto_net)
#' 
#' # currently supported networks ==============================================
#' core_as_igraph(get_data("anabaptists"))
#' 
#' core_as_igraph(get_data("cocaine_smuggling_acero"))
#' 
#' core_as_igraph(get_data("cocaine_smuggling_jake"))
#' 
#' core_as_igraph(get_data("cocaine_smuggling_juanes"))
#' 
#' core_as_igraph(get_data("cocaine_smuggling_mambo"))
#' 
#' core_as_igraph(get_data("harry_potter_death_eaters"))
#' 
#' core_as_igraph(get_data("harry_potter_dumbledores_army"))
#' 
#' core_as_igraph(get_data("montreal_street_gangs"))
#' 
#' core_as_igraph(get_data("november17"))
#' 
#' core_as_igraph(get_data("siren"))
#' 
#' 
#' @importFrom igraph graph_from_data_frame
#' 
#' @export
core_as_igraph <- function(proto_net) {
  if (.is_multiplex(proto_net) | any(.is_bimodal(proto_net))) {
    stop("Multimodal and/or multiplex objects are not yet supported.", 
         call. = FALSE)
  }
  
  
  graph_from_data_frame(
    d = proto_net$network$edges_table,
    directed = proto_net$reference$codebook$is_directed,
    vertices = proto_net$network$nodes_table
  )
}