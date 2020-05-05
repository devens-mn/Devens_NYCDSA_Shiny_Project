#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
function(input, output) {
    output$plotout = renderPlot(
        promo %>% filter(., !promo$nas) %>%  
            # group_by_(., input$var_to_analyze_by, "price") %>% 
            # summarise(., revsum = sum(revenue)) %>% 
            # ggplot(., aes_string(x=input$var_to_analyze_by, y='revsum')) + 
            # geom_col(aes(fill = as.character(price)), position = 'dodge')
            # try not with booking percentage to get the string fxns right
            group_by_(., input$var_to_analyze_by, "price") %>% 
            summarise(., revsum = sum(revenue)) %>% 
            ggplot(., aes_string(x=input$var_to_analyze_by, y='revsum')) + 
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
}
