import pandas as pd
import random

df = pd.DataFrame(columns = ['YearsExperience', 'Salary'])

for i in range(100000):
    r1 = round(random.uniform(0.0, 10.0), 1)
    r2 = round(random.uniform(40000.00, 150000.00), 2)
    df.loc[i] = [r1, r2]

df.to_csv('Data_Salary100k.csv', index=False)