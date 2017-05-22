##    program:  climate_tweets_hashtag_analysis.R
##    task:     initial analysis of hashtags
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-22

# Program setup
library(tidyverse)
library(tidytext)
library(scales)
library(wordcloud)


# load data. Set file_name to make saving easier later
file_name <- "./data/climate_tweets_2017-05-18_0522-tidy_hastags.csv"
climate_hashtags <- read_csv(file_name)

climate_hashtags_15 <- climate_hashtags %>% 
  count(word) %>%
  top_n(15) %>% 
  mutate(word = reorder(word, n))

ggplot(climate_hashtags_15, aes(word,n)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Top 15 climate-related hashtags on Twitter",
       subtitle = "Mid-May, 2017",
       caption = "Data source: 122,379 tweets collected in May, 2017",
       y = "Number of tweets",
       x = NULL) +
  coord_flip() +
  theme_minimal() +
  theme(plot.caption = element_text(size = 6, hjust = 0, face = "italic"),
        panel.grid = element_blank())

# save
hash_freq_path <- paste0(gsub(pattern = "(./)data(.+).+csv", "\\1graphs\\2", file_name),"-hashtag_freq.png")

ggsave(filename = hash_freq_path, width = 10, height = 10)

# Wordcloud because why not

# Now, a wordcloud
hash_wordcloud_path <- paste0(gsub(pattern = "(./)data(.+).+csv", "\\1graphs\\2", frequency_file),"-hash_tagword_cloud.png")

color_pal <- c(brewer.pal(9,"Blues")[7],brewer.pal(9,"Blues")[8],brewer.pal(9,"Blues")[9] )

png(filename = hash_wordcloud_path, width = 8, height = 8, units = "in",res = 300)

wordcloud_hash <- climate_hashtags %>% 
  count(word) %>% 
  with(wordcloud(word, n, max.words = 250, random.order = FALSE, colors = color_pal, scale = c(5,1)))

dev.off()
