
# MKEsurfbot

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![](https://img.shields.io/badge/Twitter-@mkesurf-white?style=flat&labelColor=blue&logo=Twitter&logoColor=white)](https://twitter.com/MKEsurf)

Source for the Twitter bot [@MKEsurf](https://www.twitter.com/MKEsurf). It posts surfing conditions in Milwaukee, WI using [{rtweet}](https://docs.ropensci.org/rtweet/) and [GitHub Actions](https://docs.github.com/en/actions). 

# What

This repo contains a [GitHub Action](https://github.com/features/actions) that runs on schedule (currently every half-hour). It executes R code that queries [Station 45013 - Atwater, WI](https://www.ndbc.noaa.gov/station_page.php?station=45013) for current lake meteorlogical observations and posts the conditions when the most recent wave height exceeds 3 feet. The tweet is posted to [@mkesurf](https://www.twitter.com/mkesurf) on Twitter using [{rtweet}](https://docs.ropensci.org/rtweet/). 
