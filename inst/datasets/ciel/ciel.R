
# Load pipes:
`%>%` <- magrittr::`%>%`

# Access: UCINET site on July 23, 2019
# paper: https://www.springer.com/gp/book/9780387095257 

# Read edges data ==============================================================
edges <- .corenets_sys_file("datasets/ciel/CIELNET.csv") %>%
  .corenets_read_csv() %>% 
  to_matrix() %>%
  igraph::graph_from_adjacency_matrix(mode     = "directed",
                                      weighted = TRUE) %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(
    from_class = "person",
    to_class   = "person",
    edge_class = "communication"
  ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# Read nodes data ==============================================================
# NOTE: No node attribute data was available via the UCINet site.

# Build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = TRUE
)

# Build final dataset ==========================================================
.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/ciel/description.txt")
)

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/ciel/abstract.txt")
)

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/ciel/refs.bib")
)

.codebook <- data.frame(
  `edge_class` = c("communication"),
  is_bimodal  = c(FALSE),
  is_directed = c(TRUE),
  is_dynamic  = c(FALSE),
  is_weighted = c(TRUE),
  definition  = c("Communication between criminals, collected through wiretapping."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Project Ciel",
  name         = "ciel",
  tags         = c("drug traffickers",
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

ciel <- list(
  reference = .reference,
  network  = .network
)

ciel
