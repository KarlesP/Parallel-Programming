#Author: KarlesP (Mr Koios)--|

#'Installing Library
#install.packages("parallel")
#'Input Library
library(parallel)
#'Detect Cores
detectCores()
#'Read data
df=read.csv("~/data_snowfall.csv",sep = ",", header = T)
#'Print the execution time
system.time((fit_30 = kmeans(df, centers = 3, nstart = 30)),gcFirst = T )
#'Create a '3 row' sample
index=sample(1:nrow(df), 3)
#'Select rows based on the previous example
new=df[index,]
#'Read the new table as matrix
new_m=as.matrix(new)
#'Create new Cluster
fit_2 = kmeans(df, centers = new_m)

#'Create function that recreates our previous steps
paral_func = function(arg) {                      
  index=sample(1:nrow(df), 3)
  new=df[index,]
  new_m=as.matrix(new)
  fit_2 = kmeans(df, centers = new_m)
  return(fit_2)                                   
}
#'Install "snowfall" and "snow" packages and then import their libraries
#install.packages("snowfall")
#install.packages("snow")
library(snowfall)
library(snow)
#'Initialize Parallel execution
sfInit(parallel=TRUE, cpus = 4)
sfLibrary(snowfall)
sfLibrary(snow)
#'Making data available for parallel processing
sfExport("df")
#'Setting up random generator
sfClusterSetupRNG(seed = 3399)
#'Print the time of the processed results
system.time(result <- sfLapply(1:30, paral_func))
#'Stopping parallel processing
sfStop()
#'Looking up the class of our results
class(result)
#'Priting the length of our results
length(result)
#'Print the first line of our results as a string
str(result[[1]])
#'Print the total distance between our sum of squares
result[[1]]$tot.withinss
#'Create variables which are going to be used later for our
min_ss = Inf
best_result = NULL
#'Find an element of the result object with the lowest tot.withinss value and assign it to " best_result" variable
for (i in 1:length(result)) {
  if(result[[i]]$tot.withinss < min_ss) {
    min_ss = result[[i]]$tot.withinss
    best_result = result[[i]]
  }
}
#'Last but not least compare the tot.withinss value of 
#'that variable with the corresponding value of the fit_30 variable
print(best_result$tot.withinss)
print(fit_30$tot.withinss)

#----source:http://www.r-exercises.com/2017/07/06/parallel-computing-exercises-snowfall-part-1/