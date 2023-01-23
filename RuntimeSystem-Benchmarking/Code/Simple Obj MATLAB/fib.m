% This approach is based on MATLAB and not similar to the one implemented in java
n = 10;
previous_results = zeros(n);
previous_results(1) = 1;
previous_results(2) = 1;

for i = 3:n+1
    previous_results(i) = previous_results(i - 1) + previous_results(i - 2);
end

previous_results(n)
