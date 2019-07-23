
library(igraph)
library(tidyverse)
library(COREnets)

# Access: UCINET site on July 23, 2019
# Original site: http://doitapps.jjay.cuny.edu/jjatt/data.php
# Citation: 

# read "raw" data ==============================================================
files <- list.files(path="datasets/Montreal Street Gangs/",
                    pattern = "\\.csv$", 
                    full.names = TRUE)
# read edges ===================================================================
edges_df <- read_csv(files[2]) %>%
      COREnets::to_matrix() %>%
      igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
      igraph::get.data.frame("edges")

# read and recode nodes ========================================================
nodes_df <- read_csv(files[1]) %>%
  rename(name = X1) %>%
  mutate(hr_allegiances =    case_when(Allegiances == 1 ~ "Bloods",
                                       Allegiances == 2 ~ "Crips",
                                       Allegiances == 3 ~ "Other"),
         hr_gang_ethnicity = case_when(Ethnicity   == 1 ~ "Hispanic",
                                       Ethnicity   == 2 ~ "Afro-Canadian",
                                       Ethnicity   == 3 ~ "Caucasian",
                                       Ethnicity   == 4 ~ "Asian",
                                       Ethnicity   == 5 ~ "No main association/mixed"),
         hr_territories =    case_when(Territories == 1 ~ "Downtown",
                                       Territories == 2 ~ "East",
                                       Territories == 3 ~ "West"))
  
  # Build igraph object ==========================================================
g <- graph_from_data_frame(
  d = edges_df,
  directed = FALSE,
  vertices = nodes_df
)

# build final dataset ==========================================================
.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = c("organizations"),
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

.introduction <- "Gang to gang network data obtained from the Montreal Police's central intelligence base and used to reconstruct the organization of drug-distribution operations in Montreal North. The network data was made available by Manchester and it includes organization to organization undirected ties (although th orignial network is directed)."

.abstract <- "Data obtained from the Montreal Police’s central intelligence base, the Automated Criminal Intelligence Information System (ACIIS), was used to reconstruct the organization of drug-distribution operations in Montreal North. These operations were targeted during three separate investigations between 2004 and 2007 by the Montreal Police, who believed that the criminal activities were under the control of one of the more reputed gangs in Montreal—the Bo-Gars (or Handsome Boys, in English). Because the trials extending from two of the investigations were still ongoing at the time of analysis, their names remain confidential and I simply refer to Investigations A, B, and C. Investigation A began in February 2004 and ended in April 2005, with the arrests of 27 individuals who were accused primarily of importing and distributing crack and cocaine in a Montreal North neighborhood. Investigation A was the largest of the three investigations under study and it was the only case to offer electronic surveillance information amongst the available data sources.  Investigations B and C, which were direct extensions of observations made during Investigation A, both began during the fall of 2006 and ended in June 2007, with the arrests of 24 individuals who were targeted in Investigation B and 11 individuals targeted in Investigation C. Investigation B concentrated on street dealers of marijuana and crack, while Investigation C focused specifically on the activities of a group of wholesalers who were supplying some of the dealers targeted in Investigation B. Overall, 101 individuals were monitored during the investigations—45 in Investigation A, 30 in Investigation B, and 26 in Investigation C. This list of 101 individuals was used as a starting point to reconstruct the final network. This final network was comprised of 70 participants and was based on information obtained from three data sources."

.codebook <- data.frame(
  relationship = c("Gang Ties"),
  data_type = c("one-mode"),
  definition = c("Undirected and binary ties representing relationship between gangs (as reported in focus groups/interterviews with gang members)."),
  stringsAsFactors = FALSE
)

.bibtex <- c(
  "@Article{montreal_street_gangs_2011,
  title   = {Alliances, Conflicts, and Contradictions in Montreal's Street Gang Landscape}, 
  volume  = {1}, 
  journal = {International Criminal Justice Review}, 
  author  = {Kescormiers, K., and Morselli, C.}, 
  year    = {2011},
  pages   = {297-314},
  }"
)

montreal_street_gangs <- list(
  metadata = list(
    title       = "Montreal Street Gangs",
    name        = "montreal_street_gangs",
    category    = "criminal",
    tags        = c("criminal", "drugs", "gangs"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(montreal_street_gangs, overwrite = TRUE)
