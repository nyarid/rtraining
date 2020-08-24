#### Package installation


# Install the following package using code
#   - data.table

options(repos = c(CRAN = "https://cran.revolutionanalytics.com"))



# Install the following packages using the package panel
#  - lubridate
#  - dplyr

# load packages using require() or library()



############################################################'
#### 01 data types ####
############################################################'

#----------- 1.1 create vectors with different types

# create a numeric vector with a length of 3

x <- c(1.2,3.5,7.9)

# alternatively you can also use the rnorm fuction for this

x <- rnorm(3)

# create a numeric vector with a length of 3 - only integers


# create a logical vector with a length of 3


# create a character vector with a length of 3


# create a date vector with a length of 2

#----------- 1.2 check vector types and transform

# Check the type of the objects created in the first step with any of the following functions: class / typeof / is.character / is.numeric / is.logical 


# Transform the numeric vector into a character one and check its type


# Format the logical vector into a numeric one and check its type


# Delete an object with code (using the rm function)


# Delete an object using the IDE


# Delete all objects


############################################################'
#### 02 Vectors ####
############################################################'

# Create a series from 1 to 50 that increases by 2


# Select its 2nd element


# Select the first 3 elements


# Select the last 3 elements


# Select the 10th and 20th elements


# Select everything but the 10th and 20th elements


# Select all elements that are greater than 25


############################################################'
#### 03 Matrices ####
############################################################'

# Create a 3x3 matrix
A <- matrix(1:6, ncol = 3, nrow = 2)

# List the number of columns and rows


# Select the 2nd row of the matrix


# Select the 3rd column of the matrix


# Select a given element


############################################################'
#### 04 lists ####
############################################################'

# Create a list
List <- list(int = 1:3,
              char = "a",
              logi = c(TRUE, FALSE, TRUE),
              dbl = c(2.3, 5.9))

list(1:3,"a",c(TRUE, FALSE, TRUE),c(2.3, 5.9))

# check the types of the list


# Select the elements of the list using different methods


############################################################'
#### 05 dataframes ####
############################################################'

# create a dataframe

dframe <- data.frame(x = c("a", "b", "c"),
                     y = (1:3),
                     stringsAsFactors = F)

# check the df column types

# display the dataframe

# print the column names


# change the column names to "id" and "value"



# Select subsamples
##########################################'

# Select a column and a row


# Select the row where Value == 2



# Putting together dataframes
##########################################'

# create a second dataframe
dframe_2 <-
  data.frame(
    x = c("d", "e", "f"),
    y = (4:6),
    stringsAsFactors = F
  )

# Bind the dataframes together





############################################################'
#### Basics of R programing ####
############################################################'


# If statement
##########################################'

# Check if an object is numeric
x <- "apple"

if (is.numeric(x)) {
  print("x is numeric")
} else{
  print("x is not numeric")
}

# Same using a user-defined function


#----- Coin tossing

# create a sample using the rbinom function



# for cycle
##########################################'

# Create a for cycle where we take the natural log of each element in the y vector

y <- seq(1, 10000000, 1)
result <- c()

for (variable in vector) {
  
}


# Do the same using the lapply function

lapply(list, function)


