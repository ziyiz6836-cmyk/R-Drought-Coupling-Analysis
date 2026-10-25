# 02_data_clean.R
# 整理后续分析需要的数据

library(data.table)
library(dplyr)
library(lubridate)

met <- fread("data/raw/ERA5L_TWSA.csv") %>%
  mutate(date = ymd(date)) %>%
  select(date, site, SM1, SM2, SM3, SM4, VPD) %>%
  arrange(date)

gpp <- fread("data/raw/GPP_anomaly.csv") %>%
  mutate(date = ymd(date)) %>%
  select(date, site, GPP) %>%
  arrange(date)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

saveRDS(met, "data/processed/met_clean.rds")
saveRDS(gpp, "data/processed/gpp_clean.rds")