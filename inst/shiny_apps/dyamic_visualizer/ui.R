library(shiny)
library(shinythemes)
library(shinyWidgets)
library(COREnets)

shiny::shinyUI(
  fluidPage(
    theme = shinythemes::shinytheme("simplex"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(width = 4,
                          fluidRow(
                            column(12,
                                   shinyWidgets::pickerInput(inputId = "select_data",
                                               label = "Choose Network Data:",
                                               choices = data(package="COREnets")$results[,3])))
                          )# End sidebarPanel
      ,
      shiny::mainPanel(width = 8,
                       shiny::tabsetPanel(
                         shiny::tabPanel("Network", visNetwork::visNetworkOutput("net"))
                         ,
                         shiny::tabPanel("Metrics", DT::dataTableOutput("table"))
                         #,
                         #shiny::tabPanel("Glossary",)
                       )# End tabPanel
                       )# End mainPanel
    )# End sidebarLayout
  )#End fluidPage
)