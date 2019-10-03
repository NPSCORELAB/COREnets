
COREnets
========

[![Build Status](https://travis-ci.org/NPSCORELAB/COREnets.svg?branch=master)](https://travis-ci.org/NPSCORELAB/COREnets)

Installation
------------

A. Install `devtools` if you haven't already.

``` r
install.packages("devtools")
```

B. Install the package using `devtools`.

``` r
devtools::install_github("NPSCORELAB/COREnets")
```

Using the Package to Access Data
--------------------------------

**{COREnets}** contains a series of network data sets that can be accessed using the `get_data` function:

``` r
library(COREnets)
london_gang <- COREnets::get_data("london_gang")
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

Each data object contains two main lists of information, the `reference` and `network` lists:

``` r
names(london_gang)
#> [1] "reference" "network"
class(london_gang$metadata)
#> [1] "NULL"
class(london_gang$network)
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
london_gang$network$edges_table %>%
  glimpse()
#> Observations: 315
#> Variables: 6
#> $ from       <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"…
#> $ to         <chr> "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "…
#> $ from_class <chr> "people", "people", "people", "people", "people", "pe…
#> $ to_class   <chr> "people", "people", "people", "people", "people", "pe…
#> $ type       <dbl> 1, 1, 2, 1, 1, 2, 3, 2, 2, 3, 1, 1, 1, 2, 2, 3, 1, 1,…
#> $ edge_class <chr> "Hang Out Together", "Hang Out Together", "Co-Offend …
```

-   `nodes_table`: A `data.frame` contain node non-relational characteristics. A unique identifier for each node in the `edge_table` should be present in the `name` variable. In addition, a `node_class` observation is included for each node.

``` r
london_gang$network$nodes_table %>%
  glimpse()
#> Observations: 54
#> Variables: 11
#> $ name          <chr> "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",…
#> $ Age           <dbl> 20, 20, 19, 21, 24, 25, 20, 21, 20, 23, 21, 25, 21…
#> $ Birthplace    <dbl> 1, 2, 2, 2, 2, 3, 4, 1, 1, 1, 1, 3, 3, 3, 3, 3, 2,…
#> $ Residence     <dbl> 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,…
#> $ Arrests       <dbl> 16, 16, 12, 8, 11, 17, 8, 15, 9, 12, 16, 5, 19, 23…
#> $ Convictions   <dbl> 4, 7, 4, 1, 3, 10, 1, 6, 3, 4, 8, 3, 9, 9, 9, 7, 8…
#> $ Prison        <dbl> 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0,…
#> $ Music         <dbl> 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0,…
#> $ Ranking       <dbl> 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4,…
#> $ node_class    <chr> "people", "people", "people", "people", "people", …
#> $ hr_birthplace <chr> "West Africa", "Caribbean", "Caribbean", "Caribbea…
```

Generating Networks
-------------------

Each network in the package contains the necessary edges and nodes tables to generate network objects with **igraph**. For instance:

``` r
net <- igraph::graph_from_data_frame(d        = london_gang$network$edges_table,
                                     directed = FALSE, 
                                     vertices = london_gang$network$nodes_table)
net
#> IGRAPH 8d0bcf6 UN-- 54 315 -- 
#> + attr: name (v/c), Age (v/n), Birthplace (v/n), Residence (v/n),
#> | Arrests (v/n), Convictions (v/n), Prison (v/n), Music (v/n),
#> | Ranking (v/n), node_class (v/c), hr_birthplace (v/c), from_class
#> | (e/c), to_class (e/c), type (e/n), edge_class (e/c)
#> + edges from 8d0bcf6 (vertex names):
#>  [1] 1--2  1--3  1--4  1--5  1--6  1--7  1--8  1--9  1--10 1--11 1--12
#> [12] 1--17 1--18 1--20 1--21 1--22 1--23 1--25 1--27 1--28 1--29 1--43
#> [23] 1--45 1--46 1--51 2--3  2--6  2--7  2--8  2--9  2--10 2--11 2--12
#> [34] 2--13 2--14 2--16 2--18 2--21 2--22 2--23 2--25 2--28 2--29 2--30
#> [45] 2--31 2--38 3--4  3--5  3--6  3--7  3--8  3--9  3--10 3--12 3--13
#> + ... omitted several edges
```
