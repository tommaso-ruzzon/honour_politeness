## TARGET: Run regressions on subsample "North"
# INDATA: Subsample "North"
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
df<-LOAD(dfinput=DFNORTH,pattdir=A)

## Linear model
lm_1_north <- lm(politeness_score ~ prop_ScotchIrish_1790, df)
summary(lm_1_north)
se_lm1_north <- coeftest(lm_1_north, vcov. = sandwich::vcovBS(lm_1_north, cluster = ~ FIPS_ST))

lm_2_north <- lm(politeness_score ~ prop_ScotchIrish_1790 +  urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages, data = df)
summary(lm_2_north)
se_lm2_north <- coeftest(lm_2_north, vcov. = sandwich::vcovBS(lm_2_north, cluster = ~ FIPS_ST))

lm_3_north <- lm(politeness_score ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages + factor(FIPS_ST), data = df)
summary(lm_3_north)
se_lm3_north <- coeftest(lm_3_north, vcov. = sandwich::vcovBS(lm_3_north, cluster = ~ FIPS_ST))

#export
stargazer(lm_1_north, lm_2_north, lm_3_north, se=list(se_lm1_north[,"Std. Error"], se_lm2_north[,"Std. Error"], se_lm3_north[,"Std. Error"]), type="text", omit = c("FIPS_ST", "Constant"), omit.stat = c("rsq", "ser", "f"), add.lines = list(c("State f.e.", "No", "No", "Yes")), out=paste0(D,MAINNAME,"_lm.txt"))


## Beta regression
beta_1_north <- betareg(politeness_score ~ prop_ScotchIrish_1790 , data = df)
summary(beta_1_north)
se_beta1_north <- coeftest(beta_1_north, vcov. = sandwich::vcovBS(beta_1_north, cluster = ~ FIPS_ST))

beta_2_north <- betareg(politeness_score ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + adu_bach + pov_allages, data = df)
summary(beta_2_north)
se_beta2_north <- coeftest(beta_2_north, vcov. = sandwich::vcovBS(beta_2_north, cluster = ~ FIPS_ST))
se_beta2_north

#export
stargazer(beta_1_north, beta_2_north, se=list(se_beta1_north[,"Std. Error"], se_beta2_north[,"Std. Error"]), type="text", omit = "Constant", out=paste0(D,MAINNAME,"_beta.txt"))


## IV estimation

iv_1_north <- felm(politeness_score ~  1 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages| 0 | (prop_ScotchIrish_1790 ~ dist_shallowford), data=df)
summary(iv_1_north)
summary(iv_1_north$stage1, lhs='prop_ScotchIrish_1790')

iv_2_north <- felm(politeness_score ~  1 + urban_rate + fractionalization + adu_bach + pov_allages| factor(FIPS_ST) | (prop_ScotchIrish_1790 ~ dist_shallowford), data=df)
summary(iv_2_north)
summary(iv_2_north$stage1, lhs='prop_ScotchIrish_1790')

#export
screenreg(list(iv_1_north$stage1, iv_2_north$stage1), include.fstatistic = T, include.rsquared = F, bootcluster="FIPS_ST", stars = c(0.01, 0.05, 0.1), file=paste0(D,MAINNAME,"_ivstage1.txt"))
screenreg(list(iv_1_north, iv_2_north), include.fstatistic = F, include.rsquared = F, include.adjrs = F, bootcluster="FIPS_ST", stars = c(0.01, 0.05, 0.1), file=paste0(D,MAINNAME,"_ivstage2.txt"))
