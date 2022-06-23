#!/bin/Rscript
## LIBRARIES
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
library("ANN2")
library("randomForest")
library("doParallel")
library("tree")
library("caret")
library("party")


## DATA CLEANING

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

missmap(df, col = c("blue", "red"), main = "1. Nominale Daten", legend = FALSE)

df["Cloud9am"][df["Cloud9am"] == 9] <- 8
df["Cloud3pm"][df["Cloud3pm"] == 9] <- 8

missmap(df, col = c("blue", "red"), main = "2. Wolkenbegrenzung", legend = FALSE)

dfmin <- subset(df, !is.na(df$RainToday) & !is.na(df$RainTomorrow))
missmap(dfmin, col = c("blue", "red"), main = "3. RainToday und RainTomorrow", legend = FALSE)

parameters <- names(select_if(df, is.numeric))

for (x in parameters) {
  dfmin[x][is.na(dfmin[x])] <- mean(dfmin[, x], na.rm = TRUE)
}
missmap(dfmin, col = c("blue", "red"), main = "4. Mittelwert der numerischen Daten", legend = FALSE)

levels(dfmin$WindGustDir) <- c(levels(dfmin$WindGustDir), "NOWIND")
levels(dfmin$WindDir9am) <- c(levels(dfmin$WindDir9am), "NOWIND")
levels(dfmin$WindDir3pm) <- c(levels(dfmin$WindDir3pm), "NOWIND")

dfmin$WindGustDir[is.na(dfmin[, "WindGustDir"])] <- "NOWIND"
dfmin$WindDir9am[is.na(dfmin[, "WindDir9am"])] <- "NOWIND"
dfmin$WindDir3pm[is.na(dfmin[, "WindDir3pm"])] <- "NOWIND"
missmap(dfmin, col = c("blue", "red"), main = "5. NOWIND eingesetzt", legend = FALSE)


## DESCRIPTIVE ANALYSIS


parameters <- names(select_if(df, is.numeric))

for (x in parameters) {
  printf("Mean(%s): %f\n", x, mean(df[, x], na.rm = TRUE))
  printf("Median(%s): %f\n", x, median(df[, x], na.rm = TRUE))
  printf("Standard deviation(%s): %f\n\n", x, sd(df[, x], na.rm = TRUE))
}

## NOMINAL DATA
da <- sapply(dfmin, class)
d <- as.data.frame(da)[, 1]
er <- aggregate(d, list(value = da), length)

pie(er$x, labels = er$value)

## CLOUD
cloud <- df
cloud[is.na(cloud)] <- 10
ggplot(as.data.frame(cloud), aes(x = Cloud9am)) +
  ggtitle("Wolken um 9am") +
  xlab("Achtel des Himmels") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
                   labels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "NaN")) +
theme_minimal()
ggplot(as.data.frame(cloud), aes(x = Cloud3pm)) +
  ggtitle("Wolken um 3pm") +
  xlab("Achtel des Himmels") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
                   labels = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "NaN")) +
theme_minimal()
ggplot(as.data.frame(dfmin), aes(x = Cloud9am)) +
  ggtitle("Wolken um 9am") +
  xlab("Achtel des Himmels") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = c(0, 1, 2, 3, 4, 5, 6, 7, 8),
                   labels = c(0, 1, 2, 3, 4, 5, 6, 7, 8)) +
theme_minimal()
ggplot(as.data.frame(dfmin), aes(x = Cloud3pm)) +
  ggtitle("Wolken um 3pm") +
  xlab("Achtel des Himmels") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = c(0, 1, 2, 3, 4, 5, 6, 7, 8),
                   labels = c(0, 1, 2, 3, 4, 5, 6, 7, 8)) +
theme_minimal()

## Rain today / tomorrow

rain <- df
rain[is.na(james)] <- "Vielleicht"

options(scipen = 999)
ggplot(as.data.frame(rain), aes(x = RainToday)) +
  ggtitle("Regen Heute") +
  xlab("Hat es geregnet?") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = unique(james$RainToday),
                   labels = c("Nein", "Ja", "NaN")) +
theme_minimal()
ggplot(as.data.frame(rain), aes(x = RainTomorrow)) +
  ggtitle("Regen Morgen") +
  xlab("Hat es geregnet?") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = unique(james$RainTomorrow),
                   labels = c("Nein", "Ja", "NaN")) +
theme_minimal()
ggplot(as.data.frame(dfmin), aes(x = RainToday)) +
  ggtitle("Regen Heute") +
  xlab("Hat es geregnet?") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = unique(dfmin$RainToday),
                   labels = c("Nein", "Ja")) +
theme_minimal()
ggplot(as.data.frame(dfmin), aes(x = RainTomorrow)) +
  ggtitle("Regen Morgen") +
  xlab("Hat es geregnet?") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = unique(dfmin$RainTomorrow),
                   labels = c("Nein", "Ja")) +
theme_minimal()

## NOWIND

