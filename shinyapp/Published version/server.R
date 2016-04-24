#
# This is the server definition for the Coursera Data Science Capstone
# Project
# Adrian Lim
# April 2016
#

library(shiny)
source('./models.R') #Load the prediction algorithm
profanity <- readLines('./profanity.txt') #Load the list of bad words
load('./ngram.RData') #Load the pre built ngram database

shinyServer(function(input, output) {
  dataInput <- reactive({
    if(input$radio == 1){
      predict0(input$entry,profanity,unigramDF,bigramDF,trigramDF,maxResults = input$n)
    }else{
      predictKN(input$entry,profanity,unigramDF,bigramDF,trigramDF,maxResults = input$n)
    }
  })
  
  output$text <- renderText({
    dataInput()
  })
  
  output$sent <- renderText({
    input$entry
  })
})
