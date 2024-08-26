# TARGET: Plot politeness features in training data
# INDATA: Training data for politeness classifier
# OUTDATA/ OUTPUT: Plot politeness features

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
setwd(A)
df_polite_train <- read.csv("df_polite_train.csv")

# The plot compares how the counts of every politeness feature differ across our binary covariate of interest (Impolite/Polite text)
politeness::politenessPlot(df_polite_train,
                           split=df_train$score,
                           split_levels = c("Impolite","Polite"),
                           split_name = "Score")

#export
ggsave(paste0(D,MAINNAME,"_politeness.png"))

