################################
# Extracting Data From snatools
# Date: 04/29/2019
################################

#devtools::install_github("knapply/snatools")
library(snatools)

### NOTE 4/29/2029: ###
# These two data sets were retrieved from the UCInet archive.

# Take data out as igraph objects:
koschade_bali_bombing <- snatools::jemmah_islamiyah
crisis_in_cloister <- snatools::crisis_in_cloister

# Get data as lists:
koschade_bali_bombing <- list("nodes" = get.data.frame(koschade_bali_bombing, "vertices"),
                         "edges" = get.data.frame(koschade_bali_bombing, "edges"),
                         "name"  = "koschade_bali_bombing",
                         "desc"  = "This dataset was coded from Stuart Koschade's (2006) articled on the first Bali bombing.
                         It contains relational data on 17 individuals involved in the bombing.")
usethis::use_data(koschade_bali_bombing, overwrite = TRUE)

crisis_in_cloister <- list("nodes" = get.data.frame(crisis_in_cloister, "vertices"),
                           "edges" = get.data.frame(crisis_in_cloister, "edges"),
                           "name"  = "crisis_in_cloister",
                           "desc"  = "This directed network contains ratings between monks related to a crisis in a cloister (or monastery) in New England (USA) which lead to the departure of several of the monks. 
                           This dataset aggregates several available ratings ((dis)esteem, (dis)liking, positive/negative influence, praise/blame) into only one rating, which is positive if all original ratings were positive and negative if all original ratings were negative. 
                           If there were mixed opinions the rating has the value 0. 
                           A node represents a monk and an edge between two monks shows that the left monk rated the right monk.")
usethis::use_data(crisis_in_cloister, overwrite = TRUE)
