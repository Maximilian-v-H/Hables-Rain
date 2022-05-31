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
library("neuralnet")

df <- read.csv("./data/weatherAUS.csv", header = TRUE, sep = ",", fill = TRUE)

n <- length(df[, 1])
index <- sample(1:n, n, replace = FALSE)
df <- df[index, ]

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

parameters <- names(select_if(df, is.numeric))

dfmin <- subset(df, !is.na(df$RainToday) & !is.na(df$RainTomorrow))

for (x in parameters) {
  dfmin[x][is.na(dfmin[x])] <- mean(dfmin[, x], na.rm = TRUE)
}

levels(dfmin$WindGustDir) <- c(levels(dfmin$WindGustDir), "NOWIND")
levels(dfmin$WindDir9am) <- c(levels(dfmin$WindDir9am), "NOWIND")
levels(dfmin$WindDir3pm) <- c(levels(dfmin$WindDir3pm), "NOWIND")

dfmin$WindGustDir[is.na(dfmin[, "WindGustDir"])] <- "NOWIND"
dfmin$WindDir9am[is.na(dfmin[, "WindDir9am"])] <- "NOWIND"
dfmin$WindDir3pm[is.na(dfmin[, "WindDir3pm"])] <- "NOWIND"

set.seed(450)
cv_error <- NULL
k <- 2

pbar <- create_progress_bar("text")
pbar$init(k)
dfmin[] <- sapply(dfmin, as.numeric) # keeps in the format of dataframe.
maxs <- apply(dfmin, 2, max)
mins <- apply(dfmin, 2, min)
dfmin <- as.data.frame(scale(dfmin, center = mins, scale = maxs - mins))

x_train_formular <- as.formula(
                               RainTomorrow ~
                                 Date +
                                 Location +
                                 MinTemp +
                                 MaxTemp +
                                 Rainfall +
                                 Evaporation +
                                 Sunshine +
                                 WindGustDir +
                                 WindGustSpeed +
                                 WindDir9am +
                                 WindDir3pm +
                                 WindSpeed9am +
                                 WindSpeed3pm +
                                 Humidity9am +
                                 Humidity3pm +
                                 Pressure9am +
                                 Pressure3pm +
                                 Cloud9am +
                                 Cloud3pm +
                                 Temp9am +
                                 Temp3pm +
                                 RainToday
)

for (i in 1:k) {
  smp_size <- floor(0.85 * nrow(dfmin))
  set.seed(123)
  train_ind <- sample(seq_len(nrow(dfmin)), size = smp_size)
  train <- dfmin[train_ind, ]
  test <- dfmin[-train_ind, ]


  y_train <- train[, "RainTomorrow"]
  y_test <- test[, "RainTomorrow"]

  nn <- neuralnet(x_train_formular,
                  data = train,
                  hidden = c(60, 20, 5, 2),
                  rep = 100,
                  linear.output = FALSE,
                  learningrate = 0.05
  )
  file_name <- gsub(" ", "", paste("model_", i))
  saveRDS(nn, file_name)

  pr_nn <- compute(nn, test[, 1:23])
  results <- data.frame(
                        actual = test$RainTomorrow,
                        prediction = pr_nn$net.result
  )
  roundedresults <- sapply(results, round, digits = 0)
  print(roundedresults)
  roundedresultsdf <- data.frame(roundedresults)
  attach(roundedresultsdf)
  table(actual, prediction)
  print(mean(results == y_test))

  pr_nn <- pr_nn$net.result * (
                               max(dfmin$RainTomorrow) -
                                 min(dfmin$RainTomorrow)) +
                               min(dfmin$RainTomorrow)

                             test_r <- (test$RainTomorrow) *
                               (max(dfmin$RainTomorrow) -
                                min(dfmin$RainTomorrow)) +
                               min(dfmin$RainTomorrow)

                             cv_error[i] <- sum((test_r - pr_nn)^2) / nrow(test)

                             pbar$step()
}

mean(cv_error)
cv_error
