# Define UI
shinyUI(
  dashboardPage(
    skin = "green",
    dashboardHeader(title = 'Effect of Days Rest and Start Times on NBA Teams'),
    
    # Sidebar
    dashboardSidebar(
      sidebarMenu(
        menuItem("Point Difference", tabName = "point_diff", icon = icon("basketball-ball")),
        menuItem("Team Comparison", tabName = "team_comp", icon = icon("dashboard"))
        #menuItem("Days Rest Comparison", icon = icon("th"), tabName = "days_comp")
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
                             title = "Set Parameters", status = "primary", solidHeader = TRUE, height = 175,
                             "Select a season for the team comparison", width=NULL, 
                             selectInput("season_tab2", 
                                         label = "Season:", 
                                         choices = season_options_tab2,
                                         selected = 2014)
                              )
                        ),
                        fluidRow(
                          column(width = 6,
                            box(
                              title = "Team 1", status = "primary", solidHeader = TRUE, height = 500,
                              "Select first team for comparison", width=NULL, 
                              selectInput("team_1", 
                                          label = "Team:", 
                                          choices = team_14,
                                          selected = "ATL"),
                              radioButtons(
                                "time_zone_team_1", label = "Select Time:",
                                choices = c("Any", "Eastern", "Central", "Mountain", "Pacific", "Other"),
                                selected = "Any", inline = TRUE
                              ),
                              radioButtons(
                                "days_between_team_1", label = "Select Days Rest:",
                                choices = c("Any", "1", "2", "3"),
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
                                 title = "Team 2", status = "primary", solidHeader = TRUE, height = 500,
                                 "Select second team for comparison", width=NULL, 
                                 selectInput("team_2", 
                                             label = "Team:", 
                                             choices = team_14,
                                             selected = "BOS"),
                                 radioButtons(
                                   "time_zone_team_2", label = "Select Time:",
                                   choices = c("Any", "Eastern", "Central", "Mountain", "Pacific", "Other"),
                                   selected = "Any", inline = TRUE
                                 ),
                                 radioButtons(
                                   "days_between_team_2", label = "Select Days Rest:",
                                   choices = c("Any", "1", "2", "3"),
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
                                    title = "Team 1 Stats", status = "primary", solidHeader = TRUE, height = 600,
                                    width=NULL, 
                                    fluidRow(uiOutput("img_team_1")),
                                    fluidRow(infoBoxOutput("team_1_points_for", width = 12)),
                                    fluidRow(infoBoxOutput("team_1_points_against", width = 12)),
                                    fluidRow(infoBoxOutput("team_1_diff", width = 12))
                                 
                                  )
                           ),
                           column(width = 6, align = "center",
                                  box(
                                    title = "Team 2 Stats", status = "primary", solidHeader = TRUE, height = 600,
                                    width=NULL, 
                                    uiOutput("img_team_2"),
                                    fluidRow(infoBoxOutput("team_2_points_for", width = 12)),
                                    fluidRow(infoBoxOutput("team_2_points_against", width = 12)),
                                    fluidRow(infoBoxOutput("team_2_diff", width = 12))
                                  )
                           )
                         )
                  )
                ) # Close Fluid Row 
                
        )
        # -------- Tab 3: Team Points ---------
      #   tabItem(tabName = "days_comp",
      #     fluidRow(
      #       column(width = 3,
      #              box(
      #                title = "Set Parameters", status = "primary", solidHeader = TRUE, height = 600,
      #                "Select a season, team, and days between games to see how team stats change", width=NULL, 
      #                selectInput("team", 
      #                            label = "Team:", 
      #                            choices = teams_85,
      #                            selected = 'ATL'),
      #                sliderInput("season", "Season",
      #                            min = 1984, max = 2019, value = 2015,
      #                            sep = "", ticks = FALSE
      #                           ),
      #                sliderInput("days_between", "Days Between Games",
      #                            min = 1, max = 3, value = 1
      #                )
      #              )
      #           ),
      #       column(width = 9,
      #              box(
      #                title = "Per Game Stats for Selected Parameters" , status = "success", 
      #                solidHeader = TRUE, width = NULL,
      #                plotOutput("nba_85_days_comp", height = 600)
      #              )
      #       )
      #     ) # Close Fluid Row    
      #   
      # ) # Close Tab Item
    ) # Close Tab Items
    ) # Close Dashboard Body
  ) # Close Dashboard Page
) # Close Shiny UI
