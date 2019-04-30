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
orgs_pxp                   <- COREnets::to_one_mode(orgs)
schools_pxp                <- COREnets::to_one_mode(schools)
classmates_pxp             <- COREnets::to_one_mode(classmates)
communication_pxp          <- COREnets::to_one_mode(communication)
kinship_pxp                <- COREnets::to_one_mode(kinship)
training_pxp               <- COREnets::to_one_mode(training)
business_pxp               <- COREnets::to_one_mode(business)
operations_pxp             <- COREnets::to_one_mode(operations)
friendship_pxp             <- COREnets::to_one_mode(friendship)
religious_affiliations_pxp <- COREnets::to_one_mode(religious_affiliations)
soulmates_pxp              <- COREnets::to_one_mode(soulmates)
logistical_place_pxp       <- COREnets::to_one_mode(logistical_place)
logistical_function_pxp    <- COREnets::to_one_mode(logistical_function)
meetings_pxp               <- COREnets::to_one_mode(meetings)

listed <- list("orgs_pxp" =orgs_pxp, "schools_pxp" = schools_pxp, "classmates_pxp" = classmates_pxp,
               "communication_pxp" = communication_pxp, "kinship_pxp" = kinship_pxp, "training_pxp" = training_pxp,
               "business_pxp" = business_pxp, "operations_pxp" = operations_pxp, "friendship_pxp" = friendship_pxp,
               "religious_affiliations_pxp" = religious_affiliations_pxp, "soulmates_pxp" = soulmates_pxp, "logistical_place_pxp" = logistical_place_pxp,
               "logistical_function_pxp" = logistical_function_pxp, "meetings_pxp" = meetings_pxp)

edges <- purrr::imap_dfr(listed, ~.x %>% get.data.frame('edges') %>% mutate(type = .y))

