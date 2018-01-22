# Add this to console window for sense.io

# Set number of cores to 32...

library('sense')

# optionally include ggplot commands...

library("parallel")
detectCores() # This should be 32
numCores = detectCores()
numCores

# install.packages("forecast")
library("forecast")

#mydata = read.csv("Headache.csv")
mydata = read.csv("Headache_Aug_16_23.csv")

# Extract number of rows in data frame
mydata_length <- nrow(mydata)
mydata_length

# Extract latest time
mdata_last_time <- mydata$time[mydata_length]
mdata_last_time

plot(mydata$headache)

# Create msts() object for headache...
# This means that I can have multiple frequencies: hour (60) and day (1440)
ha_msts_many <- msts(mydata$headache, seasonal.periods=c(30, 60, 120, 180, 240, 360, 480, 720, 1440))

# ha_msts_many <- msts(mydata$headache, seasonal.periods=c(12, 30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600, 660, 720, 780, 840, 900, 960, 1020, 1080, 1140, 1200, 1260, 1320, 1380, 1440))

# Fit TBATS on data with multiple seasons
 
ha_tbats_many_fit <- tbats(ha_msts_many, h= 1440, use.parallel=TRUE, num.cores=numCores)

# Next time, time this code!!! My estimate is approximately 2 hours on 32 cores...

# Create forecast object
ha_tbats_many_forecast <- forecast(ha_tbats_many_fit) 

# plot simple forecast
plot(ha_tbats_many_forecast)

# A list containing information about the fitted model
ha_tbats_many_forecast$model

# TBATS(1, {1,0}, 0.997, {<30,4>, <60,1>, <120,1>, <180,1>, <240,1>, <360,1>, <480,1>, <720,1>, <1440,1>})

#Parameters
#Parameters
#  Alpha: 0.01091734
#  Beta: -3.105335e-05
#  Damping Parameter: 0.997134
#  Gamma-1 Values: 7.169963e-08 9.876706e-08 1.339558e-07 7.005227e-08 6.118782e-08 1.315107e-07 2.855928e-07 1.608208e-07 1.141362e-07
#  Gamma-2 Values: -1.070341e-07 6.63092e-08 -6.015409e-07 8.631575e-08 1.513088e-07 1.674032e-07 3.043384e-08 2.828268e-07 1.809086e-07
#  AR coefficients: 0.985684

# try to understand what these parameters mean!

# The name of the forecasting method as a character string
ha_tbats_many_forecast$method
# [1] "TBATS(1, {1,0}, 0.997, {<30,4>, <60,1>, <120,1>, <180,1>, <240,1>, <360,1>, <480,1>, <720,1>, <1440,1>})"

# Point forecasts as a time series
length(ha_tbats_many_forecast$mean) 
#2880
# This means we predict 2880 points into the future... Let's see what they are

# Let's look at some sample forecasts...
# I think this is per-minute data!!!
# It predicts twice the largest frequency...
ha_tbats_many_forecast$mean[1]
ha_tbats_many_forecast$mean[10]
ha_tbats_many_forecast$mean[50]
ha_tbats_many_forecast$mean[100]
ha_tbats_many_forecast$mean[200]
ha_tbats_many_forecast$mean[350]
ha_tbats_many_forecast$mean[900]
ha_tbats_many_forecast$mean[1050]
ha_tbats_many_forecast$mean[1400]
ha_tbats_many_forecast$mean[1600]
ha_tbats_many_forecast$mean[1800]
ha_tbats_many_forecast$mean[2000]
ha_tbats_many_forecast$mean[2200]
ha_tbats_many_forecast$mean[2450]
ha_tbats_many_forecast$mean[2850]

ha_tbats_many_forecast$mean[1:80]

# Extract components of a TBATS model
# not completely sure what this does
tbats.components(ha_tbats_many_fit)

# let's look at forecast 
ha_tbats_many_forecast[0]
ha_tbats_many_forecast[1]
ha_tbats_many_forecast[2]
ha_tbats_many_forecast[3]
ha_tbats_many_forecast[4]
ha_tbats_many_forecast[5]
ha_tbats_many_forecast[6]


ha_tbats_many_forecast_mean <- ha_tbats_many_forecast$mean
length(ha_tbats_many_forecast_mean) # Has 2880 predictions

# Get 95% upper forecasts
ha_tbats_many_forecast_upper95 <- ha_tbats_many_forecast$upper[,2]
length(ha_tbats_many_forecast_upper95) # Has 2880 predictions

# quick test
ha_tbats_many_forecast_upper95[10]

# Get 80% upper forecasts
ha_tbats_many_forecast_upper80 <- ha_tbats_many_forecast$upper[,1]
length(ha_tbats_many_forecast_upper80) # Has 2880 predictions

# quick test
ha_tbats_many_forecast_upper80[10]

# Get 95% lower forecasts
ha_tbats_many_forecast_lower95 <- ha_tbats_many_forecast$lower[,2]
length(ha_tbats_many_forecast_lower95) # Has 2880 predictions

# quick test
ha_tbats_many_forecast_lower95[10]

# Get 80% lower forecasts
ha_tbats_many_forecast_lower80 <- ha_tbats_many_forecast$lower[,1]
length(ha_tbats_many_forecast_lower80) # Has 2880 predictions

# quick test
ha_tbats_many_forecast_lower80[10]

################################################
# Figure out how to extract time elements from last time: mdata_last_time
# Then increment each forecast based on this last time

# strftime: Date-time Conversion Functions to and from Character
# %F is Equivalent to %Y-%m-%d (the ISO 8601 date format).
# %T is Equivalent to %H:%M:%S.

last_time <- strftime(mdata_last_time, format="%F %T", tz="PST")

last <- toString(last_time)
# "2014-12-09 11:39:00"

# figure out type...
typeof(get(ls()))

# Let's try the lubridate package
install.packages("lubridate")

library("lubridate")

# this only works when I convert to string
last_lubri <- parse_date_time(last, "%Y%m%d %H%M%S", tz="PST")

# Yay! This is how we increment time in R()!
last_lubri + 1*60
last_lubri + 2*60
last_lubri + 1440*60

################################################

# Create vector of times...
vectimes <- function(x) last_lubri + x*60
forecast_times <- vectimes( (1:2880) )

# Now let's check forecast_times...
length(forecast_times)
min(forecast_times)
max(forecast_times)
forecast_times[2]
forecast_times[2880]  

forecast_df <- data.frame(forecast_times, ha_tbats_many_forecast_mean, ha_tbats_many_forecast_upper95, ha_tbats_many_forecast_lower95, ha_tbats_many_forecast_upper80, ha_tbats_many_forecast_lower80)

forecast_df[0:5,]

nrow(forecast_df) # confirms we have 2880 observations

write.csv(forecast_df, file="ha_forecast_2880_dec2.csv", row.names=F)