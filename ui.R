
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Phyto-zooplankton model with process error"),
  
  
  # Sidebar with a slider input for the number of bins
  fluidRow(
    column(3,
      sliderInput("tt",
                  "Time for simulation:",
                  min = 10,
                  max = 1000,
                  value = 500),
      numericInput("Aini","Initial value of phyto:",1,min=1,max=1000),
      numericInput("Hini","Initial value of zoo  :",1,min=0,max=1000),
      numericInput("Dt","Integration step (Continuous/Discrete):",0.01,min=0,max=1),
      
      selectInput("ptype", "Choose a plot type:", 
                  choices = c("Time series", "Phase diagram"))
    ),
    column(3,
           numericInput("Pm","Max photosynthetic rate (Pm):",0.04,min=0,max=10),
           numericInput("alfa","Rate of photosynthesis per mol of PAR (alfa)",0.0013,min=0,max=10),
           numericInput("Im","Average light intensity (Im):",100,min=0,max=1000), 
           numericInput("R","Phyto Respiration rate (R)",0.002,min=0,max=10)
    ),
    
    column(3,
           numericInput("c","Sinking velocity (c)",0.029,min=0,max=10), 
           numericInput("b","Resuspention rate (b)",0.06,min=0,max=10),
           numericInput("Zm","Mixing depth (Zm)",30,min=0,max=200), 
          numericInput("q","Predation eficience (q)",0.03,min=0,max=1)
    ),
    
    
    column(3,
           numericInput("mu","Mortality rate Zoo (mu)",0.01,min=0,max=10), 
           numericInput("et","Transformation efficiency Zoo (et)",0.025,min=0,max=1), 
           numericInput("errm","SD of stochastic noise:",0.001,min=0,max=1), 
           actionButton("go", "Simulate!"),
           textOutput("Stability")
           
    )
  ),
    
  hr(),
  
  # Show a plot of the generated distribution
  fluidRow(
    column(12,
      plotOutput("modelPlot")
    )
  )
  
))


