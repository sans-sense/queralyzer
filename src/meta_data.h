#include "q_JsonSerializer.h"
#include "../inc/json.h"

#ifndef METADATA
#define METADATA

class ExplainMetaData:public JsonSerializable
{
private:

public:

	ExplainMetaData (void)
{
}
	~ExplainMetaData (void)
	{
	}
	std::string id;
	std::string select_type;
	std::string table;
	std::string type;
	std::string possible_keys;
	std::string key;
	std::string key_len;
	std::string ref;
	int rows;
	std::string Extra;

	virtual bool serialize (Json::Value & root);
	virtual bool deserialize (Json::Value & root);
	ExplainMetaData & operator= (const ExplainMetaData & other);
	bool operator!= (const ExplainMetaData & other)
	{
		return false;
	}

};

class TableMetaData:public JsonSerializable
{
private:

public:
	TableMetaData (void):tableName (""), storageEngine (""), schemaName (""),
	createOption (""), rowCount (0), columnCount (0)
	{
	}
	TableMetaData (std::string name, std::string engine):tableName (name),
			storageEngine (engine)
	{
	}
	~TableMetaData (void)
	{
	}
	std::string tableName;
	std::string * tableColumns;
	std::string schemaName;
	std::string storageEngine;
	std::string createOption;
	int rowCount;
	int columnCount;

	virtual bool serialize (Json::Value & root);
	virtual bool deserialize (Json::Value & root);
	TableMetaData & operator= (const TableMetaData & other);
};

class IndexMetaData:public JsonSerializable
{
private:

public:
	IndexMetaData ()
{
}
	IndexMetaData (std::string name):indexName (name), indexType ("")
	{
	}
	virtual ~ IndexMetaData ()
	{
	}
	std::string indexName;	//for primary key it is always PRIMARY
	std::string indexType;
	std::string * indexColumns;
	std::string tableName;
	std::string schemaName;
	std::string storageEngine;
	int columnCount;
	int cardinality;
	bool nonUnique;
	bool isNullable;

	virtual bool serialize (Json::Value & root);
	virtual bool deserialize (Json::Value & root);
};

#endif
