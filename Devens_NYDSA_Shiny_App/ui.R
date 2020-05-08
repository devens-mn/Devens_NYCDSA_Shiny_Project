
library(shiny)

shinyUI(dashboardPage(
    dashboardHeader(title = "Kaggle Pricing Elasticity Data"),
    dashboardSidebar(
        sidebarUserPanel("Doug Devens"),
        sidebarMenu(
            id = 'tabs'
            ,menuItem("Introduction", tabName = "Introduction")
            ,menuItem("Economic_Analysis", tabName = "EconomicAnalysis")
            ,menuItem("Buying Decision Factors", tabName = "BuyingFactors")
            ,menuItem("Buying Decision Analysis", tabName = "BuyingAnalysis")
            )
        ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "Introduction",
                h1('Introduction to the project')
                ,p('The internet has offered the ability to track on an individual
                    level the shopping decisions of consumers in a way that is new.
                    Now the marketer has the ability to see each person who visited 
                    a product website and know if that person made a purchase without
                    having to make inferences about potential traffic.' )
                ,p('This project examines the pricing elasticity of demand for an
                    unnamed "leisure and fun"  activity examined experimentally by 
                    an internet site during Q2 2017, available on Kaggle and scrubbed
                    to maintain confidentiality. We examine the effect of pricing
                    and other factors on purchase decisions for this activity.')
                ,p('The price experiment was run changing the price from $199 to
                    $299 a third of the time, approximately evenly  distributed 
                    so that each day of the week, referral source (e.g Facebook 
                    or Google) and platform (e.g. mobile or desktop) had approximately
                    the same ratio of $299 price offers.  The distribution and 
                    total number of visits are below.')
                ,plotOutput('plotvisits', height = "200px")
                ,selectizeInput(inputId = 'vsts_var_to_analyze_by',
                           label = "Distribution of visits by",
                           choices = vsts_var_to_analyze_by)
                    )
            ,tabItem(tabName = "EconomicAnalysis",
                h1('Economic Analysis of the Pricing Experiment')
                ,p('Price elasticity is ...' )
                ,plotOutput('plotbkngs', height = "200px")
                ,plotOutput('plotrev', height = "200px")
                ,selectizeInput(inputId = 'rev_var_to_analyze_by',
                         label = "Distribution of revenue by",
                         choices = rev_var_to_analyze_by)
                )
            ,tabItem(tabName = "BuyingFactors",
                 h1('Buying factors')
                 ,p('Price elasticity is ...' )
                 ,plotOutput('plotwinpct', height = "200px")
                 ,selectizeInput(inputId = 'bk_var_to_analyze_by',
                          label = "Distribution of revenue and number sold by",
                          choices = bk_var_to_analyze_by)
                )
            ,tabItem(tabName = "BuyingAnalysis",
                     h1('Buying analysis')
                     , p('Price elasticity is ...' )
                     
                )
            )
        )
    )
)