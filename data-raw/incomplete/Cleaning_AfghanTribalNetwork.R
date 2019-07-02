
library(igraph)
library(readxl)
library(tidyverse)


# paper: 
# codebook: 

# read edges data ======================================================================
files <- "datasets/Afghan Tribal Networks.xlsx"

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
      dplyr::mutate(relationship = .y)
  ) 

# clean edges ==========================================================================
edges %>%
  mutate(from         = str_to_title(from),
         to           = str_to_title(to),
         relationship = str_to_title(relationship)) %>%
  select(from, to, relationship)

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
  left_join(attrs, by=c("name"="Tribes"))

# Note 15 - June - 2019 ================================================================
# Four nodes are missing all attibutes:
# nodes %>% filter(is.na(`Education Level`)==TRUE)
# name Tribal Order Religion Ethnicity Stance on Gov't Stance on Taliban
# 1 Charhar Aimak         <NA>     <NA>      <NA>            <NA>              <NA>
# 2 Lodi Powindah         <NA>     <NA>      <NA>            <NA>              <NA>
# 3       Barahui         <NA>     <NA>      <NA>            <NA>              <NA>
# 4  Charar Aimak         <NA>     <NA>      <NA>            <NA>              <NA>
