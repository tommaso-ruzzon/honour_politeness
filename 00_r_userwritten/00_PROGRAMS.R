############################
# packages and libraries ####

#install.packages("AER") #run only once
library(AER)

#install.packages("dplyr")
library(dplyr)  # -------------------- clashes with plyr, thus assign  explicitly in code, dplyr::summarize() ... 

#install.packages("estimatr")
library(estimatr)

#install.packages("faux")
library(faux)

#install.packages("funModeling")
library(funModeling)

#install.packages("haven")
library(haven)

#install.packages("lfe")
library(lfe)

#install.packages("scriptName")
library(scriptName)

#install.packages("stargazer")
library(stargazer)

##install.packages("ggplot2")
library(ggplot2)

#install.packages("FRACTION")
library(FRACTION)

#install.packages("sjmisc")
library(sjmisc)

#install.packages("data.table")
library(data.table)

#install.packages("data.table")
library(data.table)

#install.packages("assertthat")
library(assertthat)

#install.packages("naniar")
library(naniar)

#install.packages("betareg")
library(betareg)

#install.packages("memisc")
library(memisc)

#install.packages("olsrr")
library(olsrr)

#install.packages("scales")
library(scales)

#install.packages("texreg")
library(texreg)

#install.packages("lmtest")
library(lmtest)

#install.packages("sandwich")
library(sandwich)

#install.packages("politeness")
library(politeness)

# -- General Spacyr configuration
#install.packages("reticulate")
library(reticulate)

# #install.packages("spacyr")
# library(spacyr)
# # spacy_install() # -- create a stand-alone conda environment including a python executable separate from your system Python (or anaconda python), install the latest version of spaCy (and its required packages), and download English language model
# spacy_initialize()

# COMMENT OUT (OR CUT) -- My specific configuration
Sys.setenv(RETICULATE_PYTHON = "/Users/tommaso/opt/miniconda3/envs/myenv_arm64/bin/python3")
library(reticulate)
library(spacyr)
spacyr::spacy_initialize(python_executable = "/Users/tommaso/opt/miniconda3/envs/myenv_arm64/bin/python3")


############################
# Functions ####
source(paste0(ADO,"CLEARCOND.R"), echo=TRUE, max=1000)  
source(paste0(ADO,"DEMOFUNCTION.R"), echo=TRUE, max=1000)  
source(paste0(ADO,"LOAD.R"), echo=TRUE, max=1000)  
source(paste0(ADO,"SAVE.R"), echo=TRUE, max=1000)  
