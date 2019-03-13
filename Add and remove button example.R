library(shiny)

ui <- shinyUI(fluidPage(
  
  sidebarPanel(
    actionButton("add_btn", "Add Textbox"),
    actionButton("rm_btn", "Remove Textbox"),
    textOutput("counter")
    
  ),
  
  mainPanel(uiOutput("textbox_ui"))
  
))

server <- shinyServer(function(input, output, session) {
  
  # Track the number of input boxes to render
  counter <- reactiveValues(n = 0)
  
  #Track the number of input boxes previously
  prevcount <-reactiveValues(n = 0)
  
  observeEvent(input$add_btn, {
    counter$n <- counter$n + 1
    prevcount$n <- counter$n - 1})
  
  observeEvent(input$rm_btn, {
    if (counter$n > 0) {
      counter$n <- counter$n - 1 
      prevcount$n <- counter$n + 1
    }
    
  })
  
  output$counter <- renderPrint(print(counter$n))
  
  textboxes <- reactive({
    
    n <- counter$n
    
    if (n > 0) {
      # If the no. of textboxes previously where more than zero, then 
      #save the text inputs in those text boxes 
      if(prevcount$n > 0){
        
        vals = c()
        if(prevcount$n > n){
          lesscnt <- n
          isInc <- FALSE
        }else{
          lesscnt <- prevcount$n
          isInc <- TRUE
        }
        for(i in 1:lesscnt){
          inpid = paste0("textin",i)
          vals[i] = input[[inpid]] 
        }
        if(isInc){
          vals <- c(vals, "New text box")
        }
        
        lapply(seq_len(n), function(i) {
          textInput(inputId = paste0("textin", i),
                    label = paste0("Textbox", i), value = vals[i])
        })
        
      }else{
        lapply(seq_len(n), function(i) {
          textInput(inputId = paste0("textin", i),
                    label = paste0("Textbox", i), value = "New text box")
        }) 
      }
      
    }
    
  })
  
  output$textbox_ui <- renderUI({ textboxes() })
  
})

shinyApp(ui, server)

