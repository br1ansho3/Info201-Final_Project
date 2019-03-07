library(shiny)

home_page <- tabPanel("About Us")
first_page <- tabPanel("Recipes given constraints")
second_page <- tabPanel("Nutrition of Food")
third_page <- tabPanel("Recipe from Ingredients")



ui <- navbarPage(
  "Recipeeeez",
  home_page,
  first_page,
  second_page,
  third_page
)