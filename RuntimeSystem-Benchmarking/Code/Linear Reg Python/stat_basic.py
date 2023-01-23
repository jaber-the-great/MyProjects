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
        start = time.time()
        dataset = pd.read_csv('Salary_Data.csv')
        experience = dataset['YearsExperience'].mean()
        salary = dataset['Salary'].mean()
        end = time.time()
        T[i, iter] = end - start
    iter += 1
    
df = pd.DataFrame(T, columns = ['100', '1k', '10k', '100k'])
df.to_csv('python_results_statBasic.csv', header = False, index = False)