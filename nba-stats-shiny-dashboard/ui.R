# Define UI
shinyUI(
  dashboardPage(
    skin = "green",
    dashboardHeader(title = 'NBA Scheduling Effect'),
    
    # Sidebar
    dashboardSidebar(
      sidebarMenu(
        "Data Last Updated: January 31, 2019", br(), br(),
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
                    title = "Welcome", status = "primary", solidHeader = TRUE, height = 1250, width = 12,
                    h1("Introduction"),
                    p("This shiny app was built as a way to explore some NBA team stats. I wanted to explore how rest 
                    and travel affect NBA. This was done by visualizing how the number of days rest affect the average 
                    margin of victory. Average margin of victory serves as a proxy for a team's performance. The average 
                    margin of victory is higher for teams that perform better, and lower for worse teams."),
                    p("The site contains 2 pages. The first of which is the league margin of victory. Different 
                      parameters can be set for a given year to get a quick visualization of how the teams performed 
                      realative to other teams. The second page is a team comparison. Two teams can be selected 
                      to see how they perform under different circumstances."),
                    h1("League Margin of Victory"),
                    p("The League Margin of Victory page provides a space to view how the league as a whole
                      performs for a set of rest and travel parameters"),
                    p("There is also a table below the plot with games that fit the paramters. Filters are
                      at the top to search for certain team or stat."),
                    h3("Season"),
                    p("Select a season for stats. For this site the season will refer to the year in which the 
                      season finishes (e.g. 2018 is the 2017-18 season)"),
                    h3("Team to Highlight"),
                    p("A team can be selected to focus on. This draws a box around the circle so that 
                      you can easily find the team as the bubble shifts when the parameters are changed."),
                    h3("Time Slot"),
                    p("The time slot is the time at which the game is played. It is the typical weeknight time slot.
                      Teams tend to play at either 7 or 7:30 local time, so a Pacific time slot game is one played
                      at either 7 or 7:30 Pacific Time. Any game not played at a standard time falls into other. 
                      These are games typically on either weekends or holidays."),
                    h3("Days Rest"),
                    p("The days rest is the time from one game to the next. So, if a team plays one evening and 
                      plays again the next evening, that counts as one day of rest."),
                    h3("Home/Away"),
                    p("Choose stats for when a team plays on their home court or away. Either represents all
                      games."),
                    h1("Team Comparison"),
                    p("Select two teams for comparison. The parameters are structured the same as the League 
                      Margin of Victory page."),
                    p("The side-by-side boxes show the average points scored, points against, and margin of victory.
                      This can be used to see what might happen when those teams meet under the specified circumstances."),
                    p("Below the comparison is a table of games between those teams."),
                    p("One thing to note is for this 
                      site only games with 1, 2, or 3 days of rest are included. Notable games excluded are 
                      the first game of the season and the first game after the All Star Break. There is a 
                      small sample size of games with days of rest outside of 1 through 3, so they were excluded
                      and will not show up in the data table of the Team Comparison page."),
                    br(),
                    h3("Data Source"),
                    p("The data on this site was collected using the ", a("ballr package", href = "https://cran.r-project.org/web/packages/ballr/ballr.pdf"), 
                      "in R. It scrapes box scores from ", a("Basketball Reference", href = "https://www.basketball-reference.com/"), 
                      "."),
                    br(), br(), br(),
                    h4("Disclaimer"),
                    p("Information on this website is meant for educational purposes only. All logos and names belong
                      to the teams.")
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
                             "Select a season for the team comparison" , width= 12, 
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
