##    program:  word_frequency_comp.r
##    task:     compare frequencies of word by global warming or climate change
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-17

# Program setup
library(tidyverse)
library(tidytext)
library(scales)
library(ggthemes)

# set up variable for file name to make saving easier
frequency_file <- "./data/climate_tweets_2017-05-18_0522-tidy.csv"

# load tidy data
tweets_freq <- read_csv(file = frequency_file)


# combine the two and create counts. This is cribbed heavily from Text Mining with R.

frequency <- tweets_freq %>% 
  filter(phrase != "both" & phrase != "other") %>%
  filter(!grepl("[0-9]+", word)) %>% 
  count(phrase, word) %>%
  group_by(phrase) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(phrase, proportion)

ggplot(frequency, aes(x = cc, y = gw, color = abs(gw - cc))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  theme_minimal() +
  theme(legend.position="none")


# save
freq_path <- paste0(gsub(pattern = "(./)data(.+).+csv", "\\1graphs\\2", frequency_file),"-freq_comp.png")

ggsave(filename = freq_path, width = 10, height = 10)
