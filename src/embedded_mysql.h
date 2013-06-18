#include <string>
#include "meta_data.h"
#include "mysql.h"
#include <map>

/* This will be a singleton class and all the Query class object will use that instance
All the MYSQL related functionality are supposed to be defined here
 */

// TODO: Try to add the storage engine functionality here

class EmbeddedMYSQL
{
private:
	static EmbeddedMYSQL *my_embedded_mysql;
	static bool isInstantiated;
	static bool isInitialized;
	static MYSQL *mysql;
	MYSQL_RES *results;
	std::map<std::string, TableMetaData*> table_data_map;
	std::map<std::string, IndexMetaData*> index_data_map;
	EmbeddedMYSQL ():results (NULL)
	{

	}
	EmbeddedMYSQL (EmbeddedMYSQL const &)
	{
	}
	EmbeddedMYSQL & operator= (EmbeddedMYSQL const &);
public:
	~EmbeddedMYSQL ();
	static EmbeddedMYSQL *getInstance ();
	int initializeMYSQL ();
	int deinitializeMYSQL ();
	int executeMYSQL (std::string query_str);
	/* this is overloaded for the select statements as we don't want to mix
 MYSQL functions inside the Query class.
	 */
	int executeMYSQL (std::string query_str, std::map<std::string, ExplainMetaData*> &explain_data_map);

	void getTableMetaDataMYSQL (std::string & table_json_output);
	void setTableMetaDataMYSQL (std::string & table_json_input);
	void getIndexMetaDataMYSQL (std::string & index_json_output);
	void setIndexMetaDataMYSQL (std::string & index_json_input);
	int parseMYSQL (std::string query_str, std::vector<std::string> & create_queries_vector);
};
