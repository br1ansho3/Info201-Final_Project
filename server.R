library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
source("api-keys.R")
library(jsonlite)
library(httr)
library(RColorBrewer)
library(shinyjs)
library(DT)

recipe_uri <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
recipe_endpoint <- "findByIngredients"
nutrition_action <- "guessNutrition"

options(shiny.sanitize.errors = TRUE)

titles1 <- list(
  "calories" = "Calories", "carbs" = "Carbs(g)", "protein" = "Protein(g)",
  "fat" = "Fat(g)", "time_limit" = "Time(min)", "price" = "Price(dollar)"
)

titles2 <- list(
  "Calories" = "calories", "Carbs(g)" = "carbs" , "Protein(g)"= "protein",
  "Fat(g)" = "fat", "Time(min)" = "time_limit", "Price(dollar)" = "price"
)

generatepage <- function(recipe_information){
  recipe_price <- recipe_information[[8]]
  recipe_time <- recipe_information[[9]]
  recipe_name <- recipe_information[[3]]
  recipe_tag <- recipe_information[[5]]
  recipe_credit <- recipe_information[[6]]
  recipe_source <- recipe_information[[7]]
  recipe_image <- recipe_information[[2]]
  recipe_ingredient <- recipe_information[[1]]
  recipe_step <- recipe_information[[4]]
  recipe_nutrient <- recipe_information[[10]]
  numstep <- length(recipe_step)
  numing <- nrow(recipe_ingredient)
  h <- list(withTags(div(
    class = "mytitle", h2(recipe_name),
    p(
      img(
        src =
          paste0(
            "https://visualpharm.com/assets/147/",
            "Tags-595b40b85ba036ed117da472.svg"
          ),
        width = "30px"
      ),
      em(recipe_tag)
    ),
    p(
      img(src = "b864fae79c.png", width = "30px"),
      em(a(href = recipe_source, recipe_credit))
    )
  )),
  withTags(div(
    class = "myImage", section(img(
      src = recipe_image, width = "400px",
      style = "margin-right: 50px;
      margin-bottom: 10px"
    )),
    footer(
      h4("Ingredient"),
      ul(lapply(1:numing, function(i) {
        li(recipe_ingredient$originalString[i])
      }),
      style = "list-style-type:disc; list-style-position: inside;"
      )
    )
    )),
  withTags(div(
    class = "myStep",
    section(
      hr(),
      h4("Instruction"),
      lapply(1:numstep, function(i) {
        p(recipe_step[i])
      }),
      br(),
      br()
    ))))
  recipe_nutrient <- recipe_nutrient %>%
    mutate(amount = paste0(amount, unit)) %>%
    mutate(nutrient = title) %>%
    mutate(percentage = percentOfDailyNeeds)
  getPalette <- colorRampPalette(brewer.pal(12, "Set3"))
  colourCount <- nrow(recipe_nutrient)
  b <- ggplot(data = recipe_nutrient, aes(
    x = nutrient, y = percentage,
    fill = amount
  )) +
    geom_col(show.legend = FALSE, width = 0.7) + labs(
      title = "Nutrient Bars",
      x = "Nutrient Name",
      y = "% of Daily Need"
    ) +
    theme(axis.text.x = element_text(size = 6)) +
    scale_fill_manual(values = getPalette(colourCount)) +
    coord_flip() +
    scale_y_continuous(
      expand = c(0, 0),
      limits = c(0, max(recipe_nutrient$percentage) + 20)
    )
  b <- ggplotly(b) %>% layout(showlegend = FALSE)
  r <- withTags(div(section(
    p(recipe_price),
    p(recipe_time),
    br(),
    br(),
    hr(),
    h4("reference"),
    ul(
      li(a(
        href = "https://pngtree.com/free-icon",
        "free icons"
      ), "from pngtree.com"),
      li(p(a(
        href = paste0(
          "https://visualpharm.com/free-icons/",
          "tags-595b40b85ba036ed117da472"
        ),
        "tag icon"
      ), "from visualpharm.com"))
    )
  )))
  list(h,b,r)
}



