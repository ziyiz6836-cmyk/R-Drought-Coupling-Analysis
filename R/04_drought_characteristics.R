# 04_drought_characteristics.R
# 识别连续干旱事件并计算干旱特征

library(dplyr)
library(tidyr)

met <- readRDS("data/processed/met_drought.rds")

threshold <- 1

drought_event <- met %>%
  select(
    date,
    VPD_drought,
    SM1_drought,
    SM2_drought,
    SM3_drought,
    SM4_drought
  ) %>%
  pivot_longer(
    -date,
    names_to = "index",
    values_to = "drought"
  ) %>%
  arrange(index, date) %>%
  group_by(index) %>%
  mutate(
    is_drought = drought >= threshold,
    event = cumsum(
      is_drought & !lag(is_drought, default = FALSE)
    )
  ) %>%
  filter(is_drought) %>%
  group_by(index, event) %>%
summarise(
  date_beg = first(date),
  date_end = last(date),
  n_period = n(),
  duration = n_period * 8,
  intensity = mean(drought),
  severity = sum(drought),
  .groups = "drop"
)

print(drought_event)

dir.create("results", showWarnings = FALSE)

write.csv(
  drought_event,
  "results/drought_events.csv",
  row.names = FALSE
)

saveRDS(drought_event, "data/processed/drought_event.rds")