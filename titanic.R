# load packages
library(readr)
library(dplyr)
library(data.table)
library(ggplot2)
library(caret)
library(pROC)

options(repr.plot.width = 6, repr.plot.height = 3.5, repr.plot.position = "middle")

# read data
dt <- read_csv("train.csv") %>% data.table()

# check column names

colnames(dt)

# check data

head(dt)

# lets start by dropping variables that identify observations but not necessary for modeling

dt[,c("PassengerId",
      "Name",
      "Ticket") := NULL]

# lets convert the target variable as the coefficient signs will be more intuitive

dt[,Died := ifelse(Survived == 0,1,0)]

# lets drop the original target variables

dt[,Survived := NULL]

# lets check cabins

table(dt$Pclass, dt$Cabin)

# making a meaningful variable out of the cabin variable would require
# looking into the layout of Titanic (e.g. calculating distance to the nearest life boat)
# so let's skip that for now

# lets just make instead a variable out of the first character of the cabins (basically the deck)

dt[,deck := substr(Cabin, start = 1, stop = 1)]

table(dt$Died, dt$deck)

## lets take B-E decks as it is and substitute the others

dt[!deck %in% c("B","C","D","E"), deck := "Other"]

## we should also substitute the missing values with no cabins

dt[is.na(deck), deck := "No cabin"]

## delete the cabin variable

dt[,Cabin := NULL]

## lets create some additional variables

dt[,male := ifelse(Sex == "male",1,0)]

dt[,family_size := SibSp + Parch]

dt[,c("SibSp",
      "Parch") := NULL]

## lets start with the binning of continuous variables

dt[,age_binned := cut(Age, breaks = quantile(Age, probs = seq(0,1,0.25), na.rm =T),
include.lowest = T)]

## this binning doesnt look so good, lets try manual cutpoints

dt[,age_binned := cut(Age, breaks = c(-Inf,14, 65, Inf),
include.lowest = T)]


## lets calculate the Weight of Evidence and IV for this variables

xtab <-  dt %>% group_by(bins = age_binned) %>% summarise(no_event = sum(Died,na.rm = T),
                                                    no_total_bin = n(),
                                                    no_nonevent = no_total_bin - no_event) %>% data.table()

xtab[,sum_no_event := sum(no_event,na.rm = T)]
xtab[,sum_no_nonevent:= sum(no_nonevent,na.rm = T)]

xtab[,woe := ifelse(no_nonevent == 0 | no_event == 0,0,log(((no_nonevent)/sum_no_nonevent)/
                                                                ((no_event)/sum_no_event)))]


xtab[,iv:=(((no_nonevent)/sum_no_nonevent)-((no_event)/sum_no_event))*woe]

### lets merge back the age variable

dt <- merge(dt,xtab[,.(age_binned = bins, age_woe = woe)], by = c("age_binned"), all.x = T, all.y = F)

### lets skip the other continous variable, fare cost and focus on categorical variables

dt[Pclass == 1, ses := "Upper class"]
dt[Pclass == 2, ses := "Middle class"]
dt[Pclass == 3, ses := "Lower class"]

dt[,c("Sex","Fare","Pclass","family_size","Age","age_binned") := NULL]

### lets WoE encode our categorical variables as well

colnames(dt)

head(dt)


categorical_vars <- c("Embarked","deck","ses")

### create a for cycle so we do not have to calculate the same thing for all columns

for (i in categorical_vars) {

  xtab <-  dt %>% group_by(!!quo_name(i) := !!rlang::sym(i)) %>% summarise(no_event = sum(Died,na.rm = T),
                                                      no_total_bin = n(),
                                                      no_nonevent = no_total_bin - no_event) %>% data.table()

  xtab[,sum_no_event := sum(no_event,na.rm = T)]
  xtab[,sum_no_nonevent:= sum(no_nonevent,na.rm = T)]

  xtab[,paste0(i,"_woe") := ifelse(no_nonevent == 0 | no_event == 0,0,log(((no_nonevent)/sum_no_nonevent)/
                                                                  ((no_event)/sum_no_event)))]


  ### lets merge back the age variable

 dt <- merge(dt,select(xtab,one_of(c(i,paste0(i,"_woe")))), by = i, all.x = T, all.y = F)

 dt[,paste0(i) := NULL]

}

head(dt)

## now that we have our dataset, let's create a test and a train sample

set.seed(421)

indices <- createDataPartition(y = dt$Died, p = 0.7, times = 1)

dt_train <- dt[indices$Resample1]
dt_test <- dt[-indices$Resample1]

## lets train the model on the train sample

model <- glm(data = dt_train, Died ~ ., family = "binomial")
summary(model)

## now we have our model, let's make predictions

dt_train$pd <- predict(model,dt_train, type = "response")
dt_test$pd <- predict(model,dt_test, type = "response")

## lets see how the model performs
auc(dt_train$Died, dt_train$pd)
auc(dt_test$Died, dt_test$pd)

## ROC curves

plot.roc(dt_train$Died, dt_train$pd)
plot.roc(dt_test$Died, dt_test$pd)

roc_train <- roc(dt_train$Died, dt_train$pd)
roc_test <- roc(dt_test$Died, dt_test$pd)

str(roc_train)

roc_train <- data.table(sensitivities = roc_train$sensitivities,
                        specificities = 1-roc_train$specificities,
                        sample = "train")

roc_train %>% ggplot(aes(x = specificities, y = sensitivities)) + geom_line()
