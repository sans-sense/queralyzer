#include <string>
#include "meta_data.h"
#include "mysql.h"
#include <map>

/* This will be a singleton class and all the Query class object will use that 
 * instance. All MYSQL functionality are to be exposed via this class.
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
         
	    std::multimap < std::string, TableMetaData * >table_data_multimap;
         
	    std::multimap < std::string, IndexMetaData * >index_data_multimap;
              EmbeddedMYSQL():results(NULL)
    {
    }
    EmbeddedMYSQL(EmbeddedMYSQL const &)
    {
    }
    EmbeddedMYSQL & operator=(EmbeddedMYSQL const &);

  public:
    ~EmbeddedMYSQL();
    static EmbeddedMYSQL *getInstance();
    int initializeMYSQL();
    int deinitializeMYSQL();
    int EmbeddedMYSQL::createTableMYSQL(std::string table_name);

    int executeMYSQL(std::string query_str, std::multimap < std::string,
	ExplainMetaData * >&explain_data_multimap);

    void getTableMetaDataMYSQL(std::string & table_json_output);
    int setTableMetaDataMYSQL(std::string & table_json_input);
    void getIndexMetaDataMYSQL(std::string & index_json_output);
    int setIndexMetaDataMYSQL(std::string & index_json_input);
    int parseMYSQL(std::string query_str,
	std::vector < std::string > &create_queries_vector);
    void resetMYSQL();
    int EmbeddedMYSQL::updateMetaDataMYSQL();
    int EmbeddedMYSQL::updateStorageEngine(std::string & table_json_input);
};