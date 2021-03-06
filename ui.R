library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
source("api-keys.R")
library(jsonlite)
library(httr)
library(shinyWidgets)
library(RColorBrewer)
library(shinyjs)
library(lintr)
library(styler)

home_page <- tabPanel(
  "About Us",
  fluidPage(
    titlePanel(h2("About Us", style = "color:#9CBFC1")),
    sidebarLayout(
      sidebarPanel(
        style = "background-color: #FFFFF0; border:hidden #FFFFF0;
        color:#9CBFC1",
        img(
          src = "https://media.licdn.com/dms/image/C5603AQH1WCRU6fKPkw/profile-displayphoto-shrink_200_200/0?e=1557964800&v=beta&t=y6uk2g4kjGyAR6XBO0g6gwmu1AGI7JpzecEo8lSBtfE",
          style = "display: block; margin-left: auto; margin-right: auto;",
          width = "100x"
        ),
        h3("Henry Bates"), "Hello! I'm Henry and I'm a Junior in the
        Environmental Science program. I came to Informatics
        because I want to learn how I can better apply data
        visualization to my field. Enjoy some new recipes!",
        br(),
        br(),
        "Email: batesh2@uw.edu",
        hr(),
        img(
          src = "https://media.licdn.com/dms/image/C5603AQHht_LSnn3rKA/profile-displayphoto-shrink_800_800/0?e=1557964800&v=beta&t=uVI8QhDBDtoYcrvOImXm56yO8sErTJ5bCQ5MTCeemwk",
          style = "display: block; margin-left: auto; margin-right: auto;",
          width = "100px"
        ),
        h3("Brian Hsu"), "Hi, my name is Brian. I'm a Junior studying
        Mathematics. I'm taking this class because I love UI
        design and hope to double major in Informatics. We
        hope you find some food youve never even thought to
        cook before.",
        br(),
        br(),
        "Email: brianhsu@uw.edu",
        hr(),
        img(
          src = "https://s3.amazonaws.com/handshake.production/app/public/assets/students/13154183/profile/data.?1542575324",
          style = "display: block; margin-left: auto; margin-right: auto;",
          width = "100x"
        ),
        h3("Ruiqi Yan"), "Hello! I am Rachel, a Senior in Statistics Major at
        the University of Washington. I choose recipes as
        topic of my final project because I am really
        interested in exploring delicacy. Informatics taught
        me a lot about data visualization and R application,
        which well relates to my field. Stay healthy and enjoy
        these various recipes!",
        br(),
        br(),
        "Email: ruiqiy3@uw.edu",
        hr(),
        img(
          src = "https://scontent-sea1-1.xx.fbcdn.net/v/t1.0-9/20638469_495476044137055_2569655792785378768_n.jpg?_nc_cat=101&_nc_ht=scontent-sea1-1.xx&oh=4e80be0cbc3b8bf64b148f3289388850&oe=5D259B7F",
          style = "display: block; margin-left: auto; margin-right: auto;",
          width = "100x"
        ),
        h3("Chunmo Chen "), "Hi! I'm Mary and I'm a senior in the Neurobiology
        Major. The informatics classes are so cool and I
        want to learn more about how to present and analyze
        lab data. It is also so fun to use API's and study
        about recipes for every day! Bon Appetit! ",
        br(),
        br(),
        "Email: ccm1997@uw.edu",
        hr(),
        width = 2
      ),
      mainPanel(
        style = "color:#9CBFC1",
        h1("What Recipes Can You Find?"),
        img(
          src = "https://www.bi-lo.com/-/media/media/whatsnew/14_italian_brochure_spaghettimeatballs_028_banner.png?la=en&mw=1382",
          width = "1000px",
          height = "300px",
          style = "display: block; margin-left: auto; margin-right: auto;"
        ),
        h2("A Classic for Everyone"), h4(em("Spaghetti with meatballs is a
                                            classic dish loved by many. However
                                            many people around the world are
                                            vegatarian or don't have all the
                                            ingredients available to them.
                                            Click on our",
                                            strong("Recipes from Ingredients"),
                                            "tab above to find dishes that work
                                            just for you or your family when
                                            you enter the ingredients you want
                                            to use!"
        )),
        hr(),
        img(
          src = "https://i0.wp.com/sautemagazine.com/wp-content/uploads/2018/01/Pimp-My-Noodles_10-MINUTE-RAMEN-banner.jpg?ssl=1",
          width = "1000px",
          height = "300px",
          style = "display: block; margin-left: auto; margin-right: auto;"
        ),
        h2("Staying Healthy"), h4(em("It can be tough to resist a big bowl of
                                     ramen everyday but we can't eat everything
                                     that we want and stay healthy. It can be
                                     tough to find out the nurtional value of
                                     prepared dishes so we provide that under
                                     the", strong("Nutrition of Food"), "tab
                                     above. Search for a dish or food and
                                     explore the nutritional content and start
                                     planning a great diet today!")),
        hr(),
        img(
          src = "https://hips.hearstapps.com/del.h-cdn.co/assets/18/11/2048x1024/landscape-1520956952-chicken-tacos-horizontal.jpg?resize=1200:*",
          width = "1000px",
          height = "300px",
          style = "display: block; margin-left: auto; margin-right: auto;"
        ),
        h2("Adding a Personal Touch"), h4(em("Finding the foods that agree with
                                             you and your eating goals can be
                                             tricky. The", strong("Recipes from
                                             Nutrition"), "tab allows you to
                                             set your needs to specific
                                             nutritional amounts. Then you can
                                             explore the recipes that will
                                             leave you feeling ready for
                                             anything!")),
        hr(),
        img(
          src = "http://www.edwinascatering.com/images/banner-food.jpg",
          width = "1000px",
          height = "300px",
          style = "display: block; margin-left: auto; margin-right: auto;"
        ),
        h2("Where We Find the Recipes"), h4(em("We sourced our data from an API
                                               run by", strong("Spoonacular"),
                                               ". This allows us to provide the
                                               coolest new recipes that work
                                               for even the pickiest eaters.
                                               Let us know what the coolest
                                               dish you find is!",
          br(),
          hr(),
          h3("Thanks for visiting!")
        ))
      )
    )
  )
)
first_page <- tabPanel(
  "Recipes given Nutrition",
  fluidRow(
    column(
      3,
      wellPanel(
        style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1",
        chooseSliderSkin("Modern", color = "#9CBFC1"),
        titlePanel(h3(class = "mytitle", "Give Me Some Nutrition")),
        sliderInput("calories",
          label =
            strong("Choose range of calories"), min = 10, max = 2000,
          value = c(10, 1000)
        ),
        sliderInput("fat",
          label = strong("Choose range of fat (gram)"), min = 0,
          max = 50, value = c(0, 50)
        ),
        sliderInput("protein",
          label = strong("Choose range of protein (gram)"),
          min = 0, max = 200,
          value = c(0, 200)
        ),
        sliderInput("carbs",
          label = strong("Choose range of Carbs (gram)"),
          min = 0, max = 200,
          value = c(0, 200)
        ),
        sliderInput("fiber",
          label = strong("Choose range of fiber (gram)"),
          min = 0, max = 200,
          value = c(0, 200)
        ),
        sliderInput("calcium",
          label = strong("Choose range of Calcium (milligram)"),
          min = 0, max = 2000,
          value = c(0, 2000)
        ),
        sliderInput("va",
          label = strong("Choose range of VitaminA (milligram)"),
          min = 0, max = 2000,
          value = c(0, 2000)
        ),
        sliderInput("vc",
          label = strong("Choose range of VitaminC (milligram)"),
          min = 0, max = 2000,
          value = c(0, 2000)
        ),
        sliderInput("vd",
          label = strong("Choose range of VitaminD (milligram)"),
          min = 0, max = 2000,
          value = c(0, 2000)
        ),
        sliderInput("ve",
          label = strong("Choose range of VitaminE (milligram)"),
          min = 0, max = 2000,
          value = c(0, 2000)
        ),
        sliderInput("timelimit",
          label = strong("Time consumed limit (min)"),
          min = 0, max = 120,
          value = 120
        ),
        sliderInput("pricelimit",
          label = strong("Budget (dollar)"), min = 0, max = 30,
          value = 15
        ),
        actionButton("submit", label = "Submit")
      )
    ),

    column(
      2,
      conditionalPanel(
        condition = "input.submit > 0",
        wellPanel(
          style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1", uiOutput("recipe"),
          uiOutput("choose_y"),
          uiOutput("choose_x")
        )
      )
    )
    # selectInput("cuisine", label = strong("Choose cuisine(s)"), choices = ),
    ,
    column(7, tabsetPanel(
      tabPanel(
        "Recipe Details", uiOutput("htt"),
        tags$section(
          tags$hr(), plotlyOutput("bar"),
          tags$br(), tags$br(), tags$br()
        ),
        uiOutput("refer")
      ),
      tabPanel("Compare Dishes", plotlyOutput("scatter"))
    ))
  )
)
second_page <- navbarMenu(
  "Nutrition Calculator",
  tabPanel(
    "Nutrition Calculator",
    sidebarLayout(
      sidebarPanel(
        style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1",
        selectInput("gender", label = "Gender", choices = c("Male", "Female")),
        numericInput("weight",
          label = "Weight in kg", value = 50, min = 1,
          max = 1000
        ),
        numericInput("height",
          label = "Height in cm", value = 160, min = 1,
          max = 1000
        ),
        numericInput("age", label = "Age", value = 21, min = 1, max = 100),
        selectInput("activity_factor",
          label = "Exercise", choice =
            c(
              "little or no", "1-3 days per week",
              "3-5 days per week", "6-7 days per week",
              "Sport or Physical job"
            )
        ),
        actionButton("calculate", "Calculate")
      ),
      mainPanel(
        style = "color:#9CBFC1",
        strong("Body Mass Index (BMI)"),
        textOutput("BMI_value"),
        br(),
        br(),
        br(),
        strong("Calories Needed"),
        textOutput("Calories_need"),
        br(),
        br(),
        br(),
        strong("BMI scale"),
        br(),
        img(src = "BMI_value_scale.png", width = "500", height = "200")
      )
    )
  ),

  tabPanel(
    "Nutrition for the day",
    sidebarLayout(
      sidebarPanel(
        style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1",
        tags$style(
          type = "text/css",
          ".shiny-output-error { visibility: hidden; }",
          ".shiny-output-error:before { visibility:
                                  hidden; }"
        ),

        strong("Number of dishes"),
        textOutput("n"),
        uiOutput("dish_output"),
        actionButton("add_btn", "Add dish")
      ),


      mainPanel(
        style = "color:#9CBFC1",
        strong("Nutrition Table"),
        DT::dataTableOutput("Nutrition")
      )
    )
  )
)



third_page <- tabPanel(
  "Recipe from Ingredients",
  titlePanel(h2("What Can I Make?", style = "color:#9CBFC1")),
  sidebarLayout(
    sidebarPanel(
      style = "background-color: #FFFFF0;
            border:hidden #FFFFF0; color:#9CBFC1",
      textInput(inputId = "ingredient_1", label = "Ingredient 1"),
      uiOutput("all_ingredients"),
      actionButton("add_ingredient", "Add Ingredient"),
      actionButton("search", "Search"),
      hr(),
      h3("List of Recipes"),
      # selectInput(inputId = "intolerace", label = "Intolerance", choices =
      # intolerace),
      selectInput("amount", label = "# of recipes", choices = c(5, 10, 15, 20), selected = 5),
      uiOutput("recipes_3")
    ),
    column(
      8,
      mainPanel(
        uiOutput("htt_3"),
        tags$section(
          tags$hr(), plotlyOutput("bar_3"), tags$br(), tags$br(),
          tags$br()
        ),
        uiOutput("refer_3")
      )
    )
  )
)




ui <- tagList(
  navbarPage(
    title = "RecipEZ",
    home_page,
    first_page,
    second_page,
    third_page,
    theme = "style.css",
    useShinyjs()
  )
)
