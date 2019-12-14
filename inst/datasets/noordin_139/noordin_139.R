
# Load pipes:
`%>%` <- magrittr::`%>%`
`!!!` <- rlang::`!!!`

# paper: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.1026.7447&rep=rep1&type=pdf
# codebook: http://www.thearda.com/archive/files/codebooks/origCB/Noordin%20Subset%20Codebook.pdf

insurgent_organizations <- c(
  "Islamic Defenders Front (FPI) Pekalongan Branch",
  "Jemaah Islamiyah (JI)",
  "Darul Islam (DI)",
  "Ring Banten (DI) (3)",
  "KOMPAK Charity",
  "KOMPAK Mujahidin",
  "KOMPAK-Ambon Office",
  "KOMPAK-Waihong",
  "JI Central Command (8)",
  "Majelis Mujuhidin Indonesia (MMI)",
  "JI Mantiqi II  (5)",
  "JI East Java Wakalah",
  "Al-Qaeda",
  "Darul Islam West Java Division (DI)",
  "JI Mantiqi  I (4)",
  "Komando Jihad",
  "Laskar Jundullah",
  "STAIN Group",
  "AMIN",
  "Abu Bakar Battalion (1)",
  "Darul Islam in Maluku (DI)",
  "KOMPAK-Solo Office",
  "Cimmangis Group",
  "Mujahidin Kayamanya",
  "Darul Islam Banten Battalion for Region IX (DI)",
  "Kumpulan Mujahidin Malaysia (KMM)",
  "JI Johor Wakalah",
  "JI Mantiqi III (6)",
  "JI Central Java Wakalah",
  "Laskar Khos"
  )
