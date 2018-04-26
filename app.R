library(shiny)
library(ggplot2)
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

LyticVSLatent_TMMNorm_1[which(LyticVSLatent_TMMNorm_1[,2]<0.05 & LyticVSLatent_TMMNorm_1[,3]>2),4] <- "Up-regulated"
LyticVSLatent_TMMNorm_1[which(LyticVSLatent_TMMNorm_1[,2]<0.05 & LyticVSLatent_TMMNorm_1[,3] < -2),4] <- "Down-regulated"

# make the Plot.ly plot
z <- c("blue","black","red")

p <- plot_ly(data = LyticVSLatent_TMMNorm_1, 
             x = (LyticVSLatent_TMMNorm_1[,3]), y = -log10(LyticVSLatent_TMMNorm_1[,2]), 
             mode = "markers", color = LyticVSLatent_TMMNorm_1[,4], colors=z,
             marker = list(size=3),
             text = ~paste("Gene: ", LyticVSLatent_TMMNorm_1[,1], "P-value: ", LyticVSLatent_TMMNorm_1[,2], "FC: ", LyticVSLatent_TMMNorm_1[,3]), 
             type ="scatter") %>% 
  layout(title ="Volcano Plot") %>%
  layout(xaxis = list(range = c(-50, 50), title="Fold Change"),
         yaxis = list(range = c(0, 10), title="P-value(-log10)")) 
p

# Run the application 
shinyApp(ui = ui, server = server)

