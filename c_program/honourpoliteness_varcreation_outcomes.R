# TARGET: Create outcome variable with politeness classifier
# INDATA: Train and test data for politeness classifier
# OUTDATA/ OUTPUT: Politeness score for each web-scraped Tweet and for each county

################################################################################################################+
# INTRO	script-specific ####

#clear gobal environment of all but uppercase objects (globals, myfunctions, scalars)
CLEARCOND()

#get scriptname
MAINNAME <- current_filename() #returns path+name of sourced script (from currently executed master script)
if(is.null(MAINNAME)){
  MAINNAME <- rstudioapi::getActiveDocumentContext()$path #dto. of currently executed script
}
MAINNAME <- sub(".*/|^[^/]*$", "", MAINNAME)
MAINNAME <- substr(MAINNAME,1,nchar(MAINNAME)-2) #cut off .R

######################+
#release unused memory 
gc()

################################################################################################################+
# MAIN PART ####

df_train <- LOAD(dfinput=paste0(DFBASE,"_politeness_train"))
df_test <- LOAD(dfinput=paste0(DFBASE,"_politeness_test"))

# # Train politeness classifier (or use pre-trained dataset below)
# # Using "capture.output()" because the progress bar printed by "politeness" is corrupted
# df_polite_train <- capture.output(politeness(df_train$text, parser="spacy", num_mc_cores=parallel::detectCores()))
# df_polite_holdout <- capture.output(politeness(df_test$tweets, parser="spacy", num_mc_cores=parallel::detectCores()))

#If training takes too long: here are the pre-trained datasets
setwd(A)
df_polite_train <- read.csv("df_polite_train.csv")
df_polite_holdout <- read.csv("df_polite_holdout.csv")

# #Test: score Tweets (or use scored dataset below)
# projection<-capture.output(politenessProjection(df_polite_train,
#                                  df_train$score,
#                                  df_polite_holdout,
#                                  classifier="glmnet",
#                                  cv_folds=10))
# 
# df_scores <- as.data.frame(projection$test_proj)
# df_scores <- cbind(test_tweets, df_scores)
# colnames(df_scores)[3] <- "score"

#If scoring takes too long: here is the pre-scored dataset
df_scores <- read.csv("tweets_scores.csv")


#Analyse panel of Tweets by year
df_dates <- read.csv("df_dates.csv") # ordered by county_code by construction (see .py script)

df_scores <- df_scores[order(df_scores$county_code), ]
df_scores$Admin_ID <- seq.int(nrow(df_scores))

df_dates$Admin_ID <- seq.int(nrow(df_dates))
colnames(df_dates)[1]<-"date"
df_scores_dates<-merge(df_scores,df_dates,by="Admin_ID")

df_scores_dates$year = as.factor(substr(df_scores_dates$date,1,4))
plot(df_scores_dates$year)
count <- table(df_scores_dates$year)
count
as.data.frame(count)[9,2]/nrow(df_scores_dates)*100 # 91% of tweets are from 2022: very unbalanced data for panel by year ->
                                                    # -> panel by month? no monthly data for controls -> 
                                                    # -> average scores by county (OR scrape new Tweets by running the "panel data extension" in file "honourpoliteness_webscraping.py" and score them for politeness)


#Average scores by county
scores <- aggregate(df_scores$score, by=list(county_code=df_scores$county_code), FUN=mean)
colnames(scores)[2] <- "politeness_score"

#Keep only Tweets with extreme scores
df_scores_extreme <- df_scores
df_scores_extreme$score <- cut(df_scores_extreme$score,
                               breaks=c(0, 0.1, 0.9, 1),
                               labels=c(0, 0.5, 1))
df_scores_extreme <- df_scores_extreme %>% replace_with_na(replace = list(score = 0.5))
df_scores_extreme <- df_scores_extreme[complete.cases(df_scores_extreme),]
rownames(df_scores_extreme) <- NULL
df_scores_extreme[3] <- as.numeric(as.character(unlist(df_scores_extreme[[3]])))
scores_extreme <- aggregate(df_scores_extreme$score, by=list(county_code=df_scores_extreme$county_code), FUN=sum)
colnames(scores_extreme)[2] <- "politeness_score_extreme"

df <- merge(scores, scores_extreme, by="county_code")

SAVE(dfx=df)
