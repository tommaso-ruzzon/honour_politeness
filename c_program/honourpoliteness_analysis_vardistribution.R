# TARGET: Analyse main data sample
# INDATA: Main data sample
# OUTDATA/ OUTPUT: -

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
df<-LOAD(dfinput=DFMAIN,pattdir=A) 

#Basic exploration
dim(df)
df_status(df)

summary(df[c("politeness_score", "politeness_score_extreme", "prop_ScotchIrish_1790")])

#Average politeness score by region
score_byregion<-with(df, tapply(politeness_score, Region, mean))
score_byregion

#Analyse main variables
var(df$politeness_score)
hist(df$politeness_score)
plot(density(df$politeness_score)) # Kernel Density Plot

var(df$prop_ScotchIrish_1790)
hist(df$prop_ScotchIrish_1790)
plot(density(df$prop_ScotchIrish_1790)) # Kernel Density Plot

##############################+
#Check collinearity
model <- lm(politeness_score ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages, data = df)
## TOLERANCE & VARIANCE INFLATION FACTOR (VIF)
ols_vif_tol(model)
eigenvalues <- as.data.frame(ols_eigen_cindex(model))
ols_plot_obs_fit(model)

plot(politeness_score ~ prop_ScotchIrish_1790, data=df)

##############################+
#Heteroskedasticity (Breusch Pagan test, p-value<0.05)
bptest(politeness_score ~ prop_ScotchIrish_1790 , data = df, studentize=F)