schools <- c(
  "Pondok Ngruki/al-Mukmin",
  "Luqmanul Hakeim",
  "Gontor",
  "Universitas\r\nan-Nur/\r\nMahad Aly",
  "STAIN in Solo",
  "Miftahul huda-pesantren, Cikampek",
  "Adelaide University",
  "Reading\r\nUniversity, UK",
  "University of Technology, Malaysia",
  "Unknown Name of School in Bangil, East Java",
  "Universitas\r\nNegeri\r\nMalang",
  "Bogor Agricultural University",
  "Serang Islamic\r\nHigh School",
  "Darul\r\nFitroh",
  "Sukabumi",
  "Darusysyahada",
  "Brawijaya University in Malang",
  "al-Mutaqien, Indramayu",
  "al-Husein, Indramayu",
  "al-Muttaqien, Jepara",
  "Pesantren\r\nIsykarima,\r\nSolo"
) 
training_events <- c(
  "03 Mindanao Training",
  "Jul 04 West Ceram",
  "Oct 99 Waimurat, Buru Training",
  "May 04 Training",
  "Jan 04 Bomb Making",
  "Solo Course",
  "Training for BALI II in 'Selera' restaurant",
  "Australian Embassy Religious Training",
  "Azhari Apprenticeship",
  "Jun 04 Bomb Making",
  "99 Mindanao Training",
  "03 Rois Training",
  "01-02 Ujunj Kulon Training",
  "08-01 to 09-01 Training",
  "Post-Bali Mil Refresh Training"
)
businesses <- c(
  "Tobacco Business",
  "Clothing Business",
  "Darussalam Foundation",
  "CV Courier Business -- West Java",
  "Small Trading Business -- Surabaya",
  "Shock Absorber Repair Shop",
  "Used Cloth Business",
  "Indonesian Muslim Worker's Union",
  "Sawt al-Jihad Online Magazine",
  "Al-Bayan Magazine"
)
operations <- c(
  "Bali II    (Oct 05)",
  "Bombing Attack on Philippine Ambassador in Jakarta (Aug 00)",
  "Bali I    (Oct 02)",
  "Robbery To Raise Funds For Bali I (Aug 02)",
  "Christmas Eve Bombings    (Dec 00)",
  "Australian Embassy (Sep 04)",
  "Mosque Bombing in Yogyakarta (2000)",
  "Attack on Brimob Post in West Ceram (May 05)",
  "Marriott (Aug 03)",
  "Atrium Mall Bombing (Aug 01)",
  "Rizal Day Bombing (Dec 00)",
  "Murder Of Palu Prosecutor Fery Silalahi (May 04)",
  "Robbery of Mobile Phone Store in Pekalongan (Sep 03)",
  "Robbery of Medan Bank (May 03)"
)
mosques <- c(
  "Pekalongan Pengajian (Religious Study Circle)",
  "Kedire Mosque",
  "Banten Mosque",
  "Surabaya Mosque I al Ikhsun",
  "Solo Musque (an Nur School)",
  "Cipayung Mosque",
  "Surabaya Mosque II Airlangga University"
)
logistical_locations <- c(
  "PEKALONGAN",
  "POSO",
  "COTABATO",
  "DATU PIANG",
  "TAWAU",
  "WONOSOBO",
  "DUMAI",
  "AMBON",
  "JAKARTA",
  "SOLO",
  "CIANJUR",
  "SURABAYA",
  "BLITAR",
  "KARTOSURA",
  "MOJOKERTO",
  "SEMARANG",
  "YOGYAKARTA",
  "PASURUAN",
  "ANYER",
  "BUKITTINGGI",
  "MOJOAGUNG",
  "BANDUNG",
  "PALABUHANRATU",
  "BOYOLALI",
  "PEKANBARU",
  "INDRAMAYU",
  "BENGKULU",
  "MEDAN"
)
logistical_function <- c(
  "Material",
  "Transportation",
  "Weapons",
  "Safehouse"
)
meetings <- c(
  "Meeting  1",
  "Meeting  2",
  "Meeting  3",
  "Meeting  4",
  "Meeting  5",
  "Meeting  6",
  "Meeting  7",
  "Meeting  8",
  "Meeting  9",
  "Meeting 10",
  "Meeting 11",
  "Meeting 12",
  "Meeting 13",
  "Meeting 14",
  "Meeting 15",
  "Meeting 16",
  "Meeting 17",
  "Meeting 18",
  "Meeting 19",
  "Meeting 20"
)
edges_recode <- c(
  "Organizations (Orgs)" = "Organizations (Orgs)",
  "2a Education (Schools)" = "Education (Schools)",
  "2b Classmates" = "Classmates",
  "Communication Ties" = "Communication Ties",
  "Kinship Ties" = "Kinship Ties",
  "Training Events" = "Training Events",
  "Business & Finance" = "Business & Finance",
  "Operations" = "Operations",
  "Friendship Ties" = "Friendship Ties",
  "9a Religious Affiliation" = "Religious Affiliation",
  "9b Soulmates" = "Soulmates",
  "Logistical Place" = "Logistical Place",
  "Logistical Function" = "Logistical Function",
  "Meetings" = "Meetings"
  )

# read edges data ==============================================================
file_path <- .corenets_sys_file("datasets/noordin_139/Noordin_139_Data.xlsx")
  
edges <- file_path %>%
  readxl::excel_sheets() %>%
  purrr::discard(stringr::str_detect,
                 pattern = "Attributes") %>%
  purrr::set_names() %>%
  lapply(function(x) {
    mat <- to_matrix(
      readxl::read_excel(
        path = file_path,
        sheet = x)
      )
    if(NCOL(mat) == NROW(mat)) {
      igraph::graph_from_adjacency_matrix(mat)
    } else {
      igraph::graph_from_incidence_matrix(mat)
    }
  }) %>%
  purrr::imap_dfr( ~.x %>%
                     igraph::get.data.frame("edges") %>%
                     dplyr::mutate(
                       edge_class = .y)
                   ) %>%
  dplyr::mutate(from_class = "people",
                to_class   = dplyr::case_when(
                  to %in% from                    ~ "people",
                  to %in% insurgent_organizations ~ "organization",
                  to %in% schools                 ~ "organization",
                  to %in% training_events         ~ "event",
                  to %in% businesses              ~ "organization",
                  to %in% operations              ~ "event",
                  to %in% mosques                 ~ "organization",
                  to %in% logistical_locations    ~ "location",
                  to %in% logistical_function     ~ "resource",
                  to %in% meetings                ~ "event"
                  ),
                edge_class = trimws(
                  sub(
                    "(\\d+\\s+)",
                    "",
                    edge_class
                    ), which = "both"),
                edge_class = dplyr::recode(edge_class,
                                           !!!edges_recode)
                ) %>%
  dplyr::select(from, to, from_class, to_class, edge_class,
                dplyr::everything())