generatelist <- function(query_parameter, time, budget, key) {
  uri <- paste0(
    "https://spoonacular-recipe-food-nutrition-v1.",
    "p.rapidapi.com/recipes/searchComplex"
  )
  response <- GET(uri,
    query = query_parameter,
    add_headers("X-RapidAPI-Key" = key)
  )
  response_text <- content(response, "text")
  response_list <- fromJSON(response_text)
  recipe_list <- data.frame(
    id = response_list$results$id,
    name = response_list$results$title,
    calories = response_list$results$calories,
    carbs = as.numeric(gsub("g", "", response_list$results$carbs)),
    protein = as.numeric(gsub("g", "", response_list$results$protein)),
    fat = as.numeric(gsub("g", "", response_list$results$fat)),
    price_per_serving = response_list$results$pricePerServing,
    servings = response_list$results$servings,
    time_limit = response_list$results$readyInMinutes,
    stringsAsFactors = FALSE
  )

  recipe_list <- recipe_list %>%
    mutate(price = round(price_per_serving * servings / 100, 1)) %>%
    filter(price <= budget & time_limit <= time) %>%
    select(id, name, calories, carbs, protein, fat, time_limit, price)

  return(recipe_list)
}
generaterecipe <- function(id) {
  uri_2 <- paste0(
    "https://spoonacular-recipe-food-nutrition-v1",
    ".p.rapidapi.com/recipes/"
  )
  uri_full <- paste0(uri_2, id, "/", "information")
  response2 <- GET(uri_full,
    query = list("includeNutrition" = TRUE),
    add_headers("X-RapidAPI-Key" = recipe_key)
  )
  response_text2 <- content(response2, "text")
  response_list2 <- fromJSON(response_text2)
  ingredient <- response_list2$extendedIngredients %>%
    select(originalString)
  image_src <- response_list2$image
  name <- response_list2$title
  steps <- response_list2$analyzedInstructions$steps[[1]]$step

  for (i in 1:length(steps)) {
    steps[i] <- paste0("Step ", i, ": ", steps[i])
  }
  Tags <- c(
    response_list2$diets, response_list2$dishTypes,
    unlist(response_list2$cuisines)
  )
  Tag <- paste0(Tags[1])

  for (i in 2:length(Tags)) {
    Tag <- paste0(Tag, ", ", Tags[i])
  }
  credit_info <- response_list2$creditsText
  url_info <- response_list2$sourceUrl
  price <- paste0(
    "Estimated Cost: ",
    round(response_list2$pricePerServing * response_list2$servings / 100, 1),
    "$"
  )

  time_ready <- paste0(
    "Estimated Ready In ",
    response_list2$readyInMinutes, " mins"
  )
  recipe_nutrient <- response_list2$nutrition$nutrients
  information <- list(
    "ingredient" = ingredient, "image" = image_src,
    "name" = name, "steps" = steps, "tags" = Tag,
    "credit" = credit_info, "source" = url_info,
    "price" = price, "time" = time_ready,
    "nutrient" = recipe_nutrient
  )
}


nutrition_endpoint <- paste0(recipe_uri,nutrition_action)
nutrition_table <- function(dish){
  nutrition_response <- GET(nutrition_endpoint, 
                  add_headers("X-RapidAPI-Key" = recipe_key), 
                  query = list(title = dish) )
  nutrition_response_text <- content(nutrition_response, type = "text", encoding = "ISO-8859-1")
  nutrition_response_data <- fromJSON(nutrition_response_text)
  
  calories <- nutrition_response_data$calories$value
  fat <- nutrition_response_data$fat$value
  protein <- nutrition_response_data$protein$value
  carbs <- nutrition_response_data$carbs$value
  
  nutrition_list <- c(calories,fat,protein,carbs)
  
  nutrition_table <- data.frame(Nutrition = c("Calories", "Fat", "Protein","Carbs"), 
                                Value = nutrition_list)
  return(nutrition_table)
}



