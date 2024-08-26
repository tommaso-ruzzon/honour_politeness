# TARGET: Create main sample for analysis
# INDATA: Merged dataset
# OUTDATA/ OUTPUT: Sample data for main analysis

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
df<-LOAD(dfinput=DFMERGE)

df <- df[(df$Region==1),]

#restrict to non-missing rows
dim(df)
df <- df[complete.cases(df),]
dim(df)

#save 
SAVE(dfx=df,namex=MAINNAME,pattdir=A)