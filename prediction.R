#
# Loads preprocessed corpus file which has undergone the first stage of cleansing
# and processing by the tm package
# Tokenises and calculates word frequencies using RWeka and tm packages
# Produces the processed ngram file for use by the shiny app
#
library(Rweka)
library(tm)
library(slam)

setwd("C:/Users/adrian/Desktop/Git Repository/Coursera/capstone/predict")
corpus <- load(file="./Corpus.RData")
corpus <- Cleanfile #assign original file name used after processing by tm package

# Use the RWeka library to tokenise unigram,bigram and trigrams
unigram_token <- function(x)
  NGramTokenizer(x, Weka_control(min = 1, max = 1))
bigram_token <- function(x)
  NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram_token <- function(x)
  NGramTokenizer(x, Weka_control(min = 3, max = 3))


# Create n-gram files
unigram <- TermDocumentMatrix(corpus, control=list(tokenize=unigram_token))
save(unigram,file="unigram.RData")

bigram <- TermDocumentMatrix(corpus, control=list(tokenize=bigram_token))
save(bigram,file="bigram.RData")

trigram <- TermDocumentMatrix(corpus, control=list(tokenize=trigram_token))
save(trigram,file="trigram.RData")

# Implement manual stupid backoff algorithm
# count frequency of unigram,bigram and trigrams
freq <- rowapply_simple_triplet_matrix(unigram,sum)
freqbi <- rowapply_simple_triplet_matrix(bigram,sum)
freqtri <- rowapply_simple_triplet_matrix(trigram,sum)
save(freq,file="freq.RData")
save(freqbi,file="freqbi.RData")
save(freqtri ,file="freqtri.RData")

#sort n-grams by frequency
freq_uni <- sort(freq, decreasing = T)
freq_bi <- sort(freqbi, decreasing = T)
freq_tri <- sort(freqtri, decreasing = T)

#Split joined strings
firstname <- sapply(strsplit(names(freqbi), ' '), function(a) a[1])
secname <- sapply(strsplit(names(freqbi), ' '), function(a) a[2])
firsttriname <- sapply(strsplit(names(freqtri), ' '),function(a) a[1])
sectriname <- sapply(strsplit(names(freqtri), ' '),function(a) a[2])
tritriname <- sapply(strsplit(names(freqtri), ' '),function(a) a[3])

names(freqbi)[1] #view first entry in the bi-gram model
firstname[1]     #view the split of the first entry in the bi-gram model into the first word
secname[1]       #view the split of the first entry in the bi-gram model into the second  word

#save uni, bi and trigrams as dataframes
unigramDF <- data.frame(names(freq),freq,stringsAsFactors = F)
bigramDF <- data.frame(names(freqbi),freqbi,firstname,secname,stringsAsFactors = F)
trigramDF <- data.frame(names(freqtri),freqtri,paste(firsttriname,sectriname),tritriname,stringsAsFactors = F)

names(unigramDF) <- c('unigram','freq')
names(bigramDF) <- c('bigram','freq','unigram','name')
names(trigramDF) <- c('trigram','freq','bigram','name')

# Save datafile for use by the shiny app
save(unigramDF,bigramDF,trigramDF,file = 'ngram.RData')



