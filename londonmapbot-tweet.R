# remove and add t YAML file when done!!
library(twitteR)
library(rvest)
library(stringr)
library(dplyr)

# Create Twitter token
londonmapbot_token <- rtweet::create_token(
  app = "MKEsurf",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

# scrape data 
current_url <- "http://magicseaweed.com/Milwaukee-Surf-Report/962/"

current <- read_html(current_url) %>%
  html_nodes(".msw-fc-current-v0 .row") %>%
  html_text()  %>% str_split("        ")

body_nodes <- current %>% 
  html_node("body") %>% 
  html_children()

body_nodes 
body_nodes %>% html_children()

current <- unlist(current)

# clean up empty cells and split phrases for easy use
cond <- current
cond <- cond[!str_detect(cond, "Wind Swell")]
cond <- cond[!str_detect(cond, "Secondary Swell")]
cond[cond==""] <- NA
cond <- cond[complete.cases(cond)]
cond <- str_trim(cond, "both") %>%
  str_split(" ")

waves <- cond[[1]]
wind <- cond[[2]]
swell <- cond[[3]]
weather <- cond[[4]]

current_surf <- str_c(strftime(Sys.time(),"%I:%M %p"),":"," Waves ", waves, " with a ", swell[2], " of ", 
                      swell[6], " at ", swell[8], ". ", wind[3], " wind at ", wind[1], ". ", weather[1], 
                      "and ", weather[3], " Water temp: ", weather[5], weather[6], ". #elporto #surf")
current_surf


# Post the image to Twitter
rtweet::post_tweet(
  status = latlon_details,
  media = temp_file,
  token = londonmapbot_token
)
