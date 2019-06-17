
library(igraph)
library(tidyverse)
library(COREnets)
library(sf)

# paper: https://www.jstor.org/stable/10.1017/s0022381608080419?seq=1#metadata_info_tab_contents
# codebook: https://www.albany.edu/pvc/lethality_paper__CodeBook.pdf

kv_homebase <- c(
"2"   =   "United States",
"70"  = "Mexico",
"91"  = "Honduras",
"92"  = "El Salvador",
"93"  = "Nicaragua",
"100" = "Colombia",
"101" = "Venezuela",
"130" = "Ecuador",
"135" = "Peru" ,
"145" = "Bolivia",
"155" = "Chile",
"160" = "Argentina"  ,
"200" = "United Kingdom",
"205" = "Ireland",
"210" = "Netherlands",
"220" = "France",
"225" = "Switzerland",
"230" = "Spain",
"255" = "Germany",
"325" = "Italy",
"343" = "Macedonia",
"350" = "Greece",
"352" = "Cyprus",
"365" = "Russia",
"372" = "Georgia",
"380" = "Sweden",
"390" = "Denmark",
"451" = "Sierra Leone",
"475" = "Nigeria",
"483" = "Chad",
"490" = "Zaire",
"500" = "Uganda",
"530" = "Ethiopia",
"531" = "Eritrea",
"540" = "Angola",
"560" = "South Africa" ,
"572" = "Swaziland",
"600" = "Morocco",
"615" = "Algeria",
"620" = "Libya",
"625" = "Sudan",
"630" = "Iran",
"640" = "Turkey",
"645" = "Iraq",
"651" = "Egypt",
"660" = "Lebanon",
"663" = "Jordan",
"666" = "Israel",
"670" = "Saudi Arabia",
"679" = "Yemen",
"700" = "Afghanistan",
"702" = "Tajikistan",
"704" = "Uzbekistan",
"710" = "China",
"740" = "Japan",
"750" = "India",
"770" = "Pakistan"   ,
"771" = "Bangladesh",
"775" = "Myanmar (Burma)",
"780" = "Sri Lanka",
"790" = "Nepal",
"800" = "Thailand",
"812" = "Laos",
"840" = "Philippines",
"850" ="Indonesia"
)

# read "raw" data ==============================================================
files <- list.files(path="datasets/BAAD/full/",
  pattern = "\\.csv$", 
  full.names = TRUE)

edges <- purrr::map(files, read_csv) %>%
  # extract from multiple files and pull into one data.frame
  setNames(str_extract(files,
     pattern = "[\\w]+\\.csv$")) %>%
  keep(str_detect(names(.),
pattern = "edges_")) %>%
  map(., COREnets::to_matrix) %>%
  map(., COREnets::to_graph) %>%
  imap_dfr(., ~.x %>%
 set.edge.attribute(., name="relationship",
value=str_extract(.y,
pattern = "\\w+")) %>%
 get.data.frame("edges")) %>%
  mutate(relationship = str_replace(relationship, "edges_", ""))

nodes <- purrr::map(files, read_csv) %>%
  # extract from multiple files and pull into one data.frame
  setNames(str_extract(files,
     pattern = "[\\w]+\\.csv")) %>%
  keep(str_detect(names(.),
pattern = "attrs_")) %>%
  bind_rows()

# clean node attributes ========================================================

nodes <- nodes %>%
  rename(
    name                      = group,
    based_in                  = homecountry,
    is_contain_ethno          = ContainEthno,
    is_contain_ethno2         = ContainEthno2,
    is_contain_relig          = ContainRelig,
    is_contain_relig2         = ContainRelig2,
    is_islam                  = Islam,
    is_leftist_no_relig_ethno = LeftNoReligEthno,
    is_terrStrong             = terrStrong,
    is_pure_ethno             = PureEthno,
    is_pure_relig             = PureRelig,
    is_relig_ethno            = ReligEthno,
    is_statespond             = statespond,
    fatalities_1998_2005      = fatalities19982005,
    org_age                   = OrgAge,
    org_size                  = ordsize
  ) %>%
  select(-degree) %>%
  mutate_at(vars(starts_with("is_")), as.logical) %>%
  mutate(based_in = recode(based_in, !!!kv_homebase))

# build igraph object ==========================================================
g <- igraph::graph_from_data_frame(
  d = edges,
  directed = FALSE,
  vertices = nodes
)

# build final dataset ==========================================================

data(countryref, package = "CoordinateCleaner")
countries <- countryref[!duplicated(countryref[c('name')]),]

nodes <- nodes %>%
  as_tibble(igraph::as_data_frame(g, what = "vertices")) %>%
  left_join(countries, by=c("based_in"="name")) %>%
  as_tibble() %>%
  st_as_sf(coords = c("centroid.lon", "centroid.lat"), crs = 4326) %>%
  select(name, based_in, based_in, fatalities_1998_2005, org_age, org_size,
         is_terrStrong, is_contain_ethno, is_contain_relig, is_contain_ethno2,
         is_contain_relig2, is_leftist_no_relig_ethno, is_pure_ethno,
         is_pure_relig, is_islam, geometry) 

.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = "organizations",
    is_two_mode  = igraph::is_bipartite(g),
    is_dynamic   = FALSE,
    are_nodes_spatial = inherits(igraph::as_data_frame(g,
                                                       what = "vertices"), "sf"),
    are_edges_spatial =  inherits(igraph::as_data_frame(g,
                                                        what = "edges"), "sf")
  ),
  node_table = nodes,
  edge_table = as_tibble(igraph::as_data_frame(g, what = "edges"))
)

.introduction <- "This dataset, Big Allied and Dangerous 1.0 (BAAD1), contains
information on the size of terrorist organziations, their ideology, whether they
are supported by state sponsors, the age of organizations, numbrer of fatalities
attributed to the organizations, whether the organization controls territory,
and counts of alliace connections."

.abstract <- "Why are some terrorist organizations so much more deadly then 
others? Rearchers Victor Asal and Karl Rethmeyere address this question by 
examining organizational characteristics such as ideology, size, age, state 
sponsorship, alliance connections, and control of territory while controlling 
for factors that may also influence lethality, including the political system 
and relative wealth of the country in which the organization is based. Using 
data from the Memorial Institute for the Prevention of Terrorism’s Terrorism 
Knowledge Base(TKB), we use a negative binomial model of organizational 
lethality, finding that organizational size, ideology,territorial control, and 
connectedness are important predictors of lethality while state sponsorship, 
organizational age, and host country characteristics are not."

.bibtex <- c(
  "@Article{baad_2008,
  title   = {The Nature of the Beast: Terrorist Organizational Characteristics and Organizational Lethality.}, 
  volume  = {70}, 
  DOI     = {10.1017/s0022381608080419}, 
  number  = {2}, 
  journal = {Journal of Politics}, 
  author  = {Asal, Victor H. and Rethemeyer, R. Karl.}, 
  year    = {2008},
  pages   = {437-449},
  }"
)

baad <- list(
  metadata = list(
    title = "BAAD1 Lethality Dataset",
    name  = "baad",
    category    = "terrorism",
    tags  = "terrorism",
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  network = .network
)

usethis::use_data(baad, overwrite = TRUE)
