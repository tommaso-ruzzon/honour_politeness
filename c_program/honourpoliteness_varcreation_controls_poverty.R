# TARGET: Restrict data to relevant variables
# INDATA: Poverty data
# OUTDATA/ OUTPUT: Relevant poverty variables

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
df<-LOAD(dfinput=paste0(DFBASE,"_poverty"))

# restrict
df <- df[,c(1,11,17,23,26)]

#rename
colnames(df) <- c("county_code", "pov_allages", "pov_age17", "pov_age517", "median_inc")

df$median_inc <- as.numeric(gsub("\\.","",df$median_inc))

SAVE(dfx=df)