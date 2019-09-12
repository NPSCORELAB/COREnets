
library(igraph)
library(tidyverse)
library(COREnets)

# Access: UCINET site on July 23, 2019
# Original site: http://doitapps.jjay.cuny.edu/jjatt/data.php
# Citation: 

# read "raw" data ==============================================================
files <- list.files(path="datasets/Philippines Bombing 2000/",
                    pattern = "\\.csv$", 
                    full.names = TRUE)

# read edges ===================================================================
edges_df <- files %>%
  # NOTES:
  # Removed several fields also included in the temporal matrices.
  purrr::discard(stringr::str_detect,
                 pattern = "_TIE_YEAR.csv") %>%
  purrr::discard(stringr::str_detect,
                 pattern = "_TIE_EXTINGUISH.csv") %>%
  purrr::discard(stringr::str_detect,
                 pattern = "_OPERATION_ID.csv") %>%
  purrr::discard(stringr::str_detect,
                 pattern = "_KINSHIP.csv") %>%
  purrr::set_names() %>%
  purrr::imap_dfr(
    ~ read_csv(.x) %>%
      COREnets::to_matrix() %>%
      igraph::graph_from_adjacency_matrix(mode = "undirected",
                                          weighted = TRUE) %>%
      igraph::get.data.frame("edges") %>%
      dplyr::mutate(time = str_extract(.y,
                                       pattern = "(?<=PHILBOMB_2000_).+?(?=\\.csv$)"))
  )

# edit edges ===================================================================
# codebook: http://doitapps.jjay.cuny.edu/jjatt/files/Relations_Codebook_Public_Version2.pdf
edges_df <- edges_df %>%
  mutate(relationship = case_when(weight == 1 ~ "Acquaintances/Distant family ties",
                                  weight == 2 ~ "Friends/Moderately close family ties | Operational/Organizational leadership | Operational Ties",
                                  weight == 3 ~ "Close Friends/Family, Tight-knit operational cliques"),
         time = str_replace(time, "_", "-")
         ) %>%
  rename(tie_strength = weight) %>%
  select(from, to, time, relationship)

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges_df,
  directed = FALSE)

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
#### NOTE: CITATIONS MISSING !!! ===============================================

.introduction <- ""

.abstract <- ""

.bibtex <- c(
  "@book{
  }"
)

.codebook <- data.frame(
  relationship = c("Acquaintances/Distant family ties",
                   "Friends/Moderately close family ties | Operational/Organizational leadership | Operational Ties",
                   "Close Friends/Family, Tight-knit operational cliques"),
  data_type = c("one-mode",
                "one-mode",
                "one-mode"),
  definition = c("Acquaintances/Distant family ties (interactions limited to radical organization activities)",
                 "Friends/Moderately close family ties (interactions extend beyond radical organizations to include such categories as co-workers and roommates). Operational/Organizational leadership (i.e. JI leadership, formally or informally “ranking” members of burgeoning cells). Operational Ties i.e. worked closely on a bombing together).",
                 "Close Friends/Family, Tight-knit operational cliques (would die for each other)"),
  stringsAsFactors = FALSE
)

caviar <- list(
  metadata = list(
    title       = "Project Caviar",
    name        = "Caviar",
    category    = "criminal",
    tags        = c("drug traffic", "criminal network"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(caviar, overwrite = TRUE)
