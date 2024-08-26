# TARGET: Restrict data to relevant variables
# INDATA: Geographical county data
# OUTDATA/ OUTPUT: Relevant geographical variables that will be used to web-scrape Tweets

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
df<-LOAD(dfinput=paste0(DFBASE,"_counties"))

# restrict
df <- df[c("Geo.Point", "NAMELSAD", "GEOID", "ALAND", "AWATER", "STATE_NAME")]

#rename
colnames(df) <- sub("GEOID","county_code",colnames(df))
colnames(df) <- sub("Geo.Point","coord",colnames(df))
colnames(df) <- sub("NAMELSAD","county_name",colnames(df))
colnames(df) <- sub("STATE_NAME","state_name",colnames(df))

#create var radius for web-scraping
area <- ((df["ALAND"])+(df["AWATER"]))/1000000
radius_km <- sqrt(area/pi)
df['radius_km'] <- radius_km

SAVE(dfx=df)
