# 07_sync_async.R
# 根据滑动相关识别同步和不同步时期

library(dplyr)
library(tidyr)

cor_dat <- readRDS("data/processed/cor_dat.rds")

sm_dat <- cor_dat %>%
  select(date, site, VPD_drought,
         SM1_drought, SM2_drought, SM3_drought, SM4_drought) %>%
  pivot_longer(
    starts_with("SM"),
    names_to = "SM",
    values_to = "SM_drought"
  )

cor_long <- cor_dat %>%
  select(date, site, starts_with("cor_SM")) %>%
  pivot_longer(
    starts_with("cor_SM"),
    names_to = "SM",
    names_prefix = "cor_",
    values_to = "cor"
  )

sync_dat <- sm_dat %>%
  left_join(cor_long, by = c("date", "site", "SM")) %>%
  mutate(
    state = case_when(
      cor > 0 ~ "sync",
      cor < 0 ~ "async"
    )
  )

sync_summary <- sync_dat %>%
  filter(!is.na(state)) %>%
  count(SM, state) %>%
  group_by(SM) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

print(sync_summary)

write.csv(
  sync_summary,
  "results/sync_async_summary.csv",
  row.names = FALSE
)

saveRDS(sync_dat, "data/processed/sync_dat.rds")