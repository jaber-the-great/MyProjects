import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

filename_prefixes = ['Linear Reg MATLAB/MATLAB', 'Linear Reg Python/python', 'Linear Reg R/R']
filenames = ['_results_arraySlice.csv', '_results_dataClean.csv', '_results_linReg.csv', '_results_statBasic.csv']
lang_names = ['mat', 'py', 'r']
bench_names = ['AS', 'DC', 'LR', 'SB']
data_sizes = ['100', '1k', '10k', '100k']

dfs = []

for i in range(3):
    for j in range(4):
        df = pd.read_csv(filename_prefixes[i] + filenames[j], header=None, 
                         names = [lang_names[i] + '-' + bench_names[j] + '-' + data_sizes[0], 
                                  lang_names[i] + '-' + bench_names[j] + '-' + data_sizes[1], 
                                  lang_names[i] + '-' + bench_names[j] + '-' + data_sizes[2],
                                  lang_names[i] + '-' + bench_names[j] + '-' + data_sizes[3]])
        dfs.append(df)


markers = ["v", "s", "o", "D"]
#each compared to itself

for i in range(len(dfs)):
    title = dfs[i].columns[0].split('-')[0] + " " + dfs[i].columns[0].split('-')[1]
    plt.hist([dfs[i].iloc[:,0], dfs[i].iloc[:,1], dfs[i].iloc[:,2], dfs[i].iloc[:,3]], 50, label = data_sizes)
    plt.title(title)
    plt.legend(loc = 'upper right')
    plt.savefig("images/"+title+".png")
    plt.show()
    


plt.hist([dfs[0]["mat-AS-100k"], dfs[4]["py-AS-100k"], dfs[8]["r-AS-100k"]], 50, label=lang_names, density=True)
plt.title("Array Slice 100k")
plt.legend(loc = 'upper right')
plt.savefig("images/ArraySlice100k.png")
plt.show()

plt.hist([dfs[1]["mat-DC-100k"], dfs[5]["py-DC-100k"], dfs[9]["r-DC-100k"]], 50, label=lang_names, density=True)
plt.title("Data Clean 100k")
plt.legend(loc = 'upper right')
plt.savefig("images/DataClean100k.png")
plt.show()

plt.hist([dfs[2]["mat-LR-100k"], dfs[6]["py-LR-100k"], dfs[10]["r-LR-100k"]], 50, label=lang_names, density=True)
plt.title("Linear Regression 100k")
plt.legend(loc = 'upper right')
plt.savefig("images/LinReg100k.png")
plt.show()

plt.hist([dfs[3]["mat-SB-100k"], dfs[7]["py-SB-100k"], dfs[11]["r-SB-100k"]], 50, label=lang_names, density=True)
plt.title("Stat Basic 100k")
plt.legend(loc = 'upper right')
plt.savefig("images/StatBasic100k.png")
plt.show()
