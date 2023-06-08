#sidebar-----------------------------------------
#creates three drop down selection components
sidebar <- dashboardSidebar(
  selectInput("LA1", 
              "Select CPP", 
              choices =  CPPNames),
  selectInput("CompLA1", 
              "Select Comparator", 
              c("Scotland",CPPNames),
              selected = "Scotland"),
  selectInput("indicator", 
              "Select indicator", 
              indicators,
              selected = "Attainment")
)

#body--------------------------------------------

body <- dashboardBody(
  fluidPage(mainPanel(
    modalDialog(
      h3("Welcome to the Community Planning Outcomes Profile (CPOP). To get started use the map on the right to select a CPP and the communities that make up that CPP, and don’t forget to look at ‘help with this page’ in the top right hand corner of every page, as that gives a useful introduction to how to use each page. To explore others parts of the CPOP use the list on left to help you navigate the tool."),
      title = "CPOP",
      size = "l",
      easyClose = FALSE
    ),
    fluidRow(
      column(12,
      plotlyOutput("overtimeplot")
      )
    )
  )
  )
)

#create dashboard------------------------------------------------------

dashboardPage(title = "CPOP",
              dashboardHeader(title = "CPOP"),
              sidebar,
              body
              )