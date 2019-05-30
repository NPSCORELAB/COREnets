####################################
# Cleaning and Structuring BAAD Data
# Date: 05/20/2019
####################################

library(igraph)
library(tidyverse)
library(COREnets)


files <- list.files(path="datasets/BAAD/",
                    pattern = "*.csv", 
                    full.names = TRUE)

baad_1m <- purrr::map_dfr(files[1], read_csv) %>%
  as_tibble() %>%
  COREnets::to_matrix() %>%
  COREnets::to_graph() %>%
  get.data.frame("edges")

baad_1m_attr <- purrr::map_dfr(files[2], read_csv) %>%
  as_tibble()

test_g <- graph_from_data_frame(baad_1m,
                                vertices = baad_1m_attr)

# Dataset metadata:
baad <- list(
  page_metadata = list(
    title = "Big Allied and Dangerous (BAAD) Network",
    category = "terrorism",
    tags = c("terrorism"),
    about = NULL,
    description = NULL
  ),
  bibtex_data = list(
    preamble = "misc",
    title = "Big Allied and Dangerous Dataset Version 2.",
    author = "Asal, Victor H. and R. Karl Rethemeyer.",
    publisher = NULL,
    journal = NULL,
    volume = NULL,
    pages = NULL,
    address = NULL,
    year = 2015,
    note = NULL,
    url = "www.start.umd.edu/baad/database"
  ),
  network = list(
    metadata = list(
      node_type = "people",
      edge_type = NULL,
      modes = 1,
      directed = TRUE,
      weighted = FALSE,
      multiplex = FALSE
    ),
    node_table = as_tibble(get.data.frame(test_g, what="vertices")),
    edge_table = as_tibble(get.data.frame(test_g, what="edges"))
  )
)
usethis::use_data(baad, overwrite = TRUE)

