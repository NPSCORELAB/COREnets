
# Load pipes:
`%>%` <- magrittr::`%>%`

# paper: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3389503

# read adjacency matrices ======================================================
edges <- COREnets:::read_matrix("inst/datasets/harry_potter_death_eaters/Death Eaters Snape.csv") %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected",
                                      weighted = TRUE) %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(edge_class   = "mutual understanding and trust",
                from_class   = "people",
                to_class     = "people") %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# Death Eater's Network ========================================================
g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = FALSE
) %>%
  igraph::set.vertex.attribute(
    name  = "node_class",
    value = "people"
  )

# build final dataset ----------------------------------------------------------
.description <- readLines("inst/datasets/harry_potter_death_eaters/description.txt",
                          warn = FALSE)

.abstract <- readLines("inst/datasets/harry_potter_death_eaters/abstract.txt",
                       warn = FALSE)

.bibtex <- bibtex::read.bib("inst/datasets/harry_potter_death_eaters/refs.bib")


.codebook <- data.frame(
  `edge_class` = c("mutual understanding and trust"),
  is_bimodal  = c(FALSE),
  is_directed = c(FALSE),
  is_dynamic  = c(FALSE),
  is_weighted = c(TRUE),
  definition  = c("Undirected weighted relationship between two actors. The authors coded tie strength on a scale from 0 to 5, where '0' indicates the absece of a tie, '1' for casual acquaintances, and '5' for kin and close friendships."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Death Eaters",
  name         = "harry_potter_death_eaters",
  tags         = c("trust",
                   "strong ties",
                   "centrality",
                   "network topography"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3389503")

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

harry_potter_death_eaters <- list(
  reference = .reference,
  network   = .network
)

harry_potter_death_eaters
