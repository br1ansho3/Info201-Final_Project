library(shiny)
library(shinyjs)
library(httr)
library(jsonlite)


source("api-keys.R")
# base & endpoints
recipe_uri <- "https://webknox-recipes.p.rapidapi.com/recipes/"
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
  
  
  # ingredients <- reactive({
  #   search_list <- paste(output$ingredients_1, output$ingredients_2, output$ingredients_3, output$ingredients_4, output$ingredients_5) 
  #   print(search_list)
  #   search_list
  # })
  # returns vector of recipes (name) for input (max: 5)
  output$recipes <- renderPrint({
    counter <- input$search
    if(is.null(counter) | counter < 1) return()
    search_list <- paste(output$ingredient_1, output$ingredient_2, output$ingredient_3, output$ingredient_4, output$ingredient_5, sep = ",")
    print(search_list)
    test <- "hi"
    # query <- ""
    # query
    # for(x in (1:counter)) {
    #   print("test")
    #   print("test")
    #   id <- paste0("ingredient_", x)
    #   if(input$id != "") {
    #     input_ingredients <- paste0(input_ingredients, ",")
    #   }
    # }
    
    # print(input_ingredients)
    # input_ingredients <- substr(input_ingredients, 1, nchar(input_ingredients) - 1)
    # query_param <- list(ingredients = list(input_ingredients))
    # ingredients <- list(ingredients = list(hi ="apple,milk"))
    # response <- GET(paste0(recipe_uri, recipe_endpoint), add_headers("X-RapidAPI-Key" = recipe_key), query
    #                 = query_param)
    # body <- content(response, "text")
    # data <- fromJSON(body)    
    # data$title

  })
}