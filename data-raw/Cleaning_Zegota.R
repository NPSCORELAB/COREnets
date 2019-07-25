
library(igraph)
library(tidyverse)
library(COREnets)
library(readxl)

# Source: DA 4600 Tracking and Disrupting Dark Networks
# Paper: 
# Citation:

# read edges data ==============================================================
file <- "datasets/Zegota/Edge Lists.xlsx"

edges_df <- file %>%
  readxl::read_excel(sheet = "Networks") %>%
  as_tibble() %>%  
  rename(id = ...1,
         name = ACTOR)

# edit edges data ==============================================================
# import variables for recoding (all variables came from the codebook):
ids_organizations <- read_csv("datasets/Zegota/resistance_organizations.csv")
organizations     <- setNames(as.character(ids_organizations$name),
                              ids_organizations$id) %>%
  na.omit()

ids_roles         <- read_csv("datasets/Zegota/roles.csv")
roles             <- setNames(as.character(ids_roles$name),
                              ids_roles$id) %>%
  na.omit()

ids_cells         <- read_csv("datasets/Zegota/zegota_operational_ties.csv")
cells             <- setNames(as.character(ids_cells$name),
                              ids_cells$id) %>%
  na.omit()

ids_regions       <- read_csv("datasets/Zegota/regions.csv")
regions           <- setNames(as.character(ids_regions$name),
                              ids_regions$id) %>%
  na.omit()
  
# actor names:
ids_names <- edges_df %>%
  select(id, name)
ids <- setNames(as.character(ids_names$name),
                              ids_names$id)

# transform data:
edges_df <- edges_df %>%
  select(id,
         Friendship,
         `Operational Contacts`,
         Kinship,
         Organizations,
         Roles,
         `Zegota Cells`,
         `Zegota Roles`,
         Regions) %>%
  gather("relationship", "targets", -id) %>%
  mutate(targets = str_split(targets, pattern = ",")) %>%
  unnest() %>%
  drop_na() %>%
  mutate(targets = as.character(as.numeric(targets)),
         mode    = if_else(relationship %in% c("Friendship",
                                               "Operational Contacts",
                                               "Kinship"),
                           "One-mode",
                           "Two-mode"),
         recoded = case_when(mode         == "One-mode"      ~ recode(targets, !!!ids),
                             relationship == "Organizations" ~ recode(targets, !!!organizations),
                             relationship == "Roles"         ~ recode(targets, !!!roles),
                             relationship == "Zegota Cells"  ~ recode(targets, !!!cells),
                             relationship == "Zegota Roles"  ~ recode(targets, !!!roles),
                             relationship == "Regions"       ~ recode(targets, !!!regions)
                             )

         ) %>%
  left_join(ids_names, by = "id") %>%
  select(name, recoded, relationship, mode) %>%
  rename(from           = name,
         relationships = relationship,
         to             = recoded)

# NOTE: Relationships need to be subset so as to match the analysis in paper.
# As such we remove the two-mode relationships:
edges_df <- edges_df %>%
  filter(mode == "One-mode") %>%
  select(from, to, relationships)

# read nodes data ==============================================================
file <- "datasets/Zegota/Edge Lists.xlsx"

nodes_df <- file %>%
  readxl::read_excel(sheet = "Attributes") %>%
  as_tibble() %>%  
  rename(name = ...1)

# edit nodes data ==============================================================
# import variables for recoding (all variables came from the codebook):
political_party <- read_csv("datasets/Zegota/political_party.csv")
political_party <- setNames(as.character(political_party$name),
                                political_party$id) %>%
  na.omit()

postuprising_status <- read_csv("datasets/Zegota/postuprising_status.csv")
postuprising_status <- setNames(as.character(postuprising_status$name),
                                    postuprising_status$id) %>%
  na.omit()

skills <- read_csv("datasets/Zegota/skills.csv")
skills<- setNames(as.character(skills$name),
                                skills$id) %>%
  na.omit()

# recode:
nodes_df <- nodes_df %>%
  mutate(hr_political_party = recode(`Political Party`, !!!political_party),
         hr_releigion = if_else(Religion == 1, "Catholic", "Jewish"),
         hr_primary_professional_skills = recode(`Primary Professional Skills / Cover Job`,
                                                 !!!skills),
         hr_secondary_professional_skills = recode(`Secondary Professional Skills / Cover Job`,
                                                   !!!skills),
         hr_nationality = case_when(Nationality == 1 ~ "Polish",
                                    Nationality == 2 ~ "Russian",
                                    Nationality == 3 ~ "German",
                                    Nationality == 4 ~ "Ukranian"),
         hr_before_ghetto_uprising_status_1943 = recode(`Before Ghetto Uprising (1943) Status`,
                                                        !!!postuprising_status),
         hr_before_ghetto_uprising_status_1943_to_1944 = recode(`Before Warsaw Uprising (1943-1944) Status`,
                                                                !!!postuprising_status),
         hr_post_warsaw_uprising_status_1944 = recode(`Post-Warsaw Uprising (1944) Status`,
                                                      !!!postuprising_status),
         hr_primary_role = recode(`Role (Pri)`,
                                  !!!roles),
         hr_secondary_role = recode(`Role (Sec)`,
                                    !!!roles),
         hr_alternative_role = recode(`Role (Alt)`,
                                      !!!roles),
         hr_role_in_zegota = recode(`Role in Zegota`,
                                    !!!roles),
         hr_primary_organizational_affiliation = recode(`Primary Organizational Affiliation`,
                                                        !!!organizations),
         hr_zegota_network = recode(`Zegota's Network`,
                                    !!!cells)
  )


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
    node_type    = "people",
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

.introduction <- "This network represents a multitude of Polish resistance organization in Nazi occupied Poland (1942 -1945). The authors explore how Zegota, an underground organization, served as a synchronizing element in this broader network. Specifically, the ability to 'galvanize conditional actors to lead, manage and fascilitate a collection of networks toward a unified objective'."

.abstract <- "From 1942 to 1945, Zegota served as an underground organization of Polish resistance in German-occupied Poland. While, the individual organizations that make up this network were developed to provide security, gather food, coordinate excapes, rescue children, provide education, and counter anti-Jewish propaganda to name a few, until the formation of Zegota in 1942 none served to aid Jews. The authors of this research focused on how Zegota synchronized the efforts of multiple organizations to achieve a particular goal."

.codebook <- data.frame(
    relationship = c("Friendship",
                     "Kinship",
                     "Operational Contacts"),
    data_type = c("one-mode",
                  "one-mode",
                  "one-mode"),
    definition = c("Not defined by the authors, but noted as 'indicative of trust between actors'.",
                   "Such as brother, brother-in-law, nephew and marriages.",
                   "Not defined by the authors."),
    stringsAsFactors = FALSE
  )

.bibtex <- c(
  "@MastersThesis{zegota_2013,
  Title    = {UW Conceptualization of Resistance Networks: Illuminating 21st Century Uncertainty},
  Author   = {Kemokay, Nguanyade S. and Ludwig, Thomas},
  type     = {Masters of Science Thesis},
  School   = {Naval Postgraduate School, Department of Defense Analysis},
  Year     = {2013},
  }"
)

zegota <- list(
  metadata = list(
    title       = "Zegota Network",
    name        = "zegota",
    category    = "resistance",
    tags        = c("resistance groups", "religious"),
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  codebook = .codebook,
  network = .network
)

usethis::use_data(zegota, overwrite = TRUE)