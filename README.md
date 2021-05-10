
# MKEsurfbot

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![](https://img.shields.io/badge/Twitter-@londonmapbot-white?style=flat&labelColor=blue&logo=Twitter&logoColor=white)](https://twitter.com/MKEsurf)

Source for the Twitter bot [@MKEsurf](https://www.twitter.com/MKEsurf). It posts satellite images of random coordinates in Greater London using [{rtweet}](https://docs.ropensci.org/rtweet/) and [GitHub Actions](https://docs.github.com/en/actions). 

# What

This repo contains a [GitHub Action](https://github.com/features/actions) that runs on schedule (currently every half-hour). It executes R code that queries [the Mapbox API](https://docs.mapbox.com/api/maps/#static-images) for a satellite image of random co-ordinates in a bounding box roughly around Greater London and within the M25 motorway. The image is posted to [@londonmapbot](https://www.twitter.com/londonmapbot) on Twitter using [{rtweet}](https://docs.ropensci.org/rtweet/), along with a URL for that location on [OpenStreetMap](https://www.openstreetmap.org/).
