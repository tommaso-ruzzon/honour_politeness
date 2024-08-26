# TARGET: Restrict data to relevant variables
# INDATA: Institutional quality data
# OUTDATA/ OUTPUT: Relevant insitutional quality variables

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
df<-LOAD(dfinput=paste0(DFBASE,"_iq"))

# restrict
df <- df[c("UID", "num_allnews_pc")]

#rename
colnames(df)[1] <- "county_code"

#two rows for county_code=51710, three rows for county_code=25003 -> remove
df <- df[-c(31,32,145),]

SAVE(dfx=df)
