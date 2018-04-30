#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

#Read in File
LyticVSLatent_TMMNorm_1 <- read.delim("/home/yunkyunp/www/shiny-server/finalproject/Final-Project---Spring-2018/LyticVSLatent_TMMNorm_1.txt")

#Trim Data
LyticVSLatent_TMMNorm_1 <- LyticVSLatent_TMMNorm_1[,-8]
LyticVSLatent_TMMNorm_1 <- LyticVSLatent_TMMNorm_1[,-7]
LyticVSLatent_TMMNorm_1 <- LyticVSLatent_TMMNorm_1[,-5]
LyticVSLatent_TMMNorm_1 <- LyticVSLatent_TMMNorm_1[,-4]
LyticVSLatent_TMMNorm_1 <- LyticVSLatent_TMMNorm_1[,-2]

#Label Data
LyticVSLatent_TMMNorm_1[,4] <- "Not Significant"
LyticVSLatent_TMMNorm_1[which(LyticVSLatent_TMMNorm_1[,2]<0.05 & LyticVSLatent_TMMNorm_1[,3]>2),4] <- "Up Regulated"
LyticVSLatent_TMMNorm_1[which(LyticVSLatent_TMMNorm_1[,2]<0.05 & LyticVSLatent_TMMNorm_1[,3] < -2),4] <- "Down Regulated"

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   titlePanel("Differential binding between latent vs. lytic viral infection"),
   plotlyOutput("plot"),
   verbatimTextOutput("hover"),
   verbatimTextOutput("click"),
   verbatimTextOutput("brush"),
   verbatimTextOutput("zoom")
)

z <- c("blue","black","red")

# Define server logic required to draw a histogram
server <- function(input, output, session) {
   
   output$plot <- renderPlotly({
     # make the Plot.ly plot
      plot_ly(data = LyticVSLatent_TMMNorm_1, 
                   x = (LyticVSLatent_TMMNorm_1[,3]), y = -log10(LyticVSLatent_TMMNorm_1[,2]), 
                   mode = "markers", color = LyticVSLatent_TMMNorm_1[,4], colors=z,
                   marker = list(size=3),
                   text = ~paste("Gene: ", LyticVSLatent_TMMNorm_1[,1], "P-value: ", LyticVSLatent_TMMNorm_1[,2], "FC: ", LyticVSLatent_TMMNorm_1[,3]), 
                   type ="scatter") %>% 
        layout(title ="Volcano Plot") %>%
        layout(xaxis = list(range = c(-50, 50), title="Fold Change"),
               yaxis = list(range = c(0, 10), title="P-value(-log10)")) %>%
        layout(dragmode = "select")

   })
   
   output$hover <- renderPrint({
     d <- event_data("plotly_hover")
     if (is.null(d)) "Hover events (unhover to clear)" else d
   })
   
   output$click <- renderPrint({
     d <- event_data("plotly_click")
     if (is.null(d)) "Click events (double-click to clear)" else d
   })
   
   output$brush <- renderPrint({
     d <- event_data("plotly_selected")
     if (is.null(d)) "Click and drag events (double-click to clear)" else d
   })
   
   output$zoom <- renderPrint({
     d <- event_data("plotly_relayout")
     if (is.null(d)) "Zoom events" else d
   })
   
   
}

# Run the application 
shinyApp(ui, server)

