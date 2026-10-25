# 05_sliding_correlation.R
# 计算 VPD 与各层土壤水分干旱指数的滑动相关

library(dplyr)
library(slider)

met <- readRDS("data/processed/met_drought.rds")

window <- 15
half_window <- (window - 1) / 2

cor_dat <- met %>%
  arrange(date) %>%
  mutate(
    across(
      c(SM1_drought, SM2_drought, SM3_drought, SM4_drought),
      \(sm) slide2_dbl(
        VPD_drought, sm,
        \(vpd, sm) cor(vpd, sm),
        .before = half_window,
        .after = half_window,
        .complete = TRUE
      ),
      .names = "cor_{.col}"
    )
  )

cor_dat %>%
  select(date, starts_with("cor_")) %>%
  summary()

saveRDS(cor_dat, "data/processed/cor_dat.rds")