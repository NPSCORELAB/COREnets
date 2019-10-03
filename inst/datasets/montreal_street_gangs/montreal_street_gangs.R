
# Load pipes:
`%>%` <- magrittr::`%>%`

# read edges ===================================================================
edges <- readr::read_csv("inst/datasets/montreal_street_gangs/MONTREALGANG.csv") %>%
  COREnets:::to_matrix() %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("edges") %>%
  dplyr::mutate(
    from_class = "organization",
    to_class   = "organization",
    edge_class = "affiliation"
  ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())


# read and recode nodes ========================================================
nodes <- readr::read_csv("inst/datasets/montreal_street_gangs/MONTREALGANG_ATTR.csv") %>%
  dplyr::rename(name = X1) %>%
  dplyr::mutate(hr_allegiances = dplyr::case_when(Allegiances == 1 ~ "Bloods",
                                                  Allegiances == 2 ~ "Crips",
                                                  Allegiances == 3 ~ "Other"),
         hr_gang_ethnicity     = dplyr::case_when(Ethnicity   == 1 ~ "Hispanic",
                                                  Ethnicity   == 2 ~ "Afro-Canadian",
                                                  Ethnicity   == 3 ~ "Caucasian",
                                                  Ethnicity   == 4 ~ "Asian",
                                                  Ethnicity   == 5 ~ "No main association/mixed"),
         hr_territories        = dplyr::case_when(Territories == 1 ~ "Downtown",
                                                  Territories == 2 ~ "East",
                                                  Territories == 3 ~ "West"),
         node_class            = "organization"
         ) %>%
  dplyr::select(name, node_class,
                dplyr::everything())
  
  # Build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = FALSE,
  vertices = nodes
)

# build final dataset ==========================================================

.description <- readLines("inst/datasets/montreal_street_gangs/description.txt",
                          warn = FALSE)

.abstract <- readLines("inst/datasets/montreal_street_gangs/abstract.txt",
                       warn = FALSE)

.bibtex <- bibtex::read.bib("inst/datasets/montreal_street_gangs/refs.bib")

.codebook <- data.frame(
  `edge_class` = c("affiliation"),
  is_bimodal  = c(FALSE),
  is_directed = c(FALSE),
  is_dynamic  = c(FALSE),
  is_weighted = c(FALSE),
  definition  = c("Undirected and binary ties refering to affiliaioin between gangs. These data have been reconstrustructed by members of the UCINET team from Karine Descomiers and Carlo Morselli's 2011 article 'Alliances, Conflicts and Contraditions in Montreal's Street Gang Landscape', which appeared on the International Criminal Justice Review."),
  stringsAsFactors = FALSE
)


.reference <- list(
  title        = "Montreal Street Gangs Network",
  name         = "montreal_street_gangs",
  tags         = c("gangs",
                   "internal structure",
                   "alliances",
                   "conflicts"
                   ),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.867.7956&rep=rep1&type=pdf")

.network <- list(
  metadata    = COREnets:::unnest_edge_class(g = g,
                                             edge_class_name = "edge_class") %>%
    purrr::set_names(unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class"))) %>%
    purrr::map(~ .x %>%
                 COREnets:::generate_graph_metadata(codebook = .codebook)
    ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

montreal_street_gangs <- list(
  reference = .reference,
  network  = .network
)

montreal_street_gangs