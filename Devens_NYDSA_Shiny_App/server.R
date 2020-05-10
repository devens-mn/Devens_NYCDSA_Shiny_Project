#

# Define server logic required to draw a histogram
function(input, output) {
    output$plotvisits = renderPlot(
        usepromo %>%
            group_by_(., input$vsts_var_to_analyze_by, "price") %>%
            summarise(., novisits = n()) %>%
            ggplot(., aes_string(x=input$vsts_var_to_analyze_by, y='novisits')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
            + ggtitle('Total site visits during experiment, by price')
            + ylab('Count of site visits') + scale_fill_brewer(name = 'Price',
                labels=c('$199', '$299')) + theme_classic() 
            + theme(axis.title.x = element_text(size=14),
                  axis.text.x  = element_text(size=14),
                  axis.text.y  = element_text(size=14))
    )
    output$plotwinpct = renderPlot(
        usepromo %>%
            group_by_(., input$bk_var_to_analyze_by, "price") %>%
            summarise(., winpct = 100*sum(booked)/n()) %>%
            ggplot(., aes_string(x=input$bk_var_to_analyze_by, y='winpct')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
            + ggtitle('Number of booked activities per 100 visits, by price')
            + ylab('Count of booked activities') + scale_fill_brewer(name = 'Price',
                labels=c('$199', '$299')) + theme_classic() 
                + theme(axis.title.x = element_text(size=14),
                axis.text.x  = element_text(size=14),
                axis.text.y  = element_text(size=14))
    )
    output$plotrev = renderPlot(
        usepromo %>% 
            group_by_(., input$rev_var_to_analyze_by, "price") %>%
            summarise(., revsum = 100*sum(revenue)/n()) %>%
            ggplot(., aes_string(x=input$rev_var_to_analyze_by, y='revsum')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
            + ggtitle('Revenues generated per 100 visits, by price')
            + ylab('Revenues in US Dollars, $') + scale_fill_brewer(name = 'Price',
                labels=c('$199', '$299')) + theme_classic() 
                + theme(axis.title.x = element_text(size=14),
                axis.text.x  = element_text(size=14),
                axis.text.y  = element_text(size=14))
    )
    output$plotbkngs = renderPlot(
        usepromo %>% 
            group_by_(., input$rev_var_to_analyze_by, "price") %>%
            summarise(., bksums = 100*sum(booked)/n()) %>%
            ggplot(., aes_string(x=input$rev_var_to_analyze_by, y='bksums')) +
            geom_col(aes(fill = as.character(price)), position = 'dodge')
            + ggtitle('Number of bookings per 100 visits, by price')
            + ylab('Count of bookings') + scale_fill_brewer(name = 'Price',
                labels=c('$199', '$299')) + theme_classic() 
                + theme(axis.title.x = element_text(size=14),
                axis.text.x  = element_text(size=14),
                axis.text.y  = element_text(size=14))
    )
    output$plotttlvsts = renderPlot(
        usepromo %>% 
            group_by_(., input$bk_var_to_analyze_by) %>%
            summarise(., ttlvsts = n()) %>%
            ggplot(., aes_string(x=input$bk_var_to_analyze_by, y='ttlvsts')) +
            geom_col() + ggtitle('Total visits during experiment') + 
            ylab('Count of all visits') + scale_fill_brewer() + theme_classic() 
                + theme(axis.title.x = element_text(size=14),
                axis.text.x  = element_text(size=14),
                axis.text.y  = element_text(size=14))
    )
    output$tblsource = renderTable(
        usepromo %>% filter(., price == input$price_to_anlyz_by) %>% group_by(., source) %>% 
        summarise(., Bookings = sum(booked), Visits = n())
    )
    output$tbldevice = renderTable(
        usepromo %>% filter(., price == input$price_to_anlyz_by) %>% group_by(., device) %>% 
        summarise(., Bookings = sum(booked), Visits = n())
    )
    output$prntmodel = renderPrint(
        summary(logitmodeltest)
    )
    output$prptest1 = renderPrint(
            prptst1(input$price_to_anlyz_by)
    )
    output$prptest2 = renderPrint(
        prptst2(input$price_to_anlyz_by)
    )
}





