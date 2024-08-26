# Overview

This project explores the influence of historical cultures of honour on contemporary politeness in the U.S., using Twitter data. By analyzing Tweets from counties with different proportions of Scottish and Irish settlers in 1790, we aim to assess the lasting impact of these cultural traits.

# Data Collection

Tweets: Around 470,000 Tweets were web-scraped from December 2014 to December 2022, focusing on users with geolocation info.
Politeness Classification: Each Tweet received a politeness score using a deep learning model trained on existing research data.
Historical Data: Included the proportion of Scottish and Irish settlers in 1790, contemporary socioeconomic data, and historical proxies like newspaper circulation from 1840.

## Note: The data used in this project is not included in the repository. Please contact me if you need access to the data.

# Methodology

Regression Analysis: Ordinary Least Squares (OLS) to examine the link between politeness scores and historical honour culture.
Instrumental Variable (IV) Estimation: Distance to Shallow Ford used as an instrument for more robust results.
Additional Checks: Region-specific regressions and negative binomial models for extreme politeness cases.

# File Structure

c_program/: Main scripts and code for running the project.
00_execute_honourpoliteness_master.py: Master script to run all processes.

d_results/: Outputs, including regression results and graphs.

# How to Run

Clone the repository:
```bash
git clone https://github.com/tommaso-ruzzon/honour_politeness.git
```
Navigate to the project directory:
```bash
cd honour_politeness/c_program
```
Run the master script:
```bash
python 00_execute_honourpoliteness_master.py
```

# Future work

Limitations include data imbalance and potential classifier inaccuracies.
Future work includes more balanced data collection and model improvements.
