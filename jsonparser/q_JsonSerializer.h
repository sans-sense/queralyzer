#include "../inc/json.h"
#include "q_JsonSerializable.h"
class JsonSerializer {
private:
  JsonSerializer();
  virtual ~JsonSerializer();

public:
  static bool serialize(JsonSerializable *pObj, std::string &output);
  static bool deserialize(JsonSerializable *pObj, std::string &input);
};
