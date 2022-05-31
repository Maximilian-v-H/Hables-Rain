#!/bin/Rscript
library("doParallel")
library("R.utils")
library("dplyr")
library("plyr")
library("ggplot2")
library("dplyr")
library("broom")
library("ggpubr")
library("Amelia")
library("mlbench")
library("corrplot")
library('ANN2')
library('randomForest')
library('tree')
library('caret')
library('party')

df <- read.csv("./data/weatherAUS.csv", header = TRUE, sep = ",", fill = TRUE)

n <- length(df[,1]) 
index <- sample(1:n,n,replace=FALSE) 
df <- df[index,]

df[1:10,]

df[, "Date"] <- as.Date(df[, "Date"])
df[, "Location"] <- as.factor(df[, "Location"])
df[, "WindGustDir"] <- as.factor(df[, "WindGustDir"])
df[, "WindDir9am"] <- as.factor(df[, "WindDir9am"])
df[, "WindDir3pm"] <- as.factor(df[, "WindDir3pm"])
df[, "RainToday"] <- as.factor(df[, "RainToday"])
df[, "RainTomorrow"] <- as.factor(df [, "RainTomorrow"])
df["Cloud9am"][df["Cloud9am"] == 9] <- 8
df["Cloud3pm"][df["Cloud3pm"] == 9] <- 8


# # Deskriptive Analyse

parameters <- names(select_if(df, is.numeric))

dfmin <- subset(df, !is.na(df$RainToday) & !is.na(df$RainTomorrow))

for (x in parameters) {
  dfmin[x][is.na(dfmin[x])] <- mean(dfmin[, x], na.rm = TRUE)
}

levels(dfmin$WindGustDir) <- c(levels(dfmin$WindGustDir), "NOWIND")
levels(dfmin$WindDir9am) <- c(levels(dfmin$WindDir9am), "NOWIND")
levels(dfmin$WindDir3pm) <- c(levels(dfmin$WindDir3pm), "NOWIND")

dfmin$WindGustDir[is.na(dfmin[,"WindGustDir"])] <- "NOWIND"
dfmin$WindDir9am[is.na(dfmin[,"WindDir9am"])] <- "NOWIND"
dfmin$WindDir3pm[is.na(dfmin[,"WindDir3pm"])] <- "NOWIND"
dfmin$WindDir3pm

#Maschinelles Lernen versch. Verfahren


### Daten splitten in Test- und Trainingsdatensätze

## 75% of the sample size
smp_size <- floor(0.75 * nrow(dfmin))  ## set the seed to make your partition reproducible 
set.seed(123) 
train_ind <- sample(seq_len(nrow(dfmin)), size = smp_size)  
train <- dfmin[train_ind, ] 
test <- dfmin[-train_ind, ]

train[train$RainTomorrow %in% c("NaN", "NA", "Inf"), ]
summary(train)


x_names = c("Date", 
            "Location", 
            "MinTemp", 
            "MaxTemp", 
            "Rainfall", 
            "Evaporation", 
            "Sunshine", 
            "WindGustDir", 
            "WindGustSpeed", 
            "WindDir9am", 
            "WindDir3pm", 
            "WindSpeed9am", 
            "WindSpeed3pm", 
            "Humidity9am", 
            "Humidity3pm", 
            "Pressure9am", 
            "Pressure3pm", 
            "Cloud9am", 
            "Cloud3pm", 
            "Temp9am", 
            "Temp3pm", 
            "RainToday")
y_names = c("RainTomorrow")

################################ DECISION TREE ################################################

tutData <- train[, !names(train) %in% c("Location","RainToday","Date","WindGustDir","WindDir9am","WindDir3pm")]
dateLess <- test[, !names(test) %in% c("Date")]
nohum <- train[, !names(train) %in% c("Date","Humidity9am","Humidity3pm","Pressure3pm", "Pressure9am","Cloud9am", "Cloud3pm")]
tre <- ctree(RainTomorrow ~ ., data = nohum)
png("nohum.png", res=35, height=1000, width=32767)
plot(tre)
dev.off()

pred <- predict(tre, test)
tPred <- table(pred, test$RainTomorrow)
acc <- (tPred[1,1] + tPred[2,2]) / sum(tPred)


rf.cv <- rfcv(trainx = test[, x_names], trainy = test[, y_names], cv.fold = 2, do.trace=TRUE)
summary(rf.cv)
rf.cv$error.cv
