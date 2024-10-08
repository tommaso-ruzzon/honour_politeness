# TARGET: Save data on poverty as .rda
# INDATA: Poverty data from US Census Bureau
# OUTDATA/ OUTPUT: Poverty data as .rda

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
df <- read.csv2("/Users/tommaso/Desktop/Research_paper/data/PovertyEstimates.csv", header = TRUE, na.strings = "", stringsAsFactors = FALSE, sep = ";")


#save as .rda
SAVE(dfx=df)
