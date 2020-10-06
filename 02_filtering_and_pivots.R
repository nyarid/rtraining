# load packages
library(dplyr)
library(data.table)
library(ggplot2)

## install the nycflights13 package

install.packages("nycflights13")
library(nycflights13)

### load in the dataset

data <- copy(flights) %>% data.table()


## check columns and head


## 1: maximum delay accumulated in air

## relevant columns are arr_delay and dep_delay

## 2: list the origin - destination pairs in order of popularity

## relevant columns are origin and dest

## 3: calculate the average air time by origin destination pairs

## column air_time

## 4: calculate average delay per airline, and the number of flights

## 5: calculate the number of cancelled flights per origin airport

## 6: calculate the average speed distance/air_time per airline

## 7: find all flights that flew within a 1000 km and and the arrival delay was between 10 minutes and 1 hour

## 8: find the tail number of all flights that were supposed to arrive in 2013 but only arrived in 2014
