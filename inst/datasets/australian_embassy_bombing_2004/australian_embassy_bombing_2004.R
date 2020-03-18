# Load pipes:
`%>%` <- magrittr::`%>%`
`!!!` <- rlang::`!!!`

# data: http://doitapps.jjay.cuny.edu/jjatt/data.php

# read "raw" data ==============================================================
nodes <- .corenets_read_csv(
  .corenets_sys_file("datasets/australian_embassy_bombing_2004/AE_Nodes_Public_Version2.csv")
)
edges <- .corenets_read_csv(
  .corenets_sys_file("datasets/australian_embassy_bombing_2004/AE_Relations_Public_Version2.csv")
)

# Clean up the edges data ======================================================
edges <- edges %>%
  dplyr::select(ID, Tie_ID, Kinship, `1985_1989`, `1990_1994`, `1995_1999`, 
                `2000`, `2001`, `2002`, `2003`, `2004`, `2005`, `2006`, 
                `2007`) %>%
  tidyr::gather(key, value, -ID, -Tie_ID, -Kinship) %>%
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
           Kinship == 7 ~ "significant other (not married)")
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
  dplyr::select(name, node_class,
                dplyr::everything())

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE,
  vertices = nodes
)  

# build final dataset ==========================================================
.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/australian_embassy_bombing_2004/description.txt")
)

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/australian_embassy_bombing_2004/abstract.txt")
)

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/australian_embassy_bombing_2004/refs.bib")
)

.codebook <- data.frame(
  `edge_class` = c(#"No relationship known",
                   "Acquaintances/Distant familiy ties",
                   "Friends/Moderately close family ties",
                   "Close Friends/Family"),
  is_bimodal  = c(#FALSE,
    FALSE, FALSE, FALSE),
  is_directed = c(#FALSE,
    FALSE, FALSE, FALSE),
  is_dynamic  = c(#TRUE,
    TRUE, TRUE, TRUE),
  is_weighted = c(#FALSE,
    FALSE, FALSE, FALSE),
  definition  = c(#"No relationship known",
                  "Acquaintances/Distant family ties (interactions limited to radical organization activities)",
                  "Friends/Moderately close family ties (interactions extend beyond radical organizations to include such categories as co-workers and roommates). Operational/Organizational leadership (i.e. JI leadership, formally or informally “ranking” members of burgeoning cells). Operational Ties (i.e. worked closely on a bombing together).",
                  "Close Friends/Family, Tight-knit operational cliques (would die for each other"),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Australian Embassy Bombing 2004, Indonesia",
  name         = "australian_embassy_bombing_2004",
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

australian_embassy_bombing_2004 <- list(
  reference = .reference,
  network  = .network
)

australian_embassy_bombing_2004
