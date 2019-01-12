library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(usmap)
library(plotly)

# load datset of prescription counts by state
nba_85_to_now_grouped <- readRDS('data/85_to_now_grouped.rds')
nba_14_to_present_merged <- readRDS('data/nba_14_to_present_merged.rds')
nba_14_to_present_merged <- nba_14_to_present_merged %>% 
  mutate(
    time_zone = case_when(
      start_et == "7:00p" | start_et == "7:30p" ~ "Eastern",
      start_et == "8:00p" | start_et == "8:30p" ~ "Central",
      start_et == "9:00p" | start_et == "9:30p" ~ "Mountain",
      start_et == "10:00p" | start_et == "10:30p" ~ "Pacific",
      TRUE                      ~  "Other"
    )
  )

teams_85 <- unique(nba_85_to_now_grouped$team)
season_options_tab1 <- unique(nba_14_to_present_merged$year)
years <- 1984:2019




