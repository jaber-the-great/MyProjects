n <- 100
T <- matrix(0, n, 4)
iter <- 1
data <- list('/Users/katieturnlund/Workspace/CS263_Jaber_Katie/Code/Linear Reg R/Data_Salary100.csv',
             '/Users/katieturnlund/Workspace/CS263_Jaber_Katie/Code/Linear Reg R/Data_Salary1k.csv',
             '/Users/katieturnlund/Workspace/CS263_Jaber_Katie/Code/Linear Reg R/Data_Salary10k.csv',
             '/Users/katieturnlund/Workspace/CS263_Jaber_Katie/Code/Linear Reg R/Data_Salary100k.csv')
for (item in data) {
  for (i in 1:n) {
    start <- Sys.time()
    dataset <- read.csv(item)
    invisible(mean(as.numeric(dataset[, 1])))
    invisible(mean(as.numeric(dataset[, 2])))
    end <- Sys.time()
    T[i, iter] <- end - start
  }
  iter <- iter + 1
}
library(MASS)
write.matrix(T,file="/Users/katieturnlund/Workspace/CS263_Jaber_Katie/Code/Linear Reg R/R_results_statBasic.csv")