library(shiny)
library(shinyjs)

source("api-keys.R")
base_uri <- "https://webknox-recipes.p.rapidapi.com/recipes/"
query_param <- list(X-RapidAPI-Key = reci)


server <- function(input, output) {
  ingredients_list <- tagList()
  
  output$all_ingredients <- renderUI({
    counter <- input$add_ingredient
    print(counter)
    if(is.null(counter) | counter < 1) return()
    id <- paste0("ingredient_", counter)
    label <- paste0("Ingredient ", counter, ":")
    widget <- textInput(id, label)
    ingredients_list <<- tagAppendChild(ingredients_list, widget)
    if(counter == 5) disable("add_ingredient")
    ingredients_list
  })
  
  url <- reactive({
    response <- GET
  })
}