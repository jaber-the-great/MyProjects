# Simple Linear Regression


# Importing the libraries

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import time
from tqdm import tqdm

n = 100
T = np.zeros((n, 4))
iter = 0
data = ['Data_Salary100.csv', 'Data_Salary1k.csv', 'Data_Salary10k.csv', 'Data_Salary100k.csv']
for item in tqdm(data, position = 0):
    for i in tqdm(range(n), position=1):
        start_time = time.time()
        # Importing the dataset
        dataset = pd.read_csv(item)
        X = dataset.iloc[:, :-1].values
        y = dataset.iloc[:, -1].values

        # Splitting the dataset into the Training set and Test set
        from sklearn.model_selection import train_test_split
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 1/3, random_state = 0)

        # Training the Simple Linear Regression model on the Training set
        from sklearn.linear_model import LinearRegression
        regressor = LinearRegression()
        regressor.fit(X_train, y_train)

        # Predicting the Test set results
        y_pred = regressor.predict(X_test)
        
        # Visualising the Training set results
        plt.scatter(X_train, y_train, color = 'red')
        plt.plot(X_train, regressor.predict(X_train), color = 'blue')
        plt.title('Salary vs Experience (Training set)')
        plt.xlabel('Years of Experience')
        plt.ylabel('Salary')
        #plt.savefig('test1.png')

        # Visualising the Test set results
        plt.scatter(X_test, y_test, color = 'red')
        plt.plot(X_train, regressor.predict(X_train), color = 'blue')
        plt.title('Salary vs Experience (Test set)')
        plt.xlabel('Years of Experience')
        plt.ylabel('Salary')
        #plt.savefig('test2.png')

        T[i, iter] = time.time() - start_time
    iter += 1

df = pd.DataFrame(T, columns = ['100', '1k', '10k', '100k'])
df.to_csv('python_results_linReg.csv', header = False, index = False)