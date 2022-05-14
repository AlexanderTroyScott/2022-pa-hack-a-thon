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

temp <- adv_train %>% clean_names() %>% mutate(log.sold = log(sold_price), log.list = log(listed_price), log.dif = log.sold-log.list, dol.dif = sold_price-listed_price)
stat <- temp %>% summarise(n=n(),
                           log.mean = mean(log.sold),
                           log.dev = sd(log.sold), 
                           log.median=median(log.sold), 
                           dol.mean = mean(sold_price), 
                           dol.dev = sd(sold_price),
                           dol.median = median(sold_price),
                           dif.mean = mean(dol.dif), 
                           dif.dev = sd(dol.dif),
                           dif.median = median(dol.dif)
                          )
temp3 <- data.frame(temp,stat) %>% filter(dol.dif>dif.mean+2*dif.dev)

#Columns
c('id','sold_price','summary','type','year_built','heating','cooling','parking','lot','bedrooms','bathrooms','full_bathrooms',
  'total_interior_livable_area','total_spaces','garage_spaces','region','elementary_school','elementary_school_score',
  'elementary_school_distance','middle_school','middle_school_score','middle_school_distance','high_school','high_school_score',
  'high_school_distance','flooring','heating_features','cooling_features','appliances_included','laundry_features','parking_features',
  'tax_assessed_value','annual_tax_amount','listed_on','listed_price','last_sold_on','last_sold_price','city','zip','state')

model.rf <- randomForest(formula = sold_price ~ ., 
                         data = temp,
                         ntree = 50,
                         mtry = 3, # The number of features to use at each split.
                         sampsize = floor(0.6 * nrow(temp)), # The number of observations to use in each tree.
                         nodesize = 100, # The minimum number of observations in each leaf node of a tree - this controls complexity.
                         importance = TRUE
                         )


#XGBoost
temp <- adv_train %>% clean_names() %>% mutate(log.sold = log(sold_price), log.list = log(listed_price), log.dif = log.sold-log.list, dol.dif = sold_price-listed_price)
stat <- temp %>% summarise(n=n(),
                           log.mean = mean(log.sold),
                           log.dev = sd(log.sold), 
                           log.median=median(log.sold), 
                           dol.mean = mean(sold_price), 
                           dol.dev = sd(sold_price),
                           dol.median = median(sold_price),
                           dif.mean = mean(dol.dif), 
                           dif.dev = sd(dol.dif),
                           dif.median = median(dol.dif)
                          )
temp3 <- data.frame(temp,stat)

boosted_data <- temp3 %>% select(all_of(predictors),log.dif) %>% select(-last_sold_price) %>% filter('id' != 35868) 
boosted_data <- boosted_data %>% mutate_if(sapply(boosted_data, is.character), as.factor)
summary(boosted_data)
labels <- boosted_data$log.dif %>% as.numeric()-1
train <- model.matrix(~.+0, data=boosted_data[,-c("log.dif"),with=F])
dtrain <- xgb.DMatrix(data=train,label=labels)

params <- list(booster = "gbtree", objective = "reg:squarederror", eta = 0.3, gamma=0, max_depth=5, min_child_weight=1, subsample=1, colsample_bytree=1)
xgbcv <- xgb.cv( params = params, data = dtrain, nrounds = 100, nfold = 5, showsd = T, stratified = T, print_every_n = 10, early_stop_round = 20, maximize = F)
