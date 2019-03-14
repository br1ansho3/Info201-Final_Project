library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
source("api-keys.R")
library(jsonlite)
library(httr)
library(shinyWidgets)
library(RColorBrewer)
library(shinyjs)


home_page <- tabPanel("About Us")
first_page <- tabPanel("Recipes given Nutrition", 
  fluidRow(
  column(3,
  wellPanel(style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1",
            chooseSliderSkin("Modern", color = "#9CBFC1"),
  titlePanel(h3(class = "mytitle", "Give Me Some Nutrition")),
  sliderInput("calories", label = strong("Choose range of calories")
              , min=10,max=1000,
              value = c(10,2000)),
  sliderInput("fat", label = strong("Choose range of fat (gram)"), min=0,max=50,
              value = c(0,50)), 
  sliderInput("protein", label = strong("Choose range of protein (gram)"), min=0,max=100,
              value = c(0,100)),
  sliderInput("carbs", label = strong("Choose range of Carbs (gram)"), min=0,max=200,
              value = c(0,200)),
  sliderInput("fiber", label = strong("Choose range of fiber (gram)"), min=0,max=100,
              value = c(0,100)),
  sliderInput("calcium", label = strong("Choose range of Calcium (milligram)"), min=0,max=1000,
              value = c(0,1000)),
  sliderInput("va", label = strong("Choose range of VitaminA (milligram)"), min=0,max=1000,
              value = c(0,1000)),
  sliderInput("vc", label = strong("Choose range of VitaminC (milligram)"), min=0,max=1000,
              value = c(0,1000)),
  sliderInput("vd", label = strong("Choose range of VitaminD (milligram)"), min=0,max=1000,
              value = c(0,1000)),
  sliderInput("ve", label = strong("Choose range of VitaminE (milligram)"), min=0,max=1000,
              value = c(0,1000)),
  sliderInput("timelimit", label = strong("Time consumed limit (min)"), min=0,max=120,
              value = 120),
  sliderInput("pricelimit", label = strong("Budget (dollar)"), min=0,max=30,
              value = 15),
  actionButton("submit", label = "Submit"))),

  column(2, 
         conditionalPanel(condition = "input.submit > 0",
  wellPanel(style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1",uiOutput("recipe"),
  uiOutput("choose_y"),
  uiOutput("choose_x"))))
  #selectInput("cuisine", label = strong("Choose cuisine(s)"), choices = ),
,
    column(7,tabsetPanel(tabPanel("Recipe Details", uiOutput("htt"),
                    tags$section(tags$hr(),plotlyOutput("bar"),
                                 tags$br(),tags$br(),tags$br()),
                    uiOutput("refer")),
                     tabPanel("Two Variabls Plot",plotlyOutput("scatter"))))

))
second_page <- tabPanel("Nutrition of Food")

third_page <- tabPanel(
  "Recipe from Ingredients",
  titlePanel("What can I make?"),
  sidebarLayout(
    sidebarPanel(style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1",
      textInput(inputId = "ingredient_1", label = "Ingredient 1"),
      uiOutput("all_ingredients"),
      actionButton("add_ingredient", "Add Ingredient"),
      actionButton("search", "Search"),
      hr(),
      h3("List of Recipes"),
      # selectInput(inputId = "intolerace", label = "Intolerance", choices = intolerace),
      uiOutput("recipes_3")
    ),
    mainPanel(
      column(7,
        uiOutput("htt_3"),
        tags$section(tags$hr(), plotlyOutput("bar_3"), tags$br(), tags$br(), tags$br()),
        uiOutput("refer_3")
      )
    )
  )
)




ui <- tagList(
  navbarPage(
    title = "RecipEZ",
    home_page,
    first_page,
    second_page,
    third_page,
    theme = "style.css",
    useShinyjs()
  )
)