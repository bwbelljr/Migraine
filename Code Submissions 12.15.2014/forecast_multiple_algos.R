# Parallel
library("parallel")
numCores = detectCores()

# Load forecast library
library("forecast")

# Read in one week (August 16-22, 2014) into mydata data frame
mydata = read.csv("Headache.csv")

# mydata$time[233641] 
# Index for 2014-08-16 00:00:00-07:00
start_index = 233641

# mydata$time[243720]
# Index for 2014-08-22 23:59:00-07:00
stop_index = 243720

# Here, create test index for assessing accuracy!
# test_start_index starts immediately after stop_index
test_start_index <- stop_index + 1

# test_end_index is the 1440th test observation
test_end_index   <- test_start_index + 1439

# Extract latest time
mdata_last_time <- mydata$time[stop_index]
mdata_last_time

# let's plot the headache level from start_index to stop_index
plot(mydata$headache[start_index:stop_index])

# Create headache as time series object with no frequency
ha_ts <- ts(mydata$headache[start_index:stop_index])

# Forecast: Let's get an automatic forecast
# h=1440 specifies the number of periods for forecasting (here, 1440 periods/minutes is one day)
# level=c(80,95) returns both 80% and 95% prediction intervals
# find.frequency = TRUE uses the function to determine the appropriate period, if the data is of unknown
# period
ha_forecast <- forecast(ha_ts, h=1440, level=c(80,95), find.frequency=TRUE)

# Let's do a plot of the forecast
plot(ha_forecast)

# Let's assess the accuracy
# We compare the forecasts from ha_forecast with actual values from the next day

auto_forecast_accuracy <- accuracy(ha_forecast, mydata$headache[test_start_index:test_end_index])
auto_forecast_accuracy

####################################################################
# Here I fit the data to best ARIMA model
# ha_ts is our time series
ha_fit_arima <- auto.arima(ha_ts)

ha_arima_forecast <- forecast(ha_fit_arima, h=1440)

ha_arima_accuracy <- accuracy(ha_arima_forecast, mydata$headache[test_start_index:test_end_index])
ha_arima_accuracy

####################################################################
# Neural Network Time Series Forecasts
# ha_ts is time series
ha_nnet_fit <- nnetar(ha_ts)

# Forecast 1440 periods based on
ha_nnet_forecast <- forecast(ha_nnet_fit, h=1440)

ha_nnet_accuracy <- accuracy(ha_nnet_forecast, mydata$headache[test_start_index:test_end_index])
ha_nnet_accuracy

####################################################################
# Exponential smoothing state space model
# ha_ts is time series
ha_ets_fit <- ets(ha_ts)

# Forecast 1440 periods based on
ha_ets_forecast <- forecast(ha_ets_fit, h=1440)

ha_ets_accuracy <- accuracy(ha_ets_forecast, mydata$headache[test_start_index:test_end_index])
ha_ets_accuracy

####################################################################
# thetaf Theta method forecast
# ha_ts is time series
# 80 and 95% prediction intervals with 1440 periods of forecasting
ha_thetaf_forecast <- thetaf(ha_ts, level=c(80,95), h=1440)

ha_thetaf_accuracy <- accuracy(ha_thetaf_forecast, mydata$headache[test_start_index:test_end_index])
ha_thetaf_accuracy


####################################################################
# TBATS model (Exponential smoothing state space model with Box-Cox transformation, ARMA errors, Trend and Seasonal components)
# ha_ts is time series (note, this is NOT msts object)
# We parallelize with numCores (4)
ha_tbats_fit <- tbats(ha_ts, use.parallel=TRUE, num.cores=numCores)

# Forecast 1440 periods
ha_tbats_forecast <- forecast(ha_tbats_fit, h=1440)

ha_tbats_accuracy <- accuracy(ha_tbats_forecast, mydata$headache[test_start_index:test_end_index])
ha_tbats_accuracy


####################################################################
# splinef: Cubic Spline Forecast
# ha_ts is time series
# 80 and 95% prediction intervals with 1440 periods of forecasting
ha_splinef_forecast <- splinef(ha_ts, level=c(80,95), h=1440)

ha_splinef_accuracy <- accuracy(ha_splinef_forecast, mydata$headache[test_start_index:test_end_index])
ha_splinef_accuracy


####################################################################
# rwf: Random Walk Forecast
# ha_ts is time series
# 80 and 95% prediction intervals with 1440 periods of forecasting
ha_rwf_forecast <- rwf(ha_ts, level=c(80,95), h=1440)

