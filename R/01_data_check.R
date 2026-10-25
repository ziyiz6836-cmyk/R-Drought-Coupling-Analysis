# 01_data_check.R
# 检查原始数据结构、日期、缺失值和时间间隔

library(data.table)
library(dplyr)
library(lubridate)

met <- fread("data/raw/ERA5L_TWSA.csv")
gpp <- fread("data/raw/GPP_anomaly.csv")

dim(met)
dim(gpp)

names(met)
names(gpp)

met[, date := ymd(date)]
gpp[, date := ymd(date)]

range(met$date, na.rm = TRUE)
range(gpp$date, na.rm = TRUE)

colSums(is.na(met))
colSums(is.na(gpp))

unique(met$site)
unique(gpp$site)

met %>%
  arrange(date) %>%
  mutate(dt = date - lag(date)) %>%
  count(dt)

gpp %>%
  arrange(date) %>%
  mutate(dt = date - lag(date)) %>%
  count(dt)