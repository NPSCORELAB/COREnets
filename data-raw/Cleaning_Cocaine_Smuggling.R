############################################
# Transforming the Cocaine Smuggling Data
# Date: 06/03/2018
############################################

library(igraph)
library(tidyverse)
library(COREnets)

files <- list.files(path="datasets/smuggling/",
                   pattern = "*.csv", 
                   full.names = TRUE)

edges_unlisted <- purrr::map(files, read_csv) %>%
  setNames(str_extract(files,
                       pattern = "[\\w]+.csv")) %>%
  map(., COREnets::to_matrix) %>%
  map(., COREnets::to_graph) %>%
  imap_dfr(., ~.x %>%
             set.vertex.attribute(., name="operation",
                                  value=str_extract(.y,
                                                    pattern = "\\d+")) %>%
             get.data.frame("edges"))


nodes_unlisted <- purrr::map(files, read_csv) %>%
  setNames(str_extract(files,
                       pattern = "[\\w]+.csv")) %>%
  map(., COREnets::to_matrix) %>%
  map(., COREnets::to_graph) %>%
  imap_dfr(., ~.x %>%
             set.vertex.attribute(., name="operation",
                                  value=str_extract(.y,
                                                    pattern = "\\w+")) %>%
             get.data.frame("vertices"))

g <- igraph::graph_from_data_frame(edges_unlisted,
                                   directed = FALSE,
                                   vertices = nodes_unlisted)
visNetwork::visIgraph(g)

# Dataset metadata:
cocaine_smuggling <- list(
  metadata = list(
    title = "Cocaine Smuggling Networks",
    name = "cocaine_smuggling",
    category = "criminal",
    tags = c("criminal", "cocaine", "narcotics"),
    description = "These data refer to four groups (independent weak components) involved in cocaine trafficking in Spain between 2007 and 2009. The information used to generate this data set comes from police wiretapping and meetings registered by police investigations. The following is a list and description of each cocaine smuggling investigaion:
      - Operation MAMBO (n=22): The investigation started in 2006 and involved Colombian citizens that were introducing 50 kg of cocaine to be adulterated and distributed in Madrid (Spain). Ultimately, the group was involved in smuggling cocaine from Colombia through Brazil and Uruguay to be distributed in Spain. This is a typical Spanish middle cocaine group acting as wholesale supplier between a South American importer group and retailers in Madrid.
      - Operation JUANES (n=51): In 2009, the police investigation detected a group involved in the smuggling of cocaine from Mexico to be distributed in Madrid (Spain). In this case, the group operated in close cooperation with another organization that was laundering the illegal income from drug distribution from this and other groups. The cocaine traffickers earned an estimated EUR 60 million.
      - Operation JAKE (n=62): In 2008, the group investigated was operating as a wholesale supplier and retail distributor of cocaine and heroin in a large distribution zone located in Madrid (Spain), where gypsy clans traditionally carry out similar activities. The group was in charge of acquiring, manipulating and selling the drugs in the gypsy quarter.
      - Operation ACERO (n=11): This investigation started in 2007 and involved a smaller family-based group. The group was composed mainly of members of a same family and was led by a female. They distributed cocaine in Madrid (Spain) that was provided to them by other groups based in a northwest region of the country, one of the most active areas in the provision of cocaine from the countries of origin. The group also had their own procedures to launder money."
  ),
  bibtex_data = list(
    cocaine_smuggling = list(preamble = "misc",
                name = "cocaine_smuggling",
                title = "Illegal networks or criminal organizations: Power, roles and facilitators in four cocaine trafficking structures.",
                author = "Jimenez-Salinas Framis, A.",
                year = "2011",
                note = "Retrieved from:",
                url = "https://sites.google.com/site/ucinetsoftware/datasets/covert-networks/cocainesmuggling"
                
    )),
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
    node_table = nodes_unlisted,
    edge_table = edges_unlisted
  )
)

usethis::use_data(cocaine_smuggling, overwrite = TRUE)

