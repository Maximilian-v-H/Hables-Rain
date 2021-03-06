#!/bin/Rscript
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

df <- read.csv("./data/weatherAUS.csv", header = TRUE, sep = ",", fill = TRUE)

n <- length(df[,1]) 
index <- sample(1:n,n,replace=FALSE) 
df <- df[index,]

df[, "Date"] <- as.Date(df[, "Date"])
df[, "Location"] <- as.factor(df[, "Location"])
df[, "WindGustDir"] <- as.factor(df[, "WindGustDir"])
df[, "WindDir9am"] <- as.factor(df[, "WindDir9am"])
df[, "WindDir3pm"] <- as.factor(df[, "WindDir3pm"])
df[, "RainToday"] <- as.factor(df[, "RainToday"])
df[, "RainTomorrow"] <- as.factor(df [, "RainTomorrow"])

missmap(df, col = c("blue", "red"), main = "1. Nominale Daten", legend = FALSE)
# summary(df)

df["Cloud9am"][df["Cloud9am"] == 9] <- 8
df["Cloud3pm"][df["Cloud3pm"] == 9] <- 8

missmap(df, col = c("blue", "red"), main = "2. Wolkenbegrenzung", legend = FALSE)


dfmin <- subset(df, !is.na(df$RainToday) & !is.na(df$RainTomorrow))
missmap(dfmin, col = c("blue", "red"), main = "3. RainToday und RainTomorrow", legend = FALSE)

parameters <- names(select_if(df,is.numeric))


for (x in parameters) {
  dfmin[x][is.na(dfmin[x])] <- mean(dfmin[, x], na.rm = TRUE)
}
missmap(dfmin, col = c("blue", "red"), main = "4. Mittelwert der numerischen Daten", legend = FALSE)

levels(dfmin$WindGustDir)
levels(dfmin$WindDir3pm)
levels(dfmin$WindDir9am)
levels(dfmin$WindGustDir) <- c(levels(dfmin$WindGustDir), "NOWIND")
levels(dfmin$WindDir9am) <- c(levels(dfmin$WindDir9am), "NOWIND")
levels(dfmin$WindDir3pm) <- c(levels(dfmin$WindDir3pm), "NOWIND")

levels(dfmin$WindGustDir)
levels(dfmin$WindDir3pm)
levels(dfmin$WindDir9am)
dfmin$WindGustDir[is.na(dfmin[,"WindGustDir"])] <- "NOWIND"
dfmin$WindDir9am[is.na(dfmin[,"WindDir9am"])] <- "NOWIND"
dfmin$WindDir3pm[is.na(dfmin[,"WindDir3pm"])] <- "NOWIND"
missmap(dfmin, col = c("blue", "red"), main = "5. NOWIND eingesetzt", legend = FALSE)


# # Deskriptive Analyse

parameters <- names(select_if(df, is.numeric))

for (x in parameters) {
  printf("Mean(%s): %f\n", x, mean(df[, x], na.rm = TRUE))
  printf("Median(%s): %f\n", x, median(df[, x], na.rm = TRUE))
  printf("Standard deviation(%s): %f\n\n", x, sd(df[, x], na.rm = TRUE))
}


# correlations <- cor(select_if(df[,1:23],is.numeric), use="pairwise.complete.obs")
# corrplot(correlations, method="circle")


summary(dfmin)
length(df[,1])
length(dfmin[,1])
# dfmin$WindDir3pm

missmap(dfmin, col=c("blue", "red"), legend=FALSE)

correlations <- cor(select_if(dfmin[,1:23],is.numeric), use="pairwise.complete.obs")
corrplot(correlations, method="circle")

correlations <- cor(select_if(df[,1:23],is.numeric), use="pairwise.complete.obs")
corrplot(correlations, method="circle")

#Maschinelles Lernen versch. Verfahren


### Daten splitten in Test- und Trainingsdatens??tze

## 75% of the sample size
# smp_size <- floor(0.95 * nrow(dfmin))  ## set the seed to make your partition reproducible 
# set.seed(123) 
# train_ind <- sample(seq_len(nrow(dfmin)), size = smp_size)  
# train <- dfmin[train_ind, ] 
# test <- dfmin[-train_ind, ]
# 
# train[train$RainTomorrow %in% c("NaN", "NA", "Inf"), ]
# summary(train)

### Lineare Regression

# model <- glm(RainTomorrow~Date+Location+MinTemp+MaxTemp+Rainfall+Evaporation+Sunshine+WindGustDir+WindGustSpeed+WindDir9am+WindDir3pm+WindSpeed9am+WindSpeed3pm+Humidity9am+Humidity3pm+Pressure9am+Pressure3pm+Cloud9am+Cloud3pm+Temp9am+Temp3pm+RainToday, data = train, family = binomial)
# print(model)
# 
# summary(model)
# 
# glm.probs <- predict(model, newdata = test, type = "response")
# glm.probs[1:5]
# 
# glm.pred <- ifelse(glm.probs > 0.5, "Yes", "No")
# 
# test.RainTomorrow = test$RainTomorrow
# table(glm.pred,test.RainTomorrow)
# 
# mean(glm.pred == test.RainTomorrow)

### Neuronales Netz

# x_names = c("Date", 
#             "Location", 
#             "MinTemp", 
#             "MaxTemp", 
#             "Rainfall", 
#             "Evaporation", 
#             "Sunshine", 
#             "WindGustDir", 
#             "WindGustSpeed", 
#             "WindDir9am", 
#             "WindDir3pm", 
#             "WindSpeed9am", 
#             "WindSpeed3pm", 
#             "Humidity9am", 
#             "Humidity3pm", 
#             "Pressure9am", 
#             "Pressure3pm", 
#             "Cloud9am", 
#             "Cloud3pm", 
#             "Temp9am", 
#             "Temp3pm", 
#             "RainToday")
# y_names = c("RainTomorrow")
# 
# neural_net <- function(
#   data,
#   x_rel,
#   y_rel,
#   hiddenlayers = c(4, 3),
#   regression = FALSE,
#   losstype = "log",
#   learnrates = 1e-04,
#   nepochs = 1,
#   verbose = TRUE
# ) {
#   x <- model.matrix(
#     gen_model(x_rel, y_rel),
#     c(data[x_rel], data[y_rel])
#   )
#   x <- x[, -1]   # entferne den Intercept
#   y <- as.factor(data[, y_rel])
#   model <- neuralnetwork(
#     x,
#     y,
#     hidden.layers = hiddenlayers,
#     regression = regression,
#     loss.type = losstype,
#     learn.rates = learnrates,
#     n.epochs = nepochs,
#     verbose = verbose
#   )
#   return(model)
# }
# 
# prep <- function(data, x_rel, y_rel) {
#   x <- model.matrix(
#     gen_model(x_rel, y_rel),
#     c(data[x_rel], data[y_rel])
#   )
#   x <- x[, -1]   # entferne den Intercept
#   y <- as.factor(data[, y_rel])
#   return(c(x = x, y = y))
# }
# 
# gen_model <- function(params, y) {
#   return(as.formula(paste(paste(y, " ~ "), paste(params, collapse = " + "))))
# }
# 
# # nn1 <- neural_net(train, x_names, y_names, hiddenlayers = c(2))
# # nn1
# # p <- prep(test, x_names, y_names)
# # prognosen <- predict(nn1, p["x"])$predictions
# # mean(abs(prognosen - p["y"]))
# 
# model1 <- randomForest(RainTomorrow ~ ., data = test, importance = TRUE)
# plot(model1)
