#

# Define server logic required to draw a histogram
function(input, output) {
    output$plotvisits = renderPlot(
        promo %>% filter(., !promo$nas) %>%
            group_by_(., input$var_to_analyze_by, "price") %>%
            summarise(., novisits = n()) %>%
            ggplot(., aes_string(x=input$var_to_analyze_by, y='novisits')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
    output$plotwinpct = renderPlot(
        promo %>% filter(., !promo$nas) %>%
            group_by_(., input$var_to_analyze_by, "price") %>%
            summarise(., winpct = sum(booked)/n()) %>%
            ggplot(., aes_string(x=input$var_to_analyze_by, y='winpct')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
    output$plotrev = renderPlot(
        promo %>% filter(., !promo$nas) %>%  
            group_by_(., input$var_to_analyze_by, "price") %>%
            summarise(., revsum = sum(revenue)) %>%
            ggplot(., aes_string(x=input$var_to_analyze_by, y='revsum')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
}