wind <- aggregate(dfmin$WindGustDir, list(value = dfmin$WindGustDir), length)
ggplot(as.data.frame(dfmin), aes(x = WindGustDir)) +
  ggtitle("Windböhen Geschwindigkeit") +
  xlab("Windrichtung") +
  ylab("Frequency") +
  geom_bar(fill = "steelblue") +
  scale_x_discrete(limits = wind$value,
                   labels = wind$value) +
theme_minimal() +
theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

## EVAPORATION

ggplot(as.data.frame(dfmin), aes(x = Evaporation)) +
  ggtitle("Verdunstung") +
  xlab("Verdunstet in mm") +
  ylab("Häufigkeit") +
  geom_bar(fill = "steelblue") +
  scale_y_log10() +
  theme_minimal()

## WINDGUST

gust <- aggregate(
                  dfmin$WindGustSpeed,
                  list(value = dfmin$WindGustSpeed),
                  length
)
options(scipen = 999)
ggplot(as.data.frame(gust), aes(x = value, y = x)) +
  ggtitle("Windböhengeschwindigkeit") +
  xlab("Geschwindigkeit in km/h") +
  ylab("Häufigkeit") +
  geom_line(color = "steelblue") +
  theme_minimal()


## WINDSPEED

options(scipen = 999)

windspeed <- aggregate(
                       dfmin$WindSpeed9am,
                       list(value = dfmin$WindSpeed9am),
                       length
)
ggplot(as.data.frame(windspeed), aes(x = value, y = x)) +
  ggtitle("Windgeschwindigkeit um 9am") +
  xlab("Geschwindigkeit in km/h") +
  ylab("Häufigkeit") +
  geom_line(color = "steelblue") +
  theme_minimal()
windspeedlate <- aggregate(
                           dfmin$WindSpeed3pm,
                           list(value = dfmin$WindSpeed3pm),
                           length
)
ggplot(as.data.frame(windspeedlate), aes(x = value, y = x)) +
  ggtitle("Windgeschwindigkeit um 3pm") +
  xlab("Geschwindigkeit in km/h") +
  ylab("Häufigkeit") +
  geom_line(color = "steelblue") +
  theme_minimal()

## PRESSURE

pressure <- aggregate(
                      dfmin$Pressure9am,
                      list(value = dfmin$Pressure9am),
                      length
)
ggplot(as.data.frame(pressure), aes(x = value, y = x)) +
  ggtitle("Luftdruck um 9am") +
  xlab("Druck in hPa") +
  ylab("Häufigkeit") +
  scale_y_log10() +
  geom_area(fill = "steelblue", alpha = 0.6) +
  geom_line(color = "steelblue") +
  theme_minimal()

pressurelate <- aggregate(
                          dfmin$Pressure3pm,
                          list(value = dfmin$Pressure3pm),
                          length
)
ggplot(as.data.frame(pressurelate), aes(x = value, y = x)) +
  ggtitle("Luftdruck um 3pm") +
  xlab("Druck in hPa") +
  ylab("Häufigkeit") +
  scale_y_log10() +
  geom_area(fill = "steelblue", alpha = 0.6) +
  geom_line(color = "steelblue") +
  theme_minimal()

## RAINFALL

ggplot(as.data.frame(dfmin), aes(x = Rainfall)) +
  ggtitle("Regenfall") +
  xlab("Regen in mm") +
  ylab("Häufigkeit") +
  scale_x_log10() +
  geom_bar(fill = "steelblue", width = 0.1) +
  theme_minimal()




####### MACHINE LEARNING METHODS
## PREPARATION
smp_size <- floor(0.75 * nrow(dfmin))
set.seed(123)
train_ind <- sample(seq_len(nrow(dfmin)), size = smp_size)
train <- dfmin[train_ind, ]
test <- dfmin[-train_ind, ]

## LOGISTIC REGRESSION

model <- glm(
             RainTomorrow~
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
               RainToday, data = train, family = binomial)

summary(model)

glm_probs <- predict(model, newdata = test, type = "response")
glm_probs[1:5]

glm_pred <- ifelse(glm.probs > 0.5, "Yes", "No")

test_raintomorrow <- test$RainTomorrow
table(glm_pred, test_raintomorrow)

mean(glm_pred == test_raintomorrow)

## NEURAL NETWORK

## RANDOM FOREST

x_names <- c("Date",
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
y_names <- c("RainTomorrow")

tut_data <- train[, !names(train) %in% c("Location", "RainToday", "Date", "WindGustDir", "WindDir9am", "WindDir3pm")]
date_less <- test[, !names(test) %in% c("Date")]
nohum <- train[, !names(train) %in% c("Date", "Humidity9am", "Humidity3pm", "Pressure3pm", "Pressure9am", "Cloud9am", "Cloud3pm")]
tre <- ctree(RainTomorrow ~ ., data = nohum)
png("nohum.png", res = 35, height = 1000, width = 32767)
plot(tre)
dev.off()

pred <- predict(tre, test)
t_pred <- table(pred, test$RainTomorrow)
acc <- (t_pred[1, 1] + t_pred[2, 2]) / sum(t_pred)


rf_cv <- rfcv(trainx = test[, x_names], trainy = test[, y_names], cv.fold = 2, do.trace = TRUE)
summary(rf_cv)
rf_cv$error.cv
