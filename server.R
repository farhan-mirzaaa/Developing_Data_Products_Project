library(maps)
library(mapdata)
library(ggplot2)
library(shiny)
library(plotly)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  populationData <- reactive({
    pd <- read.csv(url("https://raw.githubusercontent.com/datasets/population/master/data/population.csv"))
    pd$Value <- pd$Value/1000000
    pd
  })
  
  worldMapData <- reactive({
    map_data("world")
  })
  
  output$inputCountries <- renderUI({
    req(worldMapData())
    rn <- factor(worldMapData()$region)
    selectInput("inputCountries", "Select Country:", choices = c(levels(rn)), selected = "Pakistan")
  })
  
  selectedCountryMap <- reactive({
    subset(worldMapData(), region %in% input$inputCountries)
  })
  
  selectedCountryPopulation <- reactive({
    if( input$inputCountries %in% populationData()$Country.Code)    {
      subset(populationData(), Country.Code %in% input$inputCountries)
    }    else    {
      subset(populationData(), Country.Name %in% input$inputCountries)
    }
  })
  
  rangePopulation <- reactive({
    subset(selectedCountryPopulation(), Year >= input$inputPopulationRange[1] & Year <= input$inputPopulationRange[2] )
  })
  
  output$worldPlot <- renderPlot({
    req(worldMapData())
    
    ggplot(data = worldMapData()) + 
      
      geom_polygon(aes(x = long, y = lat, group = group), fill = "light yellow", color = "grey") + 
      
      coord_fixed(1.3) +
      
      guides(fill=FALSE) + geom_polygon(data=selectedCountryMap(), aes(x = long, y = lat, group = group), fill = "green")
  })
  
  output$populationPlot <- renderPlotly({
    req(populationData())
    
    p <- ggplot(rangePopulation(),
                aes_string(x = rangePopulation()$Year,
                           y = rangePopulation()$Value)) +
                geom_point(color = "blue", size = 3) + labs(x = "Year", y = "Population (in mln)") +
                geom_smooth(color = "red")
    ggplotly(p)
  })
  
  output$documentHtmlText <- renderUI({
    HTML("<p>This application is the Course Project implementation of the <b>Coursera Developing Data Products</b>
          course from Data Science Secialization.
          This aaplication is a Population Viewer of selected country. This application uses multiple R packages 
          which includes: maps, mapdata, ggplot2 and plotly. This application uses population data set downloaded
          from <a>'https://raw.githubusercontent.com/datasets/population/master/data/population.csv'</a> and also 
          uses world map data from mapdata package.
          <br/><br/>
          In order to use this application you have to select the country of your interest. After that if you want
          to change population year range then you can use slider control for that.
          <br/><br/>
          The plot showing population is an interactive plot which is plotted with the 'plotly' package. You can 
          play with for any interaction available in plotly.
          <br/><br/>
          You can find the code files for this project at <a>'https://github.com/farhan-mirzaaa/Developing_Data_Products_Project'</a>
          </p>")
  })
})
