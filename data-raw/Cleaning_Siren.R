
library(igraph)
library(tidyverse)
library(COREnets)
library(readxl)

# paper: https://www.springer.com/gp/book/9780387095257 
# codebook: 

# Read edges data ==============================================================
edges <- read_csv(file = "datasets/siren/SIREN.csv") %>%
  COREnets::to_matrix() %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("edges") 

# Read nodes data ==============================================================
# NOTE: No node attribute data was available via the UCINet site.

# Build igraph object ==========================================================
g <- graph_from_data_frame(
  d = edges,
  directed = FALSE
)

# Build final dataset ==========================================================
.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = "people",
    is_two_mode  = igraph::is_bipartite(g),
    is_dynamic   = TRUE,
    are_nodes_spatial = inherits(igraph::as_data_frame(g,
                                                       what = "vertices"), "sf"),
    are_edges_spatial =  inherits(igraph::as_data_frame(g,
                                                        what = "edges"), "sf")
  ),
  node_table = as_tibble(igraph::as_data_frame(g, what = "vertices")),
  edge_table = as_tibble(igraph::as_data_frame(g, what = "edges"))
)

.introduction <- "Data on a network of criminals running a stolen-vehicle exportation operation obtained within a larger investigatite setting. The data was procured from the UCINET Software site and was reconstructed from Morselli's book Inside Criminal Networks."

.abstract <- "Morselli's Project Siren data set encompasses actors embedded in an illicit network for the stolen-vehicle exportation (or ringing) operations. The data was obtained within a larger investigative setting between 1993 and 2005 under Project CERVO. As Morselli (2009) points out 'The main objective of this task force was to monitor and control the exportation of stolen luxury vehicles from the Port of Montreal. Cooperation between law-enforcement and border/insurance agencies was the unique feature, with the latter supplying documents from maritime shipping companies that contained information on suspect cargo and the identities of individuals or enterprises involved in their trasportation.'
The data presented here was reconstructed from Morselli's book by researchers and mainteners of the UCINET Software site (https://sites.google.com/site/ucinetsoftware). However, the author provides an in detail description of his data collection process on his 2000 book Inside Criminal Networks."

.bibtex <- c(
  "@book{siren,
  author    = {Morselli, Carlo}
  address   = {New York}
  publisher = {Springer}
  title     = {Inside Criminal Networks}
  year      = {2009}
  }"
)

.codebook <- data.frame(
  relationship = c("Communications"),
  data_type = c("one-mode"),
  definition = c("Relations represent communication exchanges between criminals. Data comes from police wiretapping. Ties are undirected."),
  stringsAsFactors = FALSE
)

siren <- list(
  metadata = list(
    title       = "Project Siren",
    name        = "Siren",
    category    = "criminal",
    tags        = c("criminal network", "theft"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(siren, overwrite = TRUE)