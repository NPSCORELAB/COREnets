shiny::shinyServer(function(input, output, session){
  
  get_data <- reactive({
    switch(input$select_data,
           data(package="COREnets")$results[,3])
  })
  
  output$net <- visNetwork::renderVisNetwork({
    
  })
  
})