#include <string>
#include "q_JsonSerializable.h"
#include "meta_data.h"

bool
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
	return true;
}

bool
TableMetaData::deserialize(Json::Value & root)
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
	return true;

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

bool
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
	return true;
}

bool
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
	return true;
}

bool
ExplainMetaData::serialize (Json::Value & root)
{
	root["id"] = (id == "NULL") ? Json::Value::null : id;
	root["select_type"] = (select_type == "NULL") ? Json::Value::null : select_type;
	root["table"] = (table == "NULL") ? Json::Value::null : table;
	root["type"] = (type == "NULL") ? Json::Value::null : type;
	root["possible_keys"] = (possible_keys == "NULL") ? Json::Value::null : possible_keys;
	root["key"] = (key == "NULL") ? Json::Value::null : key;
	root["key_len"] = (key_len == "NULL") ? Json::Value::null : key_len;
	root["ref"] = (ref == "NULL") ? Json::Value::null : ref;
	root["rows"] = rows;
	root["Extra"] = (Extra == "NULL") ? Json::Value::null : Extra;

	return true;
}

bool
ExplainMetaData::deserialize (Json::Value & root)
{
	/* Not Required */
	/*
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
*/
	return true;
}


bool
JsonSerializer::serializeArray (std::map<std::string, TableMetaData*> &obj_map, std::string & output)
{
	Json::ValueType vt = Json::arrayValue;
	Json::Value serializeArrayRoot (vt);
	Json::Value serializeRoot;
	std::map<std::string, TableMetaData*>::iterator it;
	int obj_count = 0;
	for (it = obj_map.begin(); it!= obj_map.end(); ++it)
	{
		if(((it->second) != NULL) && ((it->second)->serialize (serializeRoot)))
		{
			serializeArrayRoot[obj_count++] = serializeRoot;
		}
	}
	Json::StyledWriter writer;
	output = writer.write (serializeArrayRoot);
	return true;
}


bool
JsonSerializer::deserializeArray (std::map<std::string, TableMetaData*> &obj_map, std::string & input )
{
	Json::ValueType vt = Json::arrayValue;
	Json::Value deserializeArrayRoot (vt);

	Json::Value deserializeRoot;
	Json::Reader reader;
	if (!reader.parse (input, deserializeArrayRoot))
	{
		return false;
	}
	int obj_count = deserializeArrayRoot.size();
	int i = 0;
	deserializeRoot = deserializeArrayRoot[i++];
	while (i<obj_count)
	{
		TableMetaData *new_table_data = new TableMetaData();
		if(new_table_data->deserialize(deserializeRoot))
		{
			obj_map.insert(std::pair<std::string, TableMetaData*>(new_table_data->tableName, new_table_data));
		}
		deserializeRoot = deserializeArrayRoot[i++];
	}
	return true;
}


bool
JsonSerializer::serializeArray (std::map<std::string, IndexMetaData*> &obj_map, std::string & output)
{
	Json::ValueType vt = Json::arrayValue;
	Json::Value serializeArrayRoot (vt);
	Json::Value serializeRoot;
	std::map<std::string, IndexMetaData*>::iterator it;
	int obj_count = 0;
	for (it = obj_map.begin(); it!= obj_map.end(); ++it)
	{
		if(((it->second) != NULL) && ((it->second)->serialize (serializeRoot)))
		{
			serializeArrayRoot[obj_count++] = serializeRoot;
		}
	}
	Json::StyledWriter writer;
	output = writer.write (serializeArrayRoot);
	return true;
}


bool
JsonSerializer::deserializeArray (std::map<std::string, IndexMetaData*> &obj_map, std::string & input )
{
	Json::ValueType vt = Json::arrayValue;
	Json::Value deserializeArrayRoot (vt);

	Json::Value deserializeRoot;
	Json::Reader reader;
	if (!reader.parse (input, deserializeArrayRoot))
	{
		return false;
	}
	int obj_count = deserializeArrayRoot.size();
	int i = 0;
	deserializeRoot = deserializeArrayRoot[i++];
	while (i<obj_count)
	{
		IndexMetaData *new_index_data = new IndexMetaData();
		if(new_index_data->deserialize(deserializeRoot))
		{
			obj_map.insert(std::pair<std::string, IndexMetaData*>(new_index_data->indexName, new_index_data));
		}
		deserializeRoot = deserializeArrayRoot[i++];
	}
	return true;
}


bool
JsonSerializer::serializeArray (std::map<std::string, ExplainMetaData*> &obj_map, std::string & output)
{
	Json::ValueType vt = Json::arrayValue;
	Json::Value serializeArrayRoot (vt);
	Json::Value serializeRoot;
	std::map<std::string, ExplainMetaData*>::iterator it;
	int obj_count = 0;
	for (it = obj_map.begin(); it!= obj_map.end(); ++it)
	{
		if(((it->second) != NULL) && ((it->second)->serialize (serializeRoot)))
		{
			serializeArrayRoot[obj_count++] = serializeRoot;
		}
	}
	Json::StyledWriter writer;
	output = writer.write (serializeArrayRoot);
	return true;
}

/*
bool 
JsonSerializer::serialize (std::map<std::string, JsonSerializable*> &obj_map, std::string & output)
{
	Json::ValueType vt = Json::arrayValue;
	Json::Value serializeArrayRoot (vt);
	Json::Value serializeRoot;
	std::map<std::string, JsonSerializable*>::iterator it;
	int obj_count = 0;
	for (it = obj_map.begin(); it!= obj_map.end(); ++it)
	{
		if(((it->second) != NULL) && ((it->second)->serialize (obj_map, serializeRoot)))
		{
			serializeArrayRoot[obj_count++] = serializeRoot;
		}
	}
	Json::StyledWriter writer;
	output = writer.write (serializeArrayRoot);
	return true;
}

bool
JsonSerializer::deserialize (std::map<std::string, JsonSerializable*> &obj_map, std::string & input)
{
	// treat pObj as an array
	Json::ValueType vt = Json::arrayValue;
	Json::Value deserializeArrayRoot (vt);

	Json::Value deserializeRoot;
	Json::Reader reader;
	if (!reader.parse (input, deserializeArrayRoot))
	{
		return false;
	}
	int obj_count = 0;
	deserializeRoot = deserializeArrayRoot[obj_count++];
	while (deserializeRoot != NULL)
	{
		(pObj[i]).deserialize (deserializeRoot);
		deserializeRoot = deserializeArrayRoot[obj_count++];
	}
	return true;
}

*/
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
