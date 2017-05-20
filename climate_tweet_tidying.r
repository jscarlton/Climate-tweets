##    program:  climate_tweet_tidying.r
##    task:     turn the text of climate tweets into a tidy dataset
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-17

# Program setup
library(tidyverse)
library(tidytext)

# load tweets data. Use a variable for the filepath to make saving easier.

file_name <- "./data/climate_tweets_2017-05-18_0522.csv"
tweets_raw <- read_csv(file = file_name)

# Select out everything but the screen name, the tweet, and the phrase in order to keep the file size reasonable

tweets_tidy <- tweets_raw %>% select(screen_name, text, phrase)

# tidy by unnesting the tokens 
tweets_tidy <- tweets %>% 
  unnest_tokens(word, text)

# load stop words, add custom stop words based on the corpus, and filter them from the corpus
data("stop_words")

my_stop_words <- data.frame(
  word = c("t.co", "https", "amp", "climate", "change", "global", "warming"),
  lexicon = "climate_tweets"
)

stop_words <- full_join(stop_words,my_stop_words)
tweets_tidy <- anti_join(tweets_tidy, stop_words)

# create path, stripping out the .csv and adding - tidy.csv
tidy_path <- paste0(sub(pattern = ".csv", "", file_name),"-tidy.csv")

write_csv(tweets_tidy, path = tidy_path)
