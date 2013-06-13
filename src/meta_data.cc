#include <string>
#include "q_JsonSerializable.h"
#include "meta_data.h"

void
TableMetaData::deserialize (Json::Value & root)
{
  tableName = root.get ("tableName", "").asString ();
  schemaName = root.get ("schemaName", "").asString ();
  storageEngine = root.get ("storageEngine", "").asString ();
  createOption = root.get ("createOption", "").asString ();
  rowCount = root.get ("rowCount", 0).asInt ();
  columnCount = root.get ("columnCount", 0).asInt ();

  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray (vt);
  columnArray = root["tableColumns"];

  JsonSerializer::deserializeArray (columnArray, tableColumns, columnCount);
  return;

}

void
TableMetaData::serialize (Json::Value & root)
{
  root["tableName"] = tableName;
  root["schemaName"] = schemaName;
  root["storageEngine"] = storageEngine;
  root["createOption"] = createOption;
  root["rowCount"] = rowCount;
  root["columnCount"] = columnCount;
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray (vt);

  JsonSerializer::serializeArray (columnArray, tableColumns, columnCount);
  root["tableColumns"] = columnArray;
  return;
}

TableMetaData & TableMetaData::operator= (const TableMetaData & other)
{
  tableName = other.tableName;
  schemaName = other.schemaName;
  storageEngine = other.storageEngine;
  createOption = other.createOption;
  rowCount = other.rowCount;
  columnCount = other.columnCount;

  tableColumns = new std::string[columnCount];
  for (int i = 0; i < columnCount; i++)
    {
      tableColumns[i] = other.tableColumns[i];
    }
  return *this;
}

void
IndexMetaData::deserialize (Json::Value & root)
{
  indexName = root.get ("indexName", "").asString ();
  indexType = root.get ("indexType", "").asString ();
  tableName = root.get ("tableName", "").asString ();
  schemaName = root.get ("schemaName", "").asString ();
  storageEngine = root.get ("storageEngine", "").asString ();
  columnCount = root.get ("columnCount", 0).asInt ();
  cardinality = root.get ("cardinality", 0).asInt ();
  nonUnique = root.get ("nonUnique", 0).asBool ();
  isNullable = root.get ("isNullable", 0).asBool ();
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray (vt);
  columnArray = root["indexColumns"];
  JsonSerializer::deserializeArray (columnArray, indexColumns, columnCount);
  return;
}

void
IndexMetaData::serialize (Json::Value & root)
{
  root["indexName"] = indexName;	//for primary key it is always PRIMARY
  root["indexType"] = indexType;
  root["tableName"] = tableName;
  root["schemaName"] = schemaName;
  root["storageEngine"] = storageEngine;
  root["columnCount"] = columnCount;
  root["cardinality"] = cardinality;
  root["nonUnique"] = nonUnique;
  root["isNullable"] = isNullable;
  Json::ValueType vt = Json::arrayValue;
  Json::Value columnArray (vt);

  JsonSerializer::serializeArray (columnArray, indexColumns, columnCount);
  root["indexColumns"] = columnArray;
  return;
}

void
ExplainMetaData::deserialize (Json::Value & root)
{
  id = root.get ("id", "").asString ();
  select_type = root.get ("select_type", "").asString ();
  table = root.get ("table", "").asString ();
  type = root.get ("type", "").asString ();
  possible_keys = root.get ("possible_keys", "").asString ();
  key = root.get ("key", "").asString ();
  key_len = root.get ("key_len", "").asString ();
  ref = root.get ("ref", "").asString ();
  rows = root.get ("rows", 0).asInt ();
  Extra = root.get ("Extra", "").asString ();

  return;
}

void
ExplainMetaData::serialize (Json::Value & root)
{
  root["id"] = id;
  root["select_type"] = select_type;
  root["table"] = table;
  root["type"] = type;
  root["possible_keys"] = possible_keys;
  root["key"] = key;
  root["key_len"] = key_len;
  root["ref"] = ref;
  root["rows"] = rows;
  root["Extra"] = Extra;

  return;
}

bool
JsonSerializer::serialize (JsonSerializable * pObj, std::string & output)
{
  if (pObj == NULL)
    return false;
  // treat pObj as an array
  Json::ValueType vt = Json::arrayValue;
  Json::Value serializeArrayRoot (vt);

  Json::Value serializeRoot;
  int num_of_elements = sizeof (pObj) / sizeof (JsonSerializable);
  for (int i = 0; i < num_of_elements; i++)
    {
      (pObj[i]).serialize (serializeRoot);
      serializeArrayRoot[i] = serializeRoot;
    }

  Json::StyledWriter writer;
  output = writer.write (serializeArrayRoot);
  return true;
}

bool
JsonSerializer::deserialize (JsonSerializable * pObj, std::string & input)
{
  if (pObj == NULL)
    return false;
  // treat pObj as an array
  Json::ValueType vt = Json::arrayValue;
  Json::Value deserializeArrayRoot (vt);

  Json::Value deserializeRoot;
  Json::Reader reader;
  if (!reader.parse (input, deserializeArrayRoot))
    {
      return false;
    }

  int num_of_elements = sizeof (pObj) / sizeof (JsonSerializable);
  for (int i = 0; i < num_of_elements; i++)
    {
      deserializeRoot = deserializeArrayRoot[i];
      (pObj[i]).deserialize (deserializeRoot);
    }
  return true;
}

void
JsonSerializer::deserializeArray (Json::Value & rootArray,
				  std::string * copyValues,
				  unsigned int arrayLength)
{
  copyValues = new std::string[arrayLength];
  int i;
  while (i < arrayLength)
    {
      copyValues[i] = rootArray[i].asString ();
      i++;
    }
  return;
}

void
JsonSerializer::serializeArray (Json::Value & rootArray,
				std::string * inputValues,
				unsigned int arrayLength)
{

  int i;
  while (i < arrayLength)
    {
      rootArray[i] = inputValues[i];
      i++;
    }

  return;
}
