library(shiny)
library(ggplot2)
require(RColorBrewer)

source("model_fun.r")
myCols <- brewer.pal(6,"Set1")


# Define server logic 
#
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot
  randomVals <- eventReactive(input$go, {
    TRUE
  })
  

  output$modelPlot <- renderPlot({
    
    if(randomVals()){
      # Build a list with parameters
      p <-list(tt=input$tt,Aini=input$Aini,Hini=input$Hini,Pm=input$Pm,
               alfa=input$alfa,Im=input$Im,R=input$R,c=input$c,b=input$b,
               Zm=input$Zm,q=input$q,mu=input$mu,et=input$et,errm=input$errm,
               dt=input$Dt)
      
      
      # Simulate model
      ah <- plank_zoo_rad(p)
      e <- plank_zoo_rad_eq(p)
      stab <-(input$c-input$b*input$Zm)*(input$et*input$q)/input$mu
      if(input$ptype=='Time series'){
        z <-data.frame(Bio=c(ah$A,ah$H),Time=rep(1:input$tt,2),type=rep(c("Phyto","Zoo"),each=input$tt))
        if(stab<0){
          ee <- data.frame(yl=c(e$Ae2,e$He2),type=c("Phyto","Zoo"))
          ggplot(z,aes(Time,Bio,colour=type))+theme_bw() + geom_line() + 
            geom_hline(data=ee,aes(yintercept=yl,colour=type),linetype=2,alpha=0.5) +
            scale_colour_brewer(palette="Dark2")
        
        } else {
          ggplot(z,aes(Time,Bio,colour=type))+theme_bw() + geom_line() + 
            scale_colour_brewer(palette="Dark2")
          
        }
        
      } else {
        z <-data.frame(Phyto=ah$A,Zoo=ah$H)
        ggplot(z,aes(Zoo,Phyto))+theme_bw() + geom_point(colour=myCols[1],alpha=0.5)
      }
    
    }

  })
  
  output$Stability <- 
    renderText(paste0('Stability condition (c-b Zm)(et q)/mu= ', round(
      (input$c-input$b*input$Zm)*(input$et*input$q)/input$mu,4)))
  

})
