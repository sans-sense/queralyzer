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
  Json::Value root;
  JsonSerializer::serialize( &table1, output );
  std::cout<<output<<std::endl;

  std::string input = "{ \"tableName\" : \"Test2\", \"tableColumns\" :[\"col1\", \"col2\", \"col3\"], \"schemaName\" : \"My_DB2\", \"storageEngine\" : \"qa_blackhole\", \"createOption\":\"NONE\", \"rowCount\":100, \"columnCount\":3 }\n";
  JsonSerializer::deserialize( &table1, input );
  JsonSerializer::serialize( &table1, output );
  std::cout<<output<<std::endl;

  return 0;
}
