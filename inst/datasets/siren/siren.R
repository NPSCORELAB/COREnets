
# Load pipes:
`%>%` <- magrittr::`%>%`

# Access: UCINET site on July 23, 2019
# paper: https://www.springer.com/gp/book/9780387095257 

# Read edges data ==============================================================
edges <- .corenets_sys_file("datasets/siren/SIREN.csv") %>%
  .corenets_read_csv() %>% 
  to_matrix() %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(
    from_class = "organization",
    to_class   = "organization",
    edge_class = "communication"
  ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# Read nodes data ==============================================================
# NOTE: No node attribute data was available via the UCINet site.

# Build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = FALSE
) %>%
  igraph::set.vertex.attribute(name  = "node_class",
                               value = "organization")

# Build final dataset ==========================================================

.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/siren/description.txt")
)

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/siren/abstract.txt")
)

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/siren/refs.bib")
)

.codebook <- data.frame(
  `edge_class` = c("communication"),
  is_bimodal  = c(FALSE),
  is_directed = c(FALSE),
  is_dynamic  = c(FALSE),
  is_weighted = c(FALSE),
  definition  = c("Undirected and binary ties refering to affiliaioin between gangs. These data have been reconstrustructed by members of the UCINET team from Karine Descomiers and Carlo Morselli's 2011 article 'Alliances, Conflicts and Contraditions in Montreal's Street Gang Landscape', which appeared on the International Criminal Justice Review."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Project Siren",
  name         = "siren",
  tags         = c("gangs",
                   "criminal network"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://www.springer.com/gp/book/9780387095257")

.network <- list(
  metadata    = unnest_edge_class(g = g, edge_class_name = "edge_class") %>%
    purrr::set_names(unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class"))) %>%
    purrr::map(~ .x %>% generate_graph_metadata(codebook = .codebook)
    ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

siren <- list(
  reference = .reference,
  network  = .network
)

siren
