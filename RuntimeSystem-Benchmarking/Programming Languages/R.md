link to R documentation: https://cran.r-project.org/doc/manuals/r-release/R-lang.html

- "widespread use in the statistical community"
- Parsing: https://cran.r-project.org/doc/manuals/r-release/R-lang.html#Parser
- Memory: http://adv-r.had.co.nz/memory.html

- Delving into internals: https://cran.r-project.org/doc/manuals/r-release/R-ints.pdf


In-Depth:
- SEXPTYPEs
    - 
- Rest of header
    -
- The ‘data’
A SEXPREC is a C structure containing the 64-bit header as described above, three pointers (to
the attributes, previous and next node) and the node data, a union
- Environments and variable lookup
- Hash table
Environments in R usually have a hash table, and nowadays that is the default in new.env().

## Intro
* As a programming language, R is strongly but dynamically typed, functional and interpreted (therefore not compiled). 
* Among other things, it is popular amongst data scientists, because there are (free) packages with which statistical calculations (such as matrix calculations or descriptive statistics) can be performed.


