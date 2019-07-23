
library(igraph)
library(tidyverse)
library(COREnets)

# Access: UCINET site on July 23, 2019
# Paper: https://www.jstor.org/stable/40295697?seq=1#metadata_info_tab_contents
# Citation: Rhodes, C.J. and P. Jones, “Inferring Missing Links in Partially Observed Social Networks”, Journal of the Operational Research Society (2009) 60, 1373-1383

# read "raw" data ==============================================================
files <- list.files(path="datasets/Rhodes Bombing/",
                    pattern = "\\.csv$", 
                    full.names = TRUE)

# Get edges data ===============================================================
edges_df <- files %>%
  purrr::discard(stringr::str_detect, pattern = "_ATTR.csv") %>%
  purrr::imap_dfr(
    ~ read_csv(.x) %>%
      COREnets::to_matrix() %>%
      igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
      igraph::get.data.frame("edges")
    )

# Get nodees data ==============================================================
nodes_df <- files %>%
  purrr::keep(stringr::str_detect, pattern = "_ATTR.csv") %>%
  read_csv()

# Edit nodes ===================================================================
nodes_df <- nodes_df %>%
  rename(name = X1) %>%
  # Recode for human readiblity:
  mutate(hr_role      = case_when(Role      == 1 ~ "Gives orders",
                                  Role      == 2 ~ "Recieves orders"),
         hr_faction   = case_when(Faction   == 1 ~ "1st Generation Leadership Faction",
                                  Faction   == 2 ~ "Koufontinas Faction",
                                  Faction   == 3 ~ "Sardanopoulos Faction"),
         hr_resources = case_when(Resources == 1 ~ "Controls one resource",
                                  Resources == 2 ~ "Controls two resources",
                                  Resources == 3 ~ "Controls three resources"))

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
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

.introduction <- "These data are on the social network of the Greek terrorist group November17 (N17) (now defunct) and it was derieved from open source reporting (Irwin et. al., 2002, Abram and Smith, 2004). The data was reconstructed from an article by Rhodes C.J. and P. Jones by Manchester and made available via the UCINet site."

.abstract <- "The social network data on November17 (the believed defunct Greek terrorist group) was derived from open source reporting (Irwin et. al., 2002, Abram and Smith, 2004). The links indicate some degree of connection between two individiduals at some point in the past. Rodes and Jones (2009) did not attempt to gauge the specific nature or strenght of the links, as such, these are not weighted.
In addition to the edgess, the data set includes attributes on actor membership within the November 17 organization (1st Generation Founders, Sardanopoulos faction, and the Koufontinas faction), role (leader or operational individual), and control over different levels of three specified resources (money, weapons, and safe houses)."

.codebook <- data.frame(
  relationship = c("Connection"),
  data_type = c("one-mode"),
  definition = c("Relations indicate that open source reporting has demonstrated some connection between the two individuals at some point in the past."),
  stringsAsFactors = FALSE
)

.bibtex <- c(
  "@Article{rhodes_bombing_2009,
  title   = {Inferring Missing Links in Partially Observed Social Networks}, 
  volume  = {60}, 
  journal = {Journal of the Operational Research Society}, 
  author  = {Rhodes, CJ, and Jones, P.}, 
  year    = {2009},
  pages   = {1373-1383},
  }"
)

rhodes_bombing <- list(
  metadata = list(
    title       = "Rhodes Bombing",
    name        = "rhodes_bombing",
    category    = "terrorism",
    tags        = "terrorism",
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(rhodes_bombing, overwrite = TRUE)
