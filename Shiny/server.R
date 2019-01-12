# Define server logic required to draw a histogram
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
    
    nba_grouped <- nba_season %>% 
      select(team, diff) %>% 
      group_by(team) %>% 
      summarise(
        mean_differential = round(mean(diff, na.rm = TRUE), 2)
        )
    nba_grouped$diff_type <- ifelse(nba_grouped$mean_differential < 0, "Negative", "Positive")  
    nba_grouped <- nba_grouped[order(nba_grouped$mean_differential), ]  # sort
    nba_grouped$team <- factor(nba_grouped$team, levels = nba_grouped$team)
    
    p1 <- ggplot(nba_grouped, aes(x=team, y=mean_differential, label=mean_differential)) + 
      geom_point(stat='identity', aes(col=diff_type), size=6)  +
      scale_color_manual(name="Win/Loss", 
                         labels = c("Net Win", "Net Loss"), 
                         values = c("Positive"="#00ba38", "Negative"="#f8766d")) + 
      geom_text(color="white", size=2) +
      labs(title="Margin of Victory By Team") + 
      ylim(-15, 15) +
      #ylim(as.integer(min(nba_grouped$mean_differential)) - 1, as.integer(max(nba_grouped$mean_differential)) + 1) +
      theme_bw() +
      coord_flip()
    
    ggplotly(p1)
  })
  
  
  
  
})


