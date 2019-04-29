###################################
# Transforming the Anabaptist Data
# Date: 12/28/2018
###################################
library(igraph)
library(dplyr)

# Get the data from the Raw Data > Anabaptists folder:
anabaptists <- read.graph(file="datasets/Anabaptist Leaders.net", format = "pajek")
# Now get the attributes from the same location:
anabaptists_attr <- read.csv(file="datasets/Anabaptist Attributes.csv", header = T, as.is = T)
# Clean up the first column's title:
anabaptists_attr <- anabaptists_attr %>%
  rename(id=X)
# Add attributes to igraph:
# First test that all vertex names are identical
test <- get.data.frame(anabaptists, what="vertices")
anabaptists_attr$id==test$id
# As it turns out, observation 61 (test$id[61] | anabaptists_attr$id[61]) are not identical. So recoding is needed:
V(anabaptists)$id <- ifelse(V(anabaptists)$id=="Boekbinder","Gerrit Boekbinder" ,V(anabaptists)$id)
V(anabaptists)$name <- ifelse(V(anabaptists)$name=="Boekbinder","Gerrit Boekbinder" ,V(anabaptists)$name)
# Now we can add attributes:
anabaptists_full <- graph_from_data_frame(get.data.frame(anabaptists, what="edges"),
                              vertices = anabaptists_attr)

# In order to create a comprehesive file, create a list with the following items:
# 1. Node list
# 2. Edge list

# Node list: 
nodes <- as_tibble(anabaptists_full, what="vertices")

# Edge list:
edges <- as_tibble(anabaptists_full, what="edges")

# Anabaptists list:
anabaptists <- list(nodes=nodes, edges=edges)
usethis::use_data(anabaptists, overwrite = TRUE)