##    program:  climate_tweets_sentiment_analysis.r
##    task:     analyze sentiment of climate tweets
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-18

# Program setup
library(tidyverse)
library(tidytext)
library(wordcloud)
library(reshape2)

# load data, setting file name to a variable so we can use it elsewhere

file_name <- "./data/climate_tweets_2017-05-18_0522.csv"
sentiment_tweets_raw <- read_csv(file = file_name)

# select the relevant columns and make a tidy dataset
sentiment_tweets <- sentiment_tweets_raw %>% 
  select(screen_name, created_at,status_id,text,retweet_count,phrase)

sentiment_tweets$created_at <- format(sentiment_tweets$created_at, "%Y-%m-%d")

sentiment_tweets_tidy <- sentiment_tweets %>% 
  unnest_tokens(word, text)

# Now, join with the sentiments to get a sentiment for each word in the tweets that is also in the sentiment dictionary.

bing_word_counts <- sentiment_tweets_tidy %>%
  inner_join(get_sentiments("bing")) %>%
  filter(word != "trump" & word != "like") %>% # 'trump' is positive in the sentiment dictionary, but probably not positive in this context :). Also, like is not used in the sense of "like" here.
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

# graph most common positive and negative words

bing_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Frequency",
       x = NULL) +
  coord_flip()

ggsave("./graphs/most_common_sentiments.png")

png("./graphs/sentiment_comparisoncloud.png", width = 7, height = 7, units = "in", res = 300)
sentiment_tweets_tidy %>%  
  inner_join(get_sentiments("bing")) %>%
  filter(word != "trump" & word != "like") %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                   max.words = 100)

dev.off()