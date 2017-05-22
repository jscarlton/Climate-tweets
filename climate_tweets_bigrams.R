##    program:  climate_tweets_bigrams.R
##    task:     compare bigrams for climate tweets
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-22

# Program setup
library(tidyverse)
library(tidytext)
library(igraph)
library(ggraph)
library(stringr)

# set file path and import bigrams data
bigram_file <- "./data/climate_tweets_2017-05-18_0522-bigram.csv"

climate_bigrams = read_csv(bigram_file)

# Basic count info

climate_bigrams_10 <- climate_bigrams %>%
  count(bigram, sort = TRUE) %>% 
  filter(bigram != "climate change" & bigram != "global warming") %>% 
  top_n(10) %>%
  mutate(bigram = reorder(bigram, n))


ggplot(climate_bigrams_10, aes(bigram, n)) +
  geom_col(show.legend = FALSE) +
  labs(y = "Number of times mentioned",
       x = NULL,
       caption = "Data source: 122,379 tweets collected in May, 2017",
       title = "Obama's climate change speech was a popular thing to tweet about",
       subtitle = "(and adding context makes things more sensible)") +
  coord_flip() +
  theme_minimal()+
  theme(plot.caption = element_text(size = 6, hjust = 0, face = "italic"),
        panel.grid = element_blank())

bigram_path <- paste0(gsub(pattern = "(./)data(.+).+csv", "\\1graphs\\2", bigram_file),"-bigram_freq.png")

ggsave(filename = bigram_path)

# Now the cool path analysis thing
bigram_counts <- climate_bigrams %>% 
  count(bigram, sort = TRUE) %>% 
  separate(bigram, c("word1", "word2"), sep = " ") %>% 
  filter(
    !str_detect(word1, "\\d"),# filter out numbers
    !str_detect(word2, "\\d")) 
  

bigram_graph <- bigram_counts %>% 
  filter(n>400) %>% 
  graph_from_data_frame()

set.seed(2017)
a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()

network_path <- paste0(gsub(pattern = "(./)data(.+).+csv", "\\1graphs\\2", bigram_file),"-bigram_network.png")

ggsave(filename = network_path)
