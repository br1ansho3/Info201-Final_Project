library(shiny)
library(httr)
library(jsonlite)
library(shinyjs)
# variables
intolerace <- c("dairy", "gluten", "caffeine")


#---------------

home_page <- tabPanel("About Us")
first_page <- tabPanel("Recipes given constraints")
second_page <- tabPanel("Nutrition of Food")
third_page <- tabPanel(
  "Recipe from Ingredients",
  titlePanel("What can I make?"),
  sidebarLayout(
    sidebarPanel(
      #textInput(inputId = "ingredient_1", label = "", placeholder = "Ingredient 1"),
      #textInput(inputId = "ingredient_2", label = "", placeholder = "Ingredient 2"),
      #textInput(inputId = "ingredient_3", label = "", placeholder = "Ingredient 3"),
      uiOutput("all_ingredients"),
      actionButton("add_ingredient", "Add Ingredient"),
      hr(),
      h1("Filters:"),
      selectInput(inputId = "intolerace", label = "Intolerance", choices = intolerace)
      
    ),
    mainPanel(
      
    )
  )
)



ui <- tagList(
  useShinyjs(),
  navbarPage(
    "Recipeeeez",
    home_page,
    first_page,
    second_page,
    third_page
  )
)