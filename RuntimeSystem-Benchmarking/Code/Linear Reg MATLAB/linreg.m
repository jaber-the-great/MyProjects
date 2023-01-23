

n = 100;
T = zeros(n, 4);
data = {'Data_Salary100.csv', 'Data_Salary1k.csv', 'Data_Salary10k.csv', 'Data_Salary100k.csv'};
for item = 1:(length(data))
    for i = 1:n+1
        tic;
        tbl = readtable(data{item},'NumHeaderLines',1);
        mdl = fitlm(tbl);
        plot(mdl);
        clf;
        T(i, item) = toc;
    end
end

writematrix(T, 'MATLAB_results_linReg.csv');