ha_rwf_accuracy <- accuracy(ha_rwf_forecast, mydata$headache[test_start_index:test_end_index])
ha_rwf_accuracy

####################################################################
Now let's print out all accuracies...
'


auto_forecast_accuracy
ha_arima_accuracy
ha_nnet_accuracy
ha_ets_accuracy
ha_thetaf_accuracy
ha_tbats_accuracy
ha_rwf_accuracy



####################################################################
# Let's print out arima forecasts for CSV...

#mdata_last_time <- mydata$time[stop_index]

#mdata_last_time

#mdata_last_time <- toString(mdata_last_time)

#last_time <- strftime(mdata_last_time, format="%F %T")
#last_time

#last <- toString(last_time)
# "2014-12-09 11:39:00"

# figure out type...
#typeof(get(ls()))

# Let's try the lubridate package
#install.packages("lubridate")

#library("lubridate")

# this only works when I convert to string
#last_lubri <- parse_date_time(last, "%Y%m%d %H%M%S", tz="PST")

# Yay! This is how we increment time in R()!
#last_lubri + 1*60
#last_lubri + 2*60
#last_lubri + 1440*60



forecast_df <- data.frame(ha_arima_forecast$mean, ha_arima_forecast$upper[,2], ha_arima_forecast$lower[,2], ha_arima_forecast$upper[,1], ha_arima_forecast$lower[,1], mydata$headache[test_start_index:test_end_index])

length(ha_arima_forecast$mean)
length(ha_arima_forecast$upper[,2]) # upper 95
length(ha_arima_forecast$lower[,2]) # lower 95
length(ha_arima_forecast$upper[,1]) # upper 80
length(ha_arima_forecast$lower[,1]) # lower 80
length(mydata$headache[test_start_index:test_end_index])

forecast_df[0:5,]

nrow(forecast_df) # confirms we have 1440 observations

write.csv(forecast_df, file="ha_forecast_1440_aug23_arima.csv", row.names=F)













# find the model with the best accuracy...
# then look at its numbers...

# Alternatively try this for 2 weeks prior to a day of forecasting
# when i have more time, find the optimal time window through cross-validation?
# Or maybe there is some theory behind this?


# OR just stop with this??? and evaluate accuracy on all models, including tbats...
# And just report that... in addition to my other forecasts???

# What else to consider
# tsoutliers: Identify and replace outliers in a time series
# tsdisplay(ha_ts): exploratory function showing auto-correlation
# tsclean: Identify and replace outliers and missing values in a time series... Maybe apply if I have outliers?
# BoxCox.lambda Automatic selection of Box Cox transformation parameter



#################################################################################
# let's try dshw
# First create msts object with only 2 frequencies - 60 (hour) and 1440 (day)
ha_msts_hr_day <- msts(mydata$headache, seasonal.periods=c(60, 1440))
ha_dshw_fit <- dshw(ha_msts_hr_day)
# dshw not suitable when data contain zeros or negative numbers

#################################################################################
# let's try stlf
# first a ts object with frequency 60
ha_ts_hr <- ts(mydata$headache, frequency=60)
ha_stlf_fit <- stlf(ha_ts_hr)
summary(ha_stlf_fit)



#################################################################################
# Create msts() object for headache...
# This means that I can have multiple frequencies: hour (60), day (1440), and week(10080)
ha_msts <- msts(mydata$headache, seasonal.periods=c(60, 1440, 10080), ts.frequency=60)




#################################################################################
# Use simple vector of numbers.. ANd forecast 1440 points in advance with splinef
ha_splinf_fit <- splinef(mydata$headache)

#Error: cannot allocate vector of size 1192.1 Gb
#In addition: Warning messages:
#  1: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)
#2: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)
#3: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)
#4: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)


# now let's try a ts object with frequency 60
ha_ts_hr <- ts(mydata$headache, frequency=60)
ha_splinf_fit <- splinef(ha_ts_hr)

#Error: cannot allocate vector of size 1192.1 Gb
#In addition: Warning messages:
#  1: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)
#2: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)
#3: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)
#4: In matrix(0, nrow = nn, ncol = nn) :
#  Reached total allocation of 15842Mb: see help(memory.size)



#################################################################################
# Let's try time series with frequency of 12 (12 minute intervals)
# And let's apply ets() to this

# ts object with frequency 12
ha_ts_twelve <- ts(mydata$headache, frequency=12)
ha_ets_fit <- ets(ha_ts_twelve)

# If this works, plot the forecasts!
plot(forecast(ha_ets_fit, h=1400))

# Explore this later!


