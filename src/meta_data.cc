#include <string>
#include "q_JsonSerializable.h"
#include "meta_data.h"

void
TableMetaData::serialize(Json::Value & root)
{
    root["tableName"] = tableName;
    root["schemaName"] = schemaName;
    root["storageEngine"] = storageEngine;
    root["createOption"] = createOption;
    root["rowCount"] = rowCount;
    root["columnCount"] = columnCount;
    Json::ValueType vt = Json::arrayValue;
    Json::Value columnArray(vt);

    serializeArray(columnArray, tableColumns, columnCount);
    root["tableColumns"] = columnArray;
}

void
TableMetaData::deserialize(Json::Value & root)
{
    tableName = root.get("tableName", "").asString();
    schemaName = root.get("schemaName", "").asString();
    storageEngine = root.get("storageEngine", "").asString();
    createOption = root.get("createOption", "").asString();
    rowCount = root.get("rowCount", "0").asString();
    columnCount = root.get("columnCount", 0).asInt();

    Json::ValueType vt = Json::arrayValue;
    Json::Value columnArray(vt);
    columnArray = root["tableColumns"];

    deserializeArray(columnArray, tableColumns, columnCount);

}

std::string
TableMetaData::getName()
{
    return tableName;
}

TableMetaData& 
TableMetaData::operator=(const TableMetaData & other)
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
IndexMetaData::serialize(Json::Value & root)
{
    root["indexName"] = indexName;	// for primary key it is always
					// PRIMARY
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

    serializeArray(columnArray, indexColumns, columnCount);
    root["indexColumns"] = columnArray;
}

void
IndexMetaData::deserialize(Json::Value & root)
{
    indexName = root.get("indexName", "").asString();
    indexType = root.get("indexType", "").asString();
    tableName = root.get("tableName", "").asString();
    schemaName = root.get("schemaName", "").asString();
    storageEngine = root.get("storageEngine", "").asString();
    columnCount = root.get("columnCount", 0).asInt();
    cardinality = root.get("cardinality", "0").asString();
    nonUnique = root.get("nonUnique", 0).asBool();
    isNullable = root.get("isNullable", 0).asBool();
    Json::ValueType vt = Json::arrayValue;
    Json::Value columnArray(vt);
    columnArray = root["indexColumns"];
    deserializeArray(columnArray, indexColumns, columnCount);
}

std::string
IndexMetaData::getName()
{
    return indexName;
}

void
ExplainMetaData::serialize(Json::Value & root)
{
    root["id"] = (id == "NULL") ? Json::Value::null : id;
    root["select_type"] =
	(select_type == "NULL") ? Json::Value::null : select_type;
    root["table"] = (table == "NULL") ? Json::Value::null : table;
    root["type"] = (type == "NULL") ? Json::Value::null : type;
    root["possible_keys"] =
	(possible_keys == "NULL") ? Json::Value::null : possible_keys;
    root["key"] = (key == "NULL") ? Json::Value::null : key;
    root["key_len"] = (key_len == "NULL") ? Json::Value::null : key_len;
    root["ref"] = (ref == "NULL") ? Json::Value::null : ref;
    root["rows"] = rows;
    root["Extra"] = (Extra == "NULL") ? Json::Value::null : Extra;
}

void
ExplainMetaData::deserialize(Json::Value & root)
{
    /*
     * Not Required 
     */
    /*
     * id = root.get ("id", "").asString (); select_type = root.get
     * ("select_type", "").asString (); table = root.get ("table",
     * "").asString (); type = root.get ("type", "").asString ();
     * possible_keys = root.get ("possible_keys", "").asString (); key =
     * root.get ("key", "").asString (); key_len = root.get ("key_len",
     * "").asString (); ref = root.get ("ref", "").asString (); rows =
     * root.get ("rows", 0).asInt (); Extra = root.get ("Extra",
     * "").asString (); 
     */
}

std::string ExplainMetaData::getName()
{
    /*
     * Dummy Never used 
     */
    return "DUMMY";
}
