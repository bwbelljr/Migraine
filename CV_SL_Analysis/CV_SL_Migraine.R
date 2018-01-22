# Clear workspace
rm(list=ls())

# Import Migraine dataset with binary features

getwd()

# Load CSV into a data frame
MigraineData<- read.csv("migraine_data_march_dec_2014.csv")

# Install SuperLearner package
install.packages("SuperLearner")

# Install additional packages
install.packages("arm")
install.packages("caret")
install.packages("class")
install.packages("cvAUC")
install.packages("e1071")
install.packages("earth")
install.packages("gam")
install.packages("gbm")
install.packages("genefilter") # not available for R 3.1.2
install.packages("ggplot2")
install.packages("glmnet")
install.packages("Hmisc")
install.packages("ipred")
install.packages("lattice")
install.packages("LogicReg")
install.packages("MASS")
install.packages("mda")
install.packages("mlbench")
install.packages("nloptr")
install.packages("nnet")
install.packages("parallel")
install.packages("party")
install.packages("polspline")
install.packages("quadprog")
install.packages("randomForest")
install.packages("ROCR")
install.packages("rpart")
install.packages("SIS")
install.packages("spls")
install.packages("stepPlr")
install.packages("sva") # not available for R 3.1.2

#Load these packages
library("arm")
library("caret")
library("class")
library("cvAUC")
library("e1071")
library("earth")
library("gam")
library("gbm")
library("genefilter")
library("ggplot2")
library("glmnet")
library("Hmisc")
library("ipred")
library("lattice")
library("LogicReg")
library("MASS")
library("mda")
library("mlbench")
library("nloptr")
library("nnet")
library("parallel")
library("party")
library("polspline")
library("quadprog")
library("randomForest")
library("ROCR")
library("rpart")
library("SIS")
library("spls")
library("stepPlr")
library("sva")

# Load the SuperLearner package with the library function.
library('SuperLearner')

#Use the listWrappers() function to see built-in candidate algorithms
listWrappers()

# Create candidate library of algorithms for SuperLearner
# My ideal candidate library crashed my machine
# SL.library <- c('SL.glm', 'SL.glm.interaction', 'SL.randomForest', 'SL.ipredbagg', 'SL.gam', 'SL.gbm', 'SL.nnet', 'SL.polymars', 'SL.loess', 'SL.bayesglm', 'SL.step', 'SL.step.interaction', 'SL.ridge', 'SL.leekasso', 'SL.svm', 'SL.glmnet', 'SL.knn', 'SL.mean')
# This wish list took too long.

# Let's try this and see what happens
# SL.library <- c('SL.glm', 'SL.glm.interaction', 'SL.polymars', 'SL.loess', 'SL.step', 'SL.step.interaction', 'SL.leekasso', 'SL.mean')

# Let's use barebones SL library
# SL.library<- c("SL.glm", "SL.step", "SL.glm.interaction")
# this small library uses about 19% of memory...


SL.library<- ("SL.glm")

# Create data frame X with predictor variables
X<- subset(MigraineData, select= -c(headache, time) )

?SuperLearner



## examples with snow
# library(parallel)
cl <- makeCluster(detectCores(), type = "PSOCK") # can use different types here
clusterSetRNGStream(cl, iseed = 2343)

# Let's do the analysis with snow SuperLearner. This should take advantage of multicore

# Y = outcome (headache level)
# X = all binary predictors (excluding time for now)
# family = gaussian (continuous outcomes)
# verbose = TRUE.  TRUE for printing progress during the computation (helpful for debugging).
# SL.library = machine learning libraries we use
# Default is NNLS for error estimation.
# We also calculate the System time as well.
system.time(testSNOW <- snowSuperLearner(cluster = cl, Y = MigraineData$headache, X = X, SL.library = SL.library, family='gaussian', verbose = FALSE, method = "method.NNLS"))

# Let's try it without system.time
# Starting at 3/3/2015, 7:25pm
# testSNOW <- snowSuperLearner(cluster = cl, Y = MigraineData$headache, X = X, SL.library = SL.library, family='gaussian', verbose = TRUE, method = "method.NNLS")

stopCluster(cl)

# Let's try mcSuperLearner (verbose)
system.time(testMC <- mcSuperLearner(Y = MigraineData$headache, X = X, SL.library = SL.library, family='gaussian', verbose = TRUE, method = "method.NNLS"))

# Let's try  regular SuperLearner(verbose)
system.time(testSL <- SuperLearner(Y = MigraineData$headache, X = X, SL.library = SL.library, family='gaussian', verbose = TRUE, method = "method.NNLS"))

# Let's try  regular SuperLearner(NOT verbose)
system.time(testSL <- SuperLearner(Y = MigraineData$headache, X = X, SL.library = SL.library, family='gaussian', verbose = FALSE, method = "method.NNLS"))

# Let's try mcSuperLearner (NOT verbose)
system.time(testMC <- mcSuperLearner(Y = MigraineData$headache, X = X, SL.library = SL.library, family='gaussian', verbose = FALSE, method = "method.NNLS"))



########################################################################################################
# CV.Superlearner with parallel V-fold step...

# First set up a small SL library
SL.library<- c("SL.glm", "SL.step", "SL.glm.interaction")

cl <- makeCluster(detectCores(), type = "PSOCK") # can use different types here
clusterSetRNGStream(cl, iseed = 2343)

# CV.SuperLearner is a function to get V-fold cross-validated risk estimate for super learner.
# Y = outcome (headache level)
# X = all binary predictors (excluding time for now)
# V = 10 (number of folds for CV.SuperLearner)
# family = gaussian (continuous outcomes)
# verbose = TRUE.  TRUE for printing progress during the computation (helpful for debugging).
# SL.library = machine learning libraries we use
# Default is NNLS for error estimation.
# cvControl=list(V=10) means that we set cross-validation within SuperLearner to 10 folds
# parallel = 'multicore' uses parallel computation for V-fold step. Note that SL will still be sequential
# Note... this will take long BUT will give us honest cross-validated risk estimates for SuperLearner prediction for Headache.

CV.SL.out <- CV.SuperLearner(Y=MigraineData$headache, X=X, SL.library=SL.library, family='gaussian', V=10, verbose = TRUE, cvControl=list(V=10), parallel = 'multicore')

# I am not sure if parallel computation worked?

stopCluster(cl)

