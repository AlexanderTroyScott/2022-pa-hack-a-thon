train <- read.csv("advanced_test.csv")
library(dplyr)
install.packages("wordcloud")
library(wordcloud)
install.packages("RColorBrewer")
library(RColorBrewer)
install.packages("wordcloud2")
library(wordcloud2)
install.packages("tm")
library(tm)

temp <- train
temp <- temp %>% mutate_if(sapply(temp, is.character), as.factor)
temp$Heating_Central <- grepl("gas",ignore.case = TRUE,temp$Heating)
glimpse(temp)
summary(temp)

heating <- temp$Heating
docs <- Corpus(VectorSource(heating))

docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))

dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

set.seed(1234) # for reproducibility 
wordcloud(words = df$word, freq = df$freq, min.freq = 1, max.words=200, random.order=FALSE, rot.per=0.35)
glimpse(df$word)

df <- df %>% mutate_if(sapply(df, is.character), as.factor)
print(df)
