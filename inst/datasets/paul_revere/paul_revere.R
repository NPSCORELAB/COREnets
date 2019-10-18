
# Load pipes:
`%>%` <- magrittr::`%>%`

# Access: UCINET site on July 23, 2019
# paper: https://kieranhealy.org/blog/archives/2013/06/09/using-metadata-to-find-paul-revere/

# Read edges data ==============================================================
edges <- .corenets_sys_file("datasets/paul_revere/PREVERE2MODE.csv") %>%
  .corenets_read_csv() %>% 
  to_matrix() %>%
  igraph::graph_from_incidence_matrix() %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(
    from_class = "person",
    to_class   = "organization",
    edge_class = "membership"
  ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# Set up list of organization for vertex attributes:
organizations <- unique(edges[["to"]])

# Read nodes data ==============================================================
# NOTE: No node attribute data was available via the UCINet site.

# Build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = FALSE) %>%
  igraph::set_vertex_attr(name  = "node_class",
                          value = ifelse(igraph::V(.)$name %in% organizations,
                                         "organization",
                                         "person"))

# Build final dataset ==========================================================

.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/paul_revere/description.txt")
)

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/paul_revere/abstract.txt")
)

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/paul_revere/refs.bib")
)

.codebook <- data.frame(
  `edge_class` = c("membership"),
  is_bimodal  = c(TRUE),
  is_directed = c(FALSE),
  is_dynamic  = c(FALSE),
  is_weighted = c(FALSE),
  definition  = c("Belonging to seven different organizations in the Boston area."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "The Paul Revere Conspiracy",
  name         = "paul_revere",
  tags         = c(""),
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

paul_revere <- list(
  reference = .reference,
  network  = .network
)

paul_revere
