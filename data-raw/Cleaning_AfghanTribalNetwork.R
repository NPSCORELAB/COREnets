#########################################
# Transforming the Afghan Tribal Network
# Date: 04/29/2019
#########################################
library(igraph)
library(dplyr)
library(tibble)
library(readxl)

# First import all tabs from "Afghan Tribal Networks.xlsx":
kinship <- read_xlsx("datasets/Afghan Tribal Networks.xlsx", sheet=1)
sentiment <- read_xlsx("datasets/Afghan Tribal Networks.xlsx", sheet=2)
geographic_movement <- read_xlsx("datasets/Afghan Tribal Networks.xlsx", sheet=3)
tribes_and_district <- read_xlsx("datasets/Afghan Tribal Networks.xlsx", sheet=4)
attributes <- read_xlsx("datasets/Afghan Tribal Networks.xlsx", sheet=5)

# Transform data to adjancency matrices:
to_adj_matrix <- function(.df){
  if(is_tibble(.df)){
    .df <- as.matrix(.df)
    row.names(.df) <- .df[,1]
    .df <- .df[,-1]
    
    if(nrow(.df)==ncol(.df)){
      cat("Output will be adjacency matrix.")
      return(.df)
    }
    else{
      cat("Output will not be adjacency matrix, it may be an incidence matrix. Please revise your input.")
      return(.df)
    }
  }
  else{
    stop("Data provided is not a tibble.", call. = FALSE)
  }
}
kinship <- to_adj_matrix(kinship)
sentiment <- to_adj_matrix(sentiment)
geographic_movement <- to_adj_matrix(geographic_movement)
tribes_and_district <- to_adj_matrix(tribes_and_district)

attributes <- attributes[1:91, ]
attributes$name <- attributes$Tribes

# Transform data to graphs:
g_kinship <- igraph::graph_from_adjacency_matrix(kinship)
g_sentiment <- igraph::graph_from_adjacency_matrix(sentiment)
g_geographic_movement <- igraph::graph_from_adjacency_matrix(geographic_movement)
### NOTE 4/29/19: ### 
# The two-mode network below was not included due to lack of context. 
# Future conversations should include a discussion on whether or not to project this network and aggregate the one-mode tribal data with all other relationships (above).
#g_tribes_and_district <- igraph::graph_from_incidence_matrix(tribes_and_district)

# Transform graphs to edgelist format:
kinship <- igraph::get.data.frame(g_kinship, "edges") %>%
  dplyr::mutate(relationship_type = "kinship")
sentiment <- igraph::get.data.frame(g_sentiment, "edges") %>%
  dplyr::mutate(relationship_type = "sentiment")
geographic_movement <- igraph::get.data.frame(g_geographic_movement, "edges") %>%
  dplyr::mutate(relationship_type = "geographic_movement")

# Bind all edgelist into master list of relationships
edges <- rbind(kinship, sentiment, geographic_movement)
# Nodes
nodes <- data.frame("name" = c(edges$from, edges$to)) %>%
  unique() %>%
  left_join(attributes, by=c("name")) %>%
  mutate(id = name)

### NOTE 4/29/19: ###
# There are obvious errors like unique vertices in the produced nodes table. 
# As such, will not incoorporate this data until it is deconflicted.

