
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Pricing analysis app"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            #                       selectize input for thing to analyze
            selectizeInput(inputId = 'qty_to_analyze',
                           label = "Quantity to analyze",
                           choices = qtys_to_analyze),
            #                       selectize input for variable to analyze by
            selectizeInput(inputId = 'var_to_analyze_by',
                           label = "Variable by which to analyze",
                           choices = var_to_analyze_by)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plotout")
        )
    )
))
