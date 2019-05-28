library(plumber)
library(COREnets)
library(igraph)
library(DT)

#* Echo back the input for testing
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* @get /list_data
function(){
  data(package="COREnets")$results[,3]
}

#* @param id
#* @get /get_network_data
function(id){
  id <- as.character(id)
  valid <- data(package="COREnets")$results[,3]
  if(id %in% valid){
    get(data(list=id))  
  }
  else{
    paste0("The dataset name provided was invalid, use the `list_data` parameter to list the data names.")
  }
}

#* @param id
#* @get /get_network_graph
#* @serializer htmlwidget
function(id){
  id <- as.character(id)
  valid <- data(package="COREnets")$results[,3]
  if(id %in% valid){
    listed_dat <- get(data(list=id))
    g <- graph_from_data_frame(listed_dat$edges,
                               vertices=listed_dat$nodes)
    visNetwork::visIgraph(g)
  }
  else{
    paste0("The dataset name provided was invalid, use the `list_data` parameter to list the data names.")
  }
}


#* @param id
#* @get /get_network_stats
#* @serializer htmlwidget
function(id){
  id <- as.character(id)
  valid <- data(package="COREnets")$results[,3]
  if(id %in% valid){
    listed_dat <- get(data(list=id))
    g <- graph_from_data_frame(listed_dat$edges,
                               vertices=listed_dat$nodes) %>%
      igraph::set.graph.attribute("density", edge_density(.)) %>%
      igraph::set.graph.attribute("avg_degree", mean(degree(.))) %>%
      igraph::set.graph.attribute("avg_clu_coef", transitivity(., "average")) 
    
    data.frame(
      "Density" = graph_attr(g, "density"),
      "Avg. Degree" = graph_attr(g, "avg_degree"),
      "Avg. Clustering Coefficient" = graph_attr(g, "avg_degree")
    ) %>%
      DT::datatable()
  }
  else{
    paste0("The dataset name provided was invalid, use the `list_data` parameter to list the data names.")
  }
}