# recode some known issues with the edges ======================================
edges <- edges %>%
  dplyr::mutate(
    from = dplyr::recode(from,
                  "Suramto (Deni)" = "Suramto",
                  "Mohammed Faiz" = "Mohamed Saifuddin (alias Faiz)*",
                  "Mohammed Saifuddin" = "Mohamed Saifuddin (alias Faiz)*",
                  "Mohamed Saifuddin" = "Mohamed Saifuddin (alias Faiz)*"),
    to = dplyr::recode(to,
                "Suramto (Deni)" = "Suramto", 
                "Mohammed Faiz" = "Mohamed Saifuddin (alias Faiz)*",
                "Mohammed Saifuddin" = "Mohamed Saifuddin (alias Faiz)*",
                "Mohamed Saifuddin" = "Mohamed Saifuddin (alias Faiz)*")
  )

# read attribute data ==========================================================
attrs <- readxl::excel_sheets(file_path) %>%
  purrr::keep(stringr::str_detect, pattern = "Attributes") %>%
  purrr::map_dfr(
    ~ readxl::read_excel(path = file_path,
                         sheet = .x) %>%
      dplyr::as_tibble()
    )

# build node table =============================================================

nodes <- data.frame(name = c(edges$from, edges$to)) %>%
  unique() %>%
  dplyr::left_join(attrs, by=c("name"="...1")) %>%
  dplyr::mutate(
    node_class = dplyr::case_when(
      !is.na(`Education Level`)           ~ "people",
      name %in% insurgent_organizations   ~ "organization",
      name %in% schools                   ~ "organization",
      name %in% training_events           ~ "event",
      name %in% businesses                ~ "organization",
      name %in% operations                ~ "event",
      name %in% mosques                   ~ "organization",
      name %in% logistical_locations      ~ "location",
      name %in% logistical_function       ~ "resource",
      name %in% meetings                  ~ "event"
    )
  )

# Note from 15 - June - 2019 ===================================================
# Three nodes are missing all attibutes:
# nodes %>% filter(is.na(`Education Level`)==TRUE)
#               name Education Level Contact with People Military Training Nationality Current Status (ICG Article) Current Status (Updated)
#1    Suramto (Deni)              NA                  NA                NA          NA                           NA                       NA
#2 Mohamed Saifuddin              NA                  NA                NA          NA                           NA                       NA
#3     Mohammed Faiz              NA                  NA                NA          NA                           N

# clean node table =============================================================

