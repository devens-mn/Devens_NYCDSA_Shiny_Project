library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(tidyverse)

# read in data (works for now)
promo = read_csv('../promo_results.csv', col_names = TRUE)
user = read_csv('../user_data.csv', col_names = TRUE)

# clean data, since this won't change across uses
promo$date = mdy(promo$date) #change date format to date, in case I need it
promo$day = wday(promo$date) #select just day to get the daily dependence
promo$month = month(promo$date) #select just month to get monthly dependence

# create column to be able to filter out date nas. colsums(is.na()) showed dates
# was only column with NAs.  Want to keep for other analyses
promo$nas = is.na(promo$date)

# calculate revenue for each transaction
promo$revenue = promo$price * promo$booked

# create lists of things to analyze and things to analyze by
qtys_to_analyze = c('revenue', 'book_pct', 'number_bookings')
var_to_analyze_by = colnames(promo)[c(3,4,9)]





