
# Load pipes:
`%>%` <- magrittr::`%>%`

# paper: https://journals.sagepub.com/doi/figure/10.1177/1477370812447738?

# read in file extensions ======================================================
files <- list.files(path="inst/datasets/london_gang/",
                    pattern = "\\.csv$", 
                    full.names = TRUE
                    )

# read adjacency matrix ========================================================
edges <- files %>%
  purrr::discard(stringr::str_detect,
                 pattern = "_ATTR.csv") %>%
  readr::read_csv() %>%
  COREnets:::to_matrix() %>%
  igraph::graph_from_adjacency_matrix(weighted = TRUE,
                                      mode = "undirected") %>%
  igraph::get.data.frame("edges") %>%
  # The extracted weights represent edge types
  dplyr::mutate(
    type = weight,
    edge_type = dplyr::case_when(
      type == 1 ~ "Hang Out Together",
      type == 2 ~ "Co-Offend Together",
      type == 3 ~ "Co-Offend Together, Serious Crime",
      type == 4 ~ "Co-Offend Together, Seriour Crime, Kin"),
    from_class = "people",
    to_class   = "people"
  ) %>%
  dplyr::select(from, to, from_class, to_class, type, edge_type)

# read attribute table =========================================================
nodes <- files %>%
  purrr::keep(stringr::str_detect,
              pattern = "_ATTR.csv") %>%
  readr::read_csv() %>%
  tibble::as_tibble() %>%
  dplyr::rename(name = X1) %>%
  dplyr::mutate(
    node_class    = "people",
    # Recode attributes for human readability -----------------------------
    hr_birthplace = dplyr::case_when(
      Birthplace == 1 ~ "West Africa",
      Birthplace == 2 ~ "Caribbean",
      Birthplace == 3 ~ "United Kingdom",
      Birthplace == 4 ~ "East Africa")
  )

# Note 17 June 2019 ============================================================
# Though the dataset was downloaded from UCINet's site there are issues with the
# reliability of variables. For instance, the original paper cited by the site
# makes no mention of some of the variables (e.g., music) and perhaps more 
# alarmingly the birthplace variables have been reorganized and no longer match
# those used in the paper. To air on the side of caution, we have recoded the 
# variables to match those reported in the UCINet site.

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = FALSE,
  vertices = nodes
)

# build final dataset ==========================================================
.description <- readLines("inst/datasets/london_gang/description.txt",
                           warn = FALSE)

.abstract <- readLines("inst/datasets/london_gang/abstract.txt",
                       warn = FALSE)

.bibtex <- bibtex::read.bib("inst/datasets/london_gang/refs.bib")

.codebook <- data.frame(
  `edge_type` = c("Hang Out Together",
                  "Co-Offend Together",
                  "Co-Offend Together, Serious Crime",
                  "Co-Offend Together, Seriour Crime, Kin"),
  is_bimodal  = c(FALSE,
                  FALSE,
                  FALSE,
                  FALSE),
  is_directed = c(FALSE,
                  FALSE,
                  FALSE,
                  FALSE),
  is_dynamic  = c(FALSE,
                  FALSE,
                  FALSE,
                  FALSE),
  is_weighted = c(FALSE,
                  FALSE,
                  FALSE,
                  FALSE),
  definition  = c("Undirected valued relationship for actors who hang out together.",
                  "Undirected valued relationship for actors who co-offend together.",
                  "Undirected valued relationship for actors who co-offend together and committed a serious crime.",
                  "Undirected valued relationship for actors who co-offend together, committed a serious crime, and are kin."),
  stringsAsFactors = FALSE
)

.metadata <- list(
  title        = "London Gang",
  name         = "london_gang",
  tags         = c("street gangs",
                   "crime",
                   "homophily",
                   "heterogeneity",
                   "ethnicity"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://journals.sagepub.com/doi/figure/10.1177/1477370812447738?")

.network <- list(
  net_metadata = COREnets:::unnest_edge_types(g = g,
                                             edge_type_name = "edge_type") %>%
    purrr::map(~ .x %>%
               generate_graph_metadata(codebook = .codebook)
               ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

london_gang <- list(
  metadata = .metadata,
  network  = .network
)

london_gang
