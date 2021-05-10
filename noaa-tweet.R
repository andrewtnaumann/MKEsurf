rm(list=ls())

library(readr)
library(lubridate)
library(dplyr)
library(rtweet)
library(stringr)

# Create Twitter token
londonmapbot_token <- rtweet::create_token(
  app = "mkesurf",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

df_import <- readr::read_delim("https://www.ndbc.noaa.gov/data/realtime2/45013.txt", delim = " ")

# define "good" conditions
surf_wv_ht <- 1 # meter
surf_wv_per <- 5 # seconds

df_manipulate <- df_import %>%
  # save only columns we want and rename some columns
  select('#YY', ' MM', 'DD', 'hh', 'mm', 'WDIR', 'WSPD', 'GST', 'WVHT' = ' WVHT', 'DPD' = '  DPD',
         ' WTMP', ' ATMP') %>%
  # remove the first row with measurement units
  slice(-1) %>%
  mutate_if(is.character, as.numeric) %>%
  mutate(date = as.POSIXct(paste(`#YY`, "-", ` MM`, "-", `DD`, " ", `hh`, ":", `mm`, sep = ''), format = "%Y-%m-%d %H:%M")) %>%
  select(-c("#YY", " MM", "DD", "hh", "mm")) %>%
  arrange(date) %>%
  # take care of missing values - missing values can either be 0 or missing observation
  replace(is.na(.), 0)

# define "good" surf
df_vars <- df_manipulate %>%
  mutate(surfs_up = ifelse(WVHT >= surf_wv_ht & DPD >= surf_wv_per, 1, 0)
  ) %>%
  arrange(desc(date))

rose_breaks <- c(0, 360/32, (1/32 + (1:15 / 16)) * 360, 360)

rose_labs <- c(
  "North", "North-Northeast", "Northeast", "East-Northeast",
  "East", "East-Southeast", "Southeast", "South-Southeast",
  "South", "South-Southwest", "Southwest", "West-Southwest",
  "West", "West-Northwest", "Northwest", "North-Northwest",
  "North"
)

wind_dir <- tibble(
  wd = (0:16 / 16) * 360
)
df_wind_dir <- wind_dir %>%
  mutate(
    rose = cut(
      wd,
      breaks = rose_breaks,
      labels = rose_labs,
      right = FALSE,
      include.lowest = TRUE
    )
  )

df_recent <- df_vars %>%
  slice(1) %>%
  mutate(dummy=TRUE) %>%
  left_join(df_wind_dir %>% mutate(dummy=TRUE)) %>%
  filter(WDIR >= wd
         ) %>%
  select(-dummy) %>%
  arrange(desc(wd)) %>%
  slice(1)

# is there is surf within the past hour, send a text
if (df_recent$WVHT >= 1) {
  
  current_surf <- str_c(strftime(df_recent$date - hours(5)),":"," Waves "
                        , round(df_recent$WVHT *3.28, 0), " feet at ", df_recent$DPD
                        , " seconds. ", df_recent$rose, " wind at "
                        , round(df_recent$WSPD*1.15, 0), " mph. ", " Water temp: "
                        , round((df_recent$` WTMP` * (9/5))  + 32, 0), " degrees. ", " Air temp: "
                        , round((df_recent$` ATMP` * (9/5))  + 32, 0), " degrees. #milwaukee #surf")
  current_surf
  
  # Post the image to Twitter
  rtweet::post_tweet(
    status = current_surf
    # , media = temp_file
    , token = londonmapbot_token
  )
  
} else
{
}
