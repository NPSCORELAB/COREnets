`%>%` <- magrittr::`%>%`

# read edges data ==============================================================
edges <- COREnets:::read_matrix("inst/datasets/cocaine_smuggling_acero/COCAINE_ACERO.csv") %>%
  igraph::graph_from_adjacency_matrix() %>%
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
.description <- readLines("inst/datasets/cocaine_smuggling_acero/description.txt",
                          warn = FALSE)

.abstract <- readLines("inst/datasets/cocaine_smuggling_acero/abstract.txt",
                       warn = FALSE)

.bibtex <- bibtex::read.bib("inst/datasets/cocaine_smuggling_acero/refs.bib")

.codebook <- data.frame(
  `edge_class` = c("person-to-person"),
  is_bimodal  = c(FALSE),
  is_directed = c(FALSE),
  is_dynamic  = c(FALSE),
  is_weighted = c(FALSE),
  definition  = c("Undirected valued relationship for actors, mainly of the same family."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Cocaine Smuggling Operation ACERO",
  name         = "cocaine_smuggling_acero",
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

cocaine_smuggling_acero <- list(
  reference = .reference,
  network   = .network
)

cocaine_smuggling_acero
