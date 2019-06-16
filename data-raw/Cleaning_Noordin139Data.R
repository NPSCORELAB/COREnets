
library(igraph)
library(tidyverse)
library(COREnets)
library(readxl)

# paper: 
# codebook: http://www.thearda.com/archive/files/codebooks/origCB/Noordin%20Subset%20Codebook.pdf

# read edges data ======================================================================
files <- "datasets/Noordin 139 Data.xlsx"

edges <- files %>%
  readxl::excel_sheets()%>%
  purrr::discard(stringr::str_detect, pattern = "Attributes") %>%
  purrr::set_names() %>%
  purrr::imap_dfr(
    ~ readxl::read_excel(path = files, sheet = .x) %>%
      as.data.frame() %>%
      COREnets::to_matrix() %>%
      COREnets::to_graph() %>%
      COREnets::to_one_mode(auto = TRUE, project = "rows") %>%
      igraph::get.data.frame("edges") %>%
      dplyr::mutate(relationships = .y)
  ) 
  
# read attribute data ==================================================================

attrs <- files %>%
  readxl::excel_sheets() %>%
  purrr::keep(stringr::str_detect, pattern = "Attributes") %>%
  purrr::map_dfr(
    ~ readxl::read_excel(path = files, sheet = .x) %>%
      dplyr::as_tibble()
    )

# build node table =====================================================================

nodes <- data.frame(name = c(edges$from, edges$to)) %>%
  unique() %>%
  left_join(attrs, by=c("name"="...1"))

# Note 15 - June - 2019 ================================================================
# Three nodes are missing all attibutes:
# nodes %>% filter(is.na(`Education Level`)==TRUE)
#               name Education Level Contact with People Military Training Nationality Current Status (ICG Article) Current Status (Updated)
#1    Suramto (Deni)              NA                  NA                NA          NA                           NA                       NA
#2 Mohamed Saifuddin              NA                  NA                NA          NA                           NA                       NA
#3     Mohammed Faiz              NA                  NA                NA          NA                           N

# clean node table =====================================================================

