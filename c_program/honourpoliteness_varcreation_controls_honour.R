# TARGET: Restrict data to relevant variables
# INDATA: Culture of honour data
# OUTDATA/ OUTPUT: Relevant culture of honour variables

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
df<-LOAD(dfinput=paste0(DFBASE,"_honour"))

# restrict
df <- dplyr::select(df, -contains(c("white", "black", "murder", "weapon", "elev", "v00", "gisjoin", "male", "female", "rape", "mansl", "robbery", "burglary", "possession", "offense", "drug", "assault", "crime", "arrest", "dui", "liquor", "drunk", "latit", "longit", "belfast", "newport", "phila", "newcastle", "shenandoah", "salisb", "chester", "fips_cty", "fips_cty2", "fips_county", "uid", "merge", "officer", "geoname", "police", "area", "perimeter","year", "rural", "countya")), -p, -code, -fips_st, -statea, -county)
df <- dplyr::select(df, county_code, prop_ScotchIrish_1790, ScotchIrish_1790, FIPS_ST, urban_rate, lnagg_earnings, fractionalization, gini, bordersouth:Region, dist_shallowford, Region1:South_prop_ScotchIrish_1790, Region1_dist_shall:South_dist_shall)

#rename
colnames(df)[1] <- "county_code"

#three rows for county_code=25003-> remove
nums <- unlist(lapply(df, is.numeric), use.names = FALSE)  
df_nums <- df[ , nums]
df_25003 <- df_nums[(df_nums$county_code==25003),]


df_25003$ScotchIrish_1790 <- sum(df_25003$ScotchIrish_1790)
final_25003 <- sapply(df_25003, mean)
final_25003 <- as.data.frame(t(final_25003))

df <- df[!(df$county_code==25003),]
df <- rbind(final_25003, df)


SAVE(dfx=df)
