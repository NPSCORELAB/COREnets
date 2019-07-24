
library(igraph)
library(tidyverse)
library(COREnets)

# Access: UCINET site on July 24, 2019
# Paper: https://www.tandfonline.com/doi/full/10.1080/09546553.2013.809340
# Citation: Walther, Olivier J., and Dimitris Christopoulos (2015), "Islamic terrorism and the Malian rebellion." Terrorism and Political Violence, 27 (3), 497-519.

# read "raw" data ==============================================================
files <- list.files(path="datasets/Rhodes Bombing/",
                    pattern = "\\.csv$", 
                    full.names = TRUE)

# Get graph from data ==========================================================
g_dfs <- read_csv("datasets/mali_terrorist_network/MALI.csv") %>%
  COREnets::to_matrix() %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("both")

# Edit nodes ===================================================================
# Note: While the data provided by Manchester does not include attributes, the 
# final paper by Walther and Christopoulus does include some in the figures 
# (namely, Figure 7).
rebels <- c("Hassan_Medhi",
            "Ibrahim_Ag_Mohamed_Assaleh",
            "Moussa_Ag_Assarid",
            "Nina_Wallet_Intalou",
            "Hama_Ag_Sid'Hamed",
            "Mohamed_Ag_Najim",
            "Mahmoud_Ag_Aghaly",
            "Bilal_Ag_Cherif",
            "Ibrahim_Ag_Bahanga",
            "Moussa_Ag_Acharatoumane",
            "Hassan_Fagaga",
            "Bouna_Ag_Tahib")

g_dfs[['vertices']] <- g_dfs[['vertices']] %>%
  mutate(hr_classification = ifelse(name %in% rebels,
                                    "rebel",
                                    "terrorist"))

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = g_dfs[['edges']],
  directed = FALSE,
  vertices = g_dfs[['vertices']]
)

# build final dataset ==========================================================
.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = c("people"),
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

.introduction <- "Data refers to the relationship between Islamists and rebels involved in the Malian conflict. This data set is a reconstruction of the original network data gathered by Walther and Christopoulos (2015) and was made available by Manchester. The orginal authors leveraged publicly available data to demostrate the that the connection between Islamists and rebels depends on brokers who defected fom the Tuareg rebelion to radical groups."

.abstract <- "This data set illuminates the relationship between the Islamists and rebels involved in the Malian conflict. Walther and Christopoulos (2015) recorded the network data from publicly available information from the media; namely, western articles published between July 2010 and September 2012 by the French daily Le Monde (n=27) and the weekly Jeune Afrique (n=30). These articles were supplemented with North and West African media to include 25 articles by El Watan (Algeria) and on African news websites such as African 1, Tamtaminfo, Sahara media, Occitan Touareg, and Maliactu. The period was chosen as it covers conflict between the Malian army, the Tuareg rebellion, and the AQIM-afiliated terrorists, but also events that include killings and abductions in the region."

.codebook <- data.frame(
  relationship = c("Mixed interactions"),
  data_type = c("one-mode"),
  definition = c("Walther and Christopoulos (2015) derived the ties between two actors based on participation in a joint political or military event, regardless of the duration of this event. Examples of these events include political meetings, trainings (in Afghanistan, Iraq, or Libya), combat, hostage negotiations, and/or involvement with a killing, abduction, or bombing. Note that while data on organizational membership was collected, ties between actors were not derived based on co-membership as the authors did not assume that all members within the same organization were necessarily interconnected. Furthermore, the relationships present here do not include friendship and kinship ties, nor information on internal communications, location, or financing between actors."),
  stringsAsFactors = FALSE
)

.bibtex <- c(
  "@Article{mali_terrorist_network_2015,
  title   = {Islamic Terrorism and the Malian rebellion.}, 
  volume  = {27}, 
  issue   = {3},
  journal = {Terrorism and Political Violence}, 
  author  = {Walther, O., and Christopoulos, D.}, 
  year    = {2015},
  pages   = {497-519},
  }"
)

mali_terrorist_network <- list(
  metadata = list(
    title       = "Mali Terrorist Network",
    name        = "mali_terrorist_network",
    category    = "terrorism",
    tags        = c("terrorism", "Africa"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(mali_terrorist_network, overwrite = TRUE)


