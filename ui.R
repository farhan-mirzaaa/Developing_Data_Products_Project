library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("World Population Viewer"),
  
  navbarPage("",
             
             tabPanel("Population Map Viewer",
                      sidebarPanel(width = 3,
                                   uiOutput("inputCountries"),
                                   
                                   sliderInput("inputPopulationRange", "Population Year Range:",
                                               min = 1960, max = 2016,
                                               value = c(1960,2016))
                                   ),
                      mainPanel(
                                  h6("Note: Application can take some time for loading."),
                                  plotOutput("worldPlot"),
                                  plotlyOutput("populationPlot")
                                )
                      ),
             
             tabPanel("Documentation",
                      htmlOutput("documentHtmlText") )
  )
))
