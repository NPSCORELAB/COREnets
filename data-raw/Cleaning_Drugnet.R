
library(igraph)
library(tidyverse)
library(COREnets)

# paper: https://search.proquest.com/docview/211193699?OpenUrlRefId=info:xri/sid:primo&accountid=12702
# codebook: 

# read "raw" data ==============================================================
files <- list.files(path="datasets/Drugnet/",
                    pattern = "\\.csv$", 
                    full.names = TRUE)

# read adjacency matrix ========================================================
edges <- files %>%
  purrr::discard(stringr::str_detect, pattern = "ATTR.csv") %>%
  read_csv() %>%
  COREnets::to_matrix() %>%
  graph_from_adjacency_matrix(mode = "undirected") %>%
  get.data.frame("edges")

# read attribute table =========================================================
nodes <- files %>%
  purrr::keep(stringr::str_detect, pattern = "ATTR.csv") %>%
  read_csv() %>%
  as_tibble() %>%
  rename(name = X1)

# recode attribute table =======================================================
nodes <- nodes %>%
  mutate(gender = case_when(Gender == 1 ~ "Male",
                            Gender == 2 ~ "Female",
                            Gender == 3 ~ "Unknown"),
         ethnicity = case_when(Ethnicity == 1 ~ "White/Other",
                               Ethnicity == 2 ~ "African American",
                               Ethnicity == 3 ~ "Puerto Rican/Latino",
                               Ethnicity == 4 ~ "White/Other",
                               Ethnicity == 5 ~ "White/Other",
                               Ethnicity == 6 ~ "White/Other",
                               Ethnicity == 6 ~ "White/Other",),
         has_tie = ifelse(HasTie==1, TRUE, FALSE)) %>%
  select(name, ethnicity, gender, has_tie)
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
.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = "people",
    is_two_mode  = igraph::is_bipartite(g),
    is_dynamic   = FALSE,
    are_nodes_spatial = inherits(igraph::as_data_frame(g,
                                                       what = "vertices"), "sf"),
    are_edges_spatial =  inherits(igraph::as_data_frame(g,
                                                        what = "edges"), "sf")
  ),
  node_table = as_tibble(igraph::as_data_frame(g, what = "vertices")),
  edge_table = as_tibble(igraph::as_data_frame(g, what = "edges"))
)

.introduction <- "This is a dichotomous adjacency matrix of drug users in 
Hartford.  Ties are directed and represent acquaintanceship. The network is a 
result of two years of ethnographic observations of people's drug habits. "

.abstract <- "Social network research increasingly expands our understanding of 
the social environment of drug users' health risks, particularly those 
associated with the transmission of HIV, hepatitis, and other sexually 
transmitted and bloodborne infectious diseases. Our study of the networks of 
drug users who use high-risk sites, where people gather to inject drugs and 
smoke crack cocaine, is designed to explore the relationships and interactions 
of drug users in settings in which potential risk occurs, and to assess the 
opportunity to create prevention linkages. This paper describes the ego-network 
characteristics and macro-network linkages among a sample of 293 drug users 
recruited through street outreach and personal drug-use network referral in 
Hartford, Connecticut. Characteristics of the largest connected component of the 
network are also described and analyzed. We discuss uses of network analyses as 
well as implications of network connections for peer-led AIDS prevention 
intervention conducted in high-risk drug-use sites."

.bibtex <- c(
  "@article{drugnet_2006,
   author    = {Weeks, Margaret and Clair, Scott and Borgatti, Stephen and Radda, Kim and Schensul, Jean}
   address   = {New York}
   issn      = {1090-7165}
   journal   = {AIDS and Behavior}
   number    = {2}
   pages     = {193-206}
   publisher = {Kluwer Academic Publishers-Plenum Publishers}
   title     = {Social Networks of Drug Users in High-Risk Sites: Finding the Connections}
   volume    = {6}
   year      = {2002}
  }"
)

drugnet <- list(
  metadata = list(
    title       = "Social Networks of Drug Users in High-Risk Sites",
    name        = "drugnet",
    category    = "criminal",
    tags        = c("drug users", "HIV", "drug-use settings"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  network = .network
)

usethis::use_data(drugnet, overwrite = TRUE)