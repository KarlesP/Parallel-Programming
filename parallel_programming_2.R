#Author: KarlesP (Mr Koios)--
#'Install package "foreach"
#install.packages("foreach")
#'Input library "foreach"
library(foreach)
#'Test foreach function using the special operator "%do%"
#'whereas foreach includes an iteration variable (i) and a sequence to be iterated over (1:3) and then it
#'calculates (hence "%do%") the square root of that sequence
result = foreach(i = 1:3) %do% sqrt(i)
#'Print result
print(result)
#'Print the class of the variable "result"
class(result)
#'Calculate and re-print original values
original = foreach(i = result) %do% i^2
print(original)
#'New result variable calculating two iteration variables to get a sequence of their sums
result = foreach(a = 1:3, b = rep(10, 5)) %do% (a + b)
print(result)
#'Print results length
length(result)
#'Now we use the "foreach" and "irnorm" functions 
#'to iterate over 3 vectors, each containing 5 random variables.
library(iterators)
set.seed(3333)
result = foreach(v = irnorm(5, count = 3)) %do% max(v)
#'Print the largest value in each vector
print(result)
#'We now perform a result manipulation whereas foreach returns a list now it returns a numeric
#'This can be changed using the parameter ".combine"
result_c = foreach(v = irnorm(5, count = 3), .combine = 'c') %do% v
print(result_c)
class(result_c)
length(result_c)
#'Now we run the same function but this time we change ".combine = 'c'" to ".combine = 'cbind'" 
result_cbind = foreach(v = irnorm(5, count = 3), .combine = 'cbind') %do% v
print(result_cbind)
class(result_cbind)
dim(result_cbind)
#'Adding up values using the ".combine" parameter '+' (based on the "foreach" doc)
#library(foreach)
#library(iterators)
set.seed(3333)
result_sum = foreach(v = irnorm(5, count = 3), .combine = '+') %do% v
print(result_sum)
#'Filtering values using Boolean expressions (after %:%) and foreach
result = foreach(i = 1:10, .combine = 'c') %:% when(i%%2 == 0) %do% log(i)
print(result)
#'Create a function which:
#'1)Create a string (character vector) 
#'with a file name by concatenating constant parts of the name 
#'(test_data_, .csv) with the integer (example of possible result when 1 is used as 
#'integer: test_data_1.csv).
#'2)Read the file with the obtained name from the current working directory into a data frame.
#'3)Calculate mean values for each column in the data frame.
#'4)Return a vector of those values. 
get_column_means_from_file = function(i) {
  file_name = paste0("test_data_", i, ".csv")
  data = read.csv(file_name)
  column_means = colMeans(data)
  return(column_means)}
#'Create a backend for parallel execution, using "makeCluster" and "registerDoParallel"
library(parallel)
library(doParallel)
cluster = makeCluster(4)
registerDoParallel(cluster)
#'Use the libraries "foreach" and "parallel" to perform a foreach with %do% and %dopar% and later 
#'compare the two times so we can observe which one is faster.
library(foreach)
library(parallel)
#task sequentially
system.time(
  result_do <- foreach(i = 0:9, .combine = "rbind") %do%
    get_column_means_from_file(i))
#task parallel
system.time(
  result_dopar <- foreach(i = 0:9, .combine = "rbind") %dopar%
    get_column_means_from_file(i))
#'Stop the cluster
stopCluster(cluster)
#'Print the result
print(result_dopar)
library(parallel)
library(doParallel)
library(foreach)

#'Modify the function "get_column_means_from_file" so we can have the mean of variancies.
get_mean_variance_from_first_column = function(i) {
  file_name = paste0("test_data_", i, ".csv")
  data = read.csv(file_name)
  result = c(mean(data[, 1]), var(data[, 1]))
  return(result)}

#'Make and register a cluster
cluster = makeCluster(4)
registerDoParallel(cluster)

#'Run the function in parallel to get a matrix
result = foreach(i = 0:9, .combine = "rbind") %dopar% get_mean_variance_from_first_column(i)

#'Print the result
print(result)

#'Stop the cluster
stopCluster(cluster)
