library(shiny)

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
      textInput(inputId = "ingredient_1", label = "Ingredient 1", placeholder = "Ingredient 1"),
      uiOutput("all_ingredients"),
      actionButton("add_ingredient", "Add Ingredient"),
      actionButton("search", "Search"),
      hr(),
      h1("Filters:"),
      selectInput(inputId = "intolerace", label = "Intolerance", choices = intolerace),
      uiOutput("recipes")
      
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