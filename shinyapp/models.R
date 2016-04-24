#
# This is the prediction algorithm for the Coursera Data Science Capstone
# Project
# Adrian Lim
# April 2016
#

library(tm)

# Implements the stupid backoff algorithm

predict0 <-function(input,profanity,unigramDF, bigramDF, trigramDF, maxResults = 3) {
  sw <- stopwords(kind = "en")
  input <- removePunctuation(input)
  input <- removeNumbers(input)
  input <- rev(unlist(strsplit(input," ")))
  input <- setdiff(input,sw)
  input <- input[grepl('[[:alpha:]]',input)]
  input <- paste(input[2],input[1],sep = ' ')
  input <- tolower(input) 
  if(input == ''|input == "na na") return('Warning: Please input something')
  
  seektri<-grepl(paste0("^",input,"$"),trigramDF$bigram)
  subtri<-trigramDF[seektri,]
  input2 <- unlist(strsplit(input," "))[2]
  seekbi <- grepl(paste0("^",input2,"$"),bigramDF$unigram)
  subbi <- bigramDF[seekbi,]
  unigramDF$s <- unigramDF$freq/nrow(unigramDF)*0.16
  useuni <- unigramDF[order(unigramDF$s,decreasing = T),]
  useunia <- useuni[1:maxResults,]
  
  if (sum(seektri) == 0) {
    if(sum(seekbi)==0){
      return(head(unigramDF[order(unigramDF$freq,decreasing = T),1],maxResults))
    }
    subbi$s <- 0.4*subbi$freq/sum(seekbi)
    names <- c(subbi$name,useunia$unigram)
    score <- c(subbi$s,useunia$s)
    predictWord <- data.frame(next_word=names,score=score,stringsAsFactors = F)
    predictWord <- predictWord[order(predictWord$score,decreasing = T),]
    final <- unique(predictWord$next_word)
    final <- setdiff(final,profanity)
    final <- final[grepl('[[:alpha:]]',final)]
    return(final[1:maxResults])
  } 
  subbi$s <- 0.4*subbi$freq/sum(seekbi)
  subtri$s <- subtri$freq/sum(subtri$freq)
  names <- c(subtri$name,subbi$name,useunia$unigram)
  score <- c(subtri$s,subbi$s,useunia$s)
  predictWord <- data.frame(next_word=names,score=score,stringsAsFactors = F)
  predictWord <- predictWord[order(predictWord$score,decreasing = T),]
  final <- unique(predictWord$next_word)
  final <- final[1:maxResults]
  final <- setdiff(final,profanity)
  final <- final[grepl('[[:alpha:]]',final)]        
  return(final)
}

# Placeholder for Kneser Rey implementation. Currently it is actually stupid backoff

predictKN <- function(input,profanity,unigramDF,bigramDF,trigramDF,maxResults = 3){
  sw <- stopwords(kind = "en")
  input <- removePunctuation(input)
  input <- removeNumbers(input)
  input <- rev(unlist(strsplit(input," ")))
  input <- setdiff(input,sw)
  input <- input[grepl('[[:alpha:]]',input)]
  input <- paste(input[2],input[1],sep = ' ')
  input <- tolower(input) 
  if(input == ''|input == "na na") return('Warning: Please input something')
  
  seektri<-grepl(paste0("^",input,"$"),trigramDF$bigram)
  subtri<-trigramDF[seektri,]
  input2 <- unlist(strsplit(input," "))[2]
  seekbi <- grepl(paste0("^",input2,"$"),bigramDF$unigram)
  subbi <- bigramDF[seekbi,]
  unigramDF$s <- unigramDF$freq/nrow(unigramDF)*0.16
  useuni <- unigramDF[order(unigramDF$s,decreasing = T),]
  useunia <- useuni[1:maxResults,]
  
  if (sum(seektri) == 0) {
    if(sum(seekbi)==0){
      return(head(unigramDF[order(unigramDF$freq,decreasing = T),1],maxResults))
    }
    subbi$s <- 0.4*subbi$freq/sum(seekbi)
    names <- c(subbi$name,useunia$unigram)
    score <- c(subbi$s,useunia$s)
    predictWord <- data.frame(next_word=names,score=score,stringsAsFactors = F)
    predictWord <- predictWord[order(predictWord$score,decreasing = T),]
    final <- unique(predictWord$next_word)
    final <- setdiff(final,profanity)
    final <- final[grepl('[[:alpha:]]',final)]
    return(final[1:maxResults])
  } 
  subbi$s <- 0.4*subbi$freq/sum(seekbi)
  subtri$s <- subtri$freq/sum(subtri$freq)
  names <- c(subtri$name,subbi$name,useunia$unigram)
  score <- c(subtri$s,subbi$s,useunia$s)
  predictWord <- data.frame(next_word=names,score=score,stringsAsFactors = F)
  predictWord <- predictWord[order(predictWord$score,decreasing = T),]
  final <- unique(predictWord$next_word)
  final <- final[1:maxResults]
  final <- setdiff(final,profanity)
  final <- final[grepl('[[:alpha:]]',final)]        
  return(final)
}