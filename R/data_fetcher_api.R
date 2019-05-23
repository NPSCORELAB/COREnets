library(plumber)
library(COREnets)
library(igraph)

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
