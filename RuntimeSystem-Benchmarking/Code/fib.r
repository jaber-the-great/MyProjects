# This approach is based on python and not similar to the one implemented in java (adjusted for R)
n = 11
previous_results = list(0, 1)

for (i in 3:n) {
    new_element <- previous_results[i - 1] + previous_results[i - 2]
    previous_results[[i]] <- new_element
}
previous_results
