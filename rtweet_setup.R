##    program:  rtweet_setup
##    task:     set up twitter token for future use
##    project:  climate tweets
##    author:   jsc
##    date:     2017-05-17

# This is to set up rtweet, following the directions at https://mkearney.github.io/rtweet/articles/auth.html

## whatever name you assigned to your created app
appname <- "jsc_rtweet"

## api key
key <- "RGU16XloKDjzEL4tsAYpQi0fr"

## api secret (example below is not a real key)
secret <- "JxhKOUT8W6Z1LpDknCvRpMl9BkUuPDkkvtyE1e8kZPem7Tc8ot"

## create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

## path of home directory
home_directory <- path.expand("~/")

## combine with name for token
file_name <- file.path(home_directory, "twitter_token.rds")

## save token to home directory
saveRDS(twitter_token, file = file_name)
