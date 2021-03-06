# Short-term Drought Forecaster

This repository is the R code base for the Short-term Drought Forecaster (STDF). The STDF is
a tool that predicts weather and soil moisture for user-generated, specific coordinates (lat, long)
for the upcoming year.

## Non-technical Overview

The application works by evaluating user definition of site-specific attributes (location, soil, vegetation).
Location information is used to gather gridded historical weather data and weather predictions for the
upcoming year. Soils and vegetation information are needed to simulate soil moisture conditions, alongside
weather information.

The application currently returns predictions of weather and soil moisture in both graphical and tabular formats,
for both the upcoming year (12 months from current), as well as the historical period (1980 - current).

### Weather

Weather forecasts for the next 13 months are generated by meteorologists at the National
Weather Service for the United States at a regional scale. This tool takes this forecast information
and downscales it to the local (i.e. lat/long coordinates) level and runs simulations of the future
that represent a range of potential conditions. More information about this process and the logic is
[here](Documentation/WeatherLogicStepbyStep.md).

### Soil moisture

To generate soil moisture predictions, this tool runs iterations of the mechanistic water-balance model,
SOILWAT2. The source code for this model can be found [here](https://github.com/DrylandEcology/SOILWAT2).
SOILWAT2 is a point based (lat, long) model that requires users inputs of climate, soil texture, and
vegetation structure in order to simulate water balance and soil moisture conditions
for any time periods in which it is provided climate data.

## Technical Overview

### Application Development

Application source code was written exclusively in R.

The STDF is currently deployed as an API using the [plumber package](https://www.rplumber.io/).

#### Dependencies
Functionality for soil-water modeling relies on the R package: [rSOILWAT2](https://github.com/DrylandEcology/rSOILWAT2),
a R plugin for the C based code of SOILWAT2.

### Deployment
This app is containerized in [docker-compose](https://docs.docker.com/compose/) and hosted
on an AWS EC2 instance.

Details about deployment are contained in the repository's [cloud formation
script]('../EC2_AmazonLinux_Docker.yml').
