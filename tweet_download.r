##    program:  tweet_download.r
##    task:     download tweets and write as file
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-17

# Program setup
library(tidyverse)
library(rtweet)

# search tweets for 'climate change' or 'global warming'. Note that rtweet requires search phrases to be in double quotes, not single quotes. Exclude RTs to keep only original content. Note that the rate limit is 18k tweets, so a search for 50k tweets will take at least 35 minutes and potentially more, depending on how moody Twitter's API at a given time. 

climate_search <- search_tweets(q = '"climate change" OR "global warming"', n = 50000, include_rts = FALSE, retryonratelimit = TRUE)

# copy climate_search so I don't accidentally overwrite it and have to re-do the tweet search

climate_search_archive <- climate_search
# add a column phrase that takes the value cc if the tweet said "climate change", gw if the tweet said "global warming", both if it said both, and other if the actual text of the tweet doesn't have either phrase. "Other" will occur when the phrases are in hashtags or URLs, for example.

climate_search <- climate_search %>% mutate(
  phrase = ifelse(grepl(climate_search$text,pattern = "(climate change)", ignore.case = TRUE) == TRUE & grepl(climate_search$text,pattern = "(global warming)", ignore.case = TRUE) == TRUE, "both",
                  ifelse(grepl(climate_search$text,pattern = "(climate change)", ignore.case = TRUE) == TRUE, "cc",
                         ifelse(grepl(climate_search$text,pattern = "(global warming)", ignore.case = TRUE) == TRUE, "gw",
                                "other"))))


# create a path name with today's date & time
path_name = paste0("./data/climate_tweets_",format(Sys.time(), "%Y-%m-%d_%H%M"),".csv")
write_csv(climate_search, path = path_name)
