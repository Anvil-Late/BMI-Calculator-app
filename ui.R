#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
shinyUI(fluidPage(
    # Application title
    titlePanel("Visual BMI Calculator"),

    # Sidebar config
    sidebarLayout(
        sidebarPanel(
            h2("Please enter your data here :"),
            numericInput("heightvar",
                        "What is your height (in cm) ?",
                        min = 130,
                        max = 220,
                        value = 180),
            numericInput("weightvar",
                         "How much do you weigh (in kg) ?",
                         min = 0,
                         max = 200,
                         value = 80),
            h2(""),
            
            h1("Unit Conversion"),
            br("If you know your measurements in non metric units, 
                         insert them here for conversion : "),
            br("Please insert below your height in feet and inches \n"),
            br("-"),
            numericInput("heightft",
                         "feet :",
                         min = 0,
                         max = 10,
                         value = 0),
            numericInput("heightin",
                         "inches :",
                         min = 0,
                         max = 11,
                         value = 0),
            br("Please insert below your weight in lbs"),
            br("-"),
            numericInput("weightlbs",
                         "How much do you weigh (in lbs) ?",
                         min = 0,
                         max = 800,
                         value = 0),
            h1(""),
            br("Your measurements in metric are :"),
            em("height in cm : "),
            textOutput("htincm"),
            em("Weight in kg : "),
            textOutput("wtinkg")
        ),
            

        # Main Panel with text and plot outputs
        mainPanel(
            h3("Your BMI is :"),
            textOutput("bmivalue"),
            textOutput("bmiccl"),
            plotOutput("bmiplot")
        )
    )
))
