
# COREnets

<!-- badges: start -->

[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![GitHub last
commit](https://img.shields.io/github/last-commit/NPSCORELAB/COREnets.svg)](https://github.com/NPSCORELAB/COREnets/commits/master)
[![Codecov test
coverage](https://codecov.io/gh/NPSCORELAB/COREnets/branch/master/graph/badge.svg)](https://codecov.io/gh/NPSCORELAB/COREnets?branch=master)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/NPSCORELAB/COREnets?branch=master&svg=true)](https://ci.appveyor.com/project/NPSCORELAB/COREnets)
[![Travis-CI Build
Status](https://travis-ci.org/NPSCORELAB/COREnets.svg?branch=master)](https://travis-ci.org/NPSCORELAB/COREnets)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)
[![Depends](https://img.shields.io/badge/Depends-GNU_R%3E=3.5-blue.svg)](https://www.r-project.org/)
[![GitHub code size in
bytes](https://img.shields.io/github/languages/code-size/NPSCORELAB/COREnets.svg)](https://github.com/NPSCORELAB/COREnets)
[![HitCount](http://hits.dwyl.io/NPSCORELAB/COREnets.svg)](http://hits.dwyl.io/NPSCORELAB/COREnets)
<!-- badges: end -->

## Installation

First, if you haven’t done so, install `devtools`:.

``` r
install.packages("devtools")
```

Proceed to install `{COREnets}` from Github:

``` r
devtools::install_github("NPSCORELAB/COREnets")
```

## Using the Package to Access Data

**{COREnets}** contains a series of network data sets that can be
accessed using the `get_data` function:

``` r
library(COREnets)
drugnet <- COREnets::get_data("drugnet")
drugnet
#> PROTO_NET drugnet Nodes:293 Edges:337
#> Acquaintanceship 
#>  +-D-- E:337 N:212 NC:1
#> 
#> Edge list: 
#>  from from_class to to_class       edge_class
#>     1     person  2   person Acquaintanceship
#>     1     person 10   person Acquaintanceship
#>     2     person  1   person Acquaintanceship
#> 334 entries not printed. 
#>  + Edge attributes: 
#> 
#> Node list: 
#>  + Node attributes: name<chr> node_class<chr> Gender<chr> Ethnicity<chr> HasTie<chr> hr_ethnicity<chr> hr_gender<chr> hr_has_tie<chr>
```

In order to look up the available data sets use the `list_data_sources`
function:

``` r
COREnets::list_data_sources()
#>  [1] "anabaptists"                   "cocaine_smuggling_acero"      
#>  [3] "cocaine_smuggling_jake"        "cocaine_smuggling_juanes"     
#>  [5] "cocaine_smuggling_mambo"       "drugnet"                      
#>  [7] "fifa"                          "harry_potter_death_eaters"    
#>  [9] "harry_potter_dumbledores_army" "london_gang"                  
#> [11] "montreal_street_gangs"         "noordin_139"                  
#> [13] "november17"                    "paul_revere"                  
#> [15] "siren"                         "zegota"
```

Get a brief description of the data set:

``` r
COREnets::get_description("drugnet")
#> [1] "These data represent a network of drug users in Hartford.  Ties are directed and represent acquaintanceship. The network is a result of two years of ethnographic observations of people's drug habits. "
```

Each data object contains two main lists of information, the `reference`
and `network` lists:

``` r
names(drugnet)
#> [1] "reference" "network"
class(drugnet$reference)
#> [1] "list"
class(drugnet$network)
#> [1] "list"
```

### `reference`

The `reference` list contains the following fields of information on the
data set:

<table class="table table-bordered" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

Field

</th>

<th style="text-align:left;">

Type

</th>

<th style="text-align:left;">

Definition

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

title

</td>

<td style="text-align:left;">

character

</td>

<td style="text-align:left;">

A formal title for the dataset as presented by other databases or the
author.

</td>

</tr>

<tr>

<td style="text-align:left;">

name

</td>

<td style="text-align:left;">

character

</td>

<td style="text-align:left;">

An informal dataset label for internal use.

</td>

</tr>

<tr>

<td style="text-align:left;">

tags

</td>

<td style="text-align:left;">

character

</td>

<td style="text-align:left;">

An internal classification assinged to the dataset.

</td>

</tr>

<tr>

<td style="text-align:left;">

description

</td>

<td style="text-align:left;">

character

</td>

<td style="text-align:left;">

A brief definition of the dataset to include the type of data,
collection, etc.

</td>

</tr>

<tr>

<td style="text-align:left;">

abstract

</td>

<td style="text-align:left;">

character

</td>

<td style="text-align:left;">

A brief summary of …

</td>

</tr>

<tr>

<td style="text-align:left;">

codebook

</td>

<td style="text-align:left;">

data.frame

</td>

<td style="text-align:left;">

A data table used for gathering and storing relationships and their
definitions.

</td>

</tr>

<tr>

<td style="text-align:left;">

bibtex

</td>

<td style="text-align:left;">

character

</td>

<td style="text-align:left;">

The citation for the dataset in bibtex format. Some datasets may have
mupltiple entries.

</td>

</tr>

<tr>

<td style="text-align:left;">

paper\_link

</td>

<td style="text-align:left;">

character

</td>

<td style="text-align:left;">

Hyperlink(s) to publications linked to the dataset.

</td>

</tr>

</tbody>

</table>

### `network`

The `network` list contains all the relevant data to generate a
sociogram and conduct the analysis. However, because each data set is
slightly different, this list is segmented into three entries:

  - `metadata`: A list of lists each containing information on the
    different edge types contained in the edge list. The following list
    are included as individual nested items for each edge type
    sub-graph, each contain a variety of fields:

| Field         | Type      | Definition                                                                         |
| :------------ | :-------- | :--------------------------------------------------------------------------------- |
| edge\_class   | character | A string matching the name of an edge class in the codebook.                       |
| is\_bimodal   | logical   | A logial denoting wheter or not the edge type yields a bipartite graph.            |
| is\_directed  | logical   | A logical denoting whether the network edges are directed or not.                  |
| is\_dynamic   | logical   | A logical denoting whether the edges are dynamic or not.                           |
| is\_weighted  | logical   | A logical denoting whether or not the edges are weighted.                          |
| has\_isolates | logical   | A logical which defines if the graph contains isolates or not.                     |
| has\_loops    | logical   | A logical defining the presence or absence of self-loops.                          |
| edge\_count   | double    | A number corresponding to the number of edges.                                     |
| node\_count   | double    | A number corresponding to the number of nodes.                                     |
| node\_classes | double    | A number corresponding to the number of node classes included for each edge class. |

  - `edges_table`: A `data.frame` that contains a minimum of two
    columns, one column of nodes acting as a vector source or starting
    point (`from`) and another column of nodes that are the target of
    the connection (`to`). In addition to the `from` and `to` variables
    the data include a class variable for each (`from_class` and
    `to_class`).

<!-- end list -->

``` r
drugnet$network$edges_table %>%
  glimpse()
#> Observations: 337
#> Variables: 5
#> $ from       <chr> "1", "1", "2", "2", "3", "4", "4", "5", "6", "7", "7"…
#> $ to         <chr> "2", "10", "1", "10", "7", "7", "211", "134", "152", …
#> $ from_class <chr> "person", "person", "person", "person", "person", "pe…
#> $ to_class   <chr> "person", "person", "person", "person", "person", "pe…
#> $ edge_class <chr> "Acquaintanceship", "Acquaintanceship", "Acquaintance…
```

  - `nodes_table`: A `data.frame` contain node non-relational
    characteristics. A unique identifier for each node in the
    `edge_table` should be present in the `name` variable. In addition,
    a `node_class` observation is included for each node.

<!-- end list -->

``` r
drugnet$network$nodes_table %>%
  glimpse()
#> Observations: 293
#> Variables: 8
#> $ name         <chr> "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", …
#> $ node_class   <chr> "people", "people", "people", "people", "people", "…
#> $ Gender       <dbl> 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
#> $ Ethnicity    <dbl> 1, 1, 1, 1, 3, 3, 1, 3, 1, 3, 3, 2, 2, 2, 2, 3, 3, …
#> $ HasTie       <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
#> $ hr_ethnicity <chr> "White/Other", "White/Other", "White/Other", "White…
#> $ hr_gender    <chr> "Male", "Male", "Male", "Female", "Male", "Male", "…
#> $ hr_has_tie   <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRU…
```

## Generating Graph Objects

Each network in the package contains the necessary edges and nodes
tables to generate network objects with **`{igraph}`** or
**`{network}`**. For instance:

``` r
core_as_igraph(drugnet)
#> IGRAPH 155f06f DN-- 293 337 -- 
#> + attr: name (v/c), node_class (v/c), Gender (v/n), Ethnicity
#> | (v/n), HasTie (v/n), hr_ethnicity (v/c), hr_gender (v/c),
#> | hr_has_tie (v/l), from_class (e/c), to_class (e/c), edge_class
#> | (e/c)
#> + edges from 155f06f (vertex names):
#>  [1] 1 ->2   1 ->10  2 ->1   2 ->10  3 ->7   4 ->7   4 ->211 5 ->134
#>  [9] 6 ->152 7 ->3   7 ->4   7 ->9   8 ->107 8 ->117 9 ->1   9 ->2  
#> [17] 9 ->7   10->1   10->2   11->135 11->220 12->89  13->216 14->24 
#> [25] 14->52  16->10  16->19  17->64  17->79  18->55  18->104 18->165
#> [33] 19->18  20->64  20->182 21->16  21->22  22->21  22->64  22->107
#> + ... omitted several edges

core_as_network(drugnet)
#>  Network attributes:
#>   vertices = 293 
#>   directed = TRUE 
#>   hyper = FALSE 
#>   loops = FALSE 
#>   multiple = FALSE 
#>   bipartite = FALSE 
#>   total edges= 337 
#>     missing edges= 0 
#>     non-missing edges= 337 
#> 
#>  Vertex attribute names: 
#>     Ethnicity Gender HasTie hr_ethnicity hr_gender hr_has_tie node_class vertex.names 
#> 
#>  Edge attribute names: 
#>     edge_class from_class to_class
```
