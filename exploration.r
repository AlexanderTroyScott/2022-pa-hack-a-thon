train <- read.csv("advanced_test.csv")
library(dplyr)
install.packages("wordcloud")
library(wordcloud)
install.packages("RColorBrewer")
library(RColorBrewer)
install.packages("wordcloud2")
library(wordcloud2)
install.packages("tm")
install.packages("janitor")
library(janitor)
library(tm)

set.seed(1234)

summarize_column <- function(field) {
    docs <- Corpus(VectorSource(field))
    docs <- docs %>%
      #tm_map(removeNumbers) %>%
      tm_map(removePunctuation) %>%
      tm_map(stripWhitespace)
    dtm <- TermDocumentMatrix(docs) 
    matrix <- as.matrix(dtm) 
    words <- sort(rowSums(matrix),decreasing=TRUE) 
    df <- data.frame(word = names(words),freq=words)
    #wordcloud(words = df$word, freq = df$freq, min.freq = 1, max.words=200, random.order=FALSE, rot.per=0.35)
    print(df)
    }

binarize_column <- function(df, col) {
    docs <- Corpus(VectorSource(df[[col]]))
    docs <- docs %>%
      #tm_map(removeNumbers) %>%
      tm_map(removePunctuation) %>%
      tm_map(stripWhitespace)
    dtm <- TermDocumentMatrix(docs)
    matrix <- t(as.matrix(dtm)) 
    colnames(matrix) <- paste0(col,"_",colnames(matrix))
    df <- data.frame(df,matrix) %>% select(-all_of(col))
    return(df)
    }

temp <- train
temp <- temp %>% mutate_if(sapply(temp, is.character), as.factor)

summarize_column(temp$Cooling)
summarize_column(temp$Laundry.features)
summarize_column(temp$Appliances.included)

temp <- binarize_column(df=temp, col="Cooling")
temp <- binarize_column(df=temp, col="Type")
temp <- binarize_column(df=temp, col="Heating")
temp <- binarize_column(df=temp, col="Parking")
temp <- binarize_column(df=temp, col="Region")
temp <- binarize_column(df=temp, col="Elementary.School")
temp <- binarize_column(df=temp, col="Middle.School")
temp <- binarize_column(df=temp, col="High.School")
temp <- binarize_column(df=temp, col="Flooring")
temp <- binarize_column(df=temp, col="Heating.features")
temp <- binarize_column(df=temp, col="Appliances.included")
temp <- binarize_column(df=temp, col="Laundry.features")
temp <- binarize_column(df=temp, col="Parking.features")
temp <- binarize_column(df=temp, col="City")

temp <- temp %>% select(-Summary)
temp <- temp %>% clean_names()


model.rf <- randomForest(formula = sold_price ~ ., 
                         data = temp,
                         ntree = 50,
                         mtry = 3, # The number of features to use at each split.
                         sampsize = floor(0.6 * nrow(temp)), # The number of observations to use in each tree.
                         nodesize = 100, # The minimum number of observations in each leaf node of a tree - this controls complexity.
                         importance = TRUE
                         )
