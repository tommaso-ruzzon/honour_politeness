## TARGET: Run regressions on subsample "Border South"
# INDATA: Subsample "Border South"
# OUTDATA/ OUTPUT: Regression outputs

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
df<-LOAD(dfinput=DFBORDERSOUTH,pattdir=A)

# S.e. not clustered as it's only one state (Maryland)

## Linear model
lm_1_bordersouth <- lm(politeness_score ~ prop_ScotchIrish_1790, df)
summary(lm_1_bordersouth)

lm_2_bordersouth <- lm(politeness_score ~ prop_ScotchIrish_1790 +  urban_rate + fractionalization + adu_bach + pov_allages, data = df)
summary(lm_2_bordersouth)

#export
stargazer(lm_1_bordersouth, lm_2_bordersouth, type="text", omit = "Constant", omit.stat = c("rsq", "ser", "f"), out = paste0(D,MAINNAME,"_lm.txt"))


## Beta regression
beta_1_bordersouth <- betareg(politeness_score ~ prop_ScotchIrish_1790 , data = df)
summary(beta_1_bordersouth)

beta_2_bordersouth <- betareg(politeness_score ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + adu_bach + pov_allages, data = df)
summary(beta_2_bordersouth)

#export
stargazer(beta_1_bordersouth, beta_2_bordersouth, type="text", omit = "Constant", out = paste0(D,MAINNAME,"_beta.txt"))


## IV estimation

iv_1_bordersouth <- felm(politeness_score ~  1 + urban_rate + fractionalization + adu_bach + pov_allages| 0 | (prop_ScotchIrish_1790 ~ dist_shallowford), data=df)
summary(iv_1_bordersouth)
summary(iv_1_bordersouth$stage1, lhs='prop_ScotchIrish_1790')

#export
screenreg(list(iv_1_bordersouth$stage1), include.fstatistic = T, include.rsquared = F, stars = c(0.01, 0.05, 0.1), file=paste0(D,MAINNAME,"_ivstage1.txt"))
screenreg(list(iv_1_bordersouth), include.fstatistic = F, include.rsquared = F, include.adjrs = F, stars = c(0.01, 0.05, 0.1), file=paste0(D,MAINNAME,"_ivstage2.txt"))
