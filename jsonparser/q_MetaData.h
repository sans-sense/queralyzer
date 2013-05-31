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
  TableMetaData &operator=(const TableMetaData &other);
};

class IndexMetaData : public JsonSerializable {
private:

public:
  IndexMetaData(){}
  IndexMetaData(std::string name):indexName(name),indexType("")
  {
  }
  virtual ~IndexMetaData(){}
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

