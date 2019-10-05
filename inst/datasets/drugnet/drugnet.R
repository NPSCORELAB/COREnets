
# Load pipes:
`%>%` <- magrittr::`%>%`

# paper: https://search.proquest.com/docview/211193699?OpenUrlRefId=info:xri/sid:primo&accountid=12702
# codebook: 

# read adjacency matrix ========================================================
edges_path <- .corenets_sys_file("datasets/drugnet/DRUGNET.csv")
nodes_path <- .corenets_sys_file("datasets/drugnet/DRUGATTR.csv")


edges <- edges_path %>%
  .corenets_read_csv() %>%
  to_matrix() %>%
  igraph::graph_from_adjacency_matrix(mode = "directed") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(
    edge_class  = "Acquaintanceship",
    from_class = "person",
    to_class   = "person"
  ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# read attribute table =========================================================
nodes <- nodes_path %>%
  .corenets_read_csv() %>%
  dplyr::rename(name = X1) %>%
  dplyr::mutate(hr_gender = dplyr::case_when(Gender == 1 ~ "Male",
                                             Gender    == 2 ~ "Female",
                                             Gender    == 3 ~ "Unknown"),
         hr_ethnicity = dplyr::case_when(Ethnicity == 1 ~ "White/Other",
                                         Ethnicity    == 2 ~ "African American",
                                         Ethnicity    == 3 ~ "Puerto Rican/Latino",
                                         Ethnicity    == 4 ~ "White/Other",
                                         Ethnicity    == 5 ~ "White/Other",
                                         Ethnicity    == 6 ~ "White/Other",
                                         Ethnicity    == 6 ~ "White/Other"),
         hr_has_tie = dplyr::if_else(HasTie == 1,
                             TRUE,
                             FALSE),
         node_class = "people") %>%
  dplyr::select(name, node_class,
         Gender, Ethnicity, HasTie,
         hr_ethnicity, hr_gender, hr_has_tie)

# Note 17 June 2019 ============================================================
# Though the dataset was downloaded from UCINet's site there was no formal 
# codebook, only a mention of the values for each variable on the site. The
# recoding done here follows the instructions on the site.

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = TRUE,
  vertices = nodes
)

# build final dataset ==========================================================

.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/drugnet/description.txt")
)

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/drugnet/abstract.txt")
)

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/drugnet/refs.bib")
)

.codebook <- data.frame(
  `edge_class` = c("Acquaintanceship"),
  is_bimodal  = c(FALSE),
  is_directed = c(TRUE),
  is_dynamic  = c(FALSE),
  is_weighted = c(FALSE),
  definition  = c("Ties are directed and represent acquaintanceship."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Drugnet",
  name         = "drugnet",
  tags         = c("drug users",
                   "drug-use settings",
                   "African Americans",
                   "Puerto Ricans",
                   "HIV"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://search.proquest.com/docview/211193699?OpenUrlRefId=info:xri/sid:primo&accountid=12702")

.network <- list(
  metadata   = unnest_edge_class(g = g, edge_class_name = "edge_class") %>%
    purrr::set_names(unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class"))) %>%
    purrr::map(~ .x %>%
                 generate_graph_metadata(codebook = .codebook)
    ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

drugnet <- list(
  reference = .reference,
  network   = .network
)

drugnet
