# Define UI
shinyUI(
  dashboardPage(
    skin = "green",
    dashboardHeader(title = 'NBA Scheduling Effect'),
    
    # Sidebar
    dashboardSidebar(
      sidebarMenu(
        "Data Last Updated: January 25, 2019", br(), br(),
        menuItem("Overview", tabName = "overview", icon = icon("bookmark")),
        menuItem("League Margin of Victory", tabName = "point_diff", icon = icon("basketball-ball")),
        menuItem("Team Comparison", tabName = "team_comp", icon = icon("balance-scale")),
        br(),
        menuItem("Basketball Reference Data", href = "https://www.basketball-reference.com/leagues/NBA_2019_games.html", icon = icon("link"))
        
        #menuItem("Days Rest Comparison", icon = icon("th"), tabName = "days_comp"),
            )
        ),
    
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "overview",
                fluidRow(
                  box(
                    title = "Welcome", status = "primary", solidHeader = TRUE, height = 600, width = 12,
                    "This shiny app was built as a way to explore some NBA."
                  )
                ) # Close Fluid Row 
                
        ),
        tabItem(tabName = "point_diff",
                fluidRow(
                  column(width = 3,
                         box(
                           title = "Set Parameters", status = "primary", solidHeader = TRUE, height = 700, width=NULL,
                           "Select a season, team, and days between games to see how team stats change", br(), br(),
                           "Season is ending year of the season (e.g. 2018 is the 2017-18 season)", br(), br(),
                           "Time Slot is time zone of typical weeknight game. Other represents an irregular weekend or holiday start time", br(), br(),
                           "Days Rest is between one game and the next (e.g. 1 Day Rest represents games on back-to-back days)", br(),
                           selectInput("season_tab1", 
                                       label = "Season:", 
                                       choices = season_options_tab1,
                                       selected = 2014),
                           selectInput("team_hl", 
                                       label = "Team to Highlight:", 
                                       choices = c("None", team_14),
                                       selected = "None"),
                           radioButtons(
                             "time_zone_1", label = "Select Time Slot:",
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
                           plotlyOutput("nba_14_merged", height = 640)
                         )
                  )
                ), # Close Fluid Row 
          fluidRow(
            column(width = 12,
                   DT::dataTableOutput('table_tab1')
            )
          )
        ),
        # ----------- Tab 2: Team Comparison ---------------
        tabItem(tabName = "team_comp",
                fluidRow(
                  column(width = 6,
                         fluidRow(
                           box(
                             title = "Set Season", status = "primary", solidHeader = TRUE, height = 175,
                             "Select a season for the team comparison" , width=NULL, 
                             selectInput("season_tab2", 
                                         label = "Season:", 
                                         choices = season_options_tab2,
                                         selected = 2014)
                              )
                        ),
                        fluidRow(
                          column(width = 6,
                            box(
                              title = "Team 1", status = "primary", solidHeader = TRUE, height = 385,
                              "Select first team for comparison", width=NULL, 
                              selectInput("team_1", 
                                          label = "Team:", 
                                          choices = team_14,
                                          selected = "ATL"),
                              radioButtons(
                                "days_between_team_1", label = "Select Days Rest:",
                                choices = c("Any", "1", "2", "3"),
                                selected = "Any", inline = TRUE
                              ),
                              radioButtons(
                                "time_zone_team_1", label = "Select Time Slot:",
                                choices = c("Any", "Eastern", "Central", "Mountain", "Pacific", "Other"),
                                selected = "Any", inline = TRUE
                              ),
                              
                              radioButtons(
                                "h_a_team_1", label = "Home/Away:",
                                choices = c("Home", "Away", "Either"),
                                selected = "Either", inline = TRUE
                              )
                            )
                        ),
                        column(width = 6,
                               box(
                                 title = "Team 2", status = "primary", solidHeader = TRUE, height = 385,
                                 "Select second team for comparison", width=NULL, 
                                 selectInput("team_2", 
                                             label = "Team:", 
                                             choices = team_14,
                                             selected = "BOS"),
                                 radioButtons(
                                   "days_between_team_2", label = "Select Days Rest:",
                                   choices = c("Any", "1", "2", "3"),
                                   selected = "Any", inline = TRUE
                                 ),
                                 radioButtons(
                                   "time_zone_team_2", label = "Select Time Slot:",
                                   choices = c("Any", "Eastern", "Central", "Mountain", "Pacific", "Other"),
                                   selected = "Any", inline = TRUE
                                 ),
                                 
                                 radioButtons(
                                   "h_a_team_2", label = "Home/Away:",
                                   choices = c("Home", "Away", "Either"),
                                   selected = "Either", inline = TRUE
                                 )
                               )
                        )
                     )
                  ),
                  column(width = 6,
                         fluidRow(
                           column(width = 6, align = "center",
                                  box(
                                    title = "Team 1 Stats", status = "primary", solidHeader = TRUE, height = 580,
                                    width=NULL, 
                                    fluidRow(uiOutput("img_team_1")), br(),
                                    fluidRow(infoBoxOutput("team_1_points_for", width = 12)),
                                    fluidRow(infoBoxOutput("team_1_points_against", width = 12)),
                                    fluidRow(infoBoxOutput("team_1_diff", width = 12))
                                 
                                  )
                           ),
                           column(width = 6, align = "center",
                                  box(
                                    title = "Team 2 Stats", status = "primary", solidHeader = TRUE, height = 580,
                                    width=NULL, 
                                    uiOutput("img_team_2"), br(),
                                    fluidRow(infoBoxOutput("team_2_points_for", width = 12)),
                                    fluidRow(infoBoxOutput("team_2_points_against", width = 12)),
                                    fluidRow(infoBoxOutput("team_2_diff", width = 12))
                                  )
                           )
                         )
                  )
                ), # Close Fluid Row 
                fluidRow(
                  column(width = 12,
                         DT::dataTableOutput('table_tab2')
                  )
                )
                
        )

    ) # Close Tab Items
    ) # Close Dashboard Body
  ) # Close Dashboard Page
) # Close Shiny UI
