# create days and month
library(lubridate)
# convert string to date
promo$date = mdy(promo$date)

# convert to day and month
promo$day = wday(promo$date)
promo$month = month(promo$date)

# calculate revenue for each transaction
promo$revenue = promo$price * promo$booked

# drop rows with nas in date
promo$nas = is.na(promo$date)

# get sum for just those with dates, note use of negation (!)
promo %>% filter(., !promo$nas) %>%  group_by(., day, price) %>% 
    summarise(., revsum = sum(revenue))

# df too big to plot (?) convert line above to promodys
ggplot(promodys, aes(x=day, y=revsum)) + geom_col(aes(fill = as.character(price)),
                    position = 'dodge')

# convert to month
promomos = promo %>% filter(., !promo$nas) %>%  group_by(., month, price) %>% 
  summarise(., revsum = sum(revenue))
ggplot(promomos, aes(x=promomos$month, y=revsum)) + geom_col(aes(fill = 
                as.character(price)), position = 'dodge')

# getting booking percentage by day of week and price
promopct = promo %>% filter(., !promo$nas) %>% group_by(., price, day) %>% 
                summarise(., winpct = sum(booked)/n())
ggplot(promopct, aes(x = day, y = winpct)) + geom_col(aes(fill = 
                  as.character(price)), position = 'dodge')

# winpct by test.  turns out 'test' means trying out 299 price
promo %>% filter(., !nas) %>% group_by(., test, price) %>% summarise(., 
                  winpct = sum(booked)/n(), sum(booked), n())

# effect of social media source straight to plot works
promo %>% group_by(., source, price) %>% summarise(., 
                  winpct = sum(booked)/n(), sum(booked), n())
promo %>% group_by(., source, price) %>% summarise(.,winpct = sum(booked)/n(), 
                  sum(booked), n())%>% ggplot(., aes(x = source, y = winpct)) + 
                  geom_col(aes(fill = as.character(price)), position = 'dodge') 
                  + coord_flip()

# effect of device on which viewed, plot worked
promo %>% group_by(., device, price) %>% summarise(., winpct = sum(booked)/n(),
                  sum(booked), n())
promo %>% group_by(., device, price) %>% summarise(., winpct = sum(booked)/n(),
                  sum(booked), n()) %>% ggplot(., aes(x = device, y = winpct)) 
                  + geom_col(aes(fill = as.character(price)), position = 'dodge')

# adding number to the bar plot of sources (and elsewhere)
g = promo %>% group_by(., source) %>% summarise(.,winpct = sum(booked)/n(),
            sum(booked), novsts = n()/1600000)
ggplot(g) + geom_col(aes(x = source, y = winpct)) + geom_point(aes(x = source, 
            y = novsts)) + scale_y_continuous(name = 'WinPct', 
            sec.axis = sec_axis(~.*1600000, name = 'no visits')) + coord_flip()
            + theme_classic()







