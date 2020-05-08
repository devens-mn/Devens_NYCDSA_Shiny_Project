#

# Define server logic required to draw a histogram
function(input, output) {
    output$plotvisits = renderPlot(
        usepromo %>%
            group_by_(., input$vsts_var_to_analyze_by, "price") %>%
            summarise(., novisits = n()) %>%
            ggplot(., aes_string(x=input$vsts_var_to_analyze_by, y='novisits')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
    output$plotwinpct = renderPlot(
        usepromo %>%
            group_by_(., input$bk_var_to_analyze_by, "price") %>%
            summarise(., winpct = sum(booked)/n()) %>%
            ggplot(., aes_string(x=input$bk_var_to_analyze_by, y='winpct')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
    output$plotrev = renderPlot(
        usepromo %>% 
            group_by_(., input$rev_var_to_analyze_by, "price") %>%
            summarise(., revsum = 100*sum(revenue)/n()) %>%
            ggplot(., aes_string(x=input$rev_var_to_analyze_by, y='revsum')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
    output$plotbkngs = renderPlot(
        usepromo %>% 
            group_by_(., input$rev_var_to_analyze_by, "price") %>%
            summarise(., bksums = 100*sum(booked)/n()) %>%
            ggplot(., aes_string(x=input$rev_var_to_analyze_by, y='bksums')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
    )
}