nodes <- nodes %>%
  mutate(
    education_level = case_when(`Education Level` == 0 ~ "Unknown",
                                `Education Level` == 1 ~ "Elementary Education ",
                                `Education Level` == 2 ~ "Pesantren (Luqmanul Hakiem, Ngruki, al-Husein, Indramayu, Jemaah Islamiyah)",
                                `Education Level` == 3 ~ "State High School",
                                `Education Level` == 4 ~ "Some University (University an-Nur, Univeristi Teknologi Malaysia, Adelaide University, Bogor Agricultural Univ.)",
                                `Education Level` == 5 ~ "BA/BS Designation",
                                `Education Level` == 6 ~ "Some Graduate School",
                                `Education Level` == 7 ~ "Masters",
                                `Education Level` == 8 ~ "PhD (includes Reading University)"),
    contact_w_people = case_when(`Contact with People` ==  0 ~ "Unknown",
                                 `Contact with People` ==  1 ~ "Afghanistan",
                                 `Contact with People` ==  2 ~ "Australia",
                                 `Contact with People` ==  3 ~ "Malaysia",
                                 `Contact with People` ==  4 ~ "Pakistan",
                                 `Contact with People` ==  5 ~ "Philippines",
                                 `Contact with People` ==  6 ~ "Singapore",
                                 `Contact with People` ==  7 ~ "Thailand",
                                 `Contact with People` ==  8 ~ "United Kingdom",
                                 `Contact with People` ==  9 ~ "Afghanistan & Malaysia",
                                 `Contact with People` == 10 ~ "Afghanistan & Pakistan",
                                 `Contact with People` == 11 ~ "Afghanistan & Philippines",
                                 `Contact with People` == 12 ~ "Afghanistan, Malaysia, & Philippines",
                                 `Contact with People` == 13 ~ "Australia & Malaysia",
                                 `Contact with People` == 14 ~ "Philippines & Malaysia",
                                 `Contact with People` == 15 ~ "Afghanistan, Pakistan, Egypt",
                                 `Contact with People` == 16 ~ "Iraq, Afghanistan and Pakistan"),
    military_training = case_when(`Military Training` ==  0 ~ "Unknown",
                                  `Military Training` ==  1 ~ "Afghanistan",
                                  `Military Training` ==  2 ~ "Australia",
                                  `Military Training` ==  3 ~ "Indonesia",
                                  `Military Training` ==  4 ~ "Malaysia",
                                  `Military Training` ==  5 ~ "Philippines",
                                  `Military Training` ==  6 ~ "Singapore",
                                  `Military Training` ==  7 ~ "Afghanistan & Indonesia",
                                  `Military Training` ==  8 ~ "Afghanistan & Philippines",
                                  `Military Training` ==  9 ~ "Indonesia & Malaysia",
                                  `Military Training` == 10 ~ "Indonesia & Philippines",
                                  `Military Training` == 11 ~ "Afghanistan & Iraq"),
    nationality = case_when(Nationality == 1 ~ "Afghanistan",
                            Nationality == 2 ~ "Australia",
                            Nationality == 3 ~ "Indonesia",
                            Nationality == 4 ~ "Malaysia",
                            Nationality == 5 ~ "Philippines",
                            Nationality == 6 ~ "Singapore",
                            Nationality == 7 ~ "Saudi Arabia",
                            Nationality == 8 ~ "Jordan",
                            Nationality == 9 ~ "Egypt"),
    current_status_per_icg_article = case_when(`Current Status (ICG Article)` == 0 ~ "Dead",
                                               `Current Status (ICG Article)` == 1 ~ "Alive",
                                               `Current Status (ICG Article)` == 2 ~ "Jail"),
    current_status_updated = case_when(`Current Status (Updated)` == 0 ~ "Dead",
                                       `Current Status (Updated)` == 1 ~ "Alive",
                                       `Current Status (Updated)` == 2 ~ "Jail"),
    role_original_coding = case_when(`Role (Original Coding)` ==  0 ~ "no info/unclear",
                                     `Role (Original Coding)` ==  1 ~ "strategist",
                                     `Role (Original Coding)` ==  2 ~ "bomb maker",
                                     `Role (Original Coding)` ==  3 ~ "bomber/fighter",
                                     `Role (Original Coding)` ==  4 ~ "trainer/instructor",
                                     `Role (Original Coding)` ==  5 ~ "suicide bomber",
                                     `Role (Original Coding)` ==  6 ~ "recon and surveillance",
                                     `Role (Original Coding)` ==  7 ~ "recruiter",
                                     `Role (Original Coding)` ==  8 ~ "courier/go-between",
                                     `Role (Original Coding)` ==  9 ~ "propagandist",
                                     `Role (Original Coding)` == 10 ~ "facilitator",
                                     `Role (Original Coding)` == 11 ~ "religious leader",
                                     `Role (Original Coding)` == 12 ~ "commander/tactical leader"),
    # role_expanded_primary = case_when(`Role Expanded (Primary)` == 1 ~ ""), # not in codebook
    # role_expanded_secondary = case_when(`Role Expanded (Secondary)` == 1 ~ ""), # not in codebook
    # logistic_function = case_when(`Logistic Function` == 1 ~ ""), # not in codebook
    # technical_skills = case_when(`Technical Skills` == 1 ~ ""), # not in codebook
    primary_group_affiliation = case_when(`Primary Group Affiliation` == 0 ~ "None (Noordin)",
                                          `Primary Group Affiliation` == 1 ~ "Darul Islam (DI)",
                                          `Primary Group Affiliation` == 2 ~ "KOMPAK",
                                          `Primary Group Affiliation` == 3 ~ "Jemaah Islamiyah (JI)",
                                          `Primary Group Affiliation` == 4 ~ "Ring Banten Group (DI)",
                                          `Primary Group Affiliation` == 5 ~ "Al-Qaeda"),
    is_noordin_network = ifelse(`Noordin's Network` == 0, FALSE, TRUE),
    is_orginal_79 = ifelse(`Original 79` == 0, FALSE, TRUE)
  ) %>%
  select(education_level, contact_w_people, military_training, nationality,
         current_status_per_icg_article, current_status_updated, role_original_coding,
         #role_expanded_primary, role_expanded_secondary, logistic_function, technical_skills,
         primary_group_affiliation, is_noordin_network, is_orginal_79
         )

# build igraph object ==================================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE,
  vertices = nodes
)
