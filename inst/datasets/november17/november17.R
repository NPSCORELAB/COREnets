
# Load pipes:
`%>%` <- magrittr::`%>%`

# Access: UCINET site on July 23, 2019
# Paper: https://www.jstor.org/stable/40295697?seq=1#metadata_info_tab_contents
# Citation: Rhodes, C.J. and P. Jones, “Inferring Missing Links in Partially Observed Social Networks”, Journal of the Operational Research Society (2009) 60, 1373-1383

# Get edges data ===============================================================
edges <- readr::read_csv("inst/datasets/november17/RHODESBOMBING.csv") %>%
  COREnets:::to_matrix() %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  igraph::get.data.frame("edges")%>%
  dplyr::mutate(
    from_class = "person",
    to_class   = "person",
    edge_class = "connection"
  ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# Get nodees data ==============================================================
nodes <- readr::read_csv("inst/datasets/november17/RHODESBOMBING_ATTR.csv") %>%
  dplyr::rename(name = X1) %>%
  # Recode for human readiblity:
  dplyr::mutate(
    hr_role      = dplyr::case_when(Role      == 1 ~ "Gives orders",
                                    Role      == 2 ~ "Recieves orders"),
    hr_faction   = dplyr::case_when(Faction   == 1 ~ "1st Generation Leadership Faction",
                                    Faction   == 2 ~ "Koufontinas Faction",
                                    Faction   == 3 ~ "Sardanopoulos Faction"),
    hr_resources = dplyr::case_when(Resources == 1 ~ "Controls one resource",
                                    Resources == 2 ~ "Controls two resources",
                                    Resources == 3 ~ "Controls three resources"),
    node_class   =  "person"
    ) %>%
  dplyr::select(name, node_class,
                dplyr::everything()
                )

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = FALSE,
  vertices = nodes
)

# build final dataset ==========================================================
.description <- readLines("inst/datasets/november17/description.txt",
                          warn = FALSE)

.abstract <- readLines("inst/datasets/november17/abstract.txt",
                       warn = FALSE)

.bibtex <- bibtex::read.bib("inst/datasets/november17/refs.bib")

.codebook <- data.frame(
  `edge_class` = c("connection"),
  is_bimodal  = c(FALSE), 
  is_directed = c(FALSE), 
  is_dynamic  = c(FALSE),
  is_weighted = c(FALSE),
  definition  = c("Relations indicate that open source reporting has demonstrated some connection between the two individuals at some point in the past."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "November17",
  name         = "november17",
  tags         = c("terrorism"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://www.jstor.org/stable/40295697?seq=1#metadata_info_tab_contents")

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

november17 <- list(
  reference = .reference,
  network  = .network
)

november17
