# Load pipes:
`%>%` <- magrittr::`%>%`
`!!!` <- rlang::`!!!`

# data: http://doitapps.jjay.cuny.edu/jjatt/data.php

# read "raw" data ==============================================================
nodes <- .corenets_read_csv(
  .corenets_sys_file("datasets/southeast_asian_aggregate_attack_series_2005/SEA_Nodes_Public_Version2.csv")
)
edges <- .corenets_read_csv(
  .corenets_sys_file("datasets/southeast_asian_aggregate_attack_series_2005/SEA_Relations_Public_Version2.csv")
)

# Clean up the edges data ======================================================
edges <- edges %>%
  dplyr::select(-c(Op_role, Tie_Year, Tie_Extinguish)) %>%
  tidyr::gather(key, value, -ID, -Tie_ID, -Kinship, -Operation_ID) %>%
  dplyr::rename(from = ID, to = Tie_ID, edge_time = key, edge_code = value) %>%
  dplyr::mutate(from_class = "person",
                to_class   = "person",
                edge_class = dplyr::case_when(
                  edge_code == 0 ~ "No relationship known",
                  edge_code == 1 ~ "Acquaintances/Distant familiy ties",
                  edge_code == 2 ~ "Friends/Moderately close family ties",
                  edge_code == 3 ~ "Close Friends/Family"),
                kinship = dplyr::case_when(
                  Kinship == 0 ~ "no kinship",
                  Kinship == 1 ~ "in-laws",
                  Kinship == 2 ~ "cousins",
                  Kinship == 3 ~ "sibling",
                  Kinship == 4 ~ "parent/child",
                  Kinship == 5 ~ "married",
                  Kinship == 6 ~ "grandparent/child",
                  Kinship == 7 ~ "significant other (not married)"),
                associated_operation = dplyr::case_when(
                  Operation_ID      == "16" ~ "Christmas Eve bombings (Indonesia, December 24, 2000)",
                  Operation_ID      == "16, 24" ~ "Christmas Eve bombings (Indonesia, December 24, 2000), Bali I bombings (Bali, Indonesia, October 1, 2002)",
                  Operation_ID      == "16,24" ~ "Christmas Eve bombings (Indonesia, December 24, 2000), Bali I bombings (Bali, Indonesia, October 1, 2002)",
                  Operation_ID      == "16,24,36" ~ "Christmas Eve bombings (Indonesia, December 24, 2000), Bali I bombings (Bali, Indonesia, October 1, 2002), Philippines Ambassador Residence (PAR) bombing (Jakarta, Indonesia, August 1, 2000)",
                  Operation_ID      == "16,36" ~ "Christmas Eve bombings (Indonesia, December 24, 2000), Philippines Ambassador Residence (PAR) bombing (Jakarta, Indonesia, August 1, 2000)",
                  Operation_ID      == "24" ~ "Bali I bombings (Bali, Indonesia, October 1, 2002)",
                  Operation_ID      == "24,36" ~ "Bali I bombings (Bali, Indonesia, October 1, 2002), Philippines Ambassador Residence (PAR) bombing (Jakarta, Indonesia, August 1, 2000)",
                  Operation_ID      == "24,43,44" ~ "Bali I bombings (Bali, Indonesia, October 1, 2002), Australian Embassy Bombing (Jakarta, Indonesia, September 4, 2004), Bali II Bombings (Bali, Indonesia, October 1, 2005)",
                  Operation_ID      == "36" ~ "Philippines Ambassador Residence (PAR) bombing (Jakarta, Indonesia, August 1, 2000)",
                  Operation_ID      == "43" ~ "Australian Embassy Bombing (Jakarta, Indonesia, September 4, 2004)",
                  Operation_ID      == "44" ~ "Bali II Bombings (Bali, Indonesia, October 1, 2005)",
                  Operation_ID      == "44, 43" ~ "Australian Embassy Bombing (Jakarta, Indonesia, September 4, 2004), Bali II Bombings (Bali, Indonesia, October 1, 2005)",
                  Operation_ID      == "44,43" ~ "Australian Embassy Bombing (Jakarta, Indonesia, September 4, 2004), Bali II Bombings (Bali, Indonesia, October 1, 2005)"
                )
  ) %>%
  dplyr::filter(!is.na(edge_code)) %>%
  dplyr::filter(edge_code != 0) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# Clean up the nodes data ======================================================
nodes <- nodes %>%
  dplyr::rename(
    name = ID
  ) %>%
  dplyr::select(
    -c(Color)
  ) %>%
  tidyr::gather(key, value, -name, -Group, -Arrest_Date, -Release_Date,
                -Death_Date) %>%
  dplyr::mutate(
    value = dplyr::case_when(
      value == 0 ~ "dead",
      value == 1 ~ "in custody",
      value == 2 ~ "free",
      value == 3 ~ "released"),
    node_class = "person"
  ) %>% 
  tidyr::spread(key, value) %>%
  dplyr::select(name, node_class, dplyr::everything())

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE,
  vertices = nodes
)  

# build final dataset ==========================================================
.description <- .corenets_read_file(
  .corenets_sys_file("datasets/southeast_asian_aggregate_attack_series_2005/description.txt")
)

.abstract <- .corenets_read_file(
  .corenets_sys_file("datasets/southeast_asian_aggregate_attack_series_2005/abstract.txt")
)

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/southeast_asian_aggregate_attack_series_2005/refs.bib")
)

.codebook <- data.frame(
  `edge_class` = c("No relationship known",
                   "Acquaintances/Distant familiy ties",
                   "Friends/Moderately close family ties",
                   "Close Friends/Family"),
  is_bimodal  = c(FALSE, FALSE, FALSE, FALSE),
  is_directed = c(FALSE, FALSE, FALSE, FALSE),
  is_dynamic  = c(TRUE, TRUE, TRUE, TRUE),
  is_weighted = c(FALSE, FALSE, FALSE, FALSE),
  definition  = c("No relationship known",
                  "Acquaintances/Distant family ties (interactions limited to radical organization activities)",
                  "Friends/Moderately close family ties (interactions extend beyond radical organizations to include such categories as co-workers and roommates). Operational/Organizational leadership (i.e. JI leadership, formally or informally “ranking” members of burgeoning cells). Operational Ties (i.e. worked closely on a bombing together).",
                  "Close Friends/Family, Tight-knit operational cliques (would die for each other"),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Southeast Asian Aggregate Attack Series 2005, Indonesia",
  name         = "southeast_asian_aggregate_attack_series_2005",
  tags         = c("terrorism"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "http://doitapps.jjay.cuny.edu/jjatt/data.php")

.network <- list(
  metadata    = unnest_edge_class(g = g, edge_class_name = "edge_class") %>%
    purrr::set_names(unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class"))) %>%
    purrr::map(~ .x %>% generate_graph_metadata(codebook = .codebook)
    ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

southeast_asian_aggregate_attack_series_2005 <- list(
  reference = .reference,
  network  = .network
)

southeast_asian_aggregate_attack_series_2005
