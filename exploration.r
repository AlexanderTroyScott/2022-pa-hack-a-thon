#FILES AND LIBRARIES
adv_train <- read.csv("advanced_train.csv")
adv_test <- read.csv("advanced_test.csv")
library(dplyr)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(randomForest)
library(janitor)
library(xgboost)
set.seed(1234)
'%ni%'<-Negate('%in%')
install.packages("Matrix")
library(Matrix)
install.packages("data.table")
library(data.table)
library(stringr)

#FUNCTIONS
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

ready_data <- function(df) {
    df <- binarize_column(df=df, col="cooling")
    df <- binarize_column(df=df, col="type")
    df <- binarize_column(df=df, col="heating")
    df <- binarize_column(df=df, col="parking")
    df <- binarize_column(df=df, col="region")
    df <- binarize_column(df=df, col="cooling_features")
    df <- binarize_column(df=df, col="elementary_school")
    df <- binarize_column(df=df, col="middle_school")
    df <- binarize_column(df=df, col="high_school")
    df <- binarize_column(df=df, col="flooring")
    df <- binarize_column(df=df, col="heating_features")
    df <- binarize_column(df=df, col="appliances_included")
    df <- binarize_column(df=df, col="laundry_features")
    df <- binarize_column(df=df, col="parking_features")
    df <- binarize_column(df=df, col="city")
    df <- df %>% mutate(state_AZ = case_when(state == "AZ" ~ 1, state != "AZ" ~ 0)) %>% select(-state)
    
    df <- df %>% mutate(temp = abs(coalesce(as.numeric(as.character(bedrooms)),0)) + 
                case_when(str_count(bedrooms,',') > 0 ~ as.numeric(str_count(bedrooms,','))+1,
                          coalesce(as.numeric(as.character(bedrooms)),0) == 0 ~ 1,
                          TRUE ~ 0)) %>% 
        select(-bedrooms) %>% mutate(bedrooms=temp) %>% select(-temp)
    }

#TRAINING
temp <- adv_train %>% clean_names() %>%  mutate(log.sold = log(sold_price),  log.list = log(listed_price), log.dif = log.sold-log.list, dol.dif = sold_price-listed_price) %>% filter(log.dif != Inf)
temp <- temp %>% select(-tax_assessed_value,-annual_tax_amount,-listed_on,-last_sold_on)
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

temp <- data.frame(temp,stat) 
temp <- temp %>% mutate_if(sapply(temp, is.character), as.factor) 
temp <- ready_data(df=temp)
temp <- temp %>% select(-sold_price,-summary, -id, -n, -last_sold_price, -log.sold, -log.list, -dol.dif, -log.mean, -log.dev, -log.median, -dol.mean, -dol.dev, -dol.median, -dif.mean, -dif.dev, -dif.median)
xgb_train <- xgb.DMatrix(data.matrix(temp[,colnames(temp)%ni%"log.dif"]),label=as.numeric(temp$log.dif))

#TESTING DATA
temp <- adv_test %>% clean_names() %>% select(-sold_price,-summary, -id, -last_sold_price)


#MODEL
parameters <- list("objective"="reg:linear","eval_metric"="rmse")
bst <- xgboost(data = training, label = results, max.depth = 4,
               eta = 1, nthread = 14, nrounds = 10,objective = "reg:squarederror")

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

params <- list(booster = "gbtree", objective = "reg:squarederror", eta = 0.3, gamma=0, max_depth=5, min_child_weight=1, subsample=1, colsample_bytree=1)
xgbcv <- xgb.cv( params = params, data = dtrain, nrounds = 100, nfold = 5, showsd = T, stratified = T, print_every_n = 10, early_stop_round = 20, maximize = F)
