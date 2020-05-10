
library(shiny)

shinyUI(dashboardPage(
    dashboardHeader(title = "Price Elasticity"),
    dashboardSidebar(
        sidebarUserPanel("Doug Devens"),
        sidebarMenu(
            id = 'tabs'
            ,menuItem("Introduction", tabName = "Introduction")
            ,menuItem("Economic Analysis", tabName = "EconomicAnalysis")
            ,menuItem("Purchasing Decision Factors", tabName = "BuyingFactors")
            ,menuItem("Purchasing Decision Analysis", tabName = "BuyingAnalysis")
            ,menuItem("Recommendations", tabName = "Recommendations")
            )
        ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "Introduction",
                h1('Examining price elasticity of demand with an online experiment')
                ,h4('Background')
                ,p('Internet marketplaces offer marketers the ability to track on an individual
                    level the shopping decisions, both positive and negative, of 
                    consumers without having to make inferences about potential traffic. This 
                    project examines the economic implications of price elasticity of demand
                    for an unnamed "leisure and fun" activity pricing experiment with approximately 225,000
                    observations run online by a company during Q2 2017 and presented 
                   at https://www.kaggle.com/shariqhhashmi/pricing-point#promo_results.csv' )
                ,h4('Objective')
                ,p("Our goal is to recommend methods to this company's management and marketing in order to maximize the
                   revenue and gross profit for the service.  To this end we investigate the effect of pricing
                    on economic outcomes such as revenue. We also examine the effect of price
                   and other factors on purchasing decisions observed during this experiment in order to increase 
                   further potential pricing flexibility.")
                ,h4('Description of experiment')
                ,p('The experiment changed the activity price from $199 to
                    $299 a third of the time, such that the ratios of observations
                    of the two prices were approximately evenly distributed 
                    across day of the week, referral source (e.g Facebook 
                    or Google), platform (e.g. mobile or desktop) and visitor ip address state (e.g. New York)
                     as illustrated in the figure below.')
                ,selectizeInput(inputId = 'vsts_var_to_analyze_by',
                    label = "Examine distribution of visits by",
                    choices = vsts_var_to_analyze_by)
                ,plotOutput('plotvisits', height = "200px")
                ,p('')
                ,p('E-mail: dadevens@gmail.com')
                ,p('GitHub:  devens-mn/Devens_NYCDSA_Shiny_Project ')
                ,p('linkedin.com/in/dougdevens')
                    )
            ,tabItem(tabName = "EconomicAnalysis",
                h1('Economic Analysis of the Pricing Experiment')
                ,h4('Background')
                ,p('Price elasticity of demand is the degree to which demand for
                 a product changes with its price.  Understanding this relationship
                 allows the producer/marketer to adjust price to maximize revenue' )
                ,h4('Observations on demand')
                ,p('Recall the number of visits with a $299 price was approximately half
                    the number of $199 price visits, so we standardize the number of bookings 
                    per 100 visits at a given price.  We observe in the figure below 
                    that as expected by economic models for products with negative price
                    elasticity the number of bookings drops as the price increased, here
                    on average of 22% across all factors.  The variation in this drop with respect to source,
                    device, state and day of the week is examined in the "Purchasing Decision Factors" tab.')
                ,selectizeInput(inputId = 'rev_var_to_analyze_by',
                    label = "Distribution of revenue and bookings by",
                    choices = rev_var_to_analyze_by)
                ,plotOutput('plotbkngs', height = "200px")
                ,h4('Observations of revenue')
                ,p('Economic models also predict the revenue will increase with
                   increasing price in the price-elastic region of the price-demand
                   curve, though in the price-inelastic region at higher prices revenue decreases as demand
                   drops more quickly with increasing price. This is demonstrated graphically in this figure from
                   Wikipedia.')
                ,img(src='https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Price_elasticity_of_demand_and_revenue.svg/440px-Price_elasticity_of_demand_and_revenue.svg.png',
                     height='30%',width = '30%')
                ,p('From Wikipedia')
                ,p('The figure below demonstrates
                   an average 17% increase in standardized revenue across all factors. Because the increase in
                   revenue was generated by an increase in price gross profit should also increase,
                   assuming unit costs do not increase proportionally with price 
                   as a function of decreased unit quantities')
                ,plotOutput('plotrev', height = "200px")
                ,p('Further experiments are required to determine if $299 is still in the price-elastic region
                   of the demand curve, due to the non-linear nature of the relationship 
                   between price elasticity and revenue. If $299
                   is still in the price-elastic region the revenue and presumably gross profit
                    could be further increased' )
                )
            ,tabItem(tabName = "BuyingFactors",
                 h1('Purchasing Decision Factors')
                 ,h4('Recap of prior observations in economic analysis')
                 ,p('We recall from the introduction the total number of site visits by day of week, 
                    referral source, state and device type, which represents a current
                    addressable market by that factor, to help with prioritization.' )
                 ,selectizeInput(inputId = 'bk_var_to_analyze_by',
                     label = "Distribution of total visits and booking percentage by:",
                     choices = bk_var_to_analyze_by)
                 ,plotOutput('plotttlvsts', height = "200px")
                 ,h4('Influence of factors on decision to purchase')
                 ,p('As noted in the economic analysis, the price elasticity as measured by 
                 the decrease in activity bookings did not change uniformly.  In the figure below
                    we illustate the effect of price, day of week and other factors on 
                    the decision to purchase. For source we find that Google Adwords (now Google Ads), Facebook and Unknown all
                    have higher percentages of booked trips per visit. The Unknown category warrants
                    deeper investigation to determine their source since
                    the booking percentage was relatively high in addition to a relatively large number
                    of visits from those unknown sites.  Also of interest, Google Adwords
                    and Unknown had $299 booking percentages around 2%, indicating potentially 
                    greater price elasticity and higher potential revenues from users of those sites (known and unknown) that
                    have a relatively larger number of referrals.  Similarly in device mobile users
                    appear to have a relatively higher volume and a higher booking percentage at $299 which
                    multiplied by the large number of visits may be meaningful.Finally, booking 
                    percentages do not appear to vary meaningfully by day of the week or the visitor state.' )
                 ,plotOutput('plotwinpct', height = "200px")
                )
            ,tabItem(tabName = "BuyingAnalysis",
                     h1('Purchasing Decision analysis')
                     , p('From the visualization of factors that may influence purchasing
                         we believed the differences in booking percentages may have been
                         meaningful in which source referred the visitor and the device (mobile or 
                         desktop) used by the visitor to come to the site.  ' )
                     ,selectizeInput(inputId = 'price_to_anlyz_by',
                                     label = "Price to analyze by:",
                                     choices = price_to_anlyz_by)
                     , fluidRow(
                         column(5, tableOutput('tblsource'))
                         , column(7, tableOutput('tbldevice')))
                     ,p('Analysis with a multiple proportion test confirms these
                        factors are clearly significant. The table below shows the analysis
                        of booking percentages by source, with 1 as Adwords and 
                        6 as Unknown.')
                     ,verbatimTextOutput('prptest1')
                     ,p('Similarly, we examined the significance of device with 1 as desktop. 
                        Though at $199 the difference is not significant, at $299 device is
                        significant at 95%.  However, it only barely achieves this level and is
                        of marginal importance.')
                     ,verbatimTextOutput('prptest2')
                     ,p('Finally, we attempted to use logistic regression model to determine 
                        if there is an interaction between price and source.  However, the experiment 
                        was not designed to account for interactions and they are confounded
                        with first order effects. We therefore limited the model to first order effects
                        for source and price. As the AIC and the deviance indicate, the model
                        leaves much variation unexplained, but confirms some prior observations.
                        Both source and price are significant, with the likelihood of purchase 
                        dropping as expected for a product with a negative price elasticity.  
                        From the model, the decrease was 13%  (770 basis points) lower from 
                        basis for an increase of $100.  However, a caveat
                        here is that the experiment examined only two prices, which may mask
                        nonlinearity in the response.
                        The model also confirms the proportion test for source, with Google Adwords
                        (not shown but implied) as the known source with the highest likelihood of booking a trip,
                        followed by Facebook and Other (presumed known) though the difference was not significant.
                        We will not discuss Other further because of the minimal traffic from those sites.
                        From the model the likelihood of purchase
                        for a Facebook referral is 8% lower (450 basis points) the $299 price, 
                        though that understates the effect seen experimentally. Notably, the
                        Unknown sources trended with the highest likelihood of purchase, thus confirming the
                        importance of learning the sources of those referrals. Finally, because this was a linear
                        model with no interactions, Device was no longer significant.')
                     ,verbatimTextOutput('prntmodel')
                     ,p('The logistic regression model shows an AUROC of
                        57.33%, little better than chance. The model had a sensitivity of
                        15.2%, and a specificity of 89.8%.  Though there was much variation unexplained,
                        the effects from price and referral source remain significant and should be exploited.')
                )
            ,tabItem(tabName = "Recommendations",
                     h1('Recommendations for future action')
                     ,h4('Recap of economic and purchasing decision analysis')
                     ,p('We have examined the economic outcome of a price increase
                        of a leisure activity and developed a price elasticity of demand relationship
                        (see Purchasing Analysis.)  Our model predicts a 13% decrease in 
                        likelihood of purchase as the price
                        increased $100, comparable to the 22% drop observed experimentally.  
                        However, the reduced likelihood of purchase was more than
                        compensated by the increase in revenue from the higher price.
                        Similarly, the increase in likelihood of purchase
                        in coming from Adwords instead of Facebook trends 8% higher at the $299 price.')
                     ,h4('Recommendations')
                        ,p('We recommend moving the price to $299 for the activity since this increased
                        both revenue and gross profit with only a moderate decrease in
                        quantity sold.  We also recommend further experimentation
                        to learn if there is still price elasticity at higher prices and therefore
                        the potential for higher revenues and gross profits.')
                     ,p('We also recommend the following actions with respect to marketing
                        and advertising with referral sources')
                     ,tags$ul(
                         tags$li('Investigate a better means of learning the referral source
                            to the website.  The Unknown category had the highest
                            propensity to purchase, yet it is not exploitable for further optimization.')
                         ,tags$li('Steer more visitors from Google Adwords/Ads through actions
                            such as further research and purchase of search terms funded by reallocation of 
                            funds going to souces such as Bing since it referred relatively few visitors.  An increase of 10,000
                            visitors from Adwords compared to Facebook could mean an extra 40 purchases
                            at $299 each for a total increase in revenues of nearly $12,000.')
                     )
                )
            )
        )
    )
)