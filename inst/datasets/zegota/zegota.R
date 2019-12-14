
# Load pipes:
`%>%` <- magrittr::`%>%`

# Source: DA 4600 Tracking and Disrupting Dark Networks
# Paper: FOUO NPS Library
# Citation:

# read edges data ==============================================================
file <- .corenets_sys_file("datasets/zegota/Edgelists.xlsx")

edges <- file %>%
  readxl::excel_sheets() %>%
  purrr::discard(stringr::str_detect, pattern = "Networks") %>%
  purrr::discard(stringr::str_detect, pattern = "Attributes") %>%
  purrr::discard(stringr::str_detect, pattern = "Actors") %>%
  purrr::set_names() %>%
  purrr::imap_dfr(
    ~ readxl::read_excel(path = file, sheet = .x) %>%
      dplyr::as_tibble() %>%
      tidyr::gather("relationship", "targets", -source) %>%
      dplyr::mutate(relationship = .y,
                    targets = as.numeric(targets))
  ) %>%
  dplyr::rename(id = source) %>%
  na.omit()
  
# edit edges data ==============================================================
# import variables for recoding (all variables came from the codebook):
ids_organizations <- .corenets_read_csv(
  .corenets_sys_file(
    "datasets/zegota/resistance_organizations.csv"
    )
  )
ids_organizations <- na.omit(
  setNames(
    as.character(ids_organizations$name),
    ids_organizations$id)
  )

ids_roles         <- .corenets_read_csv(
  .corenets_sys_file(
    "datasets/zegota/roles.csv"
    )
  )
ids_roles         <- na.omit(
  setNames(
    as.character(ids_roles$name),
    ids_roles$id)
  )

ids_cells         <- .corenets_read_csv(
  .corenets_sys_file(
    "datasets/zegota/zegota_operational_ties.csv"
    )
  )
ids_cells         <- na.omit(
  setNames(
    as.character(ids_cells$name),
    ids_cells$id)
  )

ids_regions       <- .corenets_read_csv(
  .corenets_sys_file(
    "datasets/zegota/regions.csv"
    )
  )
ids_regions       <- na.omit(
  setNames(
    as.character(ids_regions$name),
    ids_regions$id)
  )
  
# actor names:
ids_names <- readxl::read_excel(path  = file,
                                sheet = "Networks") %>%
  dplyr::select(...1, ACTOR) %>%
  dplyr::rename(id   = ...1,
                name = ACTOR)
ids_names <- setNames(
  as.character(ids_names$name),
  ids_names$id)

# transform data:
edges <- edges %>%
  dplyr::mutate(
         targets = dplyr::case_when(relationship == "Zegota Friendship Network"   ~ dplyr::recode(targets,
                                                                                                  !!!ids_names),
                                    relationship == "Zegota Operational Contacts" ~ dplyr::recode(targets,
                                                                                                  !!!ids_names),
                                    relationship == "Zegota Kinship Network"      ~ dplyr::recode(targets,
                                                                                                  !!!ids_names),
                                    relationship == "Zegota Organizations"        ~ dplyr::recode(targets,
                                                                                                  !!!ids_organizations),
                                    relationship == "Organizational Roles"        ~ dplyr::recode(targets,
                                                                                                  !!!ids_roles),
                                    relationship == "Zegota Cells"                ~ dplyr::recode(targets,
                                                                                                  !!!ids_cells),
                                    relationship == "Zegota Internal Roles"       ~ dplyr::recode(targets,
                                                                                                  !!!ids_roles),
                                    relationship == "Zegota Regions"              ~ dplyr::recode(targets,
                                                                                                  !!!ids_regions)
                                    ),
         id     = dplyr::recode(id,
                                !!!ids_names),
         from_class = "people",
         to_class   = dplyr::case_when(relationship == "Zegota Friendship Network"   ~ "people",
                                       relationship == "Zegota Operational Contacts" ~ "people",
                                       relationship == "Zegota Kinship Network"      ~ "people",
                                       relationship == "Zegota Organizations"        ~ "organization",
                                       relationship == "Organizational Roles"        ~ "role",
                                       relationship == "Zegota Cells"                ~ "operational cell",
                                       relationship == "Zegota Internal Roles"       ~ "role",
                                       relationship == "Zegota Regions"              ~ "location")
         ) %>%
  dplyr::rename(from        = id,
                edge_class  = relationship,
                to          = targets) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())
  

# NOTE: Relationships need to be subset so as to match the analysis in paper.
# As such we remove the two-mode relationships:
# edges_df <- edges_df %>%
#   filter(mode == "One-mode") %>%
#   select(from, to, relationships)

# read nodes data ==============================================================
political_party <- .corenets_read_csv(
  .corenets_sys_file(
    "datasets/zegota/political_party.csv"
    )
  )
political_party <- na.omit(
  setNames(
    as.character(political_party$name),
    political_party$id)
)
postuprising_status <- .corenets_read_csv(
  .corenets_sys_file(
    "datasets/zegota/postuprising_status.csv"
    )
)
postuprising_status <- na.omit(
  setNames(
    as.character(postuprising_status$name),
    postuprising_status$id)
)
skills <- .corenets_read_csv(
  .corenets_sys_file(
    "datasets/zegota/skills.csv"
    )
  )
