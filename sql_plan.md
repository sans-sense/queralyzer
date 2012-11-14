Analyzing Explains
================

Fundamentals
---------------------

1. ### Down with the cross product
Mysql uses nested loop joins, which means for select t1.* from t1, t2 where t1.f1 = t2.f2, it will first select all n records from t1 and then scan all m records in t2 which satisfy this equality condition. The cost of this operation is n * m and the goal of the optimization algo is  to reduce this product. We can extrapolate the same to any number of tables. 

1. ### Smart Indexing
Indexes are used when the complete data in the projection can be drawn from them and using the index would be x times faster than the table scan, for example in case of select m.* from m where m.id = x; it may not use the index at all as it has to fetch all the columns, unlike the scenario of select m.id from m where m.id =x where the projection can be filled by the index alone.

1. ### Love Constant Tables
Constant tables (tables with just 1 record with or without applying the filter) cut down the total cost significantly, so the algo will always start with any table that will give a constant value. This means that in our dev env if we have any table that will give only one value after applying the predicate, it will always become the driving table. When in actual production more values drop in, this would not be the case any more and the mileage may significantly vary from what was seen in the dev env. This becomes even more important when we understand that the algo is also free to convert our conditions into its equivalent values using transitivity and other rules e.g d.master_id = m.id and d.master_id =0, since we know that master_id of d is same as id of m, we can rewrite d.master_id = 0 as m.id = 0, since id is the primary key of m, so it will yield a constant value which makes it the driving table. Any comparision predicate which uses a unique index can make the table the driving table. 

1. ### Leverage Stats
For a wide range of decisions actual stat values of each table and index is consulted. Mysql would always prefer indexes with high cardinality (number of unique values), but cardinality even for small tables is out of sync with the actual values, we can update it using analyze table <table_name>, we can use show indexes in <table_name> to view index details.


Optimization Steps
-------------------------

1. ### Simplify joins (sql_select.cc:8948-9102)
   1. replace outer join with inner joins (esoteric, can eliminate only if null values are being eliminated by some other part of the query)
   1. move on conditions to where
   1. removed redundant nested joins
   1. possible order of tables, compute dependencies (except straight join, the table list is totally upto the optimizer)
      1. start with most outer value (t1,t3,t2) start with t2
      2. 
   1. skipping about nested tables

1. ### Optimize conditions
   1. optimize the where block
   1. optimize the join condition
   
Debugging Help
------------------
when table is a table_list
p table->table->s->table_name 

when dealing with the current table node in the list
p table->table_name
   
   
   experimenting with 
   explain select m.id from test_master m, test_detail d, test_m_d md where d.master_id = m.id and md.detail_id = d.id and md.master_id = m.id;


Examples
------------

1. explain select d.id from test_master m, test_detail d where d.master_id = m.id and d.master_id = 0;

m.id is PK, so changes to select from m using PRIMARY, join with d using master_id_idx

2. explain select m.* from  test_detail d, test_master m where d.master_id = m.id and d.name = 'test';

among m and d pick the table with less records, use job buffer or eq_ref to run the query
