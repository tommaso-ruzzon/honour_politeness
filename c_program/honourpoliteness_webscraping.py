#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 13 14:15:59 2022

@author: tommaso
"""
#This script performs the following:
    #It scrapes Tweets based on the coordinates from the data frame: we need Tweets for each county (i.e. observation) in the dataframe
    #It stores the tweets' information and text in dictionaries.
    #It creates a dataframe of the scraped tweets' text and exports it to a CSV file.
    #It creates a dataframe of the tweet dates and exports it to another CSV file.

#pip install pandas
import pandas as pd
#pip install snscrape
import snscrape.modules.twitter as sntwitter
#pip install tqdm
from tqdm import tqdm
#pip install pyreadr
import pyreadr


#import honourpoliteness_samplecreation_main.rda from a_microdata
result = pyreadr.read_r("/Users/tommaso/Desktop/Tommaso_exampleprojects/honourpoliteness/project_honourpoliteness/a_microdata/honourpoliteness_samplecreation_main.rda")
df = result["honourpoliteness_samplecreation_main"] # extract the pandas data frame for object

#choose number of Tweets to scrape from each county
n_tweets=5000

#creating two dictionaries: one with all the tweets' information , one with only the text
dict_tweets_all = {}
dict_tweets_text = {}
for i in tqdm(df["coord"]): 
    dict_tweets_all[i] = []
    dict_tweets_text[i] = []
    loc = "{}, 20km".format(i)
    # my search term, using syntax for Twitter's Advanced Search
    search = 'geocode:"{}"'.format(loc)
    # Using TwitterSearchScraper to scrape data and append tweets to list
    for j,tweet in enumerate(sntwitter.TwitterSearchScraper(search).get_items()):
        if tweet.user.location and tweet.lang=="en" and not tweet.media:
            if j>n_tweets:
                break
            dict_tweets_all[i].append([tweet.user.username, tweet.date, tweet.content, tweet.coordinates, tweet.user.location, tweet.lang, tweet.inReplyToTweetId])
            dict_tweets_text[i].append([tweet.content])

'''
#Alternative
## PANEL DATA (Extension): get Tweets by year (and by county)
dict_tweets_all = {}
dict_tweets_text = {}
for i in tqdm(df_honour["coord"]): 
    dict_tweets_all[i] = []
    dict_tweets_text[i] = []
    loc = "{}, 20km".format(i)
    for year in range(2010,2023): #not possible to scrape Tweets before 2010 using snscrape
        # my search term, using syntax for Twitter's Advanced Search
        search = 'lang:en geocode:"{}" since:{}-01-01 until:{}-12-20 '.format(loc,year, year) # scrape until Dec 20th because holiday wishes might bias politeness indicators
        # Using TwitterSearchScraper to scrape data and append tweets to list
        for j,tweet in enumerate(sntwitter.TwitterSearchScraper(search).get_items()):
            if tweet.user.location and not tweet.media:
                if j>n_tweets:
                    break
                dict_tweets_all[i].append([tweet.user.username, tweet.date, tweet.content, tweet.coordinates, tweet.user.location, tweet.lang, tweet.inReplyToTweetId])
                dict_tweets_text[i].append([tweet.content])
'''

county_codes = df["county_code"].tolist()
dict_tweets_all = dict(zip(county_codes, list(dict_tweets_all.values())))
dict_tweets_text = dict(zip(county_codes, list(dict_tweets_text.values())))

#create dataframe of Tweets
df_tweets = pd.DataFrame.from_dict(dict_tweets_text, orient="index")
df_tweets = df_tweets.reset_index()
df_tweets=df_tweets.rename(columns = {'index':'county_code'})


#export dataframe with tweets
df_tweets.to_csv("/Users/tommaso/Desktop/Tommaso_exampleprojects/honourpoliteness/project_honourpoliteness/a_microdata/df_tweets.csv", index=False) # The scraped tweets will then be scored by the politeness classifier (in R)

#create dataframe of dates (ordered by county_code)
dates=[]
for j in dict_tweets_all.items():
    for h in j[1]:
        dates.append(h[1])

dates=pd.DataFrame(dates)

#export dataframe with dates
dates.to_csv("/Users/tommaso/Desktop/Tommaso_exampleprojects/honourpoliteness/project_honourpoliteness/a_microdata/df_dates.csv", index=False) #panel data will be analysed in R (file "honourpoliteness_varcreation_outcomes")
