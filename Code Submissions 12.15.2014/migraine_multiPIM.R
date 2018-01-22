# Install and load multiPIM package

install.packages("multiPIM")

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

result <- multiPIM(Y, A, W=NULL, estimator = "TMLE", g.method="sl", g.sl.cands = all.bin.cands, g.num.folds=10, g.num.splits=1, Q.method="sl", Q.sl.cands="all", Q.num.folds=10, Q.num.splits=1, Q.type="continuous.outcome", adjust.for.other.As=TRUE)

#####################################################################################
# Code for 8 hour exposures

# Load data from migraine_24hr_only.csv into dataframe ObsData
ObsData_8hr <- read.csv("migraine_8hr_only.csv")

# Generate data frame containing binary exposure variables
A_8hr <- subset(ObsData_8hr, select=-c(time_8hr, time, headache_8hr))

# Generate data frame containing continuous outcome variable Y
Y_8hr <- subset(ObsData_8hr, select=headache_8hr)

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

result_8hr <- multiPIM(Y_8hr, A_8hr, W=NULL, estimator = "TMLE", g.method="sl", g.sl.cands = all.bin.cands, g.num.folds=10, g.num.splits=1, Q.method="sl", Q.sl.cands="all", Q.num.folds=10, Q.num.splits=1, Q.type="continuous.outcome", adjust.for.other.As=TRUE)


#####################################################################################
# Code for 2 hour exposures

# Load data from migraine_24hr_only.csv into dataframe ObsData
ObsData_2hr <- read.csv("migraine_2hr_only.csv")

# Generate data frame containing binary exposure variables
A_2hr <- subset(ObsData_2hr, select=-c(time_2hr, time, headache_2hr))

# Generate data frame containing continuous outcome variable Y
Y_2hr <- subset(ObsData_2hr, select=headache_2hr)

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

result_2hr <- multiPIM(Y_2hr, A_2hr, W=NULL, estimator = "TMLE", g.method="sl", g.sl.cands = all.bin.cands, g.num.folds=10, g.num.splits=1, Q.method="sl", Q.sl.cands="all", Q.num.folds=10, Q.num.splits=1, Q.type="continuous.outcome", adjust.for.other.As=TRUE)