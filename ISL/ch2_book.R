# For example, to create a vector of numbers, we use the function c() (for concatenate). 
# Any numbers inside the parentheses are joined together. The following command instructs R 
# to join together the numbers 1, 3, 2, and 5, and to save them as a vector named x. When we 
# type x, it vector gives us back the vector.

x <- c(1,3,2,5)
x

# We can also save things using = rather than <-:

x = c(1,6,2)
x
y = c(1,4,3)

# Personal note: However, I really want to keep with <- notation. It makes it clear what
# the assignment operator is really doing!

# typing ?funcname will always cause R to open a new help file window with additional information about the 
# function funcname.

?rnorm

# We can tell R to add two sets of numbers together. It will then add the first number from x 
# to the first number from y, and so on. However, x and y should be the same length. We can 
# check their length using the length() function.

length (x)
length (y)
x+y

# The ls() function allows us to look at a list of all of the objects, such as data and 
# functions, that we have saved so far. The rm() function can be used to delete any that we 
# don’t want.

ls()
rm(x,y)
ls()

# Personal Note: think of ls() like the Unix command to list the files and directories.
# think of rm as "remove"

# It’s also possible to remove all objects at once:

rm(list=ls())

# This is a very useful command! And one that I always forget!

# The matrix() function can be used to create a matrix of numbers. Before we use the matrix() 
# function, we can learn more about it:

?matrix

# The help file reveals that the matrix() function takes a number of inputs, but for now we 
# focus on the first three: the data (the entries in the matrix), the number of rows, and the 
# number of columns. First, we create a simple matrix.

x=matrix (data=c(1,2,3,4) , nrow=2, ncol =2)

# Note that by default, byrow=FALSE. Thus, it enters the values column-wise...

# Show the matrix
x

# Note that we could just as well omit typing data=, nrow=, and ncol= in the matrix() command 
# above: that is, we could just type

x=matrix (c(1,2,3,4) ,2,2)

# I think in general, we can type in the parameter values in the order in which they are
# defined in the function.
# I think I want to always include the parameter names so that when I return to my code, I am
# clear on what I was trying to accomplish. Data may be more verbose, but readable.


# Let's populate matrix by row
matrix (c(1,2,3,4) ,2,2,byrow =TRUE)

# Notice that in the above command we did not assign the matrix to a value such as x. In this 
# case the matrix is printed to the screen but is not saved for future calculations.

# The sqrt() function returns the square root of each element of a vector or matrix. The 
# command x^2 raises each element of x to the power 2; any powers are possible, including fractional or 
# negative powers.

sqrt(x)

x^2

# The rnorm() function generates a vector of random normal variables, with first argument n 
# the sample size. Each time we call this function, we will get a different answer. Here we 
# create two correlated sets of numbers, x and y, and use the cor() function to compute the 
# correlation between them.

# First, let's look up the documentation for rnorm

?rnorm
# Note that the default is mean=0 and sd=1

# Here we create 50 (standard) normal random variables
x=rnorm (50)

# Here we create 50 random variables that are the addition of x and 50 other normal random
# variables with mean (50) and sd=0.1
y=x+rnorm (50, mean=50, sd=.1)

# Let's look up cor() function
?cor

# cor(x, y = NULL, use = "everything", method = c("pearson", "kendall", "spearman"))
# Learn more about these forms of correlation, and implement them on my migraine dataset.

# Let's find the correlation between x and y
cor(x,y)

# By default, rnorm() creates standard normal random variables with a mean of 0 and a 
# standard deviation of 1. However, the mean and standard deviation can be altered using the 
# mean and sd arguments, as illustrated above.

# Sometimes we want our code to reproduce the exact same set of random numbers; we can use 
# the set.seed() function to do this. The set.seed() function takes an (arbitrary) integer 
# argument.

set.seed (1303)
rnorm (50)

# Now let's run this again and see if I get the same values...

set.seed (1303)
rnorm (50)

# Now let's set the seed to something else and see how the values differ

set.seed (252)
rnorm (50)

# These are different values... set.seed can be useful for simulations...

# We use set.seed() throughout the labs whenever we perform calculations involving random 
# quantities. In general this should allow the user to reproduce our results. However, it 
# should be noted that as new versions of R become available it is possible that some small 
# discrepancies may form between the book and the output from R.

# The mean() and var() functions can be used to compute the mean and variance of a vector of 
# numbers. Applying sqrt() to the output of var() will give the standard deviation. Or we can 
# simply use the sd() function.