server <- function(input, output, session) {
# page one  
  get_recipes <- eventReactive(input$submit, {
    offset_r <- sample(0:800, 1)
    query_r <- list(
      "limitLicense" = TRUE, "offset" = offset_r, "number" = 80,
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
      "addRecipeInformation" = "true",
      "instructionsRequired" = "true"
    )
    recipe_data <- generatelist(
      query_r, input$timelimit, input$pricelimit,
      recipe_key
    )
    return(recipe_data)
  })

  output$recipe <- renderUI({
    if (input$submit == 0) return()
    recipe_list <- get_recipes()
    selectInput("recipes",
      label = "Choose a recipe to explore",
      choices = recipe_list$name, selected = recipe_list$name[1]
    )
  })
  output$choose_y <- renderUI({
    if (input$submit == 0) return()
    recipe_list <- get_recipes()
    selectInput("ylabel",
      label = "Choose a variable on y-axis",
      choices = titles2, selected = "calories"
    )
  })
  output$choose_x <- renderUI({
    if (input$submit == 0) return()
    recipe_list <- get_recipes()
    selectInput("xlabel",
      label = "Choose a variable on x-axis",
      choices = titles2, selected = "price"
    )
  })
  output$scatter <- renderPlotly({
    if (input$submit == 0) return()
    recipe_list <- get_recipes()
    data_var <- recipe_list %>% select("name", input$ylabel, input$xlabel)
    p <- ggplot(data = data_var) +
      geom_point(mapping = aes_string(
        x = input$xlabel, y = input$ylabel,
        col = "name"
      ), show.legend = FALSE) +
      labs(
        title = paste0(
          titles1[[input$ylabel]],
          " versus ",
          titles1[[input$xlabel]],
          " of Recipes on the list"
        ),
        x = titles1[[input$xlabel]], y = titles1[[input$ylabel]]
      ) + theme_bw() + theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black")
      )
    p <- ggplotly(p) %>% layout(showlegend = FALSE)
    return(p)
  })
  observeEvent(event_data("plotly_click"), {
    newvalue <- event_data("plotly_click")
    yname <- input$ylabel
    xname <- input$xlabel
    recipe_list <- get_recipes()
    data_var <- recipe_list %>% select("name", input$ylabel, input$xlabel)
    newrow <- data_var %>% filter(get(yname) == newvalue$y & get(xname) ==
      newvalue$x)
    updateSelectInput(session, "recipes", selected = newrow$name)
  })
  information <- eventReactive(input$recipes, {
    recipe_list <- get_recipes()
    id_of_interest <- recipe_list[recipe_list$name == input$recipes, ]$id
    recipe_data <- generaterecipe(id_of_interest)
  })
  output$htt <- renderUI({
    if (input$submit == 0) return(list(h2("Recipe"),
                            withTags(div(footer(h4("Ingredient")))),
                          withTags(section(hr(),h4("Instruction")))))
    recipe_information <- information()
    generatepage(recipe_information)[[1]]
  })
  output$refer <- renderUI({
    if (input$submit == 0) return()
    recipe_information <- information()
    generatepage(recipe_information)[[3]]
  })

  output$bar <- renderPlotly({
    if (input$submit == 0) return()
    recipe_information <- information()
    generatepage(recipe_information)[[2]]
  })
# end of page 1
  
