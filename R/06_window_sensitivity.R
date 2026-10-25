# 06_window_sensitivity.R
# 比较不同窗口长度下的滑动相关

library(dplyr)
library(tidyr)
library(purrr)
library(slider)
library(ggplot2)

met <- readRDS("data/processed/met_drought.rds")

windows <- c(7, 11, 15, 19, 23)

window_cor <- map_dfr(windows, \(w) {

  h <- (w - 1) / 2

  met %>%
    transmute(
      date,
      across(
        c(SM1_drought, SM2_drought, SM3_drought, SM4_drought),
        \(sm) slide2_dbl(
          VPD_drought, sm,
          \(vpd, sm) cor(vpd, sm),
          .before = h,
          .after = h,
          .complete = TRUE
        )
      )
    ) %>%
    pivot_longer(
      -date,
      names_to = "SM",
      values_to = "cor"
    ) %>%
    mutate(window = w)
})

window_summary <- window_cor %>%
  group_by(window, SM) %>%
  summarise(
    mean_cor = mean(cor, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(
  window_summary,
  aes(window, mean_cor, group = SM, linetype = SM)
) +
  geom_line() +
  geom_point() +
  theme_classic()

write.csv(
  window_summary,
  "results/window_sensitivity.csv",
  row.names = FALSE
)