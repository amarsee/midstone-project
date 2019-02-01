shinyServer(function(input, output) {
  
  
  output$nba_85_days_comp <- renderPlot({
    
    team_selection <- input$team
    year_sel <- as.double( input$season)
    days <- input$days_between
    
    nba_filtered <- nba_85_to_now_grouped %>% 
      filter(year == year_sel, team == team_selection, daysbetweengames == days)
    
    n_df <- data.frame(stat=c("Mean Points For", "Mean Points Against"),
                     val=c(nba_filtered$mean_points_for, nba_filtered$mean_points_against))
    
    ggplot(n_df, aes(x = stat, y = val)) + 
      geom_bar(stat = "identity", fill = "steelblue") +
      theme_minimal()
           
  })
  
  output$nba_14_merged <- renderPlotly({
    #browser()
    season_select <- input$season_tab1 # 2014 to 2019
    tz_1 <- input$time_zone_1 # Can be "Any", "Eastern", "Central", "Mountain", "Pacific", "Other"
    days_rest_1 <- input$days_between_1 # Can be "Any", "1", "2", "3"
    home_away_1 <- input$h_a_1 # Can be "Home", "Away", "Either"
    team_highlight <- input$team_hl # Selection to focus on and highlight in plot
    
    nba_season <- nba_14_to_present_merged %>% 
      filter(year == season_select)
    
   if (tz_1 == "Any"){
     nba_season = nba_season
   } else {
     nba_season = nba_season %>% 
       filter(time_zone == tz_1)
   }
    
    if(days_rest_1 == "Any"){
      nba_season = nba_season
    } else {
      days_between = as.numeric(days_rest_1)
      nba_season = nba_season %>% 
        filter(daysbetweengames == days_between)
    }
    
    if (home_away_1 == "Either"){
      nba_season = nba_season
    } else if (home_away_1 == "Home"){
      nba_season = nba_season %>% 
        filter(away_indicator == 0)
    } else {
      nba_season = nba_season %>% 
        filter(away_indicator == 1)
    }
    
    table_out <- nba_season %>% 
      select(team, date, start_et, away_indicator, daysbetweengames, opponent, win_loss, tm, opp)
    
    output$table_tab1 <- DT::renderDataTable(
      table_out, filter = "top"
    )
    
    nba_grouped <- nba_season %>% 
      select(team, diff) %>% 
      group_by(team) %>% 
      summarise(
        mean_differential = round(mean(diff, na.rm = TRUE), 1)
        )
    nba_grouped$diff_type <- ifelse(nba_grouped$mean_differential < 0, "Negative", "Positive")  
    nba_grouped <- nba_grouped[order(nba_grouped$mean_differential), ]  # sort
    nba_grouped$team <- factor(nba_grouped$team, levels = nba_grouped$team)
    nba_grouped <- nba_grouped %>% 
      rename(Team = 1, `Avg. Margin of Victory` = 2)
    
    black.bold.italic.11.text <- element_text(face = "bold", color = "black", size = 11)
    black.bold.italic.15.text <- element_text(color = "black", size = 15)
    
    p1 <- ggplot(nba_grouped, aes(x=Team, y=`Avg. Margin of Victory`, label=`Avg. Margin of Victory`)) + 
      geom_point(stat='identity', aes(col=diff_type), size=5, shape = 21)  +
      scale_color_manual(name="Margin of\n Victory", 
                         labels = c("Net Win", "Net Loss"), 
                         values = c("Positive"="#00ba38", "Negative"="#f8766d")) + 
      geom_text(color="black", size=2) +
      labs(title="Average Margin of Victory By Team", 
           y = "Average Margin of Victory", x = "Team") + 
      ylim(-16, 16) +
      #ylim(as.integer(min(nba_grouped$mean_differential)) - 1, as.integer(max(nba_grouped$mean_differential)) + 1) +
      theme_bw() +
      theme(axis.text = black.bold.italic.11.text, axis.title = black.bold.italic.15.text)
    
    if (team_highlight != "None") {
      hl_data <- nba_grouped %>% 
        filter(Team == team_highlight)
      p1 <- p1 +
        geom_point(data = hl_data, aes(x = Team, y = `Avg. Margin of Victory`), size=5, shape = 23)
    }
    p1 <- p1 +
      coord_flip() +
      theme(legend.position="bottom")
    
    ggplotly(p1, tooltip=c("x", "y")) %>% 
      layout(legend = list(orientation = "h", x = 0.7, y = 0.2))
    
   
  })
  
  
  
  output$team_1_points_for <- renderInfoBox({
    infoBox(
      "12", icon = icon("list"),
      color = "purple"
    )
  })
  
  output$img_team_1 <- renderUI({
    team_1_char <- input$team_1
    year_char <- as.character(input$season_tab2)
    year_num <- input$season_tab2
    if (team_1_char == "CHA" & year_num > 2014) {
      team_1_char = "CHO"
    }
    
    img_url_1 <- paste("https://d2p3bygnnzw9w3.cloudfront.net/req/201901091/tlogo/bbr/", team_1_char, "-", year_char, ".png", sep = "")
    
    tags$img(src = img_url_1, width = 150, height = 150)
  })
  
  output$img_team_2 <- renderUI({
    team_2_char <- input$team_2
    year_char <- as.character(input$season_tab2)
    year_num <- input$season_tab2
    if (team_2_char == "CHA" & year_num > 2014) {
      team_2_char = "CHO"
    }
    
    img_url_2 <- paste("https://d2p3bygnnzw9w3.cloudfront.net/req/201901091/tlogo/bbr/", team_2_char, "-", year_char, ".png", sep = "")
    
    tags$img(src = img_url_2, width = 150, height = 150)
  })
  
  team_1_df <- reactive({
    team_1_char <- input$team_1
    season_select <- input$season_tab2 # 2014 to 2019
    tz_team_1 <- input$time_zone_team_1 # Can be "Any", "Eastern", "Central", "Mountain", "Pacific", "Other"
    days_rest_team_1 <- input$days_between_team_1 # Can be "Any", "1", "2", "3"
    home_away_team_1 <- input$h_a_team_1 # Can be "Home", "Away", "Either"
    
    nba_season <- nba_14_to_present_merged %>% 
      filter(year == season_select, team == team_1_char)
    
    if (tz_team_1 == "Any"){
      nba_season = nba_season
    } else {
      nba_season = nba_season %>% 
        filter(time_zone == tz_team_1)
    }
    
    if(days_rest_team_1 == "Any"){
      nba_season = nba_season
    } else {
      days_between = as.numeric(days_rest_team_1)
      nba_season = nba_season %>% 
        filter(daysbetweengames == days_between)
    }
    
    if (home_away_team_1 == "Either"){
      nba_season = nba_season
    } else if (home_away_team_1 == "Home"){
      nba_season = nba_season %>% 
        filter(away_indicator == 0)
    } else {
      nba_season = nba_season %>% 
        filter(away_indicator == 1)
    }
    
    nba_grouped <- nba_season %>% 
      select(team, tm, opp, diff) %>% 
      group_by(team) %>% 
      summarise(
        mean_points_for = round(mean(tm, na.rm = TRUE), 2),
        mean_points_against = round(mean(opp, na.rm = TRUE), 2),
        mean_differential = round(mean(diff, na.rm = TRUE), 2)
      )
    
    nba_grouped
  })
  
  team_2_df <- reactive({
    team_1_char <- input$team_2
    season_select <- input$season_tab2 # 2014 to 2019
    tz_team_1 <- input$time_zone_team_2 # Can be "Any", "Eastern", "Central", "Mountain", "Pacific", "Other"
    days_rest_team_1 <- input$days_between_team_2 # Can be "Any", "1", "2", "3"
    home_away_team_1 <- input$h_a_team_2 # Can be "Home", "Away", "Either"
    
    nba_season <- nba_14_to_present_merged %>% 
      filter(year == season_select, team == team_1_char)
    
    if (tz_team_1 == "Any"){
      nba_season = nba_season
    } else {
      nba_season = nba_season %>% 
        filter(time_zone == tz_team_1)
    }
    
    if(days_rest_team_1 == "Any"){
      nba_season = nba_season
    } else {
      days_between = as.numeric(days_rest_team_1)
      nba_season = nba_season %>% 
        filter(daysbetweengames == days_between)
    }
    
    if (home_away_team_1 == "Either"){
      nba_season = nba_season
    } else if (home_away_team_1 == "Home"){
      nba_season = nba_season %>% 
        filter(away_indicator == 0)
    } else {
      nba_season = nba_season %>% 
        filter(away_indicator == 1)
    }
    
    nba_grouped <- nba_season %>% 
      select(team, tm, opp, diff) %>% 
      group_by(team) %>% 
      summarise(
        mean_points_for = round(mean(tm, na.rm = TRUE), 2),
        mean_points_against = round(mean(opp, na.rm = TRUE), 2),
        mean_differential = round(mean(diff, na.rm = TRUE), 2)
      )
    
    nba_grouped
  })
  
  output$team_1_points_for <- renderInfoBox({
    #browser()
    points_for <- team_1_df()[1,2]
    infoBox(
      title = "Mean Points For",
      value = as.character(points_for) ,
      icon = icon("bolt"),
      color = "yellow",
      width = 12
    )
  })
  
  output$team_1_points_against <- renderInfoBox({
    #browser()
    points_against <- team_1_df()[1,3]
    infoBox(
      title = "Mean Points Against",
      value = as.character(points_against) ,
      icon = icon("compress"),
      color = "red",
      width = 12
    )
  })
  
  output$team_1_diff <- renderInfoBox({
    #browser()
    point_diff <- team_1_df()[1,4]
    infoBox(
      title = "Margin of Victory",
      value = as.character(point_diff) ,
      icon = icon("arrows-alt-v"),
      color = "blue",
      width = 12
    )
  })
  
  output$team_2_points_for <- renderInfoBox({
    #browser()
    points_for <- team_2_df()[1,2]
    infoBox(
      title = "Mean Points For",
      value = as.character(points_for) ,
      icon = icon("bolt"),
      color = "yellow",
      width = 12
    )
  })
  
  output$team_2_points_against <- renderInfoBox({
    #browser()
    points_against <- team_2_df()[1,3]
    infoBox(
      title = "Mean Points Against",
      value = as.character(points_against) ,
      icon = icon("compress"),
      color = "red",
      width = 12
    )
  })
  
  output$team_2_diff <- renderInfoBox({
    #browser()
    point_diff <- team_2_df()[1,4]
    infoBox(
      title = "Margin of Victory",
      value = as.character(point_diff) ,
      icon = icon("arrows-alt-v"),
      color = "blue",
      width = 12
    )
  })
  
  output$table_tab2 <- DT::renderDataTable({
    team_1_char <- input$team_1
    season_select <- input$season_tab2 # 2014 to 2019
    team_2_char <- input$team_2

    nba_season <- nba_14_to_present_merged %>% 
      filter(year == season_select, team == team_1_char, opp_init == team_2_char) %>% 
      select(date, start_et, away_indicator, team, daysbetweengames, tm, opp, opp_init, opp_daysbetween) %>% 
      rename(Date = 1, `Start Time (ET)` = 2, `Home or Away`= 3, `Team 1` = 4, `Team 1 Days Between` = 5 , `Team 1 Points` = 6, 
             `Team 2 Points` = 7, `Team 2` = 8, `Team 2 Days Between` = 9) %>% 
      mutate(
        `Home Team` = case_when(
          `Home or Away` == 0 ~ team_1_char,
          TRUE ~ team_2_char
        )
      ) %>% 
      select(Date, `Start Time (ET)`, `Home Team`,`Team 1 Days Between`, `Team 1`, `Team 1 Points`, 
             `Team 2 Points`, `Team 2`, `Team 2 Days Between`)
    
    nba_season
    
  })
  

    
})


