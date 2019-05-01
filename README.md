# COREnets

## Installation

  1. Install `devtools` if you haven't already.

``` r
install.packages("devtools")
```

  2. Install the package using `devtools`.
  
``` r
devtools::install_github("NPSCORELAB/COREnets")
```


## Using the Package

`COREnets` contains a series of network datasets that can be accessed using explicit namespace access:

```r
library(COREnets)
anabaptists <- COREnets::anabaptists
```

Each data object is a list with four items:

```r
names(anabaptists)
[1] "nodes" "edges" "name"  "desc" 
```

The nodes and edges tables contain vertex and edge information required to create an igraph object:

```r
g <- igraph::graph_from_data_frame(anabaptists$edges, vertices=anabaptists$nodes)
g
IGRAPH 8434976 DNW- 67 366 -- 
+ attr: name (v/c), Believers.Baptism (v/n), Violence (v/n), Münster.Rebellion
| (v/n), Apocalyptic (v/n), Anabaptist (v/n), Melchiorite (v/n), Swiss.Brethren
| (v/n), Denck (v/n), Hut (v/n), Hutterite (v/n), Other.Anabaptist (v/n),
| Lutheran (v/n), Reformed (v/n), Other.Protestant (v/n), Tradition (v/n),
| Origin.. (v/n), Operate.. (v/n), weight (e/n)
+ edges from 8434976 (vertex names):
 [1] Martin Luther->Ulrich Zwingli      Martin Luther->Thomas Muntzer     
 [3] Martin Luther->Andreas Carlstadt   Martin Luther->Caspar Schwenckfeld
 [5] Martin Luther->Melchior Hofmann    Martin Luther->Philipp Melanchthon
 [7] Martin Luther->Martin Bucer        John Calvin  ->Wolfgang Capito    
+ ... omitted several edges
```