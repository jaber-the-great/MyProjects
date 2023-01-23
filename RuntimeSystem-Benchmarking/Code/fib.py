# This approach is based on python and not similar to the one implemented in java
n = 10
previous_results = [0, 1]

for i in range(2, n + 1):
    previous_results.append(previous_results[i - 1] + previous_results[i - 2])

print(previous_results[n])


# This approach is much similar to the one implemented in java
n = 10
previous_results = [0] * (n+2)
previous_results[0] = 0
previous_results[1] = 1
for i in range(2, n + 1):
    previous_results[i] = previous_results[i - 1] + previous_results[i - 2]
print(previous_results[n])