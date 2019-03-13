library(shiny)
library(httr)
library(dplyr)
library(jsonlite)
library(ggplot2)
library(DT)

#get data
source("api-keys.R")
base_url <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
request <- "/recipes"
action <- "/guessNutrition"
endpoint <- paste0(base_url, request, action)

#function to generate nutrition table
nutrition_table <- function(dish){
  response <- GET(endpoint, 
                  add_headers("X-RapidAPI-Key" = recipe_key), 
                  query = list(title = dish) )
  response_text <- content(response, type = "text", encoding = "ISO-8859-1")
  response_data <- fromJSON(response_text)
  
  calories <- response_data$calories$value
  fat <- response_data$fat$value
  protein <- response_data$protein$value
  carbs <- response_data$carbs$value
  
  nutrition_list <- c(calories,fat,protein,carbs)
  
  nutrition_table <- data.frame(Nutrition = c("Calories", "Fat", "Protein","Carbs"), 
                                Value = nutrition_list)
  return(nutrition_table)
}


server <- function(input, output) {
  #BMI
  BMI_cal <- reactive(input$weight/(input$height*input$height))
  output$BMI_value <- renderText({
    return(BMI_cal())
  })
  
  #Basic Calories
  sex <- reactive(input$gender)
  activity <- reactive(input$activity_factor)
  BMR_value <- reactive(
    if (sex()== "Female") {
      BMR_cal <- 655+9.6*input$weight+1.8*input$height - 4.7*input$age
      return(BMR_cal)}
    else if (sex() == "Male") {
      BMR_cal <- 66+13.7*input$weight+5*input$height - 6.8*input$age
      return(BMR_cal)})
  
  #activity level
  BMR<- reactive(
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
  )
  
  
  #output for calories need
  output$Calories_need <- renderText(
    paste0(BMR(), "Cal"))
  
  
  #calories
  output$Nutrition <- renderDataTable({    
    
    breakfast_dish <- input$breakfast
    lunch_dish <- input$lunch
    dinner_dish <- input$dinner
    breakfast_cal <- nutrition_table(breakfast_dish)
    lunch_cal <- nutrition_table(lunch_dish)
    dinner_cal <- nutrition_table(dinner_dish)
    
    nutrition_cal <- rbind(breakfast_cal, lunch_cal, dinner_cal)
    nutrition_table_total <- aggregate(cbind(Value) ~ Nutrition, data=nutrition_cal, FUN=sum)
    nutrition_table <- datatable(nutrition_table_total)
    return(nutrition_table)
  })
}