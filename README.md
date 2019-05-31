
COREnets
========

Installation
------------

1.  Install `devtools` if you haven't already.

``` r
install.packages("devtools")
```

1.  Install the package using `devtools`.

``` r
devtools::install_github("NPSCORELAB/COREnets")
```

Using the Package
-----------------

`COREnets` contains a series of network datasets that can be accessed using explicit namespace access:

``` r
library(COREnets)
anabaptists <- COREnets::anabaptists
```

Each data object is a nested list with three levels:

``` r
names(anabaptists)
```

    #> [1] "metadata"    "bibtex_data" "network"

1.  The `metadata` contains information on the dataset:
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
    `character </td>    <td style="text-align:left;"> A formal title for the dataset for external uses. </td>   </tr>   <tr>    <td style="text-align:left;"> name </td>    <td style="text-align:left;">`character
    </td>
    <td style="text-align:left;">
    An informal dataset label for internal use.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    category
    </td>
    <td style="text-align:left;">
    `character </td>    <td style="text-align:left;"> An internal classification for the type dataset, based on one of the following: <br> - Religious <br> - Terrorirsm <br> - Criminal <br> - Other </td>   </tr>   <tr>    <td style="text-align:left;"> tags </td>    <td style="text-align:left;">`character
    </td>
    <td style="text-align:left;">
    An atomic vector of key words assinged to the piece of data.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    description
    </td>
    <td style="text-align:left;">
    \`character
    </td>
    <td style="text-align:left;">
    A brief definition of the dataset in regards to the type of data, collection, etc.
    </td>
    </tr>
    </tbody>
    </table>
2.  The `bibtex_data` the data fields required to generate a [bibtex citation](https://verbosus.com/bibtex-style-examples.html). Note that the some datasets will have mutiple citation entries.
3.  The `network` field contains a list of meta data and both the node and edges tables required to generate a network graph:

-   `net_metadata`: A list of descriptive information on the type of network:
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
    node\_type
    </td>
    <td style="text-align:left;">
    character
    </td>
    <td style="text-align:left;">
    Description of the node class.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    edge\_type
    </td>
    <td style="text-align:left;">
    character
    </td>
    <td style="text-align:left;">
    Description of the edge.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    modes
    </td>
    <td style="text-align:left;">
    double
    </td>
    <td style="text-align:left;">
    A number denoting one or two mode networks.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    directed
    </td>
    <td style="text-align:left;">
    logical
    </td>
    <td style="text-align:left;">
    A logical denoting whether the network edges are directed or not.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    weighted
    </td>
    <td style="text-align:left;">
    logical
    </td>
    <td style="text-align:left;">
    A logical denoting whether or not the edges are weighted.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    multiplex
    </td>
    <td style="text-align:left;">
    logical
    </td>
    <td style="text-align:left;">
    A logical denoting whether or not the network is made up of multiple layers.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    dynamic
    </td>
    <td style="text-align:left;">
    logical
    </td>
    <td style="text-align:left;">
    A logical denoting whether or not the network changes with time.
    </td>
    </tr>
    <tr>
    <td style="text-align:left;">
    spatial
    </td>
    <td style="text-align:left;">
    logical
    </td>
    <td style="text-align:left;">
    A logical denoting whether or not the network vertices or edges are associated with a geographic feature.
    </td>
    </tr>
    </tbody>
    </table>
-   `node_table`: A `data.frame` containg node attributes. A unique identifier for each node in the `edge_table` should be present in the `id` variable.
-   `edge_table`: A `data.frame` that contains a minimum of two columns, one column of nodes acting as a vector source or starting point (`from`) and another column of nodes that are the target of the connection (`to`).
