library(shiny)
library(shinyjs)
library(httr)
library(jsonlite)
library(dplyr)

source("api-keys.R")
# base & endpoints
recipe_uri <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
recipe_endpoint <- "findByIngredients"

generateRecipe <- function(id){
  uri_2 <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
  uri_full <- paste0(uri_2, id, "/information")
  response2 <- GET(uri_full, add_headers("X-RapidAPI-Key" = recipe_key))
  response_text2 <- content(response2, "text")
  response_list2 <- fromJSON(response_text2)
  ingredient <- response_list2$extendedIngredients %>%
    select(originalString)
  image_src <- response_list2$image
  Name <- response_list2$title
  steps <- response_list2$analyzedInstructions$steps[[1]]$step
  
  for (i in 1:length(steps)) {
    steps[i] <- paste0("Step ", i, ":", steps[i])
  }
  Tags <- c(response_list2$diets, response_list2$dishTypes,
            unlist(response_list2$cuisines))
  Tag <- paste0(Tags[1])
  
  for(i in 2:length(Tags)){
    Tag <- paste0(Tag, ", ", Tags[i])
  }
  information <- list("ingredient" = ingredient, "image" = image_src,
                      "name" = Name, "steps" = steps, "tags" = Tag)
}




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
  
  names_to_id <- NULL
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
    
    # make df for names to id
    names_to_id <<- data %>% 
      select(id, title)
    # return names
    names_to_id$title
  })
  
  
  output$recipes <- renderUI({
    ul <- tags$ul()
    for(name in recipe_input()) {
      li <- tags$li(name)
      ul <- tagAppendChild(ul, li)
    }
    recipe_list <- tagList(ul,
                           selectInput("recipes", "Choose a Recipe:", choices = names_to_id$title))
    recipe_list
  })
  
  information <- eventReactive(input$recipes, {
    id <- names_to_id[names_to_id$title == input$recipes, ]$id
    recipes_data <- generateRecipe(id)
  })
  
  output$htt <- renderUI({
    recipe_information <- information()
    recipe_ingredient <- recipe_information[[1]]
    recipe_name <- recipe_information[[3]]
    recipe_image <- recipe_information[[2]]
    recipe_tag <- recipe_information[[5]]
    numIng <- nrow(recipe_ingredient)
    recipe_step <- recipe_information[[4]]
    numStep <- length(recipe_step)
    list(withTags(div(class = "mytitle", h2(recipe_name),
                      p(img(src = 
                              "https://visualpharm.com/assets/147/Tags-595b40b85ba036ed117da472.svg",
                            width = "30px"),
                        em(recipe_tag)), hr()
    )),
    withTags(div(class = "myIngredient", img(src = recipe_image, width = "400px",
                                             style = "float: none; margin-right: 50px;
                                             margin-bottom: 10px"))), 
    
    # I want a fluid page
      fluidRow(
        column(
          4,
          withTags(div(
                   h3("Ingredients:"),
                   ul(lapply(1:numIng, function(i){
                     li(recipe_ingredient$originalString[i])
                   }), style = "list-style-type:disc; list-style-position: inside;") 
          ))
        ),
        column(
          4,
          offset = 1,
          h3("Steps:"), withTags(div(class = "myStep", lapply(1:numStep, function(i){
            p(recipe_step[i])
          })))
        )
      )
    



             
    )
  })
  
  output$stepp <- renderUI({
    recipe_information <- information()
    recipe_step <- recipe_information[[4]]
    numStep <- length(recipe_step)
    
    list(h3("Steps:"), withTags(div(class = "myStep", lapply(1:numStep, function(i){
      p(recipe_step[i])
    }))))
  })
  

}  


