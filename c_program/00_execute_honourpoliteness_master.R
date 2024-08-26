# THE LEGACY OF CULTURES OF HONOUR ON CONTEMPORARY POLITENESS

# TARGET: ordered execution of R.script(s) within public file routine
#NO detailed descriptions of data, method, etc. HERE -> done in R.scripts called upon

# CONVENTIONS of file naming, abbreviations:

#R.scripts: 	in general 		-> named like the dataset they produce, i.e., _varcreation_x.R
#PROGRAMS: 	-> CAPITAL LETTERS, automatically called upon by R.script executed

#df dataframe
#l list
#var variable


################################################################################################################+
# INTRO ####

#clear console
cat("\014")

#clear all globals in memory
rm(list = ls())
sink()

######################+
# non-automatable globals #####

#for master scriptname and extension #####
library(rstudioapi)
MAINNAME <- rstudioapi::getActiveDocumentContext()$path
MAINNAME <- sub(".*/|^[^/]*$", "", MAINNAME)
MAINNAME <- substr(MAINNAME,1,nchar(MAINNAME)-2)

# paths ####
HOME <- "/Users/tommaso/Desktop/LMU/Applied_Macroeconomics/Research_paper/Tommaso_honourpoliteness/"
DO <- paste0(HOME,"/project_honourpoliteness/c_program/")

######################+
# launch set-up scripts #####
input <- '00_execute_honourpoliteness_intro_aux.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)
#DEBUG <- T

################################################################################################################+
# MAIN PART ####

#############################################+
# read-in + basic editing of raw data: create base df ####
input <- 'honourpoliteness_databasics_counties.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_databasics_iq.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_databasics_honour.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_databasics_education.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_databasics_poverty.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_databasics_politeness_test.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_databasics_politeness_train.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

#############################################+
# variable grouping, selection, creation ####
input <- 'honourpoliteness_varcreation_controls_counties.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_varcreation_controls_iq.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_varcreation_controls_honour.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_varcreation_controls_education.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_varcreation_controls_poverty.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_varcreation_outcomes.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

input <- 'honourpoliteness_varcreation_merge.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

#############################################+
# main sample creation ####
input <- 'honourpoliteness_samplecreation_main.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

# var distribution checks (inherent and coding quality) ####
input <- 'honourpoliteness_analysis_vardistribution.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

# regressions####
input <- 'honourpoliteness_analysis_regressions_main.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

# figures ####
input <- 'honourpoliteness_analysis_figures.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)


#############################################+
# regressions (politeness_score_extreme) ####
input <- 'honourpoliteness_analysis_regressions_extreme.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)


#############################################+
# subsample creation ####
input <- 'honourpoliteness_samplecreation_robustness_deepsouth.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

# regressions ####
input <- 'honourpoliteness_analysis_regressions_deepsouth.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

#############################################+
# subsample creation ####
input <- 'honourpoliteness_samplecreation_robustness_bordersouth.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

# regressions ####
input <- 'honourpoliteness_analysis_regressions_bordersouth.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

#############################################+
# subsample creation ####
input <- 'honourpoliteness_samplecreation_robustness_north.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)

# regressions ####
input <- 'honourpoliteness_analysis_regressions_north.R'
source(paste0(DO,input,sep=""), echo=TRUE, max=1000)
