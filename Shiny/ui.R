# Define UI
shinyUI(
  dashboardPage(
    skin = "green",
    dashboardHeader(title = 'Effect of Days Rest and Start Times on NBA Teams'),
    
    # Sidebar
    dashboardSidebar(
      sidebarMenu(
        menuItem("Point Difference", tabName = "point_diff", icon = icon("dashboard")),
        menuItem("Days Rest Comparison", icon = icon("th"), tabName = "days_comp",
                 badgeLabel = "new", badgeColor = "green")
            )
        ),
    
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "point_diff",
                fluidRow(
                  column(width = 3,
                         box(
                           title = "Set Parameters", status = "primary", solidHeader = TRUE, height = 450,
                           "Select a season, team, and days between games to see how team stats change", width=NULL, 
                           selectInput("season_tab1", 
                                       label = "Season:", 
                                       choices = season_options_tab1,
                                       selected = 2014),
                           radioButtons(
                             "time_zone_1", label = "Select Time:",
                             choices = c("Any", "Eastern", "Central", "Mountain", "Pacific", "Other"),
                             selected = "Any", inline = TRUE
                           ),
                           radioButtons(
                             "days_between_1", label = "Select Days Rest:",
                             choices = c("Any", "1", "2", "3"),
                             selected = "Any", inline = TRUE
                           ),
                           radioButtons(
                             "h_a_1", label = "Home/Away:",
                             choices = c("Home", "Away", "Either"),
                             selected = "Either", inline = TRUE
                           )
                         )
                  ),
                  column(width = 9,
                         box(
                           title = "Average Margin of Victory for Selected Parameters" , status = "success", 
                           solidHeader = TRUE, width = NULL,
                           plotlyOutput("nba_14_merged", height = 600)
                         )
                  )
                ) # Close Fluid Row 
          
        ),
        
        tabItem(tabName = "days_comp",
          fluidRow(
            column(width = 3,
                   box(
                     title = "Set Parameters", status = "primary", solidHeader = TRUE, height = 600,
                     "Select a season, team, and days between games to see how team stats change", width=NULL, 
                     selectInput("team", 
                                 label = "Team:", 
                                 choices = teams_85,
                                 selected = 'ATL'),
                     sliderInput("season", "Season",
                                 min = 1984, max = 2019, value = 2015,
                                 sep = "", ticks = FALSE
                                ),
                     sliderInput("days_between", "Days Between Games",
                                 min = 1, max = 3, value = 1
                     )
                   )
                ),
            column(width = 9,
                   box(
                     title = "Per Game Stats for Selected Parameters" , status = "success", 
                     solidHeader = TRUE, width = NULL,
                     plotOutput("nba_85_days_comp", height = 600)
                   )
            )
          ) # Close Fluid Row    
        
      ) # Close Tab Item
    ) # Close Tab Items
    ) # Close Dashboard Body
  ) # Close Dashboard Page
) # Close Shiny UI