nodes <- nodes %>%
  dplyr::filter(name != "Suramto (Deni)" & name != "Mohammed Faiz") %>%
  dplyr::mutate(
    # Education Level: =========================================================
    # Defined as highest degree attainedm level taught at, studied, participated
    # in, or attended.
    education_level = `Education Level`,
    hr_education_level = dplyr::case_when(`Education Level` == 0 ~ "Unknown",
                                `Education Level` == 1 ~ "Elementary Education ",
                                `Education Level` == 2 ~ "Pesantren (Luqmanul Hakiem, Ngruki, al-Husein, Indramayu, Jemaah Islamiyah)",
                                `Education Level` == 3 ~ "State High School",
                                `Education Level` == 4 ~ "Some University (University an-Nur, Univeristi Teknologi Malaysia, Adelaide University, Bogor Agricultural Univ.)",
                                `Education Level` == 5 ~ "BA/BS Designation",
                                `Education Level` == 6 ~ "Some Graduate School",
                                `Education Level` == 7 ~ "Masters",
                                `Education Level` == 8 ~ "PhD (includes Reading University)"),
    # Contact with People outside Indonesia: ===================================
    # Defined as contact with people in different countries outside Indonesia.
    contact_w_people = `Contact with People`,
    hr_contact_w_people = dplyr::case_when(`Contact with People` ==  0 ~ "Unknown",
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
    # Military Training: =======================================================
    # Defined the country where an individual received military training and 
    # attained veteran status in fighting in known insurgent/conventional wars.   
    military_training = `Military Training`,
    hr_military_training = dplyr::case_when(`Military Training`  ==  0 ~ "Unknown",
                                  `Military Training`  ==  1 ~ "Afghanistan",
                                  `Military Training`  ==  2 ~ "Australia",
                                  `Military Training`  ==  3 ~ "Indonesia",
                                  `Military Training`  ==  4 ~ "Malaysia",
                                  `Military Training`  ==  5 ~ "Philippines",
                                  `Military Training`  ==  6 ~ "Singapore",
                                  `Military Training`  ==  7 ~ "Afghanistan & Indonesia",
                                  `Military Training`  ==  8 ~ "Afghanistan & Philippines",
                                  `Military Training`  ==  9 ~ "Indonesia & Malaysia",
                                  `Military Training`  == 10 ~ "Indonesia & Philippines",
                                  `Military Training`  == 11 ~ "Afghanistan & Iraq"),
    # Nationality of individual: =============================================== 
    # Defined as country of birth, citizenship, or residence.  
    nationality = Nationality,
    hr_nationality = dplyr::case_when(Nationality == 1 ~ "Afghanistan",
                            Nationality == 2 ~ "Australia",
                            Nationality == 3 ~ "Indonesia",
                            Nationality == 4 ~ "Malaysia",
                            Nationality == 5 ~ "Philippines",
                            Nationality == 6 ~ "Singapore",
                            Nationality == 7 ~ "Saudi Arabia",
                            Nationality == 8 ~ "Jordan",
                            Nationality == 9 ~ "Egypt"),
    # Current Status per ICG Article: ==========================================
    # Defined as the physical condition of the individual.
    current_status_per_icg_article = `Current Status (ICG Article)`,
    hr_current_status_per_icg_article = dplyr::case_when(`Current Status (ICG Article)` == 0 ~ "Dead",
                                               `Current Status (ICG Article)` == 1 ~ "Alive",
                                               `Current Status (ICG Article)` == 2 ~ "Jail"),
    # Current Status (Updated): ================================================
    # Defined as the physical condition of the terrorist/insurgent updated 
    # through Spring 2011.
    current_status_updated = `Current Status (Updated)`,
    hr_current_status_updated = dplyr::case_when(`Current Status (Updated)` == 0 ~ "Dead",
                                       `Current Status (Updated)` == 1 ~ "Alive",
                                       `Current Status (Updated)` == 2 ~ "Jail"),
    # Role (Original): =========================================================
    # Defined as the role an individual assumes in the terrorist/insurgent 
    # network.
    role_original_coding = `Role (Original Coding)`,
    hr_role_original_coding = dplyr::case_when(`Role (Original Coding)` ==  0 ~ "No Info/Unclear",
                                     `Role (Original Coding)` ==  1 ~ "Strategist",
                                     `Role (Original Coding)` ==  2 ~ "Bomb Maker",
                                     `Role (Original Coding)` ==  3 ~ "Bomber/Fighter",
                                     `Role (Original Coding)` ==  4 ~ "Trainer/Instructor",
                                     `Role (Original Coding)` ==  5 ~ "Suicide Bomber",
                                     `Role (Original Coding)` ==  6 ~ "Recon and Surveillance",
                                     `Role (Original Coding)` ==  7 ~ "Recruiter",
                                     `Role (Original Coding)` ==  8 ~ "Courier/Go-Between",
                                     `Role (Original Coding)` ==  9 ~ "Propagandist",
                                     `Role (Original Coding)` == 10 ~ "Facilitator",
                                     `Role (Original Coding)` == 11 ~ "Religious Leader",
                                     `Role (Original Coding)` == 12 ~ "Commander/Tactical Leader"),
    # Role Expanded (Primary and Secondary): ===================================
    # Defined as the role an individual assumes in the terrorist/insurgent 
    # network (includes primary and secondary roles).
    role_expanded_primary = `Role Expanded (Primary)`,
    hr_role_expanded_primary = dplyr::case_when(`Role Expanded (Primary)` ==  1 ~ "Bomb Maker",
                                      `Role Expanded (Primary)` ==  2 ~ "Bomber/Fighter",
                                      `Role Expanded (Primary)` ==  3 ~ "Courier",
                                      `Role Expanded (Primary)` ==  4 ~ "Facilitator",
                                      `Role Expanded (Primary)` ==  5 ~ "Leader",
                                      `Role Expanded (Primary)` ==  6 ~ "Liaison",
                                      `Role Expanded (Primary)` ==  7 ~ "Local Leader",
                                      `Role Expanded (Primary)` ==  8 ~ "Propagandist",
                                      `Role Expanded (Primary)` ==  9 ~ "Recruiter",
                                      `Role Expanded (Primary)` == 10 ~ "Religious Leader",
                                      `Role Expanded (Primary)` == 11 ~ "Religious Teacher, Mentor, Motivator",
                                      `Role Expanded (Primary)` == 12 ~ "Resource Provider",
                                      `Role Expanded (Primary)` == 13 ~ "Strategist",
                                      `Role Expanded (Primary)` == 14 ~ "Suicide Bomber",
                                      `Role Expanded (Primary)` == 15 ~ "Sympathizer",
                                      `Role Expanded (Primary)` == 16 ~ "Trainer",
                                      `Role Expanded (Primary)` == 99 ~ "Missing"),
    # Role Expanded (Primary and Secondary): ===================================
    # Defined as the role an individual assumes in the terrorist/insurgent 
    # network (includes primary and secondary roles).
    role_expanded_secondary = `Role Expanded (Secondary)`,
    hr_role_expanded_secondary = dplyr::case_when(`Role Expanded (Secondary)` ==  1 ~ "Bomb Maker",
                                        `Role Expanded (Secondary)` ==  2 ~ "Bomber/Fighter",
                                        `Role Expanded (Secondary)` ==  3 ~ "Courier",
                                        `Role Expanded (Secondary)` ==  4 ~ "Facilitator",
                                        `Role Expanded (Secondary)` ==  5 ~ "Leader",
                                        `Role Expanded (Secondary)` ==  6 ~ "Liaison",
                                        `Role Expanded (Secondary)` ==  7 ~ "Local Leader",
                                        `Role Expanded (Secondary)` ==  8 ~ "Propagandist",
                                        `Role Expanded (Secondary)` ==  9 ~ "Recruiter",
                                        `Role Expanded (Secondary)` == 10 ~ "Religious Leader",
                                        `Role Expanded (Secondary)` == 11 ~ "Religious Teacher", 
                                        `Role Expanded (Secondary)` == 12 ~ "Resource Provider",
                                        `Role Expanded (Secondary)` == 13 ~ "Strategist",
                                        `Role Expanded (Secondary)` == 14 ~ "Suicide Bomber",
                                        `Role Expanded (Secondary)` == 15 ~ "Sympathizer",
                                        `Role Expanded (Secondary)` == 16 ~ "Trainer",
                                        `Role Expanded (Secondary)` == 99 ~ "Missing"),
    # Logistics Function: ======================================================
    # Defined as the provision of safe houses, weapons, transportation, and/or 
    # material to the operational network.
    logistic_function = `Logistic Function`,
    hr_logistic_function = dplyr::case_when(`Logistic Function` ==  1 ~ "Providing a safe house",
                                  `Logistic Function` ==  2 ~ "Providing weapons",
                                  `Logistic Function` ==  3 ~ "Providing transportation",
                                  `Logistic Function` ==  4 ~ "Providing material",
                                  `Logistic Function` ==  5 ~ "Providing weapons, transportation, material",
                                  `Logistic Function` ==  6 ~ "Providing weapons, material",
                                  `Logistic Function` ==  7 ~ "Providing transportation, material",
                                  `Logistic Function` ==  8 ~ "Providing safehouse and transportation",
                                  `Logistic Function` ==  9 ~ "Providing safehouse, transportation, material",
                                  `Logistic Function` == 10 ~ "Providing safehouse, weapons, material"),
    # Technical Skills: ========================================================
    # We chose to code technical attributes based on explicit skill sets 
    # mentioned within the ICG report.  In contrast to an attribute like “roles”
    # we chose only to code the specific technical skills listed below and did 
    # not consider such things as “cell leader” or “financier” as a technical 
    # role.  Basically, we were looking for skills related to electronics, 
    # bomb-making, web page design, etc.  Below is a list of the roles and the 
    # corresponding number each individual received. In instances where someone 
    # had multiple technical skills, we chose to code the one that is 
    # subjectively the most relevant to terrorist operations.  For instance, 
    # Azhari Husin has a mechanical engineering background but also has 
    # explosives training.  We would code him under “bomb-making.” Those with no 
    # identified technical skills receive a 0 in the matrix. 
    technical_skills = `Technical Skills`,
    hr_technical_skills = dplyr::case_when(`Technical Skills` == 1 ~ "Bomb-making",
                                 `Technical Skills` == 2 ~ "Propaganda (production of videos & video CDs, magazines, web page design, etc)",
                                 `Technical Skills` == 3 ~ "Military skills instruction (martial arts, shooting, etc)",
                                 `Technical Skills` == 4 ~ "Other advanced degree (mechanical engineering, agriculture, etc)",
                                 `Technical Skills` == 5 ~ "Religious instructions"),
    # Primary Group Affiliation: ===============================================
    # Defined as the primary group affiliation of each member of the network,
    # generally.
    primary_group_affiliation = `Primary Group Affiliation`,
    hr_primary_group_affiliation = dplyr::case_when(`Primary Group Affiliation` == 0 ~ "None (Noordin)",
                                          `Primary Group Affiliation` == 1 ~ "Darul Islam (DI)",
                                          `Primary Group Affiliation` == 2 ~ "KOMPAK",
                                          `Primary Group Affiliation` == 3 ~ "Jemaah Islamiyah (JI)",
                                          `Primary Group Affiliation` == 4 ~ "Ring Banten Group (DI)",
                                          `Primary Group Affiliation` == 5 ~ "Al-Qaeda"),
    # Noordin’s Network: =======================================================
    # An individual is considered a member of Noordin’s splinter group (Tanzim 
    # Qaedat al-Jihad – Organization for the Basis of Jihad), as opposed to 
    # simply being linked, if the individual knowingly participated in a 
    # Noordin-led operation during any stage, he or she is explicitly stated as
    # a member of Noordin’s inner circle, and/or he or she is tied to Noordin 
    # through kinship or friendship.
    noordin_network = `Noordin's Network`,
    is_noordin_network = ifelse(`Noordin's Network` == 0, FALSE, TRUE),
    # Original 79: =============================================================
    # Defined as the 79 individuals listed in the appendix of the 2006 ICG 
    # Report, “Noordin’s Networks”
    original_79 = `Original 79`,
    is_orginal_79 = ifelse(`Original 79` == 0, FALSE, TRUE),
    # node_class    = "people",
    node_class    = dplyr::case_when(
      !is.na(education_level)           ~ "people",
      name %in% insurgent_organizations   ~ "organization",
      name %in% schools                   ~ "organization",
      name %in% training_events           ~ "event",
      name %in% businesses                ~ "organization",
      name %in% operations                ~ "event",
      name %in% mosques                   ~ "organization",
      name %in% logistical_locations      ~ "location",
      name %in% logistical_function       ~ "resource",
      name %in% meetings                  ~ "event"
    )
  ) %>%
  dplyr::select(name, node_class,
         # Original variables ==================================================
         education_level, contact_w_people, military_training,
         nationality, current_status_per_icg_article, current_status_updated,
         role_original_coding, role_expanded_primary, role_expanded_secondary,
         logistic_function, technical_skills, primary_group_affiliation,
         noordin_network, original_79,
         # Human readable variables ============================================
         hr_education_level, hr_contact_w_people, hr_military_training,
         hr_nationality, hr_current_status_per_icg_article, 
         hr_current_status_updated, hr_role_original_coding, 
         hr_role_expanded_primary, hr_role_expanded_secondary, 
         hr_logistic_function, hr_technical_skills, hr_primary_group_affiliation,
         is_noordin_network, is_orginal_79
         )

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE,
  vertices = nodes
)

