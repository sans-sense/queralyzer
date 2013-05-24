#include "q_JsonSerializable.h"
#include "q_MetaData.h"

void TableMetaData::deserialize(Json::Value &root)
{
  tableName = root.get("tableName", "").asString();
  //*tableColumns;
  schemaName = root.get("schemaName","").asString();
  storageEngine = root.get("storageEngine", "").asString();
  createOption = root.get("createOption", "").asString();
  rowCount = root.get("rowCount", 0).asInt();
  columnCount = root.get("columnCount", 0).asInt();
  
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray(vt);
  columnArray=root["tableColumns"];

  deserialize(columnArray, tableColumns, columnCount);

/*  tableColumns = new std::string[columnCount];
  while(i<columnCount)
  {
	//std::cout<<columnArray[i];
	tableColumns[i]=columnArray[i].asString();
	i++;
  }
*/
  return;

}
void TableMetaData::deserialize(Json::Value &rootArray, std::string* copyValues, unsigned int arrayLength)
{
  copyValues = new std::string[arrayLength];
  int i;
  while(i<arrayLength)
  {
	copyValues[i]=rootArray[i].asString();
	i++;
  }
  return;
}

void TableMetaData::serialize(Json::Value &root)
{
  root["tableName"] = tableName;
  //*tableColumns;
  root["schemaName"] = schemaName;
  root["storageEngine"] = storageEngine;
  root["createOption"] = createOption;
  root["rowCount"] = rowCount;
  root["columnCount"] = columnCount;
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray(vt);
 
  serialize(columnArray, tableColumns, columnCount);
 /* int i =0;
  while (i<columnCount)
  {
	columnArray[i] = tableColumns[i];
	i++;
  }
*/
  root["tableColumns"] = columnArray;

}

void TableMetaData::serialize(Json::Value &rootArray, std::string* inputValues, unsigned int arrayLength)
{
   
  int i;
  while(i<arrayLength)
  {
	rootArray[i] = inputValues[i];
	i++;
  }
  
  return;
}

void IndexMetaData::serialize(Json::Value &root)
{
/*  std::string indexName;      //for primary key it is always PRIMARY
  std::string indexType;
  std::string *indexColumns;
  std::string tableName;
  std::string schemaName;
  std::string storageEngine;
  int         cardinality;
  bool        nonUnique;
*/
}

void IndexMetaData::deserialize(Json::Value &root)
{
/*  std::string indexName;      //for primary key it is always PRIMARY
  std::string indexType;
  std::string *indexColumns;
  std::string tableName;
  std::string schemaName;
  std::string storageEngine;
  int         cardinality;
  bool        nonUnique;
*/
}

bool JsonSerializer::serialize(JsonSerializable *pObj, std::string &output)
{
  if(pObj==NULL)
	return false;
  Json::Value serializeRoot;
  pObj->serialize(serializeRoot);

  Json::StyledWriter writer;
  output = writer.write(serializeRoot);
  return true;
}

bool JsonSerializer::deserialize(JsonSerializable *pObj, std::string &input)
{
  if(pObj==NULL)
	return false;
  Json::Value deserializeRoot;
  Json::Reader reader;
  if(!reader.parse(input, deserializeRoot))
  {
	return false;
  }

  pObj->deserialize(deserializeRoot);
  return true;
}


