#
# This is the user-interface definition for the Coursera Data Science Capstone
# Project
# Adrian Lim
# April 2016
#

library(shiny)

shinyUI(fluidPage(
  # Set the page title
  titlePanel("Coursera Data Science Capstone Text Prediction App"),
  
  sidebarPanel(
    textInput("entry",
              h5("Please enter your sentence fragment"),
              "New York"),
    numericInput("n",
                 h5("Please select number of predicted words to show"), 
                 value = 2),
    radioButtons("radio", 
                 h5("Smoothing selection"),
                 choices = list("Stupid Back-off" = 1, "Kneser-Ney " = 2),
                 selected = 1),
    submitButton("SUBMIT"),
    br(),
    "V1.0", 
    a("adrianl", href = "https://github.com/adrianl66/capstone")
  ),
  
  mainPanel(
    tabsetPanel(type = "tabs", 
                tabPanel("Instructions", 
                         h4("Instructions"),
                         p('Please wait 1 minute (or more sorry) for the app to load and 30-60 seconds for the predictions'),
                         'App is loaded when you see the sentence fragment',
                         span('"New York"',style = "color:blue"),
                         'and its prediction',
                         span('"citi"',style = "color:blue"),
                         'below appears',
                         h4("Sentence fragment entered is"),
                         span(h4(textOutput('sent')),style = "color:blue"),
                         h4('Predicted text is'),
                         span(h4(textOutput('text')),style = "color:blue"),
                         ''), 
                tabPanel("Limitations & Potential Improvements",
                         h5("Prediction accuracy is poor at present"),
                         h5("Corpus coverage needs to be increased using more efficient libraries such as quanteda rather than tm used at present"),
                         h5("Kneser Rey Smoothing not implemented at present"),
                         a("My github account",href = "https://github.com/adrianl66/capstone")
                         )
                
    ))
))
