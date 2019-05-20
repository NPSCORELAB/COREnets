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
                                directed = TRUE,
                                vertices = baad_1m_attr)

# visNetwork::visIgraph(test_g) %>%
#   visNetwork::visOptions(nodesIdSelection = TRUE)

# In order to create a comprehesive file, create a list with the following items:
# 1. Node list
# 2. Edge list
# 3. Name
# 4. Description

# Node list: 
nodes <- as_tibble(get.data.frame(test_g, what="vertices"))

# Edge list:
edges <- as_tibble(get.data.frame(test_g, what="edges"))

# Name
name <- "BAAD"

# Description
desc <- "No description is available."

# Anabaptists list:
baad <- list(nodes=nodes, edges=edges, name=name, desc=desc)
usethis::use_data(baad, overwrite = TRUE)
