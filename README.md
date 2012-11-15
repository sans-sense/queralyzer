## Aim

Simple app to expose the query plan for mysql.

## Roadmap

1. Milestone 0.1 
  - repl to provide queries and see execution plans
  - mysql running in embedded mode to provide the execution plans

2. Milestone 0.2
  - repl to provide index options
  - execution plan takes indexes into consideration
               
3. Milestone 0.3 
  -  web interface for queries
  -  engine and web interace interaction 
                   
## Motivation

MySql uses a simple nested loop for query execution. 
This nested loop plan is optimized using a set of complex rules varying from 
predicate reordering, constant table detection, preferential index access etc.

From the end user perspective this means that execution plans will vary with data in the tables and where the data is stored.
A dev who has optimized on a 2k dataset for a table is in for big surprises when he runs it on a 200k table.

## Approach

Run MySql in embedded mode so that there is no discrepancy between the actual execution plan and the one shown by the tool. 
The tool mocks up the structs for data size and index information used for generating the execution plans.
