#include "q_JsonSerializer.h"

class TableMetaData : public JsonSerializable {
private:

public:
  TableMetaData(void){}
  TableMetaData(std::string name, std::string engine):tableName(name), storageEngine(engine)
  {
  }
  ~TableMetaData(void){}
  std::string tableName;
  std::string *tableColumns;
  std::string schemaName;
  std::string storageEngine;
  std::string createOption;
  int         rowCount;
  int  	      columnCount;

  virtual void serialize(Json::Value &root);
  virtual void deserialize(Json::Value &root);
};

class IndexMetaData : public JsonSerializable {
private:
  IndexMetaData();
  virtual ~IndexMetaData();

public:
  IndexMetaData(std::string name):indexName(name),indexType("")
  {
  }
  std::string indexName;      //for primary key it is always PRIMARY
  std::string indexType;
  std::string *indexColumns;
  std::string tableName;
  std::string schemaName;
  std::string storageEngine;
  int  	      columnCount;
  int         cardinality;
  bool        nonUnique;
  bool        isNullable;

  virtual void serialize(Json::Value &root);
  virtual void deserialize(Json::Value &root);
};

