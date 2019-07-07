library(rsconnect)
library(shiny)
library(readr)
library(dplyr)
library(lubridate)
library(DT)
nwsl <- read_csv("https://raw.githubusercontent.com/cdoms/rootandrally/master/nwsl_2019_schedule.csv")

nwsl$Date <- as.Date(nwsl$`Start date`, "%Y-%m-%d")
nwsl <- nwsl[c("Subject", "Date", "Start time", "Location")]
colnames(nwsl)[c(1,3)] <- c("Game", "Start Time (ET)")
## have to convert start time for nwsl from pacific time to eastern time
nwsl <- nwsl[,c(2,3,1,4)]

nwsl$`Start Time (ET)` <- format(strptime(nwsl$`Start Time (ET)`, format='%H:%M:%S'), '%I:%M %p')


# Define UI for application that draws a histogram
ui <- basicPage(
            DT::dataTableOutput('table'))

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$table <- DT::renderDataTable( nwsl %>% mutate(PLACEHOLDER = Date,Date = paste(month(Date, label = TRUE), day(Date))) %>%
                                    arrange(PLACEHOLDER),
                                  options = list(
                                    pageLength = 20,
                                    lengthChange = FALSE,
                                    paginate = TRUE,
                                    info = FALSE,
                                    columnDefs = list(list(
                                      targets = 1,orderData = 5),
                                      list(targets = 5, visible = FALSE))))
  
   }

# Run the application 
shinyApp(ui = ui, server = server)
 
