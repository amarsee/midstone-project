library(ballr)
library(dplyr)
library(tidyverse)
library(broom)

# NBA stats updated through 2/9/19

# nba_85_to_present <- read_csv("data/nba_season_data_1985_to_present_relevant_columns.csv", col_types = "dcdccccccddddcdddd")
# nba_85_to_present$away_indicator <- nba_85_to_present$away_indicator %>% replace_na("")
# nba_85_to_present <- nba_85_to_present %>% 
#   filter(daysbetweengames < 4) %>% 
#   rename(win_loss = 8, overtime = 9) %>% 
#   mutate(win_loss=if_else(win_loss == "W", 1, 0),
#          away_indicator=if_else(away_indicator == "@", 1, 0))

nba_14_to_present <- read_csv("data/nba_season_data_2013_to_present.csv", col_types = "dcdccccccddddcdddd")
# nba_14_to_present %>% 
#   filter(year > 2013, team == "ATL") %>% 
#   View()
nba_14_to_present$away_indicator <- nba_14_to_present$away_indicator %>% replace_na("")
nba_14_to_present <- nba_14_to_present %>% 
  filter(daysbetweengames < 4) %>% 
  rename(win_loss = 8, overtime = 9) %>%
  mutate(win_loss=if_else(win_loss == "W", 1, 0),
         away_indicator=if_else(away_indicator == "@", 1, 0),
         team = ifelse(team == "CHO", "CHA", team))

nba_14_to_merge <- nba_14_to_present %>% 
  select(team, date, daysbetweengames) %>% 
  rename(opp_daysbetween = 3) 

# nba_grouped_by_year_days_rest <- nba_85_to_present %>% 
#   select(year, team, daysbetweengames, tm, opp, diff) %>% 
#   group_by(year, team, daysbetweengames) %>% 
#   summarise(mean_points_for = mean(tm, na.rm = TRUE),
#             mean_points_against = mean(opp, na.rm = TRUE),
#             mean_differential = mean(diff, na.rm = TRUE))

# nba_total_grouped_by_year_days_rest <- nba_85_to_present %>% 
#   select(year, team, daysbetweengames, tm, opp, diff) %>% 
#   group_by(year, daysbetweengames) %>% 
#   summarise(mean_points_for = mean(tm, na.rm = TRUE),
#             mean_points_against = mean(opp, na.rm = TRUE),
#             mean_differential = mean(diff, na.rm = TRUE))

nba_14_to_present <- nba_14_to_present %>%
  mutate(
    opp_init = case_when(
      opponent == "Oklahoma City Thunder" ~ "OKC",
      opponent == "Indiana Pacers" ~ "IND",
      opponent == "Miami Heat" ~ "MIA",
      opponent == "Los Angeles Clippers" ~ "LAC",
      opponent == "Portland Trail Blazers" ~ "POR",
      opponent == "Golden State Warriors" ~ "GSW",
      opponent == "Sacramento Kings" ~ "SAC",
      opponent == "Orlando Magic" ~ "ORL",
      opponent == "Washington Wizards" ~ "WAS",
      opponent == "Charlotte Bobcats" ~ "CHA",
      opponent == "Cleveland Cavaliers" ~ "CLE",
      opponent == "Memphis Grizzlies" ~ "MEM",
      opponent == "Philadelphia 76ers" ~ "PHI",
      opponent == "Chicago Bulls" ~ "CHI",
      opponent == "Detroit Pistons" ~ "DET",
      opponent == "Houston Rockets" ~ "HOU",
      opponent == "New Orleans Hornets" ~ "NOP",
      opponent == "Boston Celtics" ~ "BOS",
      opponent == "Minnesota Timberwolves" ~ "MIN",
      opponent == "Utah Jazz" ~ "UTA",
      opponent == "Brooklyn Nets" ~ "BRK",
      opponent == "San Antonio Spurs" ~ "SAS",
      opponent == "New York Knicks" ~ "NYK",
      opponent == "Toronto Raptors" ~ "TOR",
      opponent == "Dallas Mavericks" ~ "DAL",
      opponent == "Milwaukee Bucks" ~ "MIL",
      opponent == "Phoenix Suns" ~ "PHO",
      opponent == "Los Angeles Lakers" ~ "LAL",
      opponent == "Denver Nuggets" ~ "DEN",
      opponent == "Atlanta Hawks" ~ "ATL",
      opponent == "New Orleans Pelicans" ~ "NOP",
      opponent == "Charlotte Hornets" ~ "CHA"
      )
    )

nba_14_to_present_merged <- nba_14_to_present %>% 
  inner_join(nba_14_to_merge, by = c("opp_init" = "team", "date"))

nba_total_grouped_by_year_with_oppenent <- nba_14_to_present_merged %>% 
  select(year, team, opp_init, daysbetweengames, opp_daysbetween, tm, opp, diff) %>% 
  group_by(year, daysbetweengames, opp_daysbetween) %>% 
  summarise(mean_points_for = mean(tm, na.rm = TRUE),
            mean_points_against = mean(opp, na.rm = TRUE),
            mean_differential = mean(diff, na.rm = TRUE))
