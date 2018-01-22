# Install and load multiPIM package

install.packages("multiPIM")

library("multiPIM")

# Code for 24 hour exposures

# Load data from migraine_24hr_only.csv into dataframe ObsData
ObsData<- read.csv("migraine_24hr_only.csv")

# Generate data frame containing binary exposure variables
A <- subset(ObsData, select=-c(time_24hr, time, headache_24hr))

# Generate data frame containing continuous outcome variable Y
Y <- subset(ObsData, select=headache_24hr)

# Call multiPIM method
#
# Specify Y, A, and optional W data frames. 
# estimator = "TMLE" is targeted maximum likelihood
# g.method="sl" specifies super learning for g (treatment mechanism)
# g.sl.cands = all.bin.cands means that we create a library of candidate algorithms for fitting g, consisting of polyclass (polspline), penalized bin (L1 penalized logistic regression), main terms logistic and rpart.bin (recursive partitioning trees for binary outcomes).
# g.num.folds=10, g.num.splits=1 means we do 10-fold cross validation with 1 split for g super learning.
# Q.method="sl" specifies super learning for Q (outcome regression)
# Q.sl.cands="all" means that we create a library of candidate algorithms for fitting Q, consisting of polymars (multivariate adaptive regression splines), lars (lars package), main terms linear regression, L1 penalized linear regression (LASSO), and rpart.cont (recursive partitioning trees for continuous outcomes).
# Q.num.folds=10, Q.num.splits=1 means we do 10-fold cross validation with 1 split for Q super learning.
# Q.type="continuous.outcome" specifies that outcome variable is continuous
# adjust.for.other.As=TRUE means that each column of A (covariates/features) is included in fit of g (treatment mechanism) and Q (outcome regression)
# For future reference, use extra.cands argument to add additional machine learning algorihtms for fitting g and Q

result <- multiPIM(Y, A, W=NULL, estimator = "TMLE", g.method="sl", g.sl.cands = c("penalized.bin", "main.terms.logistic", "rpart.bin"), g.num.folds=10, g.num.splits=1, Q.method="sl", Q.sl.cands= c("lars", "main.terms.linear", "penalized.cont", "rpart.cont"), Q.num.folds=10, Q.num.splits=1, Q.type="continuous.outcome", adjust.for.other.As=TRUE)

# Save this script to a dataframe and then an excel...

# rm (result_df)

result_df <- data.frame(result$param.estimates[,0], result$param.estimates[,1], result$plug.in.stand.errs[,1])
write.csv(result_df, file="multipim24_results.csv")

# Which Column names in our dataframe
# colnames(result_df)

# How to index all the indicators...
# rownames(result_df)[1]

# rm (result2_df)

result2_df <- data.frame(result$num.exposures, result$num.outcomes, result$estimator, result$g.method, result$g.sl.cands, result$g.winning.cands, result$g.num.folds, result$g.num.splits, result$Q.method, result$Q.sl.cands, result$Q.num.folds, result$Q.num.splits, result$Q.type, result$Q.type, result$main.time, result$g.time, result$Q.time, result$g.sl.time, result$Q.sl.time, result$g.sl.cand.times, result$Q.sl.cand.times)
write.csv(result2_df, file="multipim24_settings.csv")
