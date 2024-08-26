## TARGET: Run negative binomial regressions using a politeness score calculated on extremely (im)polite Tweets
# INDATA: Main data
# OUTDATA/ OUTPUT: Regression outputs with dependent variable "Politeness_score_extreme"

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

#Summary statistics
mean_byregion<-with(df, tapply(politeness_score_extreme, Region, mean))
mean_byregion

var(df$politeness_score_extreme)
hist(df$politeness_score_extreme)
plot(density(df$politeness_score_extreme))

## Check collinearity
model <- lm(politeness_score_extreme ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages, data = df)

ols_vif_tol(model)
eigenvalues <- as.data.frame(ols_eigen_cindex(model))
ols_plot_obs_fit(model)

plot(df$politeness_score_extreme ~ df$prop_ScotchIrish_1790)

##Poisson or negative binomial?
pois_1 <- glm(politeness_score_extreme ~ prop_ScotchIrish_1790, family="poisson", df)
summary(pois_1)
coeftest(pois_1, vcov. = sandwich::vcovBS(pois_1, cluster = ~ FIPS_ST))

nb_1 = glm.nb(politeness_score_extreme ~ prop_ScotchIrish_1790, data = df) 
summary(nb_1)
se_nb1 <- coeftest(nb_1, vcov. = sandwich::vcovBS(nb_1, cluster = ~ FIPS_ST))

#Residual plot for Poisson regression
p_res <- resid(pois_1)
plot(fitted(pois_1), p_res, col='steelblue', pch=16,
     xlab='', ylab='Standardized Residuals', main='Poisson')
abline(0,0)

#Residual plot for negative binomial regression 
nb_res <- resid(nb_1)
plot(fitted(nb_1), nb_res, col='steelblue', pch=16,
     xlab='', ylab='Standardized Residuals', main='Negative Binomial')
abline(0,0)

# Residuals are too large in the Poisson: use NB

nb_2 <- glm.nb(politeness_score_extreme ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages, data = df)
summary(nb_2)
se_nb2 <- coeftest(nb_2, vcov. = sandwich::vcovBS(nb_2, cluster = ~ FIPS_ST))

nb_3 <- glm.nb(politeness_score_extreme ~ prop_ScotchIrish_1790 + urban_rate + fractionalization + num_allnews_pc + adu_bach + pov_allages + factor(FIPS_ST), data = df)
summary(nb_3)
se_nb3 <- coeftest(nb_3, vcov. = sandwich::vcovBS(nb_3, cluster = ~ FIPS_ST))

stargazer(nb_1, nb_2, nb_3, se=list(se_nb1[,"Std. Error"], se_nb2[,"Std. Error"], se_nb3[,"Std. Error"]), type="text", omit = c("FIPS_ST", "Constant"), omit.stat = c("rsq", "ser", "f"), add.lines = list(c("State f.e.", "No", "No", "Yes")), out = paste0(D,MAINNAME,"_nb.txt"))

