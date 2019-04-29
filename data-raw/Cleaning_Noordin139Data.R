################################
# Transforming Noordin 139 Data
# Date: 04/29/2019
################################
library(igraph)
library(dplyr)
library(tibble)
library(readxl)

# First import all tabs from "Noordin 139 Data.xlsx":
orgs                  <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=1)
schools               <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=2)
classmates            <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=3)
communication         <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=4)
kinship               <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=5)
training              <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=6)
business              <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=7)
operations            <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=8)
friendship            <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=9)
religios_affiliations <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=10)
soulmates             <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=11)
logistical_place      <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=12)
logistical_function   <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=13)
meetings              <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=14)
attributes            <- readxl::read_excel("datasets/Noordin 139 Data.xlsx", sheet=15)