# Set seed to 3
set.seed (3)

# Create 100 standard normal random variables
y=rnorm (100)

# calculate the mean of y. Hint: it should be close to 0
mean(y)

# calculate the variance of y. Hint: it should be close to 1
var(y)

# Calculate standard deviation, which is the square root of the variance
sqrt(var(y))

# Note that sd() does the same as sqrt(var())
sd(y)

# The plot() function is the primary way to plot data in R. For instance, plot(x,y) produces 
# a scatterplot of the numbers in x versus the numbers in y. There are many additional 
# options that can be passed in to the plot() function. For example, passing in the argument 
# xlab will result in a label on the x-axis. To find out more information about the plot() 
# function, type ?plot.

?plot

# Create 100 standard normal random variables
x=rnorm (100)

# Create another 100 standard normal random variables
y=rnorm (100)

# Plot x against y
plot(x,y)
# Note, there doesn't seem to be any visible correlation amongst the two variables...

# Let's plot this again with the following parameters:
# xlab is the title for the x-axis "this is the x-axis"
# ylab is the title for the y-axis "this is the y-axis"
# main is the overall title fot the plot " Plot of X vs Y"
plot(x,y,xlab=" this is the x-axis",ylab=" this is the y-axis", main=" Plot of X vs Y")

# We will often want to save the output of an R plot. The command that we use to do this will 
# depend on the file type that we would like to create. For instance, to create a pdf, we use 
# the pdf() function, and to create a jpeg, we use the jpeg() function.

pdf (" Figure .pdf ")
plot(x,y,col =" green ")
dev.off ()

# The function dev.off() indicates to R that we are done creating the plot.

# Can I plot two tables in the same PDF?
pdf ("2Figures.pdf ")
plot(x,y,col =" green ")
plot(y,x,col =" black ")
dev.off ()

# Yes we can!!! This can be a framework for plotting all migraine tables...

# Alternatively, we can simply copy the plot window and paste it into an appropriate file 
# type, such as a Word document.

# The function seq() can be used to create a sequence of numbers. For instance, seq(a,b) 
# makes a vector of integers between a and b. There are many other options: for instance, 
# seq(0,1,length=10) makes a sequence of 10 numbers that are equally spaced between 0 and 1. 
# Typing 3:11 is a shorthand for seq(3,11) for integer arguments.

# Create an integer sequence from 1 to 10
x=seq (1 ,10)
x

# This code also creates an integer sequence from 1 to 10
x=1:10
x

# This creates a sequence of 50 equally spaced numbers from -pi to pi
# Also note that we can specify pi as "pi"
x=seq(-pi ,pi ,length =50)
x

# We will now create some more sophisticated plots. The contour() function produces a contour 
# plot in order to represent three-dimensional data; it is like a topographical map. It takes 
# three arguments:
# 1. A vector of the x values (the first dimension),
# 2. A vector of the y values (the second dimension), and
# 3. A matrix whose elements correspond to the z value (the third dimension) for each pair of 
#    (x,y) coordinates.

# As with the plot() function, there are many other inputs that can be used to fine-tune the 
# output of the contour() function. To learn more about these, take a look at the help file 
# by typing ?contour.

?contour
# We set y=x
y=x

?outer
# I don't quite understand the outer() function here... Let's get into this later...
f=outer(x,y,function (x,y)cos(y)/(1+x^2))
contour (x,y,f)
contour (x,y,f,nlevels =45, add=T)
fa=(f-t(f))/2
contour (x,y,fa,nlevels =15)

# The image() function works the same way as contour(), except that it produces a color-coded 
# plot whose colors depend on the z value. This is known as a heatmap, and is sometimes used 
# to plot temperature in weather forecasts. Alternatively, persp() can be used to produce a 
# three-dimensional plot. The arguments theta and phi control the angles at which the plot is
# viewed.

image(x,y,fa)
persp(x,y,fa)
# Note: I really like persp! Let's use this to create 3-d plots for migraine data...

persp(x,y,fa ,theta =30)

persp(x,y,fa ,theta =30, phi =20)

persp(x,y,fa ,theta =30, phi =70)

persp(x,y,fa ,theta =30, phi =40)

# 2.3.3 Indexing Data

# We often wish to examine part of a set of data. Suppose that our data is stored in the 
# matrix A.

A=matrix (1:16 ,4 ,4)
A

# Then, typing
A[2,3]

