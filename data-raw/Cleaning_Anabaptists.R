
library(tidyverse)

# paper: https://apps.dtic.mil/dtic/tr/fulltext/u2/a632471.pdf

# helper vars ==========================================================================
# key-value maps to recode `Origin #` and `Operate #`
kv_origins <- c(
  "1" = "Austria",
  "2" = "France",
  "3" = "Germany",
  "4" = "Italy",
  "5" = "Moravia",
  "6" = "Netherlands",
  "7" = "Poland",
  "8" = "Switzerland"
)

kv_bases <- c(
  "1" = "Austria",
  "2" = "Germany",
  "3" = "Moravia",
  "4" = "Netherlands",
  "5" = "Switzerland"
)

# read "raw" data ======================================================================
init_attrs <- read_csv("datasets/Anabaptist Attributes.csv")

# clean node attributes ================================================================
groups_attr <- init_attrs %>%
  rename(name = X1) %>% 
  mutate(is_anabaptist = Anabaptist == 1) %>% 
  # keep name and group cols
  select(name, is_anabaptist, Melchiorite, `Swiss Brethren`, `Other Anabaptist`,
         Lutheran, Reformed, `Other Protestant`, Denck, Hut, Hutterite) %>% 
  # melt data frame
  gather(group, val, -name, -is_anabaptist) %>% 
  # keep "TRUE" rows
  filter(val == 1) %>% 
  # drop "TRUE"/"FALSE" column
  select(-val)

nodes_df <- init_attrs %>% 
  # use "better" names
  rename(
    name = X1,
    is_violence_sanctioning = Violence,            # paper: p. 47
    is_apocalyptic          = Apocalyptic,         # paper: p. 47
    is_believer_baptist     = `Believers Baptism`, # paper: p. 2
    origin                  = `Origin #`,
    based_in                = `Operate #`,
    is_munster_rebel        = `Münster Rebellion`
  ) %>% 
  select(
    -c(Anabaptist, Melchiorite, `Swiss Brethren`, `Other Anabaptist`,
       Lutheran, Reformed, `Other Protestant`, Denck, Hut, Hutterite,
       Tradition) # `Tradition` is the same as `group`
  ) %>% 
  # coerce binary vars to correct type
  mutate_at(vars(starts_with("is_")), as.logical) %>% 
  # recode categorical variables
  mutate(origin = recode(origin, !!!kv_origins),
         based_in = recode(based_in, !!!kv_bases)) %>%
  # attach attribute containing all groups
  left_join(groups_attr, by = "name") %>%
  # reorder columns
  select(name, group, origin, based_in, is_anabaptist, everything())

# pull edges from pajek file
edges_df <- igraph::read_graph("datasets/Anabaptist Leaders.net", format = "paj") %>%
  igraph::as_data_frame() %>% 
  select(-weight) %>% 
  # fix name that doesn't match
  mutate_all(~ if_else(. == "Boekbinder", "Gerrit Boekbinder", .)) %>% 
  # pajek file is tracking edges in both directions, but it's supposed to be undirected
  distinct() %>% 
  rename(source = from, target = to)

# build igraph object ==================================================================
g <- igraph::graph_from_data_frame(
  d = edges_df,
  directed = FALSE,
  vertices = nodes_df
)

# build final dataset ==================================================================
.network <- list(
  metadata = list(
    is_directed  = igraph::is_directed(g),
    is_weighted  = igraph::is_weighted(g),
    is_multiplex = igraph::any_multiple(g),
    node_type    = "people",
    is_two_mode  = igraph::is_bipartite(g),
    is_dynamic   = FALSE,
    are_nodes_spatial = inherits(igraph::as_data_frame(g, what = "vertices"), "sf"),
    are_edges_spatial =  inherits(igraph::as_data_frame(g, what = "edges"), "sf")
  ),
  node_table = as_tibble(igraph::as_data_frame(g, what = "vertices")),
  edge_table = as_tibble(igraph::as_data_frame(g, what = "edges"))
)

.introduction <- "This dataset examines social networks between early Anabaptist leaders. 
Together with the dataset on the beliefs of early Anabaptist leaders and groups, it 
can be used to examine the diffusion of theology and ideas among early Anabaptist 
leaders."

.abstract <- "Religiously motivated violence is and always will be a relevant topic. To 
address and effectively counter contemporary violent groups, it is important to 
investigate similar historic groups. This thesis attempts to answer the research 
question: 'During the Radical Reformation, why did some Anabaptist groups accept the 
use of violence while others did not, and how did the movement evolve to pacifism?' To
answer this question, this study utilizes a mixed methodology of case study analysis 
and social network analysis of Anabaptist leaders during the 16th century. This thesis 
argues that violent ideology is largely a function of three factors: charismatic 
leadership, isolation, and apocalypticism. The interaction of these factors led to the
emergence of Anabaptist groups that embraced the use of violence. However, groups' 
internal characteristics can also lead them away from violence. In the case of the 
Anabaptists, social proximity assisted leaders with a counter-message to speak 
effectively to violent ultra-radical factions. The goal of this thesis is to identify 
characteristics of religious groups that may signal the potential for future violence, 
while also providing insight into which leaders may be capable of re-directing groups 
that have become violent."

.bibtex <- c(
  "@Article{anabaptists_matthews_edmonds_wildman_nunn_2013,
  title   = {Cultural inheritance or cultural diffusion of religious violence? A quantitative case study of the Radical Reformation}, 
  volume  = {3}, 
  DOI     = {10.1080/2153599x.2012.707388}, 
  number  = {1}, 
  journal = {Religion, Brain & Behavior}, 
  author  = {Matthews, Luke J. and Edmonds, Jeffrey and Wildman, Wesley J. and Nunn, Charles L.}, 
  year    = {2013},
  pages   = {3-15},
  }",

  "@MastersThesis{anabaptists_mcLaughlin_2015,
  author  = {McLaughlin, John M.}, 
  title   = {Anabaptist Leadership Network},
  year    = {2015},
  school  = {Naval Postgraduate School},
  address = {1 University Circle, Monterey, CA 93943},
  }"
)

anabaptists <- list(
  metadata = list(
    title       = "Anabaptist Leadership Network",
    name        = "anabaptists",
    category    = "religious",
    tags        = "religion",
    description = .introduction,
    abstract    = .abstract
  ),
  bibtex = .bibtex,
  network = .network
)

usethis::use_data(anabaptists, overwrite = TRUE)
