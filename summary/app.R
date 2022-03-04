library(shiny)

# Define UI for random distribution app ----
ui <- fluidPage(
  
  titlePanel("Summary"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      radioButtons("quality", "Wine quality:",
                   c("Low" = "low",
                     "Average" = "medium",
                     "High" = "high")),
    
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      verbatimTextOutput("summary")
      
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  curr_path <- getwd()
  wine <- read.csv(file='wine.csv',
                   header=T,
                   sep=";",
                   fill=T,
                   strip.white=T,
                   blank.lines.skip=T)
  wine.low <- wine[wine[, "quality"] < 5, ]
  wine.medium <- wine[wine[, "quality"] >= 5 & wine[, "quality"] <= 7, ]
  wine.high <- wine[wine[, "quality"] > 7, ]
  
  d <- reactive({
    wine_qw <- switch(input$quality,
                       low = wine.low,
                       medium = wine.medium,
                       high = wine.high,
                       wine.medium)
    
    wine_qw
  })
  

  # Generate a summary of the data ----
  output$summary <- renderPrint({
    xkablesummary(d())
  })
  
  # # Generate an HTML table view of the data ----
  # output$table <- renderTable({
  #   d()
  # })
  
}

# Create Shiny app ----
shinyApp(ui, server)
