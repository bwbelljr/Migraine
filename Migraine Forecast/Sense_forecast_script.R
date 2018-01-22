# Add this to console window for sense.io

# Set number of cores to 32...

library('sense')

# optionally include ggplot commands...

library("parallel")
detectCores() # This should be 32
numCores = detectCores()

install.packages("forecast")
library("forecast")

mydata = read.csv("Headache.csv")
plot(mydata$headache)

# Create msts() object for headache...
# This means that I can have multiple frequencies: hour (60) and day (1440)
ha_msts_many <- msts(mydata$headache, seasonal.periods=c(30, 60, 120, 180, 240, 360, 480, 720, 1440))

# Fit TBATS on data with multiple seasons
 
ha_tbats_many_fit <- tbats(ha_msts_many, use.parallel=TRUE, num.cores=numCores)
