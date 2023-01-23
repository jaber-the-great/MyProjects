# Simple Linear Regression

# Importing the dataset
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

    # Splitting the dataset into the Training set and Test set
    # install.packages('caTools')
    library(caTools)
    set.seed(123)
    split = sample.split(dataset$Salary, SplitRatio = 2/3)
    training_set = subset(dataset, split == TRUE)
    test_set = subset(dataset, split == FALSE)

    # Feature Scaling
    # training_set = scale(training_set)
    # test_set = scale(test_set)

    # Fitting Simple Linear Regression to the Training set
    regressor = lm(formula = Salary ~ YearsExperience,
                  data = training_set)

    # Predicting the Test set results
    y_pred = predict(regressor, newdata = test_set)

    # Visualising the Training set results
    library(ggplot2)
    ggplot() +
      geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary),
                colour = 'red') +
      geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
                colour = 'blue') +
      ggtitle('Salary vs Experience (Training set)') +
      xlab('Years of experience') +
      ylab('Salary')

    # Visualising the Test set results
    library(ggplot2)
    ggplot() +
      geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary),
                colour = 'red') +
      geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
                colour = 'blue') +
      ggtitle('Salary vs Experience (Test set)') +
      xlab('Years of experience') +
      ylab('Salary')
      end <- Sys.time()
    T[i, iter] <- end - start
  }
  iter <- iter + 1
 }

library(MASS)
write.matrix(T,file="/Users/katieturnlund/Workspace/CS263_Jaber_Katie/Code/Linear Reg R/R_results_linReg.csv")