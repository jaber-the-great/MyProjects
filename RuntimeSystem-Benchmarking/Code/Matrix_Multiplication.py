import random
# Define the size of n*n matrix
size = 10
matrix1 = [[0]* size] * size
matrix2 = [[0] * size] *size
res = [[0] * size ] * size
# Min and max value for random double generator
minval = 0
maxval = 10
# Generate matrix of random numbers
for i in range(size):
    for j in range(size):
        matrix1[i][j] = random.uniform(minval,maxval)
        matrix2[i][j] = random.uniform(minval, maxval)



# Matrix multiplication
for i in range(size):
    for j in range(size):
        for k in range(size):
            res[i][j] += matrix1[i][k] * matrix2[k][j]

print(res)
