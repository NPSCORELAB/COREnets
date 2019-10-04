
COREnets
========

[![Build Status](https://travis-ci.org/NPSCORELAB/COREnets.svg?branch=master)](https://travis-ci.org/NPSCORELAB/COREnets)

Installation
------------

First, if you haven't done so, install `devtools`:.

``` r
install.packages("devtools")
```

Proceed to install `{COREnets}` from Github:

``` r
devtools::install_github("NPSCORELAB/COREnets")
```

Using the Package to Access Data
--------------------------------

**{COREnets}** contains a series of network data sets that can be accessed using the `get_data` function:

``` r
library(COREnets)
drugnet <- COREnets::get_data("drugnet")
```

In order to look up the available data sets use the `list_data_sources` function:

``` r
COREnets::list_data_sources()
#>  [1] "anabaptists"                   "cocaine_smuggling_acero"      
#>  [3] "cocaine_smuggling_jake"        "cocaine_smuggling_juanes"     
#>  [5] "cocaine_smuggling_mambo"       "drugnet"                      
#>  [7] "fifa"                          "harry_potter_death_eaters"    
#>  [9] "harry_potter_dumbledores_army" "london_gang"                  
#> [11] "montreal_street_gangs"         "noordin_139"                  
#> [13] "november17"                    "siren"                        
#> [15] "zegota"
```

Get a brief description of the data set:

``` r
COREnets::get_description("noordin_139")
#> [1] "These data were drawn primarily from 'Terrorism in Indonesia: Noordin's Networks,' a publication of the International Crisis Group (2006) and include relational data on the 79 individuals listed in Appendix C of that publication. "
```

Each data object contains two main lists of information, the `reference` and `network` lists:

``` r
names(drugnet)
#> [1] "reference" "network"
class(drugnet$reference)
#> [1] "list"
class(drugnet$network)
#> [1] "list"
```

### `reference`

The `reference` list contains the following fields of information on the data set:

| Field       | Type       | Definition                                                                               |
|:------------|:-----------|:-----------------------------------------------------------------------------------------|
| title       | character  | A formal title for the dataset as presented by other databases or the author.            |
| name        | character  | An informal dataset label for internal use.                                              |
| tags        | character  | An internal classification assinged to the dataset.                                      |
| description | character  | A brief definition of the dataset to include the type of data, collection, etc.          |
| abstract    | character  | A brief summary of ...                                                                   |
| codebook    | data.frame | A data table used for gathering and storing relationships and their definitions.         |
| bibtex      | character  | The citation for the dataset in bibtex format. Some datasets may have mupltiple entries. |
| paper\_link | character  | Hyperlink(s) to publications linked to the dataset.                                      |

### `network`

The `network` list contains all the relevant data to generate a sociogram and conduct the analysis. However, because each data set is slightly different, this list is segmented into three entries:

-   `metadata`: A list of lists each containing information on the different edge types contained in the edge list. The following list are included as individual nested items for each edge type sub-graph, each contain a variety of fields:

<table>
<colgroup>
<col width="12%" />
<col width="10%" />
<col width="77%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Field</th>
<th align="left">Type</th>
<th align="left">Definition</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">edge_class</td>
<td align="left">character</td>
<td align="left">A string matching the name of an edge class in the codebook.</td>
</tr>
<tr class="even">
<td align="left">is_bimodal</td>
<td align="left">logical</td>
<td align="left">A logial denoting wheter or not the edge type yields a bipartite graph.</td>
</tr>
<tr class="odd">
<td align="left">is_directed</td>
<td align="left">logical</td>
<td align="left">A logical denoting whether the network edges are directed or not.</td>
</tr>
<tr class="even">
<td align="left">is_dynamic</td>
<td align="left">logical</td>
<td align="left">A logical denoting whether the edges are dynamic or not.</td>
</tr>
<tr class="odd">
<td align="left">is_weighted</td>
<td align="left">logical</td>
<td align="left">A logical denoting whether or not the edges are weighted.</td>
</tr>
<tr class="even">
<td align="left">has_isolates</td>
<td align="left">logical</td>
<td align="left">A logical which defines if the graph contains isolates or not.</td>
</tr>
<tr class="odd">
<td align="left">has_loops</td>
<td align="left">logical</td>
<td align="left">A logical defining the presence or absence of self-loops.</td>
</tr>
<tr class="even">
<td align="left">edge_count</td>
<td align="left">double</td>
<td align="left">A number corresponding to the number of edges.</td>
</tr>
<tr class="odd">
<td align="left">node_count</td>
<td align="left">double</td>
<td align="left">A number corresponding to the number of nodes.</td>
</tr>
<tr class="even">
<td align="left">node_classes</td>
<td align="left">double</td>
<td align="left">A number corresponding to the number of node classes included for each edge class.</td>
</tr>
</tbody>
</table>

-   `edges_table`: A `data.frame` that contains a minimum of two columns, one column of nodes acting as a vector source or starting point (`from`) and another column of nodes that are the target of the connection (`to`). In addition to the `from` and `to` variables the data include a class variable for each (`from_class` and `to_class`).

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

-   `nodes_table`: A `data.frame` contain node non-relational characteristics. A unique identifier for each node in the `edge_table` should be present in the `name` variable. In addition, a `node_class` observation is included for each node.

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

Generating Networks
-------------------

Each network in the package contains the necessary edges and nodes tables to generate network objects with **{igraph}**. For instance:

``` r
net <- igraph::graph_from_data_frame(d        = drugnet$network$edges_table,
                                     directed = FALSE, 
                                     vertices = drugnet$network$nodes_table)
net
#> IGRAPH 4a519a0 UN-- 293 337 -- 
#> + attr: name (v/c), node_class (v/c), Gender (v/n), Ethnicity
#> | (v/n), HasTie (v/n), hr_ethnicity (v/c), hr_gender (v/c),
#> | hr_has_tie (v/l), from_class (e/c), to_class (e/c), edge_class
#> | (e/c)
#> + edges from 4a519a0 (vertex names):
#>  [1] 1 --2   1 --10  1 --2   2 --10  3 --7   4 --7   4 --211 5 --134
#>  [9] 6 --152 3 --7   4 --7   7 --9   8 --107 8 --117 1 --9   2 --9  
#> [17] 7 --9   1 --10  2 --10  11--135 11--220 12--89  13--216 14--24 
#> [25] 14--52  10--16  16--19  17--64  17--79  18--55  18--104 18--165
#> [33] 18--19  20--64  20--182 16--21  21--22  21--22  22--64  22--107
#> + ... omitted several edges
```
