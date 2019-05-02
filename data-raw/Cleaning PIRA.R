####################################
# Cleaning and Structuring PIRA Data
# Date: 05/01/2019
####################################

library(igraph)
library(tidyverse)
library(COREnets)

files <- list.files(path="datasets/PIRA/",
                    pattern = "*.csv", 
                    full.names = TRUE)

listed_nets <- purrr::map(files, read_csv) %>%
  setNames(str_extract(files,
                       pattern = "[\\w]+.csv")) %>%
  keep(str_detect(names(.),
                  pattern = "NET.csv")) %>%
  map(., COREnets::to_matrix) %>%
  map(., COREnets::to_graph) %>%
  imap_dfr(., ~.x %>%
           set.edge.attribute(., name="procedence",
                              value=str_extract(.y,
                                                pattern = "PERIOD\\d")) %>%
        get.data.frame("edges"))

listed_attr <- purrr::map(files,
                          read_csv) %>%
  setNames(str_extract(files,
                       pattern = "[\\w]+.csv")) %>%
  keep(str_detect(names(.),
                  pattern = "ATT.csv")) %>%
  imap_dfr(., ~.x %>%
           mutate(procedence=str_extract(.y,
                                         pattern = "PERIOD\\d"))) %>%
  rename(id = X1)

# Name
name <- "PIRA"

# Description
desc <- "Data is on active Provisional IRA (hereafter PIRA) members between 1970 and 1998. Data collected at the International Center for the Study of Terrorism, Pennsylvania State University. From this data are derived network structures and the nature of dependence within them. The PIRA network comprises the following four types of relationships: (1) involvement in a PIRA activity together, (2) friends before joining PIRA movement, (3) blood relatives, and (4) related through marriage. We treated each relation as a tie and coded whether a tie exists between two members or not. Thus, the networks have, conceptually and technically, binary and symmetric relations between members.
Data also includes sociological information of members, such as gender, age, marital status, recruiting age, education (that is, attending university), brigade memberships, non-/violent characteristics, role-related characteristics—senior leader, IED constructor, IED planter, and gunman—and task-related characteristics (that is, foreign operation tasks, and involvement n bank robbery, kidnapping, hijacking, and drugs).
This data was downloaded from UCINET's site (https://sites.google.com/site/ucinetsoftware/datasets) on 05-01-2019."

# Anabaptists list:
noordin_top_complete_one_mode <- list(nodes=listed_attr, edges=listed_nets, name=name, desc=desc)

usethis::use_data(noordin_top_complete_one_mode, overwrite = TRUE)