### vectors, data, matrices, subsetting

# We created a vector with concatenate symbol
x=c(2,7,5)

# print out the vector x
x

# create a length-3 vector that starts with 4 and increments by 3
y=seq(from=4,length=3,by=3)

# Way to get help with functions
?seq

# We print out the y vector
y

# Notice that these operations are applied to every element of the vector y
x+y
x/y
x^y

# choose the 2nd element in the vector... Note that unlike Python, R starts counting from 1 (not 0)
x[2]

# choose 2nd and third elements of vector
x[2:3]

# Remove element 2 from vector and return subsetted vector 
x[-2]

# Only return the last element... We remove the first two elements...
x[-c(1,2)]

# Create a matrix from 1 to 12 in 4 rows and 3 columns
z=matrix(seq(1,12),4,3)
z

# Choose elements in 3rd/4th rows and 2nd/3rd columns
z[3:4,2:3]

# Choose everything from 2nd/3rd columns
z[,2:3]

# Choose the first column
z[,1]

# When we returned first column of z, it was returned as a vector and lost matrix status
# drop=FALSE returns the column of z as a matrix
z[,1,drop=FALSE]

# Returns dimension of z, in row column format
dim(z)

# This shows the list of variables in our working directory
ls()

# Removes the variable y from our working directory
rm(y)

# Run ls() again to show that y is removed...
ls()

### Generating random data, graphics

# Generate 50 uniform random variables (0,1)
x=runif(50)

# Generate 50 normal random variables (-1,1)
y=rnorm(50)

# Plot x and y
plot(x,y)

# Set x/y axes labels, characters to "*", and color to blue...
plot(x,y,xlab="Random Uniform",ylab="Random Normal",pch="*",col="blue")

# Create a panel of plots with 2 rows and 1 column
par(mfrow=c(2,1))

plot(x,y)
hist(y)
par(mfrow=c(1,1))

# Load ISLR Library
library("ISLR")

# With this library, there is NO need to manually read in data.
# But I can read in data for migaine dataset...

### Reading in data
# Auto=read.csv("Auto.csv")
# pwd()
# Auto=read.csv("../Auto.csv")

# Names of variables
names(Auto)

# Dimension of the data
dim(Auto)

# What is the class of the variable? Meaning, what is its type? Here, a dataframe!
class(Auto)

# Summary of each variable in the dataframe
summary(Auto)

# We can plot the elements of a dataframe
# We can get elements of a list with a dollar sign
plot(Auto$cylinders,Auto$mpg)
plot(Auto$cyl,Auto$mpg)

# Creates a workspace, where all dataframe variables are now variables in your workspace
attach(Auto)

# Search gives us all of our workspaces
search()

# Now we do plot command more directly
plot(cylinders,mpg)

# Makes cylinders a factor
cylinders=as.factor(cylinders)

# Plots as a box plot
plot(cylinders,mpg,xlab="Cylinders",ylab="Mpg",col="red")

# This prints pdf of plot to my current(?) directory
pdf(file="../mpg.pdf")
plot(cylinders,mpg,xlab="Cylinders",ylab="Mpg",col="red")
dev.off()

pairs(Auto,col="brown")
pairs(mpg~cylinders+acceleration+weight,Auto)
q()