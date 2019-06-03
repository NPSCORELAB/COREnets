###################################
# Transforming the FIFA Data
# Date: 12/28/2018
###################################

library(igraph)
library(tidyverse)
library(COREnets)

# Get files:
files <- list.files(path="datasets/FIFA/",
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
                                                  pattern = "\\d+")) %>%
             get.data.frame("edges"))

# Standardize names:
dfs_listed$to <- str_to_title(dfs_listed$to)
dfs_listed$from <- str_to_title(dfs_listed$from)

# Test:
g <- igraph::graph_from_data_frame(dfs_listed,
                                   directed = FALSE)
# Visualize for testing purposes:
visNetwork::visIgraph(g)

# Set values for exporting
edges <- dfs_listed %>%
  as.data.frame()
nodes <- get.data.frame(g, what = "vertices")

# Dataset metadata:
fifa <- list(
  metadata = list(
    title = "FIFA Committee Membership Network",
    name = "fifa",
    category = "sport",
    tags = c("FIFA", "sport"),
    description = "Two networks of standing commitee membership for FIFA. Both networks (2006 and 2015) were derived from two-mode data (persons to standing committees). Data reconstructed by Gemma Edwards from Select Committee 2006 activity report. This data was adquired from the UCINet site on June 3, 2019."
  ),
  bibtex_data = list(
    fifa = list(preamble = "misc",
                name = "fifa",
                title = "FIFA",
                author = "Edwards, G.",
                year = "2016",
                note = "data retrieved from UCINET's site",
                url = "https://sites.google.com/site/ucinetsoftware/datasets/covert-networks/fifa"
                
  )),
  network = list(
    net_metadata = list(
      node_type = "people",
      edge_type = NULL,
      modes = 1,
      directed = FALSE,
      weighted = FALSE,
      multiplex = FALSE,
      dynamic = TRUE,
      spatial = FALSE
    ),
    node_table = nodes,
    edge_table = edges
  )
)

usethis::use_data(fifa, overwrite = TRUE)

