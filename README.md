## Aim

Simple app to expose the query plan for MySQL.

## Roadmap

1. Milestone 0.1 
  - repl to provide queries and see execution plans
  - MySQL running in embedded mode to provide the execution plans

2. Milestone 0.2
  - repl to provide index options
  - execution plan takes indexes into consideration
               
3. Milestone 0.3 
  -  web interface for queries
  -  engine and web interace interaction 
                   
## Motivation

MySQL uses a simple nested loop for query execution. 
This nested loop plan is optimized using a set of complex rules varying from 
predicate reordering, constant table detection, preferential index access etc.

From the end user perspective this means that execution plans will vary with data in the tables and where the data is stored.
A dev who has optimized on a 2k dataset for a table is in for big surprises when he runs it on a 200k table.

## Approach

Run MySQL in embedded mode so that there is no discrepancy between the actual execution plan and the one shown by the tool. 
The tool mocks up the structs for data size and index information used for generating the execution plans.

## Installation

We need to build MySQL from source if we do not have the embedded server library. 

### Steps to build embedded server

 1. Download mysql-${version}
 2. Extract and run build --with-embedded-server, use CMake -DWITH_EMBEDDED_SERVER=true
 3. We should see a new file libsql_embedded.a

Refer http://dev.mysql.com/doc/refman/5.5/en/source-configuration-options.html for details

### Building queralyzer
 1. Set env variable QA_MYSQL_HOME or edit the makefile to define QA_MYSQL_HOME. It should point to the extracted and built MySQL server
2. Run make in the queralyzer folder

