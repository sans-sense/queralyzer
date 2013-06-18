#include "../inc/json.h"
#include "q_JsonSerializable.h"

#include <map>

#ifndef JSONSERIALIZER
#define JSONSERIALIZER
class TableMetaData;
class IndexMetaData;
class ExplainMetaData;
class JsonSerializer
{
private:
	JsonSerializer ();
	virtual ~ JsonSerializer ();

public:
	static bool serializeArray (std::map<std::string, TableMetaData*> &obj_map, std::string & output);
	static bool deserializeArray (std::map<std::string, TableMetaData*> &obj_map, std::string & input);

	static bool serializeArray (std::map<std::string, IndexMetaData*> &obj_map, std::string & output);
	static bool deserializeArray (std::map<std::string, IndexMetaData*> &obj_map, std::string & input);

	static bool serializeArray (std::map<std::string, ExplainMetaData*> &obj_map, std::string & output);
	static bool deserializeArray (std::map<std::string, ExplainMetaData*> &obj_map, std::string & input);

	static void serializeArray (Json::Value & rootArray,
			std::string * inputValues,
			unsigned int arrayLength);
	static void deserializeArray (Json::Value & rootArray,
			std::string * copyValues,
			unsigned int arrayLength);
};

#endif
