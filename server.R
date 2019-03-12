library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
source("api-keys.R")
library(jsonlite)
library(httr)


titles <- list("Calories" = "Calories", "Carbs" ="Carbs(g)", "Protein" = "Protein(g)", 
             "Fat" = "Fat(g)","Time" = "Time(min)", "Price" = "Price(dollar)")

generateList <- function(query_parameter, time, budget, key){
  uri <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/searchComplex"
  response <- GET(uri, query = query_parameter, add_headers("X-RapidAPI-Key" = key))
  response_text <- content(response, "text")
  response_list <- fromJSON(response_text)
  recipe_list <- data.frame(
    id = response_list$results$id,
    Name = response_list$results$title,
    Calories = response_list$results$calories,
    Carbs = as.numeric(gsub("g", "",response_list$results$carbs)),
    Protein = as.numeric(gsub("g", "",response_list$results$protein)),
    Fat = as.numeric(gsub("g", "",response_list$results$fat)),
    Price_per_serving = response_list$results$pricePerServing,
    Servings = response_list$results$servings,
    Time = response_list$results$readyInMinutes,
    stringsAsFactors = FALSE)
  
  recipe_list <- recipe_list %>% 
    mutate(Price = round(Price_per_serving*Servings/100,1)) %>% 
    filter(Price <= budget & Time <= time) %>% 
    select(id, Name, Calories, Carbs, Protein, Fat, Time, Price)
  
  return(recipe_list)
}
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


server <- function(input, output, session) {
  get_recipes <- eventReactive(input$submit, {
    query_r <- list("limitLicense" = TRUE, "offset" = 0, "number" = 100,
              "minCalories" = input$calories[1], 
              "maxCalories" = input$calories[2], 
              "minFat" = input$fat[1], "maxFat" = input$fat[2],
              "minProtein" = input$protein[1], 
              "maxProtein" = input$protein[2],
              "minCarbs" = input$carbs[1], 
              "maxCarbs" = input$carbs[2],
              "minCalcium" = input$calcium[1], 
              "maxCalcium" = input$calcium[2],
              "minVitaminA" = input$va[1], 
              "maxVitaminA" = input$va[2],
              "minVitaminC" = input$vc[1], 
              "maxVitaminC" = input$vc[2],
              "minVitaminD" = input$vd[1], 
              "maxVitaminD" = input$vd[2],
              "minVitaminE" = input$ve[1], 
              "maxVitaminE" = input$ve[2],
              "addRecipeInformation" = TRUE,
              "instructionsRequired" = TRUE)
    recipe_data <- generateList(query_r, input$timelimit, input$pricelimit, 
                                recipe_key)
    return(recipe_data)
    })
  
  output$recipe <- renderUI({
    if(input$submit == 0) return()
    recipe_list <- get_recipes()
    selectInput("recipes", label = "choose a recipe to explore", 
                 choices = recipe_list$Name, selected = recipe_list$Name[1])
    
  })
  output$choose_y <- renderUI ({
    if(input$submit == 0) return()
    recipe_list <- get_recipes()
    selectInput("ylabel", label = "Choose a variable on y-axis", 
        choices = colnames(recipe_list)[3:8], selected = colnames(recipe_list)[3])
  })
  output$choose_x <- renderUI ({
    if(input$submit == 0) return()
    recipe_list <- get_recipes()
    selectInput("xlabel", label = "Choose a variable on y-axis", 
        choices = colnames(recipe_list)[3:8], selected = colnames(recipe_list)[8])
  })
  output$scatter <- renderPlotly({
    if(input$submit == 0) return()
    recipe_list <- get_recipes()
    data_var <- recipe_list %>% select("Name", input$ylabel, input$xlabel)
    p <- ggplot(data = data_var) +
      geom_point(mapping = aes_string(x = input$xlabel, y =input$ylabel, 
                                      col = "Name"), show.legend = FALSE) +
      labs(
        title = paste0(titles[[input$ylabel]], 
                       " versus ", 
                       titles[[input$xlabel]], 
                       " of Recipes on the list"),
        x = titles[[input$xlabel]], y=titles[[input$ylabel]]
      ) + theme(panel.background = element_blank())
    p <- ggplotly(p) %>% layout(showlegend = FALSE)
    return(p)
  })
  observeEvent(event_data("plotly_click"),{
    newValue <- event_data("plotly_click")
    yname <- input$ylabel
    xname <- input$xlabel
    recipe_list <- get_recipes()
    data_var <- recipe_list %>% select("Name", input$ylabel, input$xlabel)
    newRow <- data_var %>% filter(get(yname) == newValue$y & get(xname) == 
                                    newValue$x)
    updateSelectInput(session, "recipes", selected = newRow$Name)
  })
  information <- eventReactive(input$recipes,{
    recipe_list <- get_recipes()
    id_of_interest <- recipe_list[recipe_list$Name == input$recipes,]$id
    recipe_data <- generateRecipe(id_of_interest)
  })
  output$htt <- renderUI({
    if(input$submit == 0) return()
    recipe_information <- information()
    recipe_ingredient <- recipe_information[[1]]
    recipe_name <- recipe_information[[3]]
    recipe_image <- recipe_information[[2]]
    recipe_tag <- recipe_information[[5]]
    numIng <- nrow(recipe_ingredient)
    tags = ""
    list(withTags(div(class = "mytitle", h2(recipe_name),
                      p(img(src = 
                              "https://visualpharm.com/assets/147/Tags-595b40b85ba036ed117da472.svg",
                            width = "30px"),
                        em(recipe_tag)), hr()
    )),
    withTags(div(class = "myIngredient", img(src = recipe_image, width = "400px",
                                             style = "float: left; margin-right: 50px;
                                             margin-bottom: 10px"), 
                 ul(lapply(1:numIng, function(i){
                   li(recipe_ingredient$originalString[i])
                 }), style = "list-style-type:disc; list-style-position: inside;"), 
                 hr())))
  })
  output$stepp <- renderUI({
    if(input$submit == 0) return()
    recipe_information <- information()
    recipe_step <- recipe_information[[4]]
    numStep <- length(recipe_step)
    withTags(div(class = "myStep", lapply(1:numStep, function(i){
      p(recipe_step[i])
    })))})
}