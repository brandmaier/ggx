#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

if (!("heyshiny" %in% installed.packages())) {
if (!require("remotes")) {
  install.packages("remotes")
}
remotes::install_github("jcrodriguez1989/heyshiny", dependencies = TRUE)
}


library(shiny)
library("heyshiny")
library(ggplot2)
library(ggx)

cmd_stack <- list()

app.env <- new.env()

hey <- "gg"
#hey <- "hey"


# Define UI for application that draws a histogram
ui <- fluidPage(
    useHeyshiny(language = "en-US"), # configure the heyshiny package
    titlePanel("ggx voice"),
    h4("This app does not work within Rstudio. Open the shiny URL in Google Chrome."),
    h4("Say: Gee-Gee, paint the x-axis label red"),
    speechInput(inputId = "hey_cmd", command = paste(hey, " *msg")), # set the input
    verbatimTextOutput("shiny_response"),
    plotOutput("plt",width = "400px",height="400px")
)

buildPlot <- function( ) {
    gp <- ggplot(data=iris, 
                 mapping=aes(x=Sepal.Length, 
                             y=Petal.Length, color=Species))+
        geom_point()
    
    for (cmd in app.env$cmd_stack) {
        gp <- gp + gg_(cmd)
    }
    
    return(gp)
}

# Define server logic required to draw a histogram
server <- function(input, output) {
    
  output$plt<-renderPlot({ buildPlot() })

    
    observeEvent(input$hey_cmd, {
        speech <- input$hey_cmd
        #print("Speech is:")
        #print(speech)
        message(paste0("Recognized: ", speech))
        
        speech <- gsub("quote", "\"", speech )
        
        res <- speech

        output$shiny_response <- renderText(res)
        
        temp_cmd <- gg_(res)
        if (!is.null(temp_cmd)) {
            app.env$cmd_stack[[length(app.env$cmd_stack)+1]] <- speech
            cat("Current Stack:","\n")
            print(app.env$cmd_stack)
            cat("Command added: ",res,"\n")
            
        }
        
    gp <- buildPlot()
         
    #        NULL
        
        output$plt <- renderPlot( {plot(gp)} )
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
