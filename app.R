#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)

# Sample data (replace this with your actual dataset)
holocaust_data <- data.frame(
  Nationality = c("Jewish", "Polish", "Roma", "Soviet", "Other"),
  Count = c(1000000, 70000, 21000, 14000, 12000)
)

# Define UI for application
ui <- fluidPage(
  titlePanel("Holocaust Victims at Auschwitz"),
  sidebarLayout(
    sidebarPanel(
      selectInput("group", "Select Group:",
                  choices = unique(holocaust_data$Nationality),
                  selected = c("Jewish","Polish"),
                  multiple = TRUE)
    ),
    mainPanel(
      plotOutput("plot"),
      dataTableOutput("table")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Filter data based on user input
  filtered_data <- reactive({
    subset(holocaust_data, Nationality %in% input$group)
  })
  
  # Render plot
  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Nationality, y = Count)) +
      geom_bar(stat = "identity") +
      labs(title = "Number of Holocaust Victims by Nationality",
           x = "Nationality",
           y = "Count")
  })
  
  # Render table
  output$table <- renderDataTable({
    filtered_data()
  })
}

# Run the application
shinyApp(ui = ui, server = server)