# will select the element corresponding to the second row and the third column. The first 
# number after the open-bracket symbol [ always refers to the row, and the second number 
# always refers to the column. We can also select multiple rows and columns at a time, by 
# providing vectors as the indices.

A[c(1,3) ,c(2,4) ]
A[1:3 ,2:4]
A[1:2 ,]
A[ ,1:2]

# The last two examples include either no index for the columns or no index for the rows. 
# These indicate that R should include all columns or all rows, respectively. R treats a 
# single row or column of a matrix as a vector.

A[1,]

# The use of a negative sign - in the index tells R to keep all rows or columns except those 
# indicated in the index.

A[-c(1,3) ,]

# The dim() function outputs the number of rows followed by the number of  columns of a 
# given matrix.
dim(A)

# 2.3.4 Loading Data
# They load a dataset from a text file. INstead, I will load from the ISLR package...
library (ISLR)

# Once the data has been loaded, the fix() function can be used to view it in a spreadsheet 
# like window. However, the window must be closed before further R commands can be entered.
fix(Auto)

# na.omit() function simply removes rows with missing data

# Once the data are loaded correctly, we can use names() to check the variable names.
names(Auto)

# We can use the plot() function to produce scatterplots of the quantitative variables. 
# However, simply typing the variable names will produce an error message, because R does not 
# know to look in the Auto data set for those variables.
plot(cylinders , mpg)

# To refer to a variable, we must type the data set and the variable name joined with a $ 
# symbol. Alternatively, we can use the attach() function in order to tell R to make the 
# variables in this data frame available by name

plot(Auto$cylinders , Auto$mpg)

attach (Auto)
plot(cylinders , mpg)

# Personal note: I would rather NOT use the attach function. I would rather refer to 
# variables with respect to their dataframe.

# The cylinders variable is stored as a numeric vector, so R has treated it as quantitative. 
# However, since there are only a small number of possible values for cylinders, one may 
# prefer to treat it as a qualitative variable. The as.factor() function converts 
# quantitative variables into qualitative variables.

cylinders = as.factor (cylinders)

# Personal note: apply this to migraine headache variable.

# If the variable plotted on the x-axis is categorial, then boxplots will automatically be 
# produced by the plot() function. As usual, a number of options can be specified in order to 
# customize the plots.

# Here, just plot mpg as a function of cylinders
plot(cylinders , mpg)

# Same plot, but make the color "red"
plot(cylinders , mpg , col ="red ")
 
plot(cylinders , mpg , col ="red", varwidth =T)

plot(cylinders , mpg , col ="red", varwidth =T,horizontal =T)

plot(cylinders , mpg , col ="red", varwidth =T, xlab=" cylinders ", ylab ="MPG ")

# The hist() function can be used to plot a histogram. Note that col=2 histogram has the 
# same effect as col="red".

hist(mpg)
hist(mpg ,col =2)
hist(mpg ,col =2, breaks =15)

# The pairs() function creates a scatterplot matrix i.e. a scatterplot for every pair of 
# variables for any given data set. We can also produce scatterplots matrix for just a 
# subset of the variables.

pairs(Auto)

# This could be useful for migraine dataset, but only on a subset of the variables...

pairs(∼ mpg + displacement + horsepower + weight + acceleration , Auto)

# Here, we only chose 5 variables to compare. This is a bit more tractable...

# In conjunction with the plot() function, identify() provides a useful interactive method 
# for identifying the value for a particular variable for points on a plot. We pass in three 
# arguments to identify(): the x-axis variable, the y-axis variable, and the variable whose 
# values we would like to see printed for each point. Then clicking on a given point in the 
# plot will cause R to print the value of the variable of interest. Right-clicking on the 
# plot will exit the identify() function (control-click on a Mac). The numbers printed under 
# the identify() function correspond to the rows for the selected points.

plot(horsepower ,mpg)

identify (horsepower ,mpg ,name)

# I don't quite understand the point of the identity function. come back to this later...

# The summary() function produces a numerical summary of each variable in a particular data 
# set.

summary (Auto)

# For qualitative variables such as name, R will list the number of observations that fall 
# in each category. We can also produce a summary of just a single variable.

summary (mpg)

# Once we have finished using R, we type q() in order to shut it down, or quit. When exiting 
# R, we have the option to save the current workspace so  that all objects (such as data sets) 
# that we have created in this R session will be available next time. Before exiting R, we 
# may want to save a record of all of the commands that we typed in the most recent session; 
# this can be accomplished using the savehistory() function. Next time we enter R, 
# we can load that history using the loadhistory() function.

