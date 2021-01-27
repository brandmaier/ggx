#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library("heyshiny")
library(ggplot2)
library(ggx)

cmd_stack <- list()

app.env <- new.env()


# Define UI for application that draws a histogram
ui <- fluidPage(
    useHeyshiny(language = "en-US"), # configure the heyshiny package
    titlePanel("ggx voice"),
    #speechInput(inputId = "hey_cmd", command = "gg *msg"), # set the input
    speechInput(inputId = "hey_cmd", command = "gg *msg"), # set the input
#    speechInput(inputId = "hey_cmd"),
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
    
  #  observe(
   #          output$plt<-renderPlot( buildPlot() )
    #         )
    
    observeEvent(input$hey_cmd, {
        speech <- input$hey_cmd
        #print("Speech is:")
        #print(speech)
        message(paste0("Recognized: ", speech))
        
        speech <- gsub("quote", "\"", speech )
        
        res <- speech
     #   res <- "Sorry, I don't know how to help with that yet"
       # if (grepl("^random number", tolower(speech))) {
    #        res <- paste0("Here is your random number: ", round(runif(1, 0, 8818)))
    #    } else if (grepl("^repeat", tolower(speech))) {
    #        res <- sub("repeat ", "", speech)
    #    }
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
