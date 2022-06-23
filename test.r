#!/bin/Rscript
library("R.utils")
library("dplyr")
library("Amelia")

df <- read.csv("./data/weatherAUS.csv", header = TRUE, sep = ",", fill = TRUE)

size <- 700

n <- length(df[,1])
index <- sample(1:n,n,replace=FALSE)
df <- df[index,]

png(file="./00raw.png")
missmap(df, col = c("blue", "red"), main = "0. Rohe Daten", legend = FALSE, axes=FALSE)
dev.off()

df[, "Date"] <- as.Date(df[, "Date"])
df[, "Location"] <- as.factor(df[, "Location"])
df[, "WindGustDir"] <- as.factor(df[, "WindGustDir"])
df[, "WindDir9am"] <- as.factor(df[, "WindDir9am"])
df[, "WindDir3pm"] <- as.factor(df[, "WindDir3pm"])
df[, "RainToday"] <- as.factor(df[, "RainToday"])
df[, "RainTomorrow"] <- as.factor(df [, "RainTomorrow"])

png(file="./01Nominal.png")
missmap(df, col = c("blue", "red"), main = "1. Nominale Daten", legend = FALSE)
dev.off()
# summary(df)

df["Cloud9am"][df["Cloud9am"] == 9] <- 8
df["Cloud3pm"][df["Cloud3pm"] == 9] <- 8

png(file="./02Cloud.png")
missmap(df, col = c("blue", "red"), main = "2. Wolkenbegrenzung", legend = FALSE)
dev.off()


dfmin <- subset(df, !is.na(df$RainToday) & !is.na(df$RainTomorrow))
png(file="./03Rain.png")
missmap(dfmin, col = c("blue", "red"), main = "3. RainToday und RainTomorrow", legend = FALSE)
dev.off()

parameters <- names(select_if(df,is.numeric))


for (x in parameters) {
  dfmin[x][is.na(dfmin[x])] <- mean(dfmin[, x], na.rm = FALSE)
}
png(file="./04Mean.png")
missmap(dfmin, col = c("blue", "red"), main = "4. Mittelwert der numerischen Daten", legend = FALSE)
dev.off()

levels(dfmin$WindGustDir) <- c(levels(dfmin$WindGustDir), "NOWIND")
levels(dfmin$WindDir9am) <- c(levels(dfmin$WindDir9am), "NOWIND")
levels(dfmin$WindDir3pm) <- c(levels(dfmin$WindDir3pm), "NOWIND")

dfmin$WindGustDir[is.na(dfmin[,"WindGustDir"])] <- "NOWIND"
dfmin$WindDir9am[is.na(dfmin[,"WindDir9am"])] <- "NOWIND"
dfmin$WindDir3pm[is.na(dfmin[,"WindDir3pm"])] <- "NOWIND"
png(file="./05Wind.png")
missmap(dfmin, col = c("blue", "red"), main = "5. NOWIND eingesetzt", legend = FALSE)
dev.off()
