#include <iostream>
#include <string>
#include "../inc/json.h"

#ifndef QUERALYZER_Q_JSONSERIALIZABLE_H_
#define QUERALYZER_Q_JSONSERIALIZABLE_H_

class JsonSerializable
{
private:
public:
	JsonSerializable (void)
{
}
	~JsonSerializable (void)
	{
	}
	virtual void serialize (Json::Value & root) = 0;
	virtual void deserialize (Json::Value & root) = 0;
	virtual std::string getName() = 0; //require to implement key in the map
};

#endif  //QUERALYZER_Q_JSONSERIALIZABLE_H_
