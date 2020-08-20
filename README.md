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


![](https://github.com/Anvil-Late/BMI-Calculator-app/blob/master/assets/img/ggcode.png?raw=true)

This code will require to load both the dplyr and ggplot2 packages. We have to remember to include the package load in the server code



## UI code

The UI code is pretty straight forward : 

![](https://github.com/Anvil-Late/BMI-Calculator-app/blob/master/assets/img/uicode.png?raw=true)


## Server code

The server code manipulates the inputs a lot, so we mainly use reactive expressions

![](https://github.com/Anvil-Late/BMI-Calculator-app/blob/master/assets/img/servcode2.png?raw=true)