# build final dataset ==========================================================

.description <- .corenets_read_lines(
  .corenets_sys_file("datasets/noordin_139/description.txt")
  )

.abstract <- .corenets_read_lines(
  .corenets_sys_file("datasets/noordin_139/abstract.txt")
  )

.bibtex <- bibtex::read.bib(
  .corenets_sys_file("datasets/noordin_139/refs.bib")
  )

.codebook <- data.frame(
  `edge_class` = c("Organizations (Orgs)",
                   "Education (Schools)",
                   "Classmates",
                   "Communication Ties",
                   "Kinship Ties",
                   "Training Events",
                   "Business & Finance",
                   "Operations",
                   "Friendship Ties",
                   "Religious Affiliation",
                   "Soulmates",
                   "Logistical Place",
                   "Logistical Function",
                   "Meetings"),
  is_bimodal  = c(TRUE,  # Organizations
                  TRUE,  # Education
                  FALSE, # Classmates
                  FALSE, # Communication
                  FALSE, # Kinship
                  TRUE,  # Training
                  TRUE,  # Business
                  TRUE,  # Operations
                  FALSE, # Friendship
                  TRUE,  # Religious
                  FALSE, # Soulmates
                  TRUE,  # Logistical
                  TRUE,  # Logistical Function
                  TRUE), # Meetings
  is_directed = c(FALSE, # Organizations
                  FALSE, # Education
                  FALSE, # Classmates
                  FALSE, # Communication
                  FALSE, # Kinship
                  FALSE, # Training
                  FALSE, # Business
                  FALSE, # Operations
                  FALSE, # Friendship
                  FALSE, # Religious
                  FALSE, # Soulmates
                  FALSE, # Logistical
                  FALSE, # Logistical Function
                  FALSE), # Meetings
  is_dynamic  = c(FALSE, # Organizations
                  FALSE, # Education
                  FALSE, # Classmates
                  FALSE, # Communication
                  FALSE, # Kinship
                  FALSE, # Training
                  FALSE, # Business
                  FALSE, # Operations
                  FALSE, # Friendship
                  FALSE, # Religious
                  FALSE, # Soulmates
                  FALSE, # Logistical
                  FALSE, # Logistical Function
                  FALSE), # Meetings
  is_weighted = c(FALSE, # Organizations
                  FALSE, # Education
                  FALSE, # Classmates
                  FALSE, # Communication
                  FALSE, # Kinship
                  FALSE, # Training
                  FALSE, # Business
                  FALSE, # Operations
                  FALSE, # Friendship
                  FALSE, # Religious
                  FALSE, # Soulmates
                  FALSE, # Logistical
                  FALSE, # Logistical Function
                  FALSE), # Meetings
  definition  = c("Terrorist/Insurgent and Affiliated Organizations: A terrorist/insurgent organization is defined as an administrative and functional system, whose primary common goal is the operational conduct of terrorist/insurgent activities, consisting of willingly affiliated claimant members.  For the purpose of this exercise, factions and offshoots will be considered separate from their parent organization in order to prevent from coding redundant ties. In other words, the most micro-level affiliations are coded while an individual is only coded in the parent organization if he or she is not listed as being affiliated with a component organization.  Terrorist/insurgent affiliated organizations, such MMI and FPI, are also coded in this matrix.",
                  "Educational Relations: Educational relations are defined as schools where individuals receive formal education, serve as an employee (teacher, admin etc.), and/or involved in additional educational or religious instruction at the institution.",
                  "Classmate Relations:Classmates/educational colleagues are defined as individuals who receive formal education, serve as an employee (teacher, admin etc.), and/or involved in additional educational or religious instruction at the same institution and at the same time. This relationship is more likely to reflect accurate relationships than the two-mode “Educational Affiliation” matrix since it considers the time in which individuals are present at a school.",
                  "Internal Communication: Internal communication is defined as the relaying of messages between individuals and/or groups inside the network through some sort of medium.",
                  "Kinship: Kinship is defined as any family connection such as brother, brother-in-law, nephew etc.  Kinship will also include current marriages and past marriages due to divorces and/or deaths.",
                  "Training Relations: Participation in any specifically designated activity that teaches the knowledge, skills, and competencies of terrorism and insurgency.  Training does not include participation in a terrorist sponsored act or mujahedeen activity in places such as Afghanistan, Bosnia, Chechnya, or Iraq unless the individuals’ presence was to participate in a specifically designated training camp or base in one of these areas.",
                  "Business Relations: Defined as profit and non-profit organizations that employ people (includes Durassalam Foundation).",
                  "Operations: Operational relations are defined as individuals who are knowingly involved in preparing, executing, and/or providing post-operation support.  Preparation must directly relate to the operation and can include surveying targets, providing a safehouse for preparation, contributing to religious and/or physical training, and participating in a robbery where proceeds fund a subsequent attack. Providing post-operation support, such as hiding fugitives and disposing of explosives, must also be directly related to the operation.",
                  "Friendship Relations: Friendship relations are defined as close attachments through affection or esteem between two people. Friendship ties are not defined solely as meetings and/ or school ties.",
                  "Religious Relations: Religious relations are defined as an association with a mosque, church, synagogue or religious study circle.  Religious study circles are only coded if they are separate from other religious entities (i.e. mosque). We do not include Islamic schools even though we assume that the schools have mosques.  Not using the schools prevents duplication of effort with the team constructing the school ties.  Additionally, we listed the mosques by the town in which it is located.  If there was more than one in a city, we added a numerical identifier plus the name of nearest location.",
                  "Soulmate Relations: Soulmate relations are defined as individuals who are affiliated with the same religious institution at the same time.  This relationship is more likely to indicate accurate religious ties than the “religious affiliation” since it considers the timeframes in which individuals are affiliated with religious institutions.",
                  "Logistical Relations: Logistical relations are defined to mean a Key Place within the archipelago where logistical activity occurred.  Logistical activity is defined as providing “safe houses” for meeting/hiding, providing material support in terms of explosives, providing weaponry, or facilitating transportation of personnel or equipment.",
                  "Logistic Functions: Logistical functions are defined as the support for terrorist/insurgency operations by providing materials, weapons, transportation and safehouses.",
                  "Meetings: A preplanned, coordinated event between two or more individuals.  Meetings do not include all styles of communications.  Rather, Meeting refers to a certain location at a certain date with specific individuals.  Meetings infer the necessity of a decision, but the data does not specifically identify the decision or meeting subject."),
  stringsAsFactors = FALSE
)

.reference <- list(
  title        = "The Noordin Top Terrorist Network",
  name         = "noordin_139",
  tags         = c("jihad",
                   "religious terrorism",
                   "suicide bombings"),
  description  = .description,
  abstract     = .abstract,
  codebook     = .codebook,
  bibtex       = .bibtex,
  paper_link   = "http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.1026.7447&rep=rep1&type=pdf")

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

noordin_139 <- list(
  reference = .reference,
  network  = .network
)

noordin_139
