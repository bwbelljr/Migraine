# First, let's load migraine.csv into a dataframe...

# This will be the default location for all R Scripts...
migraine_df = read.csv("C:/Users/Bob/My Documents/My Box Files/Business/Migraine/R/migraine_data_march_dec_2014.csv")

# Let's check the dimension of migraine_df

dim (migraine_df)

# It's a 400,000 rows and 85 columns

# Let's remove all missing values...
migraine_df_complete <- na.omit (migraine_df)

# What is the dimension of this new data frame with no missing values?

dim (migraine_df_complete)

# It is still 400,000 by 85. I think this is because I did imputation...

# Since these are essentially the same, let's remove the new (duplicate) dataframe

rm(migraine_df_complete)

# Let's look at the names of the variables in our dataframe migraine_df

names(migraine_df)

# What type of variable is migraine_df$headache ?

typeof(migraine_df$headache) 
# It is currently an integer

# Let's turn this into a factor (categorical) variable...

# migraine_df$headache <- as.factor(migraine_df$headache)

# Now let's check that this is a factor variable

# typeof(migraine_df$headache)

summary(migraine_df$headache)

# [[ is the the programmatic equivalent of $
# Thus, it picks the second column of the dataframe (headache)
summary(migraine_df[[2]])

# Let's check that this works for the next column... sickness
summary(migraine_df$sickness)

summary(migraine_df[[3]])

# Yay! It works...

# Lastly, I need to know how to recover the name of each column heading...

colnames(migraine_df[2])
colnames(migraine_df[3])

# Okay, this is it!!!

# Though it says integer, the summary statistics are counts at the various levels...

# Let's do a histogram of headache level...
hist(migraine_df$headache)
# This works if migraine is considered a continuous variable...

# Error in hist.default(migraine_df$headache) : 'x' must be numeric
# Let's find a better way to deal with this...



# Correlation - let's do this for our variables
# This is a crude measure (linear) and treats our variables...
cor(migraine_df$headache, migraine_df$coq10)

# Try correlation between headache level and sickness
cor(migraine_df$headache, migraine_df$sickness)

# Try correlation between headache level and sickness, with multiple methods
cor(migraine_df$headache, migraine_df$sickness, method = c("pearson", "kendall", "spearman"))
# I got the same value... Let's try multiple methods

cor(migraine_df$headache, migraine_df$sickness, method = "pearson")
# Returns the same value...

cor(migraine_df$headache, migraine_df$sickness, method = "kendall")
# Kendall took too long. Alternatively, function cor.fk in package pcaPP.

cor(migraine_df$headache, migraine_df$sickness, method = "spearman")
# This returns a very different value than before...

cor(migraine_df$headache, migraine_df[[3]])

# Now let's make sure that the other way of referencing the vector works here with 

# for loop
# i is the iterator variable
# We start at the 3rd column "sickness" (first column is time and second column is headache)
# We end at length(colnames(migraine_df)) which is the number of columns in our dataframe
# In this loop (for now), we print out the column names.
# In the next session, we will use [[]] notation to compute pairwise correlation between
# headache and the respective variable/column
# We will then save the results to a new dataframe (or matrix), where the first column
# is the variable being correlated with headache (e.g, sickness) and the second column is
# is the correlation score.
# With this data structure, I can look at the max, min correlations.
# We can also create this as a function as well and vary the types of correlation we want
# to do.
# Later on, I wil find automated ways to do this from existing R packages. But it is good to
# implement the code here and now.

# I create two variables as an empty vector with 83 elements
variable <- var_cor_pearson <- var_cor_spearman <- rep (NA, 83)

# I use these two variables to create an empty (NA) dataframe cor_df
cor_df <- data.frame (variable, var_cor_pearson, var_cor_spearman)

for (i in 3:length(colnames(migraine_df))) {
  # First put the name of the variable into the dataframe
  # Index is i-2 because our index from migraine_df starts at 3
  # But the index for the new dataframe cor_df should start at 1
  cor_df$variable[i-2] <- colnames(migraine_df[i])
  
  # Next, we compute the pairwise correlation between headache level and the selected variable
  # We place this value into our new dataframe cor_df
  # As before, the index for cor_df is i-2, while the index for original dataframe migraine)df is i
  cor_df$var_cor_pearson[i-2]  <- cor(migraine_df$headache, migraine_df[[i]], method = "pearson" )
  cor_df$var_cor_spearman[i-2] <- cor(migraine_df$headache, migraine_df[[i]], method = "spearman")
  # Finally we print colnames to output to make sure we get what we think we should
  # print (colnames(migraine_df[i]))
}

# Let's find a convenient way to identify which variable is the max or min...

max(cor_df$var_cor_pearson) # kt indicator (as Kt increases, so does headache)

# Let's print out this variable name!

# First, we find the variable name where the value of the pearson correlation coefficient
# is equal to the max pearson correlation coefficient value.
cor_df$variable[max(cor_df$var_cor_pearson) == cor_df$var_cor_pearson]

# In a similar way, we do this for the minimum for Pearson. It should return vacation.
cor_df$variable[min(cor_df$var_cor_pearson) == cor_df$var_cor_pearson]

# Let's do the same for Spearman correlation coefficient.
# Here is the max for Spearman.
cor_df$variable[max(cor_df$var_cor_spearman) == cor_df$var_cor_spearman]
# Here, it is also kt_indicator.

# In a similar way, we do this for the minimum for Spearman. It should return vacation.
cor_df$variable[min(cor_df$var_cor_spearman) == cor_df$var_cor_spearman]
# Here, it is also vacation!

#   'x' must be numeric
# How can I get correlation for categorical variables???
# Also, try correlation for headache as a continuous variable...
# I think this exercise was useful... don't you?


# Finally, let's do some graphing of our variables and print them to a PDF for visual inspection.
# Before I do any fancy machine learning or statistical analysis, it is really important to see if the 
# (visual) exploratory data analysis will help me here.

# Here we copy the entire migraine dataframe without the time variable.
migraine_df_no_time <- subset(migraine_df, select=-time)

pairs(headache ~ sickness + flight + medical + berkeley , migraine_df_no_time)

# Note that the pairs function takes a VERY long time in R.
# Would pandas have similar functionality and take less time?
# Let's stop the running of pairs

# Let's do the following
# (1) Print a couple of (bivariate) graphs to a PDF and make sure they come out right
# (2) Can I print out the same graphs using an index instead of the name (probably)
# (3) If so, create a loop that prints out all bivariate graphs to a PDF file
# (4) Finally inspect this...
# (5) Note... this might take some time. Just get the process started.

# Can I plot two tables in the same PDF?
pdf ("2MigraineFigures.pdf ")
plot(migraine_df_no_time$headache, migraine_df_no_time$sickness)
plot(migraine_df_no_time$headache, migraine_df_no_time$flight)
dev.off ()

# note that opening the file
