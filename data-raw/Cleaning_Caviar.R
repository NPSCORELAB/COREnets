
library(igraph)
library(tidyverse)
library(COREnets)
library(readxl)

# paper: https://www.springer.com/gp/book/9780387095257 
# codebook: 

# Read edges data ==============================================================
# NOTE: Though the UCINet provides a '_FULL' data set with all periods for this
# investigation, here we focus on importing each time slice so as to capture the
# edge temporal attribute.
files <- list.files(path="datasets/caviar/",
                    pattern = "\\.csv$", 
                    full.names = TRUE)

edges <- files %>%
  purrr::discard(stringr::str_detect, pattern = "_FULL") %>%
  purrr::set_names() %>%
  purrr::imap_dfr(
    ~ read_csv(.x) %>%
      COREnets::to_matrix() %>%
      igraph::graph_from_adjacency_matrix(mode = "directed",
                                          weighted = TRUE) %>%
      igraph::get.data.frame("edges") %>%
      dplyr::mutate(time = str_extract(.y,
                                        pattern = "(?<=CAVIAR).+?(?=\\.csv$)"))
  )
# NOTE: Thought the author refers to the 'time' variable for each edge as a 
# 'period', we have here listed it as a time to comply with the archive's 
# internal onthology.

# Read nodes data ==============================================================
# NOTE: No node attribute data was available via the UCINet site.

# Build igraph object ==========================================================
g <- graph_from_data_frame(
  d = edges,
  directed = TRUE
)

# Build final dataset ==========================================================
.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = "people",
    is_two_mode  = igraph::is_bipartite(g),
    is_dynamic   = TRUE,
    are_nodes_spatial = inherits(igraph::as_data_frame(g,
                                                       what = "vertices"), "sf"),
    are_edges_spatial =  inherits(igraph::as_data_frame(g,
                                                        what = "edges"), "sf")
  ),
  node_table = as_tibble(igraph::as_data_frame(g, what = "vertices")),
  edge_table = as_tibble(igraph::as_data_frame(g, what = "edges"))
)

.introduction <- "Project Caviar was a unique investigation that targeted a network of hashish and cocaine importers operating out of Montreal. The network was targeted between 1994 and 1996 by a tandem investigation uniting the Montreal Police, the Royal Canadian Mounted Police, and other national and regional law-enforcement agencies from various countries (i.e., England, Spain, Italy, Brazil, Paraguay, and Colombia)."

.abstract <- "The Caviar data was derived from an investigation that targeted a network of hashish and cocaine importers operating out of Montreal. The case is unique because it involved a specific investigative approach that will be referred to as a “seize and wait” strategy. Unlike most law-enforcement strategies, the mandate set forward in the Project Caviar case was to seize identified drug consignments, but not to arrest any of the identified participants. This took place over a 2-year period. Thus, although 11 importation consignments were seized at different moments throughout this period, arrests only took place at the end of the investigation. What this case offers is a rare opportunity to study the evolution of a criminal network phenomenon as it was being disrupted by law-enforcement agents. The inherent investigative strategy permits an assessment of change in the network structure and an inside look into how network participants react and adapt to the growing constraints set upon them.
The principal data source was comprised of information submitted as evidence during the trials of 22 participants in the Caviar network. It included 4,279 paragraphs of information (over 1,000 pages) revealing electronically intercepted telephone conversations between network participants. These transcripts were used to create the overall matrix of the drug-trafficking operation’s communication system throughout the course of the investigation. Individuals falling in the surveillance net were not all participants in the trafficking operation. An initial extraction of all names appearing in the surveillance data led to the identification of 318 individuals. From this pool, 208 individuals were not implicated in the trafficking operations. Most were simply named during the many transcripts of conversations, but never detected. Others who were detected had no clear participatory role within the network (e.g., family members or legitimate entrepreneurs). The final network was thus composed of 110 participants. "

.bibtex <- c(
  "@book{caviar,
  author    = {Morselli, Carlo}
  address   = {New York}
  publisher = {Springer}
  title     = {Inside Criminal Networks}
  year      = {2009}
  }"
)

.codebook <- data.frame(
  relationship = c("Interaction/Communications"),
  data_type = c("one-mode"),
  definition = c("Ties are communication exchanges between criminals. Values represent level of communication activity. Data comes from police wiretapping."),
  stringsAsFactors = FALSE
)

caviar <- list(
  metadata = list(
    title       = "Project Caviar",
    name        = "Caviar",
    category    = "criminal",
    tags        = c("drug traffic", "criminal network"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(caviar, overwrite = TRUE)