# R-Drought-Coupling-Analysis

R analysis of the coupling relationship between meteorological drought (VPD) and agricultural drought (soil moisture), and their effects on GPP.

## Workflow

1. Data check
2. Data cleaning
3. Drought index calculation
4. Drought characteristics
5. Sliding correlation
6. Window sensitivity
7. Synchrony and asynchrony identification
8. GPP response analysis

## Data

* `ERA5L_TWSA.csv`: VPD and soil moisture data
* `GPP_anomaly.csv`: GPP anomaly data

## R scripts

The analysis scripts are stored in the `R/` folder and should be run in numerical order from `01` to `08`.

## Main packages

`data.table`, `dplyr`, `tidyr`, `lubridate`, `purrr`, `slider`, `ggplot2`
