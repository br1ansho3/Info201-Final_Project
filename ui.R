library(shiny)

home_page <- tabPanel(
  "About Us",
  fluidPage(
  titlePanel("About Us"),
  sidebarLayout(
    sidebarPanel(tags$head(tags$style(HTML('.skin-black .main-sidebar {color: #000000; background-color: #FFB6C1;}')))
,
      img(src = "https://media.licdn.com/dms/image/C5603AQH1WCRU6fKPkw/profile-displayphoto-shrink_200_200/0?e=1557964800&v=beta&t=y6uk2g4kjGyAR6XBO0g6gwmu1AGI7JpzecEo8lSBtfE", style = "display: block; margin-left: auto; margin-right: auto;", width = "100x"),
      h3("Henry Bates"), "Hello! I'm Henry and I'm a Junior in the Environmental Science program. 
      I came to Informatics because I want to learn how I can better apply data visualization to 
      my field. Enjoy some new recipes!", br(), br(), "Email: batesh2@uw.edu", hr(),
      img(src = "https://media.licdn.com/dms/image/C5603AQHht_LSnn3rKA/profile-displayphoto-shrink_800_800/0?e=1557964800&v=beta&t=uVI8QhDBDtoYcrvOImXm56yO8sErTJ5bCQ5MTCeemwk",style = "display: block; margin-left: auto; margin-right: auto;", width = "100px"),
      h3("Brian Hsu"),"Hi my name is Brian. I'm a Junior studying Mathematics. I'm taking this 
      class because I love UI design and hope to double major in Informatics. We 
      hope you find some food youve never even thought to cook before.", br(), 
      br(), "Email: brianhsu@uw.edu", hr(),
      img(src = "https://media.licdn.com/dms/image/C5603AQH1WCRU6fKPkw/profile-displayphoto-shrink_200_200/0?e=1557964800&v=beta&t=y6uk2g4kjGyAR6XBO0g6gwmu1AGI7JpzecEo8lSBtfE", style = "display: block; margin-left: auto; margin-right: auto;", width = "100x"),
      h3("Ruiqi Yan"), "INTRO HERE", br(), br(), "Email: ruiqiy3@uw.edu", hr(),
      img(src = "https://media.licdn.com/dms/image/C5603AQH1WCRU6fKPkw/profile-displayphoto-shrink_200_200/0?e=1557964800&v=beta&t=y6uk2g4kjGyAR6XBO0g6gwmu1AGI7JpzecEo8lSBtfE", style = "display: block; margin-left: auto; margin-right: auto;", width = "100x"),
      h3("Chunmo Chen "), "INTRO HERE", br(), br(), "Email: ccm1997@uw.edu", hr(), width = 2
    ),
    mainPanel(
      h1("What Recipes Can You Find?"),
      img(src = "https://www.bi-lo.com/-/media/media/whatsnew/14_italian_brochure_spaghettimeatballs_028_banner.png?la=en&mw=1382", width = "1000px", height = "300px", style = "display: block; margin-left: auto; margin-right: auto;"),
      h2("A Classic for Everyone"), h4(em("Spaghetti with meatballs is a classic dish loved by many. However
                                  many people around the world are vegatarian or don't have all the ingredients available to them. Click on our", strong("Recipes from Ingredients"), "tab above
                                  to find dishes that work just for you or your family when you enter the ingredients you want to use!")), hr(),
      img(src = "https://i0.wp.com/sautemagazine.com/wp-content/uploads/2018/01/Pimp-My-Noodles_10-MINUTE-RAMEN-banner.jpg?ssl=1", width = "1000px", height = "300px", style = "display: block; margin-left: auto; margin-right: auto;"),
      h2("Staying Healthy"), h4(em("It can be tough to resist a big bowl of ramen everyday but we can't eat everything that 
                                    we want and stay healthy. It can be tough to find out the nurtional value of prepared dishes 
                                    so we provide that under the", strong("Nutrition of Food"), "tab above. Search for a dish or food and explore
                                    the nutritional content and start planning a great diet today!")), hr(),
      img(src = "https://hips.hearstapps.com/del.h-cdn.co/assets/18/11/2048x1024/landscape-1520956952-chicken-tacos-horizontal.jpg?resize=1200:*", width = "1000px", height = "300px", style = "display: block; margin-left: auto; margin-right: auto;"),
      h2("Adding a Personal Touch"), h4(em("Finding the foods that agree with you and your eating goals can be tricky. 
                                           The", strong("Recipes from Nutrition"), "tab allows you to set your needs
                                           to specific nutritional amounts. Then you can explore the recipes that will leave you
                                            feeling ready for anything!"))
    )
  )
)
)
first_page <- tabPanel("Recipes from Ingredients")
second_page <- tabPanel("Nutrition of Food")
third_page <- tabPanel("Recipes from Nutrition")



ui <- navbarPage(
  "Recipeeeez",
  home_page,
  first_page,
  second_page,
  third_page
)
