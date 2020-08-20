---
title       : "BMI Calculator"
subtitle    : "A quick slide presentation on how I built my visual BMI calculator app" 
author      : "Antoine VILLATTE"
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction

Here's a quick slide presentation on how I built my visual BMI calculator app which can be found here :

[Visual BMI calculator app](https://anvil.shinyapps.io/BMI-calculator/)

We'll go through the following steps :

1. The GGPLOT background

2. The UI code

3. The server code


## GGPLOT Background

Here's the code for the ggplot background. I create a data frame for my BMI 16.5 to BMI 40 lines, then plot them.

After that, I plot the colored intervals with the geom_ribbon functions.

Finally, I add the text with geom_text and I manually set the positions and the slight angle


```{r}
BMI <- data.frame(height = c(130:220), weight = c(40:130))

BMI <- BMI %>% mutate(bmi16.5 = 16.5 * (height*0.01)**2,
                      bmi18.5 = 18.5 * (height*0.01)**2,
                      bmi25 = 25 * (height*0.01)**2,
                      bmi30 = 30 * (height*0.01)**2,
                      bmi35 = 35 * (height*0.01)**2,
                      bmi40 = 40 * (height*0.01)**2,
                      )


g <- ggplot(data = data.frame(height = c(130 : 220), weight = c(40 : 130)),
                              aes(x = height, y = weight))


g <- g + geom_line(data = BMI, aes(x = height, y = bmi16.5), size = 1.2) +
   geom_line(data = BMI, aes(x = height, y = bmi18.5), size = 1.2) +
   geom_line(data = BMI, aes(x = height, y = bmi25), size = 1.2) +
   geom_line(data = BMI, aes(x = height, y = bmi30), size = 1.2) +
   geom_line(data = BMI, aes(x = height, y = bmi35), size = 1.2) +
   geom_line(data = BMI, aes(x = height, y = bmi40), size = 1.2) 

g <- g + geom_ribbon(aes(ymin = 0, ymax = BMI$bmi16.5), fill = "lightblue", alpha = 0.5) +
   geom_ribbon(aes(ymin = BMI$bmi16.5, ymax = BMI$bmi18.5), fill = "blue", alpha = 0.5) +
   geom_ribbon(aes(ymin = BMI$bmi18.5, ymax = BMI$bmi25), fill = "white", alpha = 0.5) +
   geom_ribbon(aes(ymin = BMI$bmi25, ymax = BMI$bmi30), fill = "yellow", alpha = 0.5) +
   geom_ribbon(aes(ymin = BMI$bmi30, ymax = BMI$bmi35), fill = "orange", alpha = 0.5) +
   geom_ribbon(aes(ymin = BMI$bmi35, ymax = BMI$bmi40), fill = "orange4", alpha = 0.5) +
   geom_ribbon(aes(ymin = BMI$bmi40, ymax = Inf), fill = "salmon", alpha = 0.5)
   

g <- g + geom_text(x = 175, y = 30, label = "Severely Underweight", angle = 11) +
   geom_text(x = 175, y = 54, label = "Underweight", angle = 11) +
   geom_text(x = 175, y = 66, label = "Normal", angle = 11) +
   geom_text(x = 175, y = 84, label = "Overweight", angle = 11) +
   geom_text(x = 175, y = 99, label = "Highly Overweight", angle = 11) +
   geom_text(x = 175, y = 115, label = "Obese", angle = 11) +
   geom_text(x = 175, y = 160, label = "Severely Obese", angle = 11)
   
```
This code will require to load both the dplyr and ggplot2 packages. We have to remember to include the package load in the server code



## UI code

The UI code is pretty straight forward : 

```{r}
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


```

## Server code

The server code manipulates the inputs a lot, so we mainly use reactive expressions

```{r}
library(shiny)


shinyServer(function(input, output) {
    
    # Extract main values. Set to 0 if input is empty
    heightvar <- reactive({
        if (is.na(input$heightvar)){0}
        else {as.numeric(input$heightvar)}
        })
    weightvar <- reactive({
        if (is.na(input$weightvar)){0}
        else {as.numeric(input$weightvar)}
        })
    
    # Calculate BMI value
    bmival <- reactive({
        round(weightvar() / ((0.01*heightvar())**2),2)
        })
    # Create "bmivalue" output
    output$bmivalue = renderText(bmival())
    
    # Create "bmiccl" output that depends on the user's BMI
    output$bmiccl = renderText(
        if (bmival() < 16.5) {print("You are severly underweight")}
        else if (bmival() < 18.5) {print("You are underweight")}
        else if (bmival() < 25) {print("Your weight is normal")}
        else if (bmival() < 30) {print("You are overweight")}
        else if (bmival() < 35) {print("You are highly overweight")}
        else if (bmival() < 40) {print("You are obese")}
        else {print("You are severly obese")}
        )
    # UNIT CONVERSION PANEL 
    
    # Extract values and set to 0 if input is empty
    wtlbs <- reactive({
        if (is.na(input$weightlbs)){0}
        else {input$weightlbs}
    })
    
    htft <- reactive({
        if (is.na(input$heightft)){0}
        else {input$heightft}
    })
    
    htin <- reactive({
        if (is.na(input$heightin)){0}
        else {input$heightin}
    })
    
    # Create output : converted measurements, NULL if empty or = 0
    # NULL output = results don't appear = cleaner UI
    output$wtinkg = reactive({
        if (wtlbs() == 0){NULL}
        else {round(wtlbs() * 0.453592, 1)}
        })
    
    output$htincm = reactive({
        if (htft() + htin() == 0){NULL}
        else {round((htft() * 12 + htin()) * 2.54, 1)}
        })
    
    # Create plot output 
    output$bmiplot <- renderPlot({
        
        # GGPLOT BACKGROUND :
        library(dplyr)
        library(ggplot2)
        BMI <- data.frame(height = c(130:220), weight = c(40:130))
        BMI <- BMI %>% mutate(bmi16.5 = 16.5 * (height*0.01)**2,
                              bmi18.5 = 18.5 * (height*0.01)**2,
                              bmi25 = 25 * (height*0.01)**2,
                              bmi30 = 30 * (height*0.01)**2,
                              bmi35 = 35 * (height*0.01)**2,
                              bmi40 = 40 * (height*0.01)**2,
        )
        g <- ggplot(data = data.frame(height = c(130 : 220), weight = c(40 : 130)),
                    aes(x = height, y = weight))
        
        g <- g + geom_line(data = BMI, aes(x = height, y = bmi16.5), size = 1.2) +
            geom_line(data = BMI, aes(x = height, y = bmi18.5), size = 1.2) +
            geom_line(data = BMI, aes(x = height, y = bmi25), size = 1.2) +
            geom_line(data = BMI, aes(x = height, y = bmi30), size = 1.2) +
            geom_line(data = BMI, aes(x = height, y = bmi35), size = 1.2) +
            geom_line(data = BMI, aes(x = height, y = bmi40), size = 1.2) 
        
        g <- g + geom_ribbon(aes(ymin = 0, ymax = BMI$bmi16.5), fill = "lightblue", alpha = 0.5) +
            geom_ribbon(aes(ymin = BMI$bmi16.5, ymax = BMI$bmi18.5), fill = "blue", alpha = 0.5) +
            geom_ribbon(aes(ymin = BMI$bmi18.5, ymax = BMI$bmi25), fill = "white", alpha = 0.5) +
            geom_ribbon(aes(ymin = BMI$bmi25, ymax = BMI$bmi30), fill = "yellow", alpha = 0.5) +
            geom_ribbon(aes(ymin = BMI$bmi30, ymax = BMI$bmi35), fill = "orange", alpha = 0.5) +
            geom_ribbon(aes(ymin = BMI$bmi35, ymax = BMI$bmi40), fill = "orange4", alpha = 0.5) +
            geom_ribbon(aes(ymin = BMI$bmi40, ymax = Inf), fill = "salmon", alpha = 0.5)
        
        g <- g + geom_text(x = 175, y = 30, label = "Severely Underweight", angle = 11) +
            geom_text(x = 175, y = 54, label = "Underweight", angle = 11) +
            geom_text(x = 175, y = 66, label = "Normal", angle = 11) +
            geom_text(x = 175, y = 84, label = "Overweight", angle = 11) +
            geom_text(x = 175, y = 99, label = "Highly Overweight", angle = 11) +
            geom_text(x = 175, y = 115, label = "Obese", angle = 11) +
            geom_text(x = 175, y = 160, label = "Severely Obese", angle = 11)
        
        # Add user input to GGPLOT background and print the final GGPLOT :
        g <- g + geom_point(x = heightvar(), y = weightvar(), colour = "red", size = 5, shape = 4, stroke = 2)
        g
    })
})


```
