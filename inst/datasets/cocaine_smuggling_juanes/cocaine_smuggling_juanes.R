`%>%` <- magrittr::`%>%`

.codebook <- data.frame(
  `edge_class` = "person-to-person",
  is_bimodal  = FALSE,
  is_directed = FALSE,
  is_dynamic  = FALSE,
  is_weighted = TRUE,
  definition  = "Undirected valued relationship for actors, mainly of the same family.",
  stringsAsFactors = FALSE
)


# read edges data ==============================================================
edges <- COREnets:::read_matrix(
  .corenets_sys_file("datasets/cocaine_smuggling_juanes/COCAINE_JUANES.csv") 
  ) %>%
  igraph::graph_from_adjacency_matrix(
    mode = if (.codebook$is_directed) "directed" else "undirected",
    weighted = .codebook$is_weighted
  ) %>%
  igraph::get.data.frame(what = "edges") %>%
  dplyr::mutate(
    edge_class = "person-to-person",
    from_class = "person",
    to_class   = "person" 
  ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class)

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE
) %>%
  igraph::set.vertex.attribute(.,
                               name  = "node_class",
                               value = "person")

# build final dataset ==========================================================
.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/cocaine_smuggling_juanes/description.txt")
)

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/cocaine_smuggling_juanes/abstract.txt")
)

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/cocaine_smuggling_juanes/refs.bib")
)


.reference <- list(
  title        = "Cocaine Smuggling Operation JUANES",
  name         = "cocaine_smuggling_juanes",
  tags         = c("drug smuggling",
                   "crime"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://sites.google.com/site/ucinetsoftware/datasets/covert-networks/cocainesmuggling")

.network <- list(
  metadata   = COREnets:::unnest_edge_class(g = g,
                                            edge_class_name = "edge_class") %>%
    purrr::set_names(unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class"))) %>%
    purrr::map(~ .x %>%
                 COREnets:::generate_graph_metadata(codebook = .codebook)
    ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

cocaine_smuggling_juanes <- list(
  reference = .reference,
  network   = .network
)

cocaine_smuggling_juanes
