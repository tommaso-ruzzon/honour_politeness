## TARGET: Run regressions on main sample
# INDATA: Main sample
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
df<-LOAD(dfinput=DFMAIN,pattdir=A)

## Linear model
lm_1 <- lm(politeness_score ~ prop_ScotchIrish_1790, df)
summary(lm_1)
se_lm1 <- coeftest(lm_1, vcov. = sandwich::vcovBS(lm_1, cluster = ~ FIPS_ST))
se_lm1

lm_2 <- lm(politeness_score ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages, data = df)
summary(lm_2)
se_lm2 <- coeftest(lm_2, vcov. = sandwich::vcovBS(lm_2, cluster = ~ FIPS_ST))
se_lm2

lm_3 <- lm(politeness_score ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages + factor(FIPS_ST), data = df)
summary(lm_3)
se_lm3 <- coeftest(lm_3, vcov. = sandwich::vcovBS(lm_3, cluster = ~ FIPS_ST))
se_lm3

#export
stargazer(lm_1, lm_2, lm_3, se=list(se_lm1[,"Std. Error"], se_lm2[,"Std. Error"], se_lm3[,"Std. Error"]), type="text", omit = c("FIPS_ST", "Constant"), omit.stat = c("rsq", "ser", "f"), add.lines = list(c("State f.e.", "No", "No", "Yes")), out=paste0(D,MAINNAME,"_lm.txt"))


## Beta regression
beta_1 <- betareg(politeness_score ~ prop_ScotchIrish_1790, data = df)
summary(beta_1)
se_beta1 <- coeftest(beta_1, vcov. = sandwich::vcovBS(beta_1, cluster = ~ FIPS_ST))
se_beta1

beta_2 <- betareg(politeness_score ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages, data = df)
summary(beta_2)
se_beta2 <- coeftest(beta_2, vcov. = sandwich::vcovBS(beta_2, cluster = ~ FIPS_ST))
se_beta2

#export
stargazer(beta_1, beta_2, se=list(se_beta1[,"Std. Error"], se_beta2[,"Std. Error"]), type="text", omit = "Constant", out=paste0(D,MAINNAME,"_beta.txt"))


## IV estimation

iv_1 <- felm(politeness_score ~  urban_rate + fractionalization + adu_bach + pov_allages| 0 | (prop_ScotchIrish_1790 ~ dist_shallowford), bootcluster="FIPS_ST", data=df)
summary(iv_1)
summary(iv_1$stage1)

iv_2 <- felm(politeness_score ~  urban_rate + fractionalization + adu_bach + pov_allages| factor(FIPS_ST) | (prop_ScotchIrish_1790 ~ dist_shallowford), bootcluster="FIPS_ST", data=df)
summary(iv_2)
summary(iv_2$stage1)

#export
screenreg(list(iv_1$stage1, iv_2$stage1), include.fstatistic = T, include.rsquared = F, stars = c(0.01, 0.05, 0.1), file=paste0(D,MAINNAME,"_ivstage1.txt"))
screenreg(list(iv_1, iv_2), include.fstatistic = F, include.rsquared = F, include.adjrs = F, stars = c(0.01, 0.05, 0.1), file=paste0(D,MAINNAME,"_ivstage2.txt"))
