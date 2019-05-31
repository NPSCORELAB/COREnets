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

# Node list: 
nodes <- as_tibble(get.data.frame(anabaptists_full, what="vertices"))

# Edge list:
edges <- as_tibble(get.data.frame(anabaptists_full, what="edges"))

# Dataset metadata:
anabaptists <- list(
  metadata = list(
    title = "Anabaptist Network",
    name = "anabaptists",
    category = "religious",
    tags = c("religion"),
    description = NULL
  ),
  bibtex_data = list(
    anabaptists2013= list(preamble = "article",
         name = "anabaptists2013",
         title = "Cultural Inheritance or Cultural Diffusion of Religious Violence? A Quantitative Case Study of the Radical Reformation.",
         author = "Matthews, Luke J., Jeffrey Edmonds, Wesley Wildman, and Charles Nunn.",
         journal = "Religion, Brain & Behavior.",
         volume = 3,
         pages = "3-15",
         year = 2013),
    anabaptists2015= list(preamble = "masterthesis",
         name = "anabaptists2015",
         title = "Anabaptist Leadership Network.",
         author = "McLaughlin, John M.",
         school = "Naval Postgraduate School",
         address = "1 University Circle, Monterey, CA 93943",
         year = 2015,
         month = NULL,
         note = NULL)
  ),
  network = list(
    net_metadata = list(
      node_type = "people",
      edge_type = NULL,
      modes = 1,
      directed = FALSE,
      weighted = FALSE,
      multiplex = FALSE,
      dynamic = FALSE,
      spatial = FALSE
    ),
    node_table = nodes,
    edge_table = edges
  )
)

usethis::use_data(anabaptists, overwrite = TRUE)

