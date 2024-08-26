# TARGET: Save historical institutional quality data as .rda
# INDATA: Institutional quality data from Grosjean (2014)
# OUTDATA/ OUTPUT: Institutional data as .rda

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
df <- read_dta("CrimeAnd1790and2000&IQ_repli.dta")

#save as .rda
SAVE(dfx=df)
