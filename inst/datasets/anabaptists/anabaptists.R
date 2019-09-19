
# Load pipes:
`%>%` <- magrittr::`%>%`
`!!!` <- rlang::`!!!`

# paper: https://apps.dtic.mil/dtic/tr/fulltext/u2/a632471.pdf

# helper vars ==================================================================
# key-value maps to recode `Origin #` and `Operate #`
kv_origins <- c(
  "1" = "Austria",
  "2" = "France",
  "3" = "Germany",
  "4" = "Italy",
  "5" = "Moravia",
  "6" = "Netherlands",
  "7" = "Poland",
  "8" = "Switzerland"
)

kv_bases <- c(
  "1" = "Austria",
  "2" = "Germany",
  "3" = "Moravia",
  "4" = "Netherlands",
  "5" = "Switzerland"
)

# read "raw" data ==============================================================
init_attrs <- readr::read_csv("inst/datasets/anabaptists/Anabaptist_Attributes.csv")

# clean node attributes ========================================================
groups_attr <- init_attrs %>%
  dplyr::rename(name = X1) %>% 
  dplyr::mutate(is_anabaptist = Anabaptist == 1) %>% 
  # keep name and group cols
  dplyr::select(name,
                is_anabaptist,
                Melchiorite,
                `Swiss Brethren`,
                `Other Anabaptist`,
                Lutheran,
                Reformed,
                `Other Protestant`,
                Denck,
                Hut,
                Hutterite) %>% 
  # melt data frame
  tidyr::gather(group,
                val,
                -name,
                -is_anabaptist) %>% 
  # keep "TRUE" rows
  dplyr::filter(val == 1) %>% 
  # drop "TRUE"/"FALSE" column
  dplyr::select(-val)

nodes_df <- init_attrs %>% 
  # use "better" names
  dplyr::rename(
    name                 = X1,
    violence_sanctioning = Violence,            # paper: p. 47
    apocalyptic          = Apocalyptic,         # paper: p. 47
    believer_baptist     = `Believers Baptism`, # paper: p. 2
    origin               = `Origin #`,
    based_in             = `Operate #`,
    munster_rebel        = `Münster Rebellion`
  ) %>% 
  dplyr::mutate(hr_origin               = dplyr::recode(origin,
                                                        !!!kv_origins),
                hr_based_in             = dplyr::recode(based_in,
                                                        !!!kv_bases),
                is_violence_sanctioning = dplyr::if_else(violence_sanctioning == 1,
                                                         TRUE,
                                                         FALSE),
                is_apocalyptic          = dplyr::if_else(apocalyptic == 1,
                                                         TRUE,
                                                         FALSE),
                is_believer_baptist     = dplyr::if_else(believer_baptist == 1,
                                                         TRUE,
                                                         FALSE),
                is_munster_rebel        = dplyr::if_else(munster_rebel == 1,
                                                         TRUE,
                                                         FALSE),
                node_class              = "people"
                ) %>%
  # attach attribute containing all groups
  dplyr::left_join(groups_attr,
                   by = "name"
                   ) %>%
  dplyr::mutate(hr_group = group
                ) %>%
  # reorder columns
  dplyr::select(name, node_class,
         # Original variables --------------------------------------------------
         believer_baptist, violence_sanctioning, munster_rebel, apocalyptic,
         Anabaptist, Melchiorite, `Swiss Brethren`, Denck, Hut, Hutterite,
         `Other Anabaptist`, Lutheran, Reformed, `Other Protestant`, Tradition,
         origin, based_in,
         # Human readable variables --------------------------------------------
         hr_origin, hr_based_in, hr_group, is_violence_sanctioning, 
         is_apocalyptic, is_believer_baptist, is_munster_rebel, is_anabaptist
         ) 

# pull edges from pajek file
edges_df <- igraph::read_graph("inst/datasets/anabaptists/Anabaptist_Leaders.net",
                               format = "paj") %>%
  igraph::as_data_frame() %>% 
  dplyr::select(-weight) %>% 
  # fix name that doesn't match
  dplyr::mutate_all(~ dplyr::if_else(. == "Boekbinder", "Gerrit Boekbinder", .)) %>% 
  # pajek file is tracking edges in both directions, but it's supposed to be
  # undirected
  dplyr::distinct() %>% 
  dplyr::mutate(edge_type  = "Face-to-Face Meeting",
                from_class = "people",
                to_class   = "people") %>%
  dplyr::select(from, to, from_class, to_class, edge_type,
                dplyr::everything())

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges_df,
  directed = FALSE,
  vertices = nodes_df
)

# build final dataset ==========================================================
.description <- readLines("inst/datasets/anabaptists/description.txt",
                          warn = FALSE)

.abstract <- readLines("inst/datasets/anabaptists/abstract.txt",
                       warn = FALSE)

.bibtex <- bibtex::read.bib("inst/datasets/anabaptists/refs.bib")

.codebook <- data.frame(
  `edge_type` = c("Face-to-Face Meeting"),
  is_bimodal  = c(FALSE),
  is_directed = c(FALSE),
  is_dynamic  = c(FALSE),
  is_weighted = c(FALSE),
  definition  = c("Ties indicate that the two actors met one another at some point in time or were in conversation with one another. In many cases, the leaders worked together, or went to school together. In other cases, they opposed one another in debates and were at total odds with one another. The importance of looking at ties, regardless of sentiment, is that this data set provides a better understanding as to who had access to different ideas throughout the overall network, and who was isolated."),
  stringsAsFactors = FALSE
)

.metadata <- list(
  title        = "Anabaptist Leadership Network",
  name         = "anabaptists",
  tags         = c("Anabaptists",
                   "religious violence",
                   "charismatic leadership",
                   "isolation",
                   "apocalypticism"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "https://apps.dtic.mil/dtic/tr/fulltext/u2/a632471.pdf")

.network <- list(
  net_metadata = COREnets:::unnest_edge_types(g = g,
                                              edge_type_name = "edge_type") %>%
    purrr::map(~ .x %>%
                 COREnets:::generate_graph_metadata(codebook = .codebook)
    ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

anabaptists <- list(
  metadata = .metadata,
  network  = .network
)

anabaptists
