
library(igraph)
library(tidyverse)
library(COREnets)

# paper: 
# codebook: 

# read edges data ==============================================================
files <- list.files(path="datasets/smuggling/",
                   pattern = "\\.csv$", 
                   full.names = TRUE)

edges <- files %>%
  map(
    ~ .x %>%
      read.csv(header = TRUE) %>%
      COREnets::to_matrix() %>%
      COREnets::to_graph()
      ) %>%
  setNames(str_extract(files, pattern = "[\\w]+\\.csv$")) %>%
  imap_dfr(
    ~ set.edge.attribute(.x, name="network_name",
                           value=str_extract(.y,
                                             pattern = "[\\w]+")) %>%
      get.data.frame("edges"))


# read edges data ==============================================================
nodes <- files %>%
  map(
    ~ .x %>%
      read.csv(header = TRUE) %>%
      COREnets::to_matrix() %>%
      COREnets::to_graph()
  ) %>%
  map_dfr( 
    ~ get.data.frame(.x, "vertices")
    )

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE,
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

.introduction <- "This dataset looks at a multiple organizations involved in 
narcotics trafficking in Spain between 2007 and 2009. All organizations are
represented as weak components. "

.abstract <- "These data refer to four groups (independent weak components) 
involved in cocaine trafficking in Spain between 2007 and 2009. The information 
used to generate this data set comes from police wiretapping and meetings 
registered by police investigations. The following is a list and description of
each cocaine smuggling investigaion:
- Operation MAMBO (n=22): The investigation started in 2006 and involved 
  Colombian citizens that were introducing 50 kg of cocaine to be adulterated 
  and distributed in Madrid (Spain). Ultimately, the group was involved in 
  smuggling cocaine from Colombia through Brazil and Uruguay to be distributed 
  in Spain. This is a typical Spanish middle cocaine group acting as wholesale 
  supplier between a South American importer group and retailers in Madrid.
- Operation JUANES (n=51): In 2009, the police investigation detected a group 
  involved in the smuggling of cocaine from Mexico to be distributed in Madrid 
  (Spain). In this case, the group operated in close cooperation with another 
  organization that was laundering the illegal income from drug distribution 
  from this and other groups. The cocaine traffickers earned an estimated 
  EUR 60 million.
- Operation JAKE (n=62): In 2008, the group investigated was operating as a 
  wholesale supplier and retail distributor of cocaine and heroin in a large 
  distribution zone located in Madrid (Spain), where gypsy clans traditionally 
  carry out similar activities. The group was in charge of acquiring, 
  manipulating and selling the drugs in the gypsy quarter.
- Operation ACERO (n=11): This investigation started in 2007 and involved a 
  smaller family-based group. The group was composed mainly of members of a same
  family and was led by a female. They distributed cocaine in Madrid (Spain) 
  that was provided to them by other groups based in a northwest region of the 
  country, one of the most active areas in the provision of cocaine from the 
  countries of origin. The group also had their own procedures to launder 
  money."

.bibtex <- c(
  "@misc{cocaine_2011,
  author  = {Jimenez-Salinas Framis, A.}, 
  title   = {Illegal networks or criminal organizations: Power, roles and facilitators in four cocaine trafficking structures},
  year    = {2011},
  note   = \\url{https://sites.google.com/site/ucinetsoftware/datasets/covert-networks/cocainesmuggling},
  }"
)

cocaine_smuggling <- list(
  metadata = list(
    title       = "Cocaine Smuggling Networks",
    name        = "cocaine_smuggling",
    category    = "criminal",
    tags        = c("criminal", "trannational crime", "narcotics"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  network = .network
)

usethis::use_data(cocaine_smuggling, overwrite = TRUE)
