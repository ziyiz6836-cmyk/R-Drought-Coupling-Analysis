# 03_drought_index.R
# 标准化 VPD 和各层土壤水分，统一干旱方向

library(dplyr)

met <- readRDS("data/processed/met_clean.rds")

met <- met %>%
  mutate(
    VPD_drought = as.numeric(scale(VPD)),
    across(
      c(SM1, SM2, SM3, SM4),
      ~ -as.numeric(scale(.x)),
      .names = "{.col}_drought"
    )
  )

met %>%
  select(VPD_drought, SM1_drought, SM2_drought, SM3_drought, SM4_drought) %>%
  summary()

saveRDS(met, "data/processed/met_drought.rds")