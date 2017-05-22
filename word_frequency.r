##    program:  word_frequency.r
##    task:     overview of the frequencies of different words
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-20

# Program setup
library(tidyverse)
library(tidytext)
library(scales)
library(ggthemes)
library(wordcloud)
library(RColorBrewer)

# set up variable for file name to make saving easier
frequency_file <- "./data/climate_tweets_2017-05-18_0522-tidy.csv"

# load tidy data
tweets_freq <- read_csv(file = frequency_file)


# Create counts of each word. This is cribbed heavily from Text Mining with R.

frequency <- tweets_freq %>% 
  filter(!grepl("[0-9]+", word)) %>% # filter out numbers
  filter(word != "climatechange") %>% 
  count(word) %>%
  top_n(10) %>% 
  mutate(word = reorder(word, n))

ggplot(frequency, aes(word, n)) +
  geom_col(show.legend = FALSE) +
  labs(y = "Number of times mentioned",
       x = NULL) +
  coord_flip() +
  theme_minimal()


# save
freq_path <- paste0(gsub(pattern = "(./)data(.+).+csv", "\\1graphs\\2", frequency_file),"-word_freq.png")

ggsave(filename = freq_path, width = 10, height = 10)

# Now, a wordcloud
freq_path <- paste0(gsub(pattern = "(./)data(.+).+csv", "\\1graphs\\2", frequency_file),"-word_cloud.png")

color_pal <- c(brewer.pal(9,"Blues")[5],brewer.pal(9,"Blues")[6],brewer.pal(9,"Blues")[7],brewer.pal(9,"Blues")[8],brewer.pal(9,"Blues")[9] )

png(filename = freq_path, width = 8, height = 8, units = "in",res = 300)

wordcloud_freq <- tweets_freq %>% 
  filter(!grepl("[0-9]+", word)) %>% # filter out numbers
  filter(word != "climatechange") %>% 
  count(word) %>% 
  with(wordcloud(word, n, max.words = 200, random.order = FALSE, colors = color_pal, scale = c(5,1)))

dev.off()
