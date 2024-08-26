# TARGET: Save test data for politeness classifier as .rda
# INDATA: Web-scraped Twitter data 
# OUTDATA/ OUTPUT: Twitter data as .rda

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
df_tweets <- read.csv("df_tweets.csv")

text <- df_tweets[-1]
county_codes <- df_tweets[1]

a <- do.call("rbind", replicate(ncol(text), county_codes, simplify = FALSE))
b <- data.frame(V1=unlist(text, use.names = FALSE))

df <- cbind(a, b)
colnames(df)[2] <- "tweets"
df <- df[!(df$tweets==""), ]

#save as .rda
SAVE(dfx=df)
