################################
# Transforming Noordin 139 Data
# Date: 04/29/2019
################################
library(igraph)
library(dplyr)
library(COREnets)
library(readxl)

# First import all tabs from "Noordin 139 Data.xlsx":
orgs                   <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=1))
schools                <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=2))
classmates             <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=3))
communication          <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=4))
kinship                <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=5))
training               <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=6))
business               <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=7))
operations             <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=8))
friendship             <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=9))
religious_affiliations <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=10))
soulmates              <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=11))
logistical_place       <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=12))
logistical_function    <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=13))
meetings               <- COREnets::to_matrix(readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=14))
attributes             <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=15)

# From matrices to graphs:
orgs                   <- COREnets::to_graph(orgs)
schools                <- COREnets::to_graph(schools)
classmates             <- COREnets::to_graph(classmates)
communication          <- COREnets::to_graph(communication)
kinship                <- COREnets::to_graph(kinship)
training               <- COREnets::to_graph(training)
business               <- COREnets::to_graph(business)
operations             <- COREnets::to_graph(operations)
friendship             <- COREnets::to_graph(friendship)
religious_affiliations <- COREnets::to_graph(religious_affiliations)
soulmates              <- COREnets::to_graph(soulmates)
logistical_place       <- COREnets::to_graph(logistical_place)
logistical_function    <- COREnets::to_graph(logistical_function)
meetings               <- COREnets::to_graph(meetings)

# Transform two-mode data to one mode:
orgs_pxp                   <- COREnets::to_one_mode(orgs, auto=TRUE, project = "rows")
schools_pxp                <- COREnets::to_one_mode(schools, auto=TRUE, project = "rows")
classmates_pxp             <- COREnets::to_one_mode(classmates, auto=TRUE, project = "rows")
communication_pxp          <- COREnets::to_one_mode(communication, auto=TRUE, project = "rows")
kinship_pxp                <- COREnets::to_one_mode(kinship, auto=TRUE, project = "rows")
training_pxp               <- COREnets::to_one_mode(training, auto=TRUE, project = "rows")
business_pxp               <- COREnets::to_one_mode(business, auto=TRUE, project = "rows")
operations_pxp             <- COREnets::to_one_mode(operations, auto=TRUE, project = "rows")
friendship_pxp             <- COREnets::to_one_mode(friendship, auto=TRUE, project = "rows")
religious_affiliations_pxp <- COREnets::to_one_mode(religious_affiliations, auto=TRUE, project = "rows")
soulmates_pxp              <- COREnets::to_one_mode(soulmates, auto=TRUE, project = "rows")
logistical_place_pxp       <- COREnets::to_one_mode(logistical_place, auto=TRUE, project = "rows")
logistical_function_pxp    <- COREnets::to_one_mode(logistical_function, auto=TRUE, project = "rows")
meetings_pxp               <- COREnets::to_one_mode(meetings, auto=TRUE, project = "rows")

listed <- list("orgs_pxp" =orgs_pxp, "schools_pxp" = schools_pxp, "classmates_pxp" = classmates_pxp,
               "communication_pxp" = communication_pxp, "kinship_pxp" = kinship_pxp, "training_pxp" = training_pxp,
               "business_pxp" = business_pxp, "operations_pxp" = operations_pxp, "friendship_pxp" = friendship_pxp,
               "religious_affiliations_pxp" = religious_affiliations_pxp, "soulmates_pxp" = soulmates_pxp, "logistical_place_pxp" = logistical_place_pxp,
               "logistical_function_pxp" = logistical_function_pxp, "meetings_pxp" = meetings_pxp)

edges <- purrr::imap_dfr(listed, ~.x %>% get.data.frame('edges') %>% mutate(type = .y))

nodes <- data.frame(name = c(edges$from, edges$to)) %>%
  unique() %>%
  left_join(attributes, by=c("name"="X__1"))

### Note 4/30/2019 ###
# Two nodes are missing all attibutes.

# Name
name <- "noordin_top_complete_one-mode"

# Description
desc <- "The foundation for the Noordin Top Terrorist network data were extracted from two International Crisis Group (ICG) reports, which contain rich data one- and two-mode data on a variety of relations and affiliations (friendship, kinship, meetings, etc.) along with significant attribute data (education, group membership, physical status, etc.).
Because a single source for any network data raises the possibility of bias, the data were supplemented with additional open-source literature in order to fill gaps in the data and in order to generate montly time codes from January 2010 through December 2010, whih allowed the authors to account for when actors enter and leave the network and examine the network longitudinally."

# Anabaptists list:
noordin_top_complete_one_mode <- list(nodes=nodes, edges=edges, name=name, desc=desc)

usethis::use_data(noordin_top_complete_one_mode, overwrite = TRUE)