# Re-apply ets to simple vector and see what happens
ha_ets_fit_vector <- ets(mydata$headache)
plot(forecast(ha_ets_fit_vector))

######################################################################################
# Create msts() object for headache...
# This means that I can have multiple frequencies: hour (60) and day (1440)
ha_msts_hr_day <- msts(mydata$headache, seasonal.periods=c(60, 1440))

# Fit TBATS on data with hourly and daily seasons

ha_tbats_hr_day_fit <- tbats(ha_msts_hr_day)

# Now this looks interesting: 
plot(forecast(ha_tbats_hr_day_fit))

summary(ha_tbats_hr_day_fit)

ha_tbats_hr_day_forecast <- forecast.tbats(ha_tbats_hr_day_fit) # this works...

ha_tbats_hr_day_forecast$model
length(ha_tbats_hr_day_forecast$mean) # this returns 2880 values...

# this gives h=2880, which is twice the largest frequency (1440)...

length(ha_tbats_hr_day_forecast$lower) # lower gives 5760 (probably two lower bounds)

length(ha_tbats_hr_day_forecast$upper) # upper gives 5760 (probably two upper bounds)

ha_tbats_hr_day_forecast$level # returns 80 95

ha_tbats_hr_day_forecast





###################################################################################
# Let's do tbats with a crazy msts time series involving the following frequencies:
# freq=30 (half-hour), 60 (hour), 120 (2 hours), 180 (3 hours), 240 (4 hours), 
# 360 (6 hours), 480 (8 hours), 720 (12 hours), and 1440 (day).

ha_msts_many <- msts(mydata$headache, seasonal.periods=c(30, 60, 120, 180, 240, 360, 480, 720, 1440))

library("parallel")
# library(help = "parallel")
numCores = detectCores()

# Fit TBATS on data with hourly and daily seasons

ha_tbats_many_fit <- tbats(ha_msts_many, use.parallel=TRUE, num.cores=numCores)
































################################################################################
# Next would be msts object of only 60 and 1440 periods with bats/tbats
# Another would be msts object with 60 (per hour) and 120 (per two hours) and maybe (480)
# Another would be ts object with 120 (per two hours) applied to arima

# Also do a simple forecast (fully automated) with vector (no frequency) and freq=12, 60, 
# 120, 240, 480, 960 and 1440.
# Exhaust all possibilities with this package!


# Finally, figure out how to do the following
# (1) RStudio Shiny (on this computer), including running in the cloud. Anyway to
# visualize this?
# (2) Run R Scripts on Sense.io as well as DOmino Data Lab - increasing clusters 
# and automated processes
# (3) Auto-updating headache level from CSV/Google calendar
# (4) Re-run Variable importance analysis (with weather data?) on cloud services? and for 
# 2hr, 8hr, and 24hr data.
# (5) Consider alternative variable importance measures, including tmle.npvi and RF for
# comparison...




# Convert headache to a time series
# ha_ts <- ts(mydata$headache, start=c(2014, 3), frequency=1)
ha_ts <- ts(mydata$headache) # Will this work?
plot(ha_ts) # Simple plot of headache data
hist(ha_ts) # histogram of headache data


# Automated forecasting using an exponential model
headache_ets <- ets(ha_ts)

# predictive accuracy for headache_ets
accuracy(headache_ets)

# predict next 10 observations with ets model
forecast(headache_ets, 10, level=95)
plot(forecast(headache_ets, 10))

# Automated forecasting using an ARIMA model
headache_arima <- auto.arima(ha_ts)

# predictive accuracy for headache_arima
accuracy(headache_arima)

# predict next 10 observations with arima model
forecast(headache_arima, 150, level=95)
plot(forecast(headache_arima, 10:11))

summary(headache_arima)



# # Automated forecasting using best package
# headache_auto <- forecast(ha_ts, 10000) # Asking for forecast on next 1440 time points...

# What happens if we just ask for forecast???
headache_auto <- forecast(ha_ts, h=1000) 


summary(headache_auto)

accuracy(headache_auto)



# What else can I do with ts object?


# Yay! this works! I just need to figure out the time scales in Python...
plot(forecast(ha_ts))

# Alternatively creating a forecast object called ha_forecast.
plot(forecast(ha_ts, h=1440))

daily_headache_forecast <- forecast(ha_ts, h=1440)

plot(daily_headache_forecast)

summary(daily_headache_forecast)

accuracy(daily_headache_forecast)

plot.forecast(daily_headache_forecast)

daily_headache_forecast$fitted[1000]

# I am getting some values. I just need to figure out what are the actual time points.
# Also, should I specify a number to predict into the future with or not???