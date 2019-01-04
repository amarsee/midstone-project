library(ballr)
library(dplyr)
library(tidyverse)

nba_85_to_present <- read_csv("nba_season_data_1985_to_present_relevant_columns.csv", col_types = "dcdccccccddddcdddd")
nba_85_to_present <- nba_85_to_present %>% 
  filter(daysbetweengames < 5)

nba_14_to_present <- read_csv("nba_season_data_2013_to_present.csv", col_types = "dcdccccccddddcdddd")
nba_14_to_present <- nba_14_to_present %>% 
  filter(daysbetweengames < 5)
nba_14_to_merge <- nba_14_to_present %>% 
  select(year, team, date, opponent, daysbetweengames) %>% 
  rename(opp_daysbetween = 5)

nba_grouped_by_year_days_rest <- nba_85_to_present %>% 
  select(year, team, daysbetweengames, tm, opp, diff) %>% 
  group_by(year, team, daysbetweengames) %>% 
  summarise(mean_points_for = mean(tm),
            mean_points_against = mean(opp),
            mean_differential = mean(diff))

nba_total_grouped_by_year_days_rest <- nba_85_to_present %>% 
  select(year, team, daysbetweengames, tm, opp, diff) %>% 
  group_by(year, daysbetweengames) %>% 
  summarise(mean_points_for = mean(tm),
            mean_points_against = mean(opp),
            mean_differential = mean(diff))

# nba_14_to_present <- nba_14_to_present %>%
#   mutate(opp_inits = if(opponent == "Atlanta Hawks", "ATL"),
#          Level2 = if_else(`TVAAS Composite` == 2, 1, 0),
#          Level3 = if_else(`TVAAS Composite` == 3, 1, 0),
#          Level4 = if_else(`TVAAS Composite` == 4, 1, 0),
#          Level5 = if_else(`TVAAS Composite` == 5, 1, 0)) 
