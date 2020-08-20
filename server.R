#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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
