# TARGET: Save train data for politeness classifier as .rda
# INDATA: Politeness data from Yeomans, Kantor, et al. (2018), Madaan, Setlur, et al. (2020), Niu and Bansal (2018)
# OUTDATA/ OUTPUT: Politeness data as .rda

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

setwd(A)

###First training dataset (scored by humans)
train_a_spc <- read.csv("stack-exchange.annotated.csv")
train_a_spc <- train_a_spc[c(3,14)]
train_b_spc <- read.csv("wikipedia.annotated.csv")
train_b_spc <- train_b_spc[c(3,14)]
train_spc <- rbind(train_a_spc,train_b_spc)
colnames(train_spc) <- c("text", "norm_score")

train_spc$score_cont<- rescale(train_spc$norm_score)

#Only keep extremely polite and impolite Tweets
train_spc$score <- cut(train_spc$score_cont,
                       breaks=c(0, 0.25, 0.75, 1),
                       labels=c(0, 0.5, 1))

train_spc <- train_spc %>% replace_with_na(replace = list(score = 0.5))
train_spc <- train_spc[complete.cases(train_spc),]
train_spc <- train_spc[c("text", "score")]

count_spc <- table(train_spc$score)

############################
###Second training dataset
load("phone_offers.rdata")
load("bowl_offers.rdata")
train_offers<- rbind(phone_offers, bowl_offers[ncol(bowl_offers):1])
colnames(train_offers) <- c("text", "score")

count_offers <- table(train_offers$score)

############################
###Third training dataset (scored by machine)
df_madaan <- read.csv("politeness_madaan.csv")
train_madaan <- df_madaan[df_madaan$is_useful == 1,]
train_madaan <- train_madaan[c("txt","score")]
colnames(train_madaan)[1] <- "text"

##Balancing data
#Create temporary dataframe to count extremely polite and impolite Tweets
train_madaan_tmp <- train_madaan
train_madaan_tmp$score <- cut(train_madaan_tmp$score,
                              breaks=c(0, 0.1, 0.9, 1),
                              labels=c(0, 0.5, 1))
train_madaan_tmp <- train_madaan_tmp %>% replace_with_na(replace = list(score = 0.5))
train_madaan_tmp <- train_madaan_tmp[complete.cases(train_madaan_tmp),]
rownames(train_madaan_tmp) <- NULL

count_madaan <- table(train_madaan_tmp$score)
count_madaan

#Analyse data for balancing (n° of polite texts should be equal to n° of impolite texts for politeness classifier)
n_polite_tot <- as.data.frame(count_madaan)[3,2] + as.data.frame(count_spc)[3,2] + as.data.frame(count_offers)[2,2]
n_impolite_tot <- as.data.frame(count_madaan)[1,2] + as.data.frame(count_spc)[1,2] + as.data.frame(count_offers)[1,2]

n_polite_madaan <- n_impolite_tot - as.data.frame(count_spc)[3,2] - as.data.frame(count_offers)[2,2]

n_impolite_madaan <- as.data.frame(count_madaan)[1,2]

#Balance data (keep only most polite and most impolite)
train_madaan_balanced <- train_madaan[order(train_madaan$score, decreasing = TRUE), ]
train_madaan_polite <- head(train_madaan_balanced, n_polite_madaan)
train_madaan_polite$score <- 1
train_madaan_impolite <- tail(train_madaan_balanced, n_impolite_madaan)
train_madaan_impolite$score <- 0
train_madaan_balanced <- rbind(train_madaan_polite, train_madaan_impolite)

############################
###Merge training data
df <- rbind(train_spc, train_offers, train_madaan_balanced)
df$score <- as.integer(as.character(df$score))
count_train<- table(df$score)

#save as .rda
SAVE(dfx=df)