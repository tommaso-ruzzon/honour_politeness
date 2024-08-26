# TARGET: Merge relevant controls and outcomes in one final dataframe
# INDATA: Datasets on counties, institutional quality, culture of honour, education, poverty and politeness
# OUTDATA/ OUTPUT: Single dataframe that will be used for analysis and regressions

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
df1 <- LOAD(dfinput="honourpoliteness_varcreation_outcomes")
df2 <- LOAD(dfinput="honourpoliteness_varcreation_controls_honour")
df3 <- LOAD(dfinput="honourpoliteness_varcreation_controls_iq")
df4 <- LOAD(dfinput="honourpoliteness_varcreation_controls_education")
df5 <- LOAD(dfinput="honourpoliteness_varcreation_controls_poverty")
df6 <- LOAD(dfinput="honourpoliteness_varcreation_controls_counties")

#merge
df <- merge(df1,df2,by="county_code") 
df <- merge(df,df3,by="county_code") 
df<- merge(df,df4,by="county_code")
df<- merge(df,df5,by="county_code")
df<- merge(df,df6,by="county_code")


SAVE(dfx=df)  