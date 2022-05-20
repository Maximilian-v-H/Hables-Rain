#########################################################
# 1. Unnötigen Code schreiben

# date <- as.Date(df[, "Date"])
# location <- (df[, "Location"])
# minTemp <- (df[, "MinTemp"])
# maxTemp <- (df[, "MaxTemp"])
# rain <- (df[,  "Rainfall"])
# evaporation <- (df[, "Evaporation"])
# sunshine <- (df[, "Sunshine"])
# WindGustDirection <- as.factor(df[, "WindGustDir"])
# WindGustSpeed <-  (df[, "WindGustSpeed"])
# Wind9Direction <- as.factor(df[, "WindDir9am"])
# Wind9Speed <- (df[, "WindSpeed9am"])
# Wind3Direction <- as.factor(df[, "WindDir3pm"])
# Wind3Speed <- (df[, "WindSpeed3pm"])
# Humidity9 <- (df[, "Humidity9am"])
# Humidity3 <- (df[, "Humidity3pm"])
# Pressure9 <- (df[, "Pressure9am"])
# Pressure3 <- (df[, "Pressure3pm"])
# Cloud9 <- (df[, "Cloud9am"]) #Convert 9 to 8
# Cloud3 <- (df[, "Cloud3pm"]) #Convert 9 to 8
# Temp9 <- (df[, "Temp9am"])
# Temp3 <- (df[, "Temp3pm"])
# RainToday <- as.factor(df[, "RainToday"])
# RainTomorrow <- as.factor(df [, "RainTomorrow"])

library("R.utils")
library("dplyr")
df <- read.csv("./data/weatherAUS.csv", header = TRUE, sep = ",", fill = TRUE)

####### DATEN EINLESEN #############

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

summary(df)

###### DESKRIPTIVE DATEN ANALYSE #########

# Metrics

parameters <- names(select_if(df, is.numeric))

for (x in parameters) {
  printf("Mean(%s): %f\n", x, mean(df[, x], na.rm = TRUE))
  printf("Median(%s): %f\n", x, median(df[, x], na.rm = TRUE))
  printf("Standard deviation(%s): %f\n\n", x, sd(df[, x], na.rm = TRUE))S
}

# Graphical
par(mfrow=c(4,4))
for (x in parameters) {
  boxplot(df[, x],main=x)
}

