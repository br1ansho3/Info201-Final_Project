library(shiny)
library(shinyjs)
library(httr)
library(jsonlite)


source("api-keys.R")
# base & endpoints
recipe_uri <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
recipe_endpoint <- "findByIngredients"



server <- function(input, output) {
  ingredients_list <- tagList()
  
  output$all_ingredients <- renderUI({
    counter <- input$add_ingredient
    print(counter)
    if(is.null(counter) | counter < 1) return()
    id <- paste0("ingredient_", counter + 1)
    label <- paste0("Ingredient ", counter + 1, ":")
    widget <- textInput(id, label)
    ingredients_list <<- tagAppendChild(ingredients_list, widget)
    if(counter == 4) disable("add_ingredient")
    ingredients_list
  })
  
  #vector of recipe names
  recipe_input <- eventReactive(input$search, {
    test <- paste(input$ingredient_1, input$ingredient_2, input$ingredient_3, input$ingredient_4, input$ingredient_5, sep = ",")
    while(substr(test, nchar(test), nchar(test)) == ",") {
      test <- gsub(".$", "", test)
    }
    param <- list(test)
    ingredients <- list(ingredients = param)
    response <- GET(paste0(recipe_uri, recipe_endpoint), add_headers("X-RapidAPI-Key" = recipe_key), query = ingredients)
    content <- content(response, type = "text")
    data <- fromJSON(content)
    data$title
    
  })
  
  output$recipes <- renderUI({
    ul <- tags$ul()
    for(name in recipe_input()) {
      li <- tags$li(name)
      ul <- tagAppendChild(ul, li)
    }
    recipe_list <- tagList(ul)
    recipe_list

  })
  
}  
  
