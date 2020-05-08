library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(tidyverse)

# read in data (works for now)
promo = read_csv('../promo_results.csv', col_names = TRUE)
user = read_csv('../user_data.csv', col_names = TRUE)

# format dates in promo data
promo$date = mdy(promo$date) #change date format to date, in case I need it
promo$day = as.character(wday(promo$date)) #select just day to get the daily dependence
promo$month = as.character(month(promo$date)) #select just month to get monthly dependence

# create filter for missing dates in promo
promo$nas = is.na(promo$date)

# create filter for missing states in user
user$statena = is.na(user$state)

# outer join of promo and user on user_id
usepromo = full_join(promo, user, by = 'user_id')

# calculate revenue for each transaction
usepromo$revenue = usepromo$price * usepromo$booked

# filter out nas for date and state
usepromo = usepromo %>% filter(., !nas & !statena)

# create lists of things to analyze and things to analyze by
# qtys_to_analyze = c('revenue', 'book_pct', 'number_bookings')
vsts_var_to_analyze_by = colnames(usepromo)[c(3,4,9,12)]
rev_var_to_analyze_by = colnames(usepromo)[c(3,4,9,12)]
bk_var_to_analyze_by = colnames(usepromo)[c(3,4,9,12)]

# logistic regression model
# create factors from current integer(days) or character variables
usepromo$source = as.factor(usepromo$source)
usepromo$device = as.factor(usepromo$device)
usepromo$day = as.factor(usepromo$day)
usepromo$state = as.factor(usepromo$state)

# identify rows with ones, other set with zeros
input_ones <- usepromo[which(usepromo$booked == 1), ] 
input_zeros <- usepromo[which(usepromo$booked == 0), ] 

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
logitmodeltest = glm(booked ~ source + price, 
                     data = trainingData, family = 'binomial'(link = 'logit'))



