#include "../inc/json.h"
#include "q_JsonSerializable.h"

#ifndef JSONSERIALIZER
#define JSONSERIALIZER

class JsonSerializer
{
private:
  JsonSerializer ();
  virtual ~ JsonSerializer ();

public:
  static bool serialize (JsonSerializable * pObj, std::string & output);
  static bool deserialize (JsonSerializable * pObj, std::string & input);

  static void serializeArray (Json::Value & rootArray,
			      std::string * inputValues,
			      unsigned int arrayLength);
  static void deserializeArray (Json::Value & rootArray,
				std::string * copyValues,
				unsigned int arrayLength);
};

#endif
