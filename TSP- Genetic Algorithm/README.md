## Traveling Sales Person(TSP) problem solved by artificial intelligence (genetic algorithm)
* My code was the fastest one in the class based on the TA observation and feedback
* TCP.c is the main file to run
#### Input format:
1. Name if input is "infile"
2. First line: The population size
3. Second line: Chromosome length (number of cities)
4. Third line: Number of generations
5. Forth line: Probability of crossover
6. Fifth line: Probability of mutation
7. Sixth line: Name of output file
8. Rest of the file: The adjacency matrix, each element is the distance between two cities (zero as infinity or no direct link) 
#### Output format:
1. Name is provided in "infile"
2. Current generation number
3. Size of the best fitness in current generation
4. Number of generation with highest fitness so far
5. Maximum fitness so far
6. The final result is the chromosome with the highest fitness

#### Strategies and findings
* PMX Crossover. I also tested the ordered crossover but PMX outperformed that
  * PMX is the best crossover for TSP problem
* Inversion mutation: It is the best mutation for TSP problem
* Roulette selection: It is the best selection method for TSP problem
* I applied the above methods for the genetic algorithm in this project
* The probability of mutation and crossover are given as input to this program and we can play with them to get the best optimization and faster runtime
* Evaluation should be performed before roulette selection because roulette needs the updated fitness to work properly