# Getting total schedule for 2014 to present with mean points for, points against, and point differential
# The mean values are given the certain number of days rest
nba_total_schedule <- nba_14_to_present_merged %>% 
  group_by(year, team, daysbetweengames) %>% 
  mutate(mean_points_for = mean(tm, na.rm = TRUE),
            mean_points_against = mean(opp, na.rm = TRUE),
            mean_differential = mean(diff, na.rm = TRUE)) %>% 
  ungroup()# %>% 
  # group_by(year, team) %>% 
  # mutate(season_avg_points_for = mean(tm, na.rm = TRUE),
  #        season_avg_points_against = mean(opp, na.rm = TRUE)
  #        ) %>% 
  # ungroup()

# Create a new df to merge so I can have the oppenent's average points per game and points allowed given their amount of rest
nba_total_to_merge <- nba_total_schedule %>% 
  select(team, date, mean_points_for, mean_points_against, mean_differential) %>% 
  rename(opp_mean_points_for = 3, opp_mean_points_against = 4, opp_mean_differential = 5) 
# Merge to have all data in one dataframe
nba_total_merged <- nba_total_schedule %>% 
  inner_join(nba_total_to_merge, by = c("opp_init" = "team", "date"))


# model <- glm(formula= win_loss ~ mean_points_for + mean_points_against + 
#                                   opp_mean_points_for + opp_mean_points_against, 
#                                   data=nba_total_merged, family=binomial)
# summary(model)

# model <- glm(formula= win_loss ~ mean_points_for + mean_points_against,
#                                   data=nba_total_merged, family=binomial)
# summary(model)
# 
# nba_nested <- nba_total_merged %>% 
#   group_by(team) %>% 
#   nest()
# nba_nested$data[[1]]

# nba_models <- nba_nested %>% 
#   mutate(model = map(data, ~glm(formula= win_loss ~ mean_points_for + mean_points_against + mean_differential + 
#                                   opp_mean_points_for + opp_mean_points_against + opp_mean_differential, 
#                                   family=binomial, data = .x)))

nba_total_by_team <- nba_14_to_present_merged %>% 
  select(year, team, daysbetweengames, tm, opp, diff) %>% 
  group_by(year, team, daysbetweengames) %>% 
  summarise(mean_points_for = mean(tm, na.rm = TRUE),
         mean_points_against = mean(opp, na.rm = TRUE),
         mean_differential = mean(diff, na.rm = TRUE))

# nba_total_by_team_85 <- nba_85_to_present %>% 
#   select(year, team, daysbetweengames, tm, opp, diff) %>% 
#   group_by(year, team, daysbetweengames) %>% 
#   summarise(mean_points_for = round(mean(tm, na.rm = TRUE), 2),
#             mean_points_against = round(mean(opp, na.rm = TRUE), 2),
#             mean_differential = round(mean(diff, na.rm = TRUE), 2))
# nba_total_by_team_85$diff_type <- ifelse(nba_total_by_team_85$mean_differential < 0, "below", "above")  # above / below avg flag
# nba_total_by_team_85_sorted <- nba_total_by_team_85 %>% 
#   arrange(-mean_differential)


nba_14_to_present_start_time <- nba_14_to_present %>% 
  select(year, team, start_et, daysbetweengames, tm, opp, diff) %>% 
  group_by(year, team, start_et, daysbetweengames) %>% 
  summarise(mean_points_for = round(mean(tm, na.rm = TRUE), 2),
            mean_points_against = round(mean(opp, na.rm = TRUE), 2),
            mean_differential = round(mean(diff, na.rm = TRUE), 2))

nba_14_to_present_just_start_time <- nba_14_to_present %>% 
  select(year, team, start_et, tm, opp, diff) %>% 
  group_by(year, team, start_et) %>% 
  summarise(mean_points_for = round(mean(tm, na.rm = TRUE), 2),
            mean_points_against = round(mean(opp, na.rm = TRUE), 2),
            mean_differential = round(mean(diff, na.rm = TRUE), 2))
# Eastern: 7 or 7:30
# Central: 8 or 8:30
# Mountain: 9 or 9:30
# Pacific: 10 or 10:30
# Afternoon: Anything Else

start_groups_nba_14_to_present <- nba_14_to_present %>% 
  select(year, team, start_et, tm, opp, diff) %>% 
  mutate(
    time_zone = case_when(
      start_et == "7:00p" | start_et == "7:30p" ~ "Eastern",
      start_et == "8:00p" | start_et == "8:30p" ~ "Central",
      start_et == "9:00p" | start_et == "9:30p" ~ "Mountain",
      start_et == "10:00p" | start_et == "10:30p" ~ "Pacific",
      TRUE                      ~  "Afternoon"
    )
  ) %>% 
  select(year, team, time_zone, tm, opp, diff) %>% 
  group_by(year, team, time_zone) %>% 
  summarise(mean_points_for = round(mean(tm, na.rm = TRUE), 2),
            mean_points_against = round(mean(opp, na.rm = TRUE), 2),
            mean_differential = round(mean(diff, na.rm = TRUE), 2))


saveRDS(nba_14_to_present_merged, "nba-stats-shiny-dashboard/data/nba_14_to_present_merged.rds")

