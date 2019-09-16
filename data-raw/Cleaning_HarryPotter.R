
library(igraph)
library(tidyverse)
library(COREnets)

# paper: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3389503

# read in file extensions ======================================================
files <- list.files(path="datasets/Potter/",
                    pattern = "\\.csv$", 
                    full.names = TRUE
)

# read adjacency matrices ======================================================
edges <- files %>%
  setNames(str_extract(files,
                       pattern = "[\\w\\s]+\\.csv$")
           ) %>%
  purrr::imap_dfr(
    ~ read_csv(.x) %>%
      COREnets::to_matrix() %>%
      igraph::graph_from_adjacency_matrix(mode = "directed",
                                          weighted = TRUE) %>%
      igraph::get.data.frame("edges") %>%
      dplyr::mutate(network_type = str_extract(.y,
                                       pattern = ".+?(?=\\.csv$)"),
                    edge_type    = "Mutual understanding and trust",
                    from_class   = "people",
                    to_class     = "people")
    )

# NOTE: We really have three networks here:
#   1. Death Eaters
#   2. Death Eaters + Snape
#   3. Dumbledore's army
# As such, we need to create three different network objects.

# Death Eater's Network ========================================================
de_g <- igraph::graph_from_data_frame(
  d        = edges[edges$network == "Death Eaters", ],
  directed = FALSE
)
# build final dataset ----------------------------------------------------------
.description <- "The authors draw from the J. K. Rowling's seven Harry Potter books and other open-source data to code two networks found in these novels - Dumbledore's Army and Voldemort's Death Eaters.
Specifically, they identify 28 members of Dumbledore's Army and 25 Death Eaters (26 when Severus Snape is included). 
In this paper, they code tie strenght between members of each network on a scale from 0 to 5, where '0' indicates the absence of a tie, '1' for casual acquaintances, and '5' for kin and close friendships."

.abstract <- "Network approaches for analyzing narratives and other texts are being used with increasing frequency.
They are seen as capable of identifying key actors and events, highlighting semantic structures, and
uncovering underlying meanings and mental models. Numerous network approaches exist. In this paper,
the authors adopt an approach where the characters in the story are nodes and the ties linking indicate some type
of interaction between them. The authors explore the effects of tie strength between members of two
“dark networks” found in the Harry Potter novels—Dumbledore’s Army and Voldemort’s Death Eaters.
Drawing on centrality measures, this analysis finds that a handful of secondary characters play roles as
important, or almost as important, as Harry Potter and Lord Voldemort. Moreover, a comparison of the
topographical structure of the two networks suggests that if the fictional world of Harry Potter remotely
mirrors the real one, Dumbledore’s Army is built to withstand stress and uncertainty, while the Death
Eaters is not, suggesting that that J. K. Rowling has an intuitive understanding of a key difference
between networks built on trust and those built on fear. The former live to fight another day; the latter do
not."

.bibtex <- c(
  "@misc{death_eaters,
  title        = {Strong Ties and Where to Find Them: Or, Why Neville (and Ginny and Seamus) and Bellatrix (and Lucius) Might Be More Important than Harry and Tom}, 
  author       = {Everton, S. and Everton, T. and Green, A. and Hamblin, C. and Schroeder, R.}, 
  year         = {2019},
  howpublished = {\url{https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3389503}},
  note         = {Online; accessed 16 September 2019}
  }"
)

.codebook <- data.frame(
  `Edge Type` = c("Mutual understanding and trust"),
  data_type   = c("one-mode"),
  definition  = c("Undirected weighted relationship between two actors. The authors coded tie strength on a scale from 0 to 5, where '0' indicates the absece of a tie, '1' for casual acquaintances, and '5' for kin and close friendships."),
  stringsAsFactors = FALSE
)

.metadata <- list(
  title        = "Death Eaters",
  name         = "death_eaters",
  tags         = c("trust",
                   "network centrality",
                   "network topography",
                   "harry potter"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3389503")

.network <- list(
  net_metadata = unnest_edge_types(de_g, "edge_type") %>%
    purrr::map(~.x %>%
                 generate_graph_metadata),
  nodes_table = igraph::as_data_frame(de_g, what = "vertices"),
  edges_table = igraph::as_data_frame(de_g, what = "edges")
)

death_eaters <- list(
  metadata = .metadata,
  network  = .network
)
usethis::use_data(death_eaters, overwrite = TRUE)

# Dumbledore's Army Network ====================================================
da_g <- igraph::graph_from_data_frame(
  d        = edges[edges$network == "Dumbledores Army", ],
  directed = FALSE
)
.metadata <- list(
  title        = "Dumbledore's Army",
  name         = "dumbledores_army",
  tags         = c("trust",
                   "network centrality",
                   "network topography",
                   "harry potter"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3389503")

.network <- list(
  net_metadata = unnest_edge_types(da_g, "edge_type") %>%
    purrr::map(~.x %>%
                 generate_graph_metadata),
  nodes_table = igraph::as_data_frame(da_g, what = "vertices"),
  edges_table = igraph::as_data_frame(da_g, what = "edges")
)

dumbledores_army <- list(
  metadata = .metadata,
  network  = .network
)
usethis::use_data(dumbledores_army, overwrite = TRUE)
