######################################################
# Cleaning and Structuring Global Suicide Attacks Data
# Date: 05/01/2019
######################################################

library(igraph)
library(tidyverse)
library(COREnets)

files <- list.files(path="datasets/Global_Suicide_Attacks/",
                    pattern = "*.csv", 
                    full.names = TRUE)


dfs_listed <- purrr::map(files, read_csv) %>%
  setNames(str_extract(files,
                       pattern = "[\\w]+.csv")) %>%
  map(., COREnets::to_matrix) %>%
  map(., COREnets::to_graph) %>%
  imap_dfr(., ~.x %>%
             set.edge.attribute(., name="time",
                                value=str_extract(.y,
                                                  pattern = "_\\d+_")) %>%
             get.data.frame("edges"))

dfs_listed$time <- str_replace_all(dfs_listed$time, "_", "")

# Test:
g <- igraph::graph_from_data_frame(dfs_listed,
                                   directed = FALSE)

