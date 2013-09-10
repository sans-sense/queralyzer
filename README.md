## Aim :

Transforming given query access plan into JSON tree structure.

## Description :

It is a stand alone html page which takes input as access plan and convert it into JSON objects and displays JSON objects in tree structure.

## Installation :

Download this project and open Transformation.html page in any browser.

## Supported Inputs :

1. CSV file generated on any client software.
Note : While exporting CSV file,please ensure that line terminated by "\n" and fields terminated by "\t".

2. Access plan of type.
+----+-------------+---------+--------+---------------+---------------+---------+--------------------------+------+-------+
 | id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra |
 +----+-------------+---------+--------+---------------+---------------+---------+--------------------------+------+-------+
 | 1 | SIMPLE | history | index | idx_sc_date | idx_sc_date | 35 | NULL | 740 | |
 | 1 | SIMPLE | stock | eq_ref | idx_stockcode | idx_stockcode | 32 | pfolio.history.stockcode | 1 | |
 +----+-------------+---------+--------+---------------+---------------+---------+--------------------------+------+-------+
 
 


