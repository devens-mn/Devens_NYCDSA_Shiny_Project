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

# figure out logistic regression
# clean out nas to make the model cleaner
cleanpromo = promo %>% filter(., !nas)

# join user data to clean promo and call it userclean
userclean = full_join(cleanpromo, user, by = "user_id")
summary(userclean)

# count to figure out if some levels of factors didn't get same number of 0s
xtabs(~ book + day, userclean) # 1s equally distributed
xtabs(~ booked + day, userclean) # 1s equally distributed
xtabs(~ booked + month, userclean) #not enough books in March, July
xtabs(~ booked + state, userclean)

# convert characters to factors
userclean$source = as.factor(userclean$source)
userclean$device = as.factor(userclean$device)
userclean$day = as.factor(userclean$day)
userclean$state = as.factor(userclean$state)
str(userclean) # confirm that we got factors where we wanted
summary(userclean)

# clean NAs from states
userclean$statenas = is.na(userclean$state)
userclean = userclean %>% filter(., !statenas)
summary(userclean)

# identify rows with ones, other set with zeros
input_ones <- userclean[which(userclean$booked == 1), ] 
input_zeros <- userclean[which(userclean$booked == 0), ] 

# sample row numbers from 1 rows and 0 rows
set.seed(1)
input_ones_training_rows = sample(1:nrow(input_ones), 0.5*nrow(input_ones))
input_zeros_training_rows = sample(1:nrow(input_zeros), 0.5*nrow(input_ones))

# use those rows to create training matrix for 1s and 0s
training_ones = input_ones[input_ones_training_rows, ] 
training_zeros = input_zeros[input_zeros_training_rows, ] 
trainingData = rbind(training_ones, training_zeros) 

# create test data from data not sampled into test
test_ones = input_ones[-input_ones_training_rows, ]
test_zeros = input_zeros[-input_zeros_training_rows, ]
testData = rbind(test_ones, test_zeros)

#create logistic model
logitmodeltest = glm(booked ~ source + device + price + day + state, 
          data = trainingData, family = 'binomial'(link = 'logit'))
summary(logitmodeltest)

# got rid of day and device, since they weren't significant
logitmodeltest2 = glm(booked ~ source + price, data = 
          trainingData, family = 'binomial'(link = 'logit'))
summary(logitmodeltest2)

# check VIF, I think need to load InformationValue
vif(logitmodeltest2)

# test model on test data, create vector of 'predicted'
predicted = plogis(predict(logitmodeltest2, testData)) 
summary(predicted)

# set optimal cutoff value for deciding whether a prob is a 1 or 0
optCutOff = optimalCutoff(testData$booked, predicted)[1]

# misclassification
misClassError(testData$booked, predicted, threshold = optCutOff)

# ROC plot
plotROC(testData$booked, predicted)

# concordance
Concordance(testData$booked, predicted)

# sensitivity and specificity
sensitivity(testData$booked, predicted, threshold = optCutOff)
specificity(testData$booked, predicted, threshold = optCutOff)

# confusion matrix, columns are actuals and rows are predicted
confusionMatrix(testData$booked, predicted, threshold = optCutOff)


