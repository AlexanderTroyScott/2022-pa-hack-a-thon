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
temp <- temp %>% select(-sold_price,-listed_price,-summary, -id, -n, -last_sold_price, -log.sold, -log.list, -dol.dif, -log.mean, -log.dev, -log.median, -dol.mean, -dol.dev, -dol.median, -dif.mean, -dif.dev, -dif.median)
xgb_train <- xgb.DMatrix(data.matrix(temp[,colnames(temp)%ni%"log.dif"]),label=as.numeric(temp$log.dif))
train_copy <- temp

#MODEL
parameters <- list("eval_metric"="rmse")
bst <- xgboost(data = xgb_train, max.depth = 20,
               eta = .01, print_every_n = 50,
               nfold = 5, nrounds = 1500,objective = "reg:squarederror",params=parameters)

#TESTING DATA
training_order <- train_copy %>% select(-log.dif) %>% colnames()
temp <- adv_test %>% clean_names() #%>% select(-summary, -id, -last_sold_price,-tax_assessed_value,-annual_tax_amount,-listed_on,-last_sold_on,-listed_price)
temp[temp$id == 46735,"listed_price"] <- 350000
temp[temp$id == 38600,"listed_price"] <- 2000000
temp[temp$id == 41608,"listed_price"] <- 2000000
temp[temp$id == 39704,"listed_price"] <- 600000
temp[temp$id == 37646,"listed_price"] <- 150000

temp <- ready_data(df=temp)

features <- bst$feature_names
missing_features <- features[features %ni% colnames(temp)]
temp <- temp[colnames(temp) %in% features]
missing_columns <- setdiff(bst$feature_names,colnames(temp))
temp[c(missing_columns)] <- 0
temp <- temp %>% select(all_of(training_order))

xgb_test <- xgb.DMatrix(data.matrix(temp))
results <- predict(bst,xgb_test)
scalar = 1.05
listed <- adv_test %>% clean_names() %>% mutate(log.listed = log(listed_price)) 
adj_results <- data.frame(results,listed)
adj_results %>% select(id, log.listed) %>% mutate("Sold Price" = exp(log.listed+results)*scalar) %>% select(id,"Sold Price") %>% write.csv(adj_results,"Test Results.csv",row.names=FALSE)

#Columns
c('id','sold_price','summary','type','year_built','heating','cooling','parking','lot','bedrooms','bathrooms','full_bathrooms',
  'total_interior_livable_area','total_spaces','garage_spaces','region','elementary_school','elementary_school_score',
  'elementary_school_distance','middle_school','middle_school_score','middle_school_distance','high_school','high_school_score',
  'high_school_distance','flooring','heating_features','cooling_features','appliances_included','laundry_features','parking_features',
  'tax_assessed_value','annual_tax_amount','listed_on','listed_price','last_sold_on','last_sold_price','city','zip','state')
#debug
setdiff(colnames(xgb_test),bst$feature_names)
print("other direction")
setdiff(bst$feature_names,colnames(xgb_test))

model.rf <- randomForest(formula = sold_price ~ ., 
                         data = temp,
                         ntree = 50,
                         mtry = 3, # The number of features to use at each split.
                         sampsize = floor(0.6 * nrow(temp)), # The number of observations to use in each tree.
                         nodesize = 100, # The minimum number of observations in each leaf node of a tree - this controls complexity.
                         importance = TRUE
                         )


params <- list(booster = "gbtree", objective = "reg:squarederror", eta = 0.3, gamma=0, max_depth=5, min_child_weight=1, subsample=1, colsample_bytree=1)
xgbcv <- xgb.cv( params = params, data = dtrain, nrounds = 100, nfold = 5, showsd = T, stratified = T, print_every_n = 10, early_stop_round = 20, maximize = F)
