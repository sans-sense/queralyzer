#include "q_JsonSerializable.h"
#include "q_MetaData.h"

void TableMetaData::deserialize(Json::Value &root)
{
  tableName = root.get("tableName", "").asString();
  schemaName = root.get("schemaName","").asString();
  storageEngine = root.get("storageEngine", "").asString();
  createOption = root.get("createOption", "").asString();
  rowCount = root.get("rowCount", 0).asInt();
  columnCount = root.get("columnCount", 0).asInt();
  
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray(vt);
  columnArray=root["tableColumns"];

  JsonSerializer::deserializeArray(columnArray, tableColumns, columnCount);
  return;

}

void TableMetaData::serialize(Json::Value &root)
{
  root["tableName"] = tableName;
  root["schemaName"] = schemaName;
  root["storageEngine"] = storageEngine;
  root["createOption"] = createOption;
  root["rowCount"] = rowCount;
  root["columnCount"] = columnCount;
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray(vt);
 
  JsonSerializer::serializeArray(columnArray, tableColumns, columnCount);
  root["tableColumns"] = columnArray;
  return;
}

TableMetaData & TableMetaData::operator=(const TableMetaData &other)
{
  tableName = other.tableName;
  schemaName = other.schemaName;
  storageEngine = other.storageEngine;
  createOption = other.createOption;
  rowCount = other.rowCount;
  columnCount = other.columnCount;

  tableColumns = new std::string[columnCount];
  for(int i=0; i<columnCount; i++)
  {
	tableColumns[i] = other.tableColumns[i];
  }
  return *this;
}

void IndexMetaData::deserialize(Json::Value &root)
{
  indexName = root.get("indexName", "").asString();
  indexType = root.get("indexType", "").asString();
  tableName = root.get("tableName", "").asString();
  schemaName = root.get("schemaName","").asString();
  storageEngine = root.get("storageEngine", "").asString();
  columnCount = root.get("columnCount", 0).asInt();
  cardinality = root.get("cardinality", 0).asInt();
  nonUnique = root.get("nonUnique", 0).asBool();
  isNullable = root.get("isNullable", 0).asBool();
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray(vt);
  columnArray=root["indexColumns"];
  JsonSerializer::deserializeArray(columnArray, indexColumns, columnCount);
  return;
}

void IndexMetaData::serialize(Json::Value &root)
{
  root["indexName"] = indexName;  //for primary key it is always PRIMARY
  root["indexType"] = indexType;
  root["tableName"] = tableName;
  root["schemaName"] = schemaName;
  root["storageEngine"] = storageEngine;
  root["columnCount"] = columnCount;
  root["cardinality"] = cardinality;
  root["nonUnique"] = nonUnique;
  root["isNullable"] = isNullable;
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray(vt);
 
  JsonSerializer::serializeArray(columnArray, indexColumns, columnCount);
  root["indexColumns"] = columnArray;
  return;
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

void JsonSerializer::deserializeArray(Json::Value &rootArray, std::string* copyValues, unsigned int arrayLength)
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

void JsonSerializer::serializeArray(Json::Value &rootArray, std::string* inputValues, unsigned int arrayLength)
{

  int i;
  while(i<arrayLength)
  {
        rootArray[i] = inputValues[i];
        i++;
  }

  return;
}

