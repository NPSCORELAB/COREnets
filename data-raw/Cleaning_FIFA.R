
library(tidyverse)
library(igraph)

# paper:

# read "raw" data ======================================================================
# pull edges from two matrices in CSV format:
files <- list.files(path="datasets/FIFA/",
                    pattern = "*.csv", 
                    full.names = TRUE)

edges <- purrr::map(files, read_csv) %>%
  # extract from multiple files and pull into one data.frame
  setNames(str_extract(files,
                       pattern = "[\\w]+\\.csv")) %>%
  map(., COREnets::to_matrix) %>%
  map(., COREnets::to_graph) %>%
  imap_dfr(., ~.x %>%
             set.edge.attribute(., name="time_slice",
                                value=str_extract(.y,
                                                  pattern = "\\d+")) %>%
             get.data.frame("edges")) %>%
  # clean edges data.frame:
  mutate(to = str_to_title(to),
         from = str_to_title(from))

# build igraph object ==================================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE
  )

# build final dataset ==================================================================
.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = "people",
    is_two_mode  = igraph::is_bipartite(g),
    is_dynamic   = FALSE,
    are_nodes_spatial = inherits(igraph::as_data_frame(g, what = "vertices"), "sf"),
    are_edges_spatial =  inherits(igraph::as_data_frame(g, what = "edges"), "sf")
  ),
  node_table = as_tibble(igraph::as_data_frame(g, what = "vertices")),
  edge_table = as_tibble(igraph::as_data_frame(g, what = "edges"))
)

.introduction <- "Two Networks of Standing Committee membership. These are overt networks with
covert elements."

.abstract <- "This dataset was reconstructed by Gemma Edwards from FIFA Select Committee reports
for both 2006 and 2015. These are overt networks with covert elements."

.bibtex <- c(
  "@misc{fifa,
  author  = {Edwards, Gemma}, 
  year    = {2016},
  title   = {FIFA},
  note    = {data retrieved from UCINET Software, 
             \\url{https://sites.google.com/site/ucinetsoftware/datasets/covert-networks/fifa}},
  }"
)

fifa <- list(
  metadata = list(
    title       = "FIFA Standing Committee Co-Membership Network",
    name        = "fifa",
    category    = "sport",
    tags        = "sport",
    description = .description,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  network = .network
)

usethis::use_data(fifa, overwrite = TRUE)
