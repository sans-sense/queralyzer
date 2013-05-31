#include <iostream>
#include <string>
#include "q_MetaData.h"
//#include "q_JsonSerializable.h"
#include "../inc/json.h"

int main()
{
  /* TODO: unit test for this module */
  TableMetaData table1;
  std::string* columnArray = new std::string[5]; 
  columnArray[0]="column0";
  columnArray[1]="column1";
  columnArray[2]="column2";
  columnArray[3]="column3";
  columnArray[4]="column4";


  table1.columnCount=5;
  table1.tableName="Test1";
  table1.tableColumns = columnArray;
  table1.schemaName="My_DB1";
  table1.storageEngine="qa_blackhole";
  table1.createOption="NONE";
  table1.rowCount=60;

  std::string output;
  JsonSerializer::serialize( &table1, output );
  std::cout<<output<<std::endl;

  std::string input = "{ \"tableName\" : \"Test2\", \"tableColumns\" :[\"col1\", \"col2\", \"col3\"], \"schemaName\" : \"My_DB2\", \"storageEngine\" : \"qa_blackhole\", \"createOption\":\"NONE\", \"rowCount\":100, \"columnCount\":3 }\n";
  JsonSerializer::deserialize( &table1, input );
  JsonSerializer::serialize( &table1, output );
  std::cout<<output<<std::endl;



  /* TODO: unit test for this module */
  IndexMetaData index1;
  std::string* indexColumnArray = new std::string[5]; 
  indexColumnArray[0]="column0";
  indexColumnArray[1]="column1";
  indexColumnArray[2]="column2";
  indexColumnArray[3]="column3";
  indexColumnArray[4]="column4";


  index1.columnCount=5;
  index1.indexName="i1";
  index1.indexType="PRIMARY";
  index1.tableName="Test1";
  index1.indexColumns = indexColumnArray;
  index1.schemaName="My_DB1";
  index1.storageEngine="qa_blackhole";
  index1.isNullable="FALSE";
  index1.isNullable="FALSE";
  index1.nonUnique="FALSE";
  index1.cardinality=100;

  std::string indexOutput;
  JsonSerializer::serialize( &index1, indexOutput );
  std::cout<<indexOutput<<std::endl;

  std::string indexInput = "{ \"indexName\" : \"i2\", \"indexType\" : \"PRIMARY\", \"indexColumn\" :[\"col1\", \"col2\", \"col3\"], \"tableName\" : \"Test2\", \"schemaName\" : \"My_DB2\", \"storageEngine\" : \"qa_blackhole\", \"columnCount\":3, \"cardinality\":300, \"nonUnique\" : false, \"isNullable\" : false }\n";
  JsonSerializer::deserialize( &index1, indexInput );
  JsonSerializer::serialize( &index1, indexOutput );
  std::cout<<indexOutput<<std::endl;

  return 0;
}
