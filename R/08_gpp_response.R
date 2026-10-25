# 08_gpp_response.R
# 比较同步和不同步时期的 GPP 响应

library(dplyr)
library(ggplot2)

sync_dat <- readRDS("data/processed/sync_dat.rds")
gpp <- readRDS("data/processed/gpp_clean.rds")

gpp_dat <- sync_dat %>%
  left_join(gpp, by = c("date", "site")) %>%
  filter(!is.na(GPP), !is.na(state))

gpp_summary <- gpp_dat %>%
  group_by(SM, state) %>%
  summarise(
    n = n(),
    mean_GPP = mean(GPP),
    cor_VPD = cor(GPP, VPD_drought),
    cor_SM = cor(GPP, SM_drought),
    .groups = "drop"
  )

print(gpp_summary)

p_vpd <- ggplot(
  gpp_dat,
  aes(VPD_drought, GPP, linetype = state)
) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ SM) +
  labs(
    x = "VPD drought index",
    y = "GPP anomaly",
    linetype = "State"
  ) +
  theme_classic()

p_sm <- ggplot(
  gpp_dat,
  aes(SM_drought, GPP, linetype = state)
) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ SM) +
  labs(
    x = "SM drought index",
    y = "GPP anomaly",
    linetype = "State"
  ) +
  theme_classic()

print(p_vpd)
print(p_sm)

write.csv(
  gpp_summary,
  "results/gpp_response.csv",
  row.names = FALSE
)

ggsave("Figures/Fig02_GPP_VPD_response.pdf", p_vpd, width = 9, height = 6)
ggsave("Figures/Fig03_GPP_SM_response.pdf", p_sm, width = 9, height = 6)