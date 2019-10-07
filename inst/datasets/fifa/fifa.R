
# Load pipes:
`%>%` <- magrittr::`%>%`

# paper:

# read "raw" data ==============================================================
# pull edges from two matrices in CSV format:
files <- list.files(path= .corenets_sys_file("datasets/fifa/"),
                    pattern = "*.csv", 
                    full.names = TRUE)

edges <- lapply(files, read_matrix) %>%
  # extract from multiple files and pull into one data.frame
  setNames(stringr::str_extract(files,
                              pattern = "[\\w]+\\.csv")) %>%
  lapply(igraph::graph_from_adjacency_matrix) %>%
  purrr::imap_dfr(., ~.x %>%
                    igraph::set.edge.attribute(.,
                                               name = "edge_time",
                                               value = stringr::str_extract(.y,
                                                                            pattern = "\\d+")) %>%
                    igraph::set.edge.attribute(.,
                                               name  = "edge_class",
                                               value = "co-membership") %>%
                    igraph::get.data.frame("edges")) %>%
  # clean edges data.frame:
  dplyr::mutate(to         = stringr::str_to_title(to),
                from       = stringr::str_to_title(from),
                from_class = "person",
                to_class   = "person")

# build igraph object ==================================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE
  ) %>%
  igraph::set.vertex.attribute(name  = "node_class",
                               value = "person")

# build final dataset ==================================================================
.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/fifa/description.txt"
                     )
  )
.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/fifa/abstract.txt"
                     )
  )
.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/fifa/refs.bib"
                     )
  )

.codebook <- data.frame(
  `edge_class` = c("co-membership"),
  is_bimodal  = c(FALSE),
  is_directed = c(FALSE),
  is_dynamic  = c(TRUE),
  is_weighted = c(FALSE),
  definition  = c("Undirected binary ties representing joint membership on a standing committee."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "FIFA",
  name         = "fifa",
  tags         = c("fifa"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://sites.google.com/site/ucinetsoftware/datasets/covert-networks/fifa")

.network <- list(
  metadata   = unnest_edge_class(g = g,
                                 edge_class_name = "edge_class") %>%
    purrr::set_names(unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class"))) %>%
    purrr::map(~ .x %>%
                 generate_graph_metadata(codebook = .codebook)
    ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

fifa <- list(
  reference = .reference,
  network   = .network
)

fifa
