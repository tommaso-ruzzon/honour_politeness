# TARGET: Restrict data to relevant variables
# INDATA: Education data
# OUTDATA/ OUTPUT: Relevant education variables

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
df<-LOAD(dfinput=paste0(DFBASE,"_education"))

# restrict
df <- df[,c(1,(ncol(df)-3):ncol(df))]

#rename
colnames(df) <- c("county_code", "adu_nohs", "adu_hs", "adu_college", "adu_bach")

SAVE(dfx=df)
