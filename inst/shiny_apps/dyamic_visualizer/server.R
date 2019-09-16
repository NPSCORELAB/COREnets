shiny::shinyServer(function(input, output, session){
  
  switch_data <- reactive({
    cat(input$select_data)
    t <- input$select_data
    temp <- get(data(cat(t), package="COREnets"))
    cat(temp)
  })
  
  output$table <- DT::renderDataTable({
    data <- switch_data()
    DT::datatable(data$network$node_table)
  })
})