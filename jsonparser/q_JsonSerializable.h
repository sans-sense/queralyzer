#include <iostream>
#include <string>
#include "../inc/json.h"

#ifndef JSONSERIALIZABLE
#define JSONSERIALIZABLE

class JsonSerializable {
private:
public:
  JsonSerializable(void){ }
  ~JsonSerializable(void){ }
  virtual void serialize(Json::Value &root)=0;
  virtual void deserialize(Json::Value &root)=0;
};

#endif
