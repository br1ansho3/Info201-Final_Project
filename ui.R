library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
source("api-keys.R")
library(jsonlite)
library(httr)
cuisine_list <- list("African" = "african",
                     "Chinese" = "chinese",
                      "Japanese"="japanese", 
                      "Korean" = "korean", 
                        "Vietnamese" = "vietnamese", 
                       "Thai" = "thai", 
                       "Indian" = "indian", 
                        "British" = "british", 
                     "Irish" = "irish", 
                     "French" = "french", 
                     "Italian"="italian", 
                    "Mexican" = "mexican", 
                    "Spanish" = "spanish", 
                    "middle eastern" = "middle eastern", 
                    "Jewish" = "jewish", 
                    "American" = "american", 
                    "Cajun"="cajun", 
                    "Southern" = "southern", 
                    "Greek" = "greek", 
                      "German" = "german", 
                    "Nordic" = "nordic", 
                    "Eastern European" = "eastern european", 
                     "Caribbean" = "caribbean", "Latin" =  "latin american")



home_page <- tabPanel("About Us")
first_page <- tabPanel("Recipes given Nutrition", 
  fluidRow(titlePanel("Give Me Some Nutrition"),
  column(3, wellPanel(sliderInput("calories", label = strong("Choose range of calories"), min=10,max=1000,
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

  column(2,conditionalPanel(condition = "input.submit > 0",
  uiOutput("recipe"),
  uiOutput("choose_y"),
  uiOutput("choose_x")))
  #selectInput("cuisine", label = strong("Choose cuisine(s)"), choices = ),
, 
column(7,tabsetPanel(tabPanel("Recipe Details", uiOutput("htt"), 
                              uiOutput("stepp")), 
                     tabPanel("Two Variabls Plot",plotlyOutput("scatter"))))

))
second_page <- tabPanel("Nutrition of Food")
third_page <- tabPanel("Recipe from Ingredients")



ui <- navbarPage(
  "Recipeeeez",
  home_page,
  first_page,
  second_page,
  third_page
)