
library(igraph)
library(tidyverse)
library(COREnets)

# Note: CSV.zip retrieved from UCINET on July 23, 2019.
# paper: http://www.cs.umd.edu/~sen/pubs/sna2006/RelClzPIT.pdf
# Original soure (not used): https://www.cs.purdue.edu/commugrate/data/terrorist/

### NOTE =======================================================================
# On July 23, 2019 we could not square the multitude sources for this 
# for this data. There is no MIND Lab, the paper recomended by the README in the
# .tar file was not published. Furthermore the numbers do not match...


# Get files ====================================================================
files <- list.files(path="datasets/Linux Terrorists/",
                    pattern = "\\.csv$", 
                    full.names = TRUE)

# Read edges data ==============================================================
edges <- files %>%
  purrr::set_names() %>%
  purrr::imap_dfr(
    ~ read_csv(.x) %>%
      COREnets::to_matrix() %>%
      igraph::graph_from_adjacency_matrix(mode = "directed") %>%
      igraph::get.data.frame("edges") %>%
      dplyr::mutate(relationship = str_extract(.y,
                                       pattern = "(?<=datasets/Linux Terrorists//).+?(?=\\.csv$)")
                    )
    )

# Edit edges data ==============================================================
edges <- edges %>%
  mutate(relationship = case_when(relationship == "LINUX_LOC_ORGEDGES" ~ "Co-located terrorist attack by same organization.",
                                  relationship == "LINUX_ORGEDGES"     ~ "Co-location of terrorist attack.")
         )

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
    node_type    = "organizations",
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

.introduction <- "This network is composed of two data sets on a set of terrorists and the attacks they carried out. The dataset was collected by the MIND Lab at the University of Maryland (http://www.mindswap.org/) and made available from Manchester (https://sites.google.com/site/ucinetsoftware)."

.abstract <- "These are two data sets about terrorist organizations and the attacks they carried out"

.bibtex <- c(
  "@book{caviar,
  author    = {}
  address   = {}
  publisher = {}
  title     = {}
  year      = {}
  }"
)

.codebook <- data.frame(
  relationship = c(""),
  data_type = c("one-mode"),
  definition = c(""),
  stringsAsFactors = FALSE
)

linux_terrorists <- list(
  metadata = list(
    title       = "",
    name        = "",
    category    = "",
    tags        = c(""),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(linux_terrorists, overwrite = TRUE)