library(shiny)

#input for BMI and suggest Calories
gender_panel<- selectInput(
  "gender",
  label = "Gender",
  choices = c("Male", "Female"))

weight_panel <- numericInput(
  "weight",
  label = "Weight in kg",
  value = 50,
  min = 1,
  max = 1000)

height_panel <- numericInput(
  "height",
  label = "Height in cm",
  value = 160,
  min = 1,
  max = 1000)

age_panel <- numericInput(
  "age",
  label = "Age",
  value = 21,
  min = 1,
  max = 100)

activity_factor_panel <- selectInput(
  "activity_factor",
  label = "Exercise",
  choice = c("little or no", "1-3 days per week", "3-5 days per week",
             "6-7 days per week", "Sport or Physical job")
)

#input for recipe 

breakfast_panel <- textInput(
  "breakfast",
  label = "Breakfast"
)

lunch_panel <- textInput(
  "lunch",
  label = "Lunch"
)

dinner_panel <- textInput(
  "dinner",
  label = "Dinner"
)


                          
home_page <- tabPanel("About Us")
first_page <- tabPanel("Recipes given constraints")
second_page <- tabPanel("Nutrition calculator",
                        sidebarLayout(
                          sidebarPanel(gender_panel,
                                       weight_panel,
                                       height_panel,
                                       age_panel,
                                       activity_factor_panel,
                                       submitButton("Calculate"),
                                       br(),
                                       strong("Body Mass Index (BMI)"),
                                       textOutput("BMI_value"),
                                       br(),
                                       strong("Basic calories need"),
                                       textOutput("Calories_need")),
                          
                          mainPanel(breakfast_panel,
                                    br(),
                                    lunch_panel,
                                    br(),
                                    dinner_panel,
                                    br(),
                                    submitButton("Update", icon("refresh")),
                                    br(),
                                    strong("Nutrition Table"),
                                    dataTableOutput("Nutrition"))
                          
                        ))

third_page <- tabPanel("Recipe from Ingredients")



ui <- navbarPage(
  "Recipeeeez",
  home_page,
  first_page,
  second_page,
  third_page
)