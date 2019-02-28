library("ballr")
library('dplyr')
library(tidyverse)

# ------------ Testing functions of ballr --------------
s2019 <- NBAPerGameAdvStatistics(season = 2019) %>% 
  filter(mp > 150)
ad <- as.character( s2019 %>% 
                      filter(player == 'Anthony Davis') %>% 
                      select(link)) 
ad_career <- NBAPlayerPerGameStats(ad)

standings <- NBAStandingsByDate("2018-12-13") # "YEAR-MO-DY"
standings
atl_2019 <- NBASeasonTeamByYear("ATL", 1985)

team_chars <- s2019 %>% 
  filter(tm != "TOT")  
nchars <- unique(team_chars$tm)

# ------------------ Function to call ballr function to concatenate team schedules to one dataframe -------
combineYears <- function(year1, year2) {
  totalDf <- NBASeasonTeamByYear("ATL", (year1 - 1))
  totalDf$year <- (year1 - 1)
  totalDf$team = "ATL"
  for (year in year1:year2){
    nbaStatsYear = NBAPerGameStatistics(season = year)
    teamSub <- nbaStatsYear %>%
                    filter(tm != "TOT")
    team_chars <- unique(teamSub$tm)
    for (team in team_chars) {
      yearDf <- NBASeasonTeamByYear(team, year)
      yearDf$year <- year
      yearDf$team <- team
      totalDf <- rbind(totalDf, yearDf)
    }
  }
  return(totalDf)
}

# ------------- Dataframe for 2014 to 2019 -------------------
tots <- combineYears(2014, 2019)

# nba85toCurrent <- combineYears(1985, 2019)
# write.csv(relevantColumnsKept, file = "nba_season_data_1985_to_present_relevant_columns.csv",row.names=FALSE)

# ----------------- Keeping columns relevant for analysis -------------------
# relevantColumnsKept <- nba85toCurrent %>%
#   select(year, team, g, date, start_et, away_indicator, opponent, x_4, x_5, tm, opp,
#          w, l, streak, diff, avg_diff, away, daysbetweengames)

relevantColumnsKept_tots <- tots %>%
  select(year, team, g, date, start_et, away_indicator, opponent, x_4, x_5, tm, opp,
         w, l, streak, diff, avg_diff, away, daysbetweengames)
write.csv(relevantColumnsKept_tots, file = "nba_season_data_2013_to_present.csv",row.names=FALSE)

daysRestComp <- relevantColumnsKept %>% 
  select(year, daysbetweengames, diff) %>% 
  filter(daysbetweengames < 6) %>% 
  group_by(year, daysbetweengames) %>% 
  summarise_at(vars(diff), funs(mean(., na.rm=TRUE)))
# https://d2cwpp38twqe55.cloudfront.net/req/201811081/images/players/davisan02.jpg

## Teams average points per game for season, compared with averages for different numbers of days in between
# Maybe compare away versus home, see if there's any significant difference
# Start time