#page 2
  
  
  dish_list <- tagList()
  
  output$dish_output <- renderUI({
    n <- input$add_btn
    print(n)
    if(is.null(n) | n < 1) return()
    dish_id <- paste0("dish_", n )
    dish_label <- paste0("Dish  ", n , ":")
    dish_widget <- textInput(dish_id, dish_label)
    dish_list <<- tagAppendChild(dish_list, dish_widget)
    
    if(n > 6) {disable("add_btn")}
    dish_list
  })
  
  output$n <- renderText(input$add_btn)
  
  #BMI
  BMI_cal <- eventReactive(input$calculate,
                           input$weight/(input$height*input$height/10000))
  output$BMI_value <- renderText({
    return(BMI_cal())
  })
  
  #Basic Calories
  sex <- reactive(input$gender)
  activity <- reactive(input$activity_factor)
  BMR_value <- eventReactive(input$calculate,{
    if (sex()== "Female") {
      BMR_cal <- 655+9.6*input$weight+1.8*input$height - 4.7*input$age
      return(BMR_cal)}
    else if (sex() == "Male") {
      BMR_cal <- 66+13.7*input$weight+5*input$height - 6.8*input$age
      return(BMR_cal)}})
  
  #activity level
  BMR<- eventReactive(input$calculate,{
    if (activity() == "little or no"){
      BMR_factor <- BMR_value() * 1.2
      return(BMR_factor)}
    else if (activity() == "1-3 days per week"){
      BMR_factor <- BMR_value() * 1.375
      return(BMR_factor)}
    else if (activity() == "3-5 days per week"){
      BMR_factor <- BMR_value() * 1.55
      return(BMR_factor)}
    else if (activity() == "6-7 days per week"){
      BMR_factor <- BMR_value() * 1.725
      return(BMR_factor)}
    else if (activity() == "Sport or Physical job"){
      BMR_factor <- BMR_value() * 1.9
      return(BMR_factor)}
  })
  
  
  #output for calories need
  output$Calories_need <- renderText(
    paste0(BMR(), "Cal"))
  
  
  #calories
  output$Nutrition <- renderDataTable({    
    
    if (input$add_btn == 1)
    {dish1_cal <- nutrition_table(input$dish_1)
    nutrition_table <- datatable(dish1_cal)
    return(nutrition_table)}
    else if (input$add_btn==2) 
    {dish1_cal <- nutrition_table(input$dish_1)
    dish2_cal <- nutrition_table(input$dish_2)
    nutrition_cal <- bind_rows(dish1_cal, dish2_cal)
    nutrition_table_total <- aggregate(cbind(Value) ~ Nutrition, data=nutrition_cal, FUN=sum)
    nutrition_table <- datatable(nutrition_table_total)
    return(nutrition_table)}
    else if (input$add_btn==3)
    {dish1_cal <- nutrition_table(input$dish_1)
    dish2_cal <- nutrition_table(input$dish_2)
    dish3_cal <- nutrition_table(input$dish_3)
    nutrition_cal <- bind_rows(dish1_cal, dish2_cal, dish3_cal)
    nutrition_table_total <- aggregate(cbind(Value) ~ Nutrition, data=nutrition_cal, FUN=sum)
    nutrition_table <- datatable(nutrition_table_total)
    return(nutrition_table)}
    else if (input$add_btn==4)
    {dish1_cal <- nutrition_table(input$dish_1)
    dish2_cal <- nutrition_table(input$dish_2)
    dish3_cal <- nutrition_table(input$dish_3)
    dish4_cal <- nutrition_table(input$dish_4)
    nutrition_cal <- bind_rows(dish1_cal, dish2_cal, dish3_cal, dish4_cal)
    nutrition_table_total <- aggregate(cbind(Value) ~ Nutrition, data=nutrition_cal, FUN=sum)
    nutrition_table <- datatable(nutrition_table_total)
    return(nutrition_table)}
    else if (input$add_btn==5)
    {dish1_cal <- nutrition_table(input$dish_1)
    dish2_cal <- nutrition_table(input$dish_2)
    dish3_cal <- nutrition_table(input$dish_3)
    dish4_cal <- nutrition_table(input$dish_4)
    dish5_cal <- nutrition_table(input$dish_5)
    nutrition_cal <- bind_rows(dish1_cal, dish2_cal, dish3_cal, dish4_cal, dish5_cal)
    nutrition_table_total <- aggregate(cbind(Value) ~ Nutrition, data=nutrition_cal, FUN=sum)
    nutrition_table <- datatable(nutrition_table_total)
    return(nutrition_table)}
    else if (input$add_btn==6)
    {dish1_cal <- nutrition_table(input$dish_1)
    dish2_cal <- nutrition_table(input$dish_2)
    dish3_cal <- nutrition_table(input$dish_3)
    dish4_cal <- nutrition_table(input$dish_4)
    dish5_cal <- nutrition_table(input$dish_5)
    dish6_cal <- nutrition_table(input$dish_6)
    nutrition_cal <- bind_rows(dish1_cal, dish2_cal, dish3_cal, dish4_cal, dish5_cal, dish5_cal)
    nutrition_table_total <- aggregate(cbind(Value) ~ Nutrition, data=nutrition_cal, FUN=sum)
    nutrition_table <- datatable(nutrition_table_total)
    return(nutrition_table)}
    
  })
  
  #end Page 2
  
#page 3
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
  
  
  output$recipes_3 <- renderUI({
    ul <- tags$ul()
    for(name in recipe_input()) {
      li <- tags$li(name)
      ul <- tagAppendChild(ul, li)
    }
    recipe_list <- tagList(ul,
                           selectInput("recipes_3", "Choose a Recipe:", choices = names_to_id$title))
    recipe_list
  })
  
  information_3 <- eventReactive(input$recipes_3, {
    id <- names_to_id[names_to_id$title == input$recipes_3, ]$id
    recipes_data <- generaterecipe(id)
  })
  
  output$htt_3 <- renderUI({
    recipe_information <- information_3()
    generatepage(recipe_information)[[1]]
  })
  
  output$bar_3 <- renderPlotly({
    recipe_information <- information_3()
    generatepage(recipe_information)[[2]]
  })
  
  output$refer_3 <- renderUI({
    recipe_information <- information_3()
    generatepage(recipe_information)[[3]]
  })
}