skills<- na.omit(
  setNames(
    as.character(skills$name),
    skills$id)
)

nodes_temp <- file %>%
  readxl::read_excel(sheet = "Attributes") %>%
  dplyr::rename(name = ...1) %>%
  dplyr::mutate(
    hr_political_party = dplyr::recode(`Political Party`,
                                       !!!political_party),
    hr_releigion = dplyr::if_else(Religion == 1,
                                  "Catholic",
                                  "Jewish"),
    hr_primary_professional_skills = dplyr::recode(`Primary Professional Skills / Cover Job`,
                                                   !!!skills),
    hr_secondary_professional_skills = dplyr::recode(`Secondary Professional Skills / Cover Job`,
                                                   !!!skills),
    hr_nationality = dplyr::case_when(Nationality == 1 ~ "Polish",
                                      Nationality == 2 ~ "Russian",
                                      Nationality == 3 ~ "German",
                                      Nationality == 4 ~ "Ukranian"),
    hr_before_ghetto_uprising_status_1943 = dplyr::recode(`Before Ghetto Uprising (1943) Status`,
                                                          !!!postuprising_status),
    hr_before_ghetto_uprising_status_1943_to_1944 = dplyr::recode(`Before Warsaw Uprising (1943-1944) Status`,
                                                          !!!postuprising_status),
    hr_post_warsaw_uprising_status_1944 = dplyr::recode(`Post-Warsaw Uprising (1944) Status`,
                                                        !!!postuprising_status),
    hr_primary_role = dplyr::recode(`Role (Pri)`,
                                    !!!ids_roles),
    hr_secondary_role = dplyr::recode(`Role (Sec)`,
                                      !!!ids_roles),
    hr_alternative_role = dplyr::recode(`Role (Alt)`,
                                        !!!ids_roles),
    hr_role_in_zegota = dplyr::recode(`Role in Zegota`,
                                      !!!ids_roles),
    hr_primary_organizational_affiliation = dplyr::recode(`Primary Organizational Affiliation`,
                                                          !!!ids_organizations),
    hr_zegota_network = dplyr::recode(`Zegota's Network`,
                                      !!!ids_cells)
  )

nodes <- edges %>%
  igraph::graph_from_data_frame() %>%
  igraph::get.data.frame("vertices") %>%
  dplyr::mutate(node_class = dplyr::case_when(name %in% ids_names         == TRUE ~ "people",
                                             name %in% ids_roles         == TRUE ~ "role",
                                             name %in% ids_organizations == TRUE ~ "organization",
                                             name %in% ids_cells         == TRUE ~ "operational cell",
                                             name %in% ids_regions       == TRUE ~ "location")
                ) %>%
  dplyr::left_join(nodes_temp, by = "name")

g <- igraph::graph_from_data_frame(
  d        = edges,
  directed = FALSE,
  vertices = nodes
)

# build final dataset ==========================================================
.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/zegota/description.txt")
  )

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/zegota/abstract.txt")
  )

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/zegota/refs.bib")
  )

.codebook <- data.frame(
  `edge_class` = c("Zegota Friendship Network",
                   "Zegota Kinship Network",
                   "Zegota Operational Contacts",
                   "Organizational Roles",
                   "Zegota Cells",
                   "Zegota Internal Roles",
                   "Zegota Organizations",
                   "Zegota Regions"),
  is_bimodal  = c(FALSE,
                  FALSE,
                  FALSE,
                  TRUE,
                  TRUE,
                  TRUE,
                  TRUE,
                  TRUE), 
  is_directed = c(FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE), 
  is_dynamic  = c(FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE),
  is_weighted = c(FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE,
                  FALSE),
  definition  = c("Not defined by the authors, but noted as 'indicative of trust between actors'.",
                  "Such as brother, brother-in-law, nephew and marriages.",
                  "Not defined by the authors. Ties people to people.",
                  "Not defined by the authors. Ties people to roles (e.g., founder, leader, etc.).",
                  "Not defined by the authors. Ties people to organizations internal to Zegota (e.g., Anti-szmalcownik Cell, Child welfare Cell, etc.).",
                  "Not defined by the authors. Ties people to roles (e.g., founder, leader, etc.).",
                  "Not defined by the authors. Ties people to organizations external to Zegota (e.g., Allied Forces and Leaders, Armia Krajowa (Home Army), etc.).",
                  "Not defined by the authors. Ties people to regions (e.g., Aushwitz, United States, etc.)."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "Zegota",
  name         = "zegota",
  tags         = c("terrorism"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "")

.network <- list(
  metadata    = unnest_edge_class(g = g,
                                  edge_class_name = "edge_class") %>%
    purrr::set_names(unique(igraph::edge_attr(
      graph = g,
      name  = "edge_class"))) %>%
    purrr::map(~ .x %>%
                 generate_graph_metadata(codebook = .codebook)
               ),
  nodes_table = igraph::as_data_frame(g, what = "vertices"),
  edges_table = igraph::as_data_frame(g, what = "edges")
)

zegota <- list(
  reference = .reference,
  network  = .network
)

zegota

