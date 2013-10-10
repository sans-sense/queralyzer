#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/un.h>
#include "embedded_mysql.h"

#define ADDRESS "/tmp/queralyzer.sock"

extern int queralyzer_parser(const char *queryBuffer,
    std::vector < std::string > &createQueriesVector,
    std::multimap < std::string, TableMetaData * >&tableData,
    std::multimap < std::string, IndexMetaData * >&indexData,
    std::multimap < std::string, std::string > &table_name_data);

bool
    EmbeddedMYSQL::isInstantiated = false;

EmbeddedMYSQL *
    EmbeddedMYSQL::my_embedded_mysql = NULL;

bool
    EmbeddedMYSQL::isInitialized = false;

MYSQL *
    EmbeddedMYSQL::mysql = NULL;

EmbeddedMYSQL *
EmbeddedMYSQL::getInstance()
{
    if (isInstantiated)
    {
	return my_embedded_mysql;
    }
    else
    {
	my_embedded_mysql = new EmbeddedMYSQL();
	isInstantiated = true;
	isInitialized = false;
	return my_embedded_mysql;
    }
}

int
EmbeddedMYSQL::initializeMYSQL()
{
    if (mysql)
	return 0;
    /*
     * Currently these are hard coded, implmentation may be changed in
     * future 
     */
    char *server_options[] = { "mysql_test",
	"--defaults-file=my.init",
	NULL
    };
    int num_elements = (sizeof(server_options) / sizeof(char *)) - 1;
    char *server_groups[] = {"mysqld", "server", "client", NULL };

    mysql_library_init(num_elements, server_options, server_groups);
    mysql = mysql_init(NULL);
    if (mysql)
    {
	mysql_options(mysql, MYSQL_READ_DEFAULT_GROUP, "libmysqld_client");
	mysql_options(mysql, MYSQL_OPT_USE_EMBEDDED_CONNECTION, NULL);

	if (!mysql_real_connect(mysql, NULL, NULL, NULL, "test_queralyzer", 0, NULL, 0))
	{
	    std::cout << "mysql_real_connect failed: " << mysql_error(mysql) <<
		std::endl;
	    isInitialized = false;
	    return 1;
	}

	if (mysql_query(mysql,
		"create table IF NOT EXISTS test_aps (id int primary key, name varchar(100))"))
	{
	    isInitialized = false;
	    return 1;
	}
	isInitialized = true;
	return 0;
    }
    else
    {
	std::cout << "mysql was never inited succesfully" << std::endl;
	isInitialized = false;
	return 1;
    }
}

int
EmbeddedMYSQL::deinitializeMYSQL()
{
    mysql_close(mysql);
    mysql_library_end();
    return 0;
}

int
EmbeddedMYSQL::createTableMYSQL(std::string table_name)
{
    if (isInitialized == false)
    {
	std::cout <<
	    "MYSQL is not initialised properly, unable to process queries";
	return 1;
    }
    if (table_name.empty())
    {
	std::cout << "Table Name is empty";
	return 2;
    }

    TableMetaData *table_found = NULL;

    std::multimap < std::string, TableMetaData * >::iterator it;
    it = table_data_multimap.find(table_name);
    table_found = it->second;

    if (table_found == NULL)
    {
	std::cout << "ERROR while searching the table in table multimap" <<
	    std::endl;
	return 2;
    }
    int column_count = table_found->columnCount;

    std::string create_query;
    std::string drop_query;
    drop_query = "drop table if exists ";
    drop_query += table_name;
    drop_query += ";\n";
    create_query = "create table if not exists ";
    create_query += table_found->tableName;
    create_query += " ( ";
    while (column_count != 0)
    {
	create_query += table_found->tableColumns[column_count - 1];
	create_query += " int";
	if (column_count > 1)
	{
	    create_query += ",";
	}
	column_count -= 1;
    }
    create_query += " ) engine=ANALYSISENGINE;\n";
    /*
     * Avoiding risk, dropping the table if it exists 
     */
    if (mysql_query(mysql, drop_query.c_str()))
    {
	std::cout << "problems running " << drop_query << " error " <<
	    mysql_error(mysql);
	return 2;
    }
    if (mysql_query(mysql, create_query.c_str()))
    {
	std::cout << "problems running " << create_query << " error " <<
	    mysql_error(mysql);
	return 2;
    }
    return 0;

}

int
EmbeddedMYSQL::executeMYSQL(std::string query_str,
    std::multimap < std::string, ExplainMetaData * >&explain_data_multimap)
{
    if (isInitialized == false)
    {
	std::cout <<
	    "MYSQL is not initialised properly, unable to process queries";
    }
    if (query_str.empty())
    {
	std::cout << "Cannot process empty query";
	return 3;
    }
    std::string table_json_string;
    serializeMap(table_data_multimap, table_json_string);
    int result = updateStorageEngine(table_json_string);

    {
	if (result == -1)
	    return 6;
    }
    if (mysql_query(mysql, query_str.c_str()))
    {
	std::cout << "problems running " << query_str << " error " <<
	    mysql_error(mysql);
	return 3;
    }
    if (mysql_field_count(mysql) > 0)
    {
	results = mysql_store_result(mysql);
	// used to determine if the query returned any results
	if (!results)
	{
	    // Contains null result
	    return 0;
	}
	/*
	 * Store the values in explain_data 
	 */
	int i = 10;
	MYSQL_ROW row;

	while (row = mysql_fetch_row(results))
	{
	    ExplainMetaData *explain_data = new ExplainMetaData();

	    std::stringstream ss;
	    ss << i;
	    std::string key = "ROW" + ss.str();
	    explain_data->id = *(row + 0) ? (char *) *(row + 0) : "NULL";
	    explain_data->select_type =
		*(row + 1) ? (char *) *(row + 1) : "NULL";
	    explain_data->table = *(row + 2) ? (char *) *(row + 2) : "NULL";
	    explain_data->type = *(row + 3) ? (char *) *(row + 3) : "NULL";
	    explain_data->possible_keys =
		*(row + 4) ? (char *) *(row + 4) : "NULL";
	    explain_data->key = *(row + 5) ? (char *) *(row + 5) : "NULL";
	    explain_data->key_len = *(row + 6) ? (char *) *(row + 6) : "NULL";
	    explain_data->ref = *(row + 7) ? (char *) *(row + 7) : "NULL";
	    explain_data->rows = *(row + 8) ? (char *) *(row + 8) : "NULL";
	    explain_data->Extra = *(row + 9) ? (char *) *(row + 9) : "NULL";
	    explain_data_multimap.insert(std::pair < std::string,
		ExplainMetaData * >(key, explain_data));
	    i++;
	}
    }
    mysql_free_result(results);
    return 0;
}


void
EmbeddedMYSQL::getTableMetaDataMYSQL(std::string & table_json_output)
{
    serializeMap(table_data_multimap, table_json_output);
}

int
EmbeddedMYSQL::setTableMetaDataMYSQL(std::string & table_json_input)
{
    /*
     * Doesn't wanted to clear the complete map, but since the libhttpd
     * server doesn;t handle the DELETE / PUT request, there is no other way 
     * to update the existing map other then deleting and recreating
     * the whole map. Same applies to Index Meta Data.
     */
    table_data_multimap.clear();
    deserializeMap(table_data_multimap, table_json_input);

    /*
     * Passing the serialize data to the Storage engine. Since in future we
     * intend to do all the work in the Storage engine. It's better to store 
     * the meta data map in the SE. ToDo: remove all the meta data from
     * queralyzer (currently needed for create and alter table) and let
     * storage engine alone maintain it. 
     */

    int result = updateStorageEngine(table_json_input);

    if (result == -1)
	return 6;

    return 0;
}

void
EmbeddedMYSQL::getIndexMetaDataMYSQL(std::string & index_json_output)
{
    serializeMap(index_data_multimap, index_json_output);
}

int
EmbeddedMYSQL::setIndexMetaDataMYSQL(std::string & index_json_input)
{
    index_data_multimap.clear();
    deserializeMap(index_data_multimap, index_json_input);

    this->updateMetaDataMYSQL();
}

void 
EmbeddedMYSQL::getTableAliasDataMYSQL(std::string & alias_json_output)
{
    Json::ValueType vt = Json::arrayValue;
    Json::Value serializeArrayRoot(vt);
    int obj_count=0;
    std::multimap<std::string,std::string>::iterator table_alias_multimap_it;
    for(table_alias_multimap_it = table_alias_multimap.begin();
        table_alias_multimap_it != table_alias_multimap.end();
        ++table_alias_multimap_it)
    {
        std::cout<<(*table_alias_multimap_it).second<< ":" <<(*table_alias_multimap_it).first <<std::endl;
        Json::Value serializeObj;
        /* As per our parser implementation it is not possible to have same table alias 
         * for more than one table. 
         * one alias per table name, but that is fine, as in json we
         * want to map aliases to table names. 
         */
         serializeObj[(*table_alias_multimap_it).second]=(*table_alias_multimap_it).first;
         serializeArrayRoot[obj_count++]=serializeObj;
    }
    Json::FastWriter writer;
    alias_json_output=writer.write(serializeArrayRoot);
}

int
EmbeddedMYSQL::parseMYSQL(std::string query_str,
    std::vector < std::string > &create_queries_vector)
{
    return (queralyzer_parser(query_str.c_str(), create_queries_vector,
	    table_data_multimap, index_data_multimap, table_alias_multimap));
}

void
EmbeddedMYSQL::resetMYSQL()
{
    results = NULL;
    table_data_multimap.clear();
    index_data_multimap.clear();
}

int
EmbeddedMYSQL::updateMetaDataMYSQL()
{
    /*
     * Drop all the tables and recreate them with the new table meta data
     * and index meta data information. 
     */
    std::multimap < std::string,
	TableMetaData * >::iterator tableMetaDataMultiMap_it;

    for (tableMetaDataMultiMap_it = table_data_multimap.begin();
	tableMetaDataMultiMap_it != table_data_multimap.end();
	++tableMetaDataMultiMap_it)
    {
	std::string table_name = tableMetaDataMultiMap_it->first;
	TableMetaData *table_data = tableMetaDataMultiMap_it->second;

	std::pair < std::multimap < std::string, IndexMetaData * >::iterator,
	    std::multimap < std::string, IndexMetaData * >::iterator >
	    index_found;

	index_found = index_data_multimap.equal_range(table_name);

	std::string create_query;
	std::string drop_query;
	drop_query = "drop table if exists ";
	drop_query += table_name;
	drop_query += ";\n";
	create_query = "create table if not exists ";
	create_query += table_data->tableName;
	create_query += " ( ";
	int column_count = table_data->columnCount;

	while (column_count != 0)
	{
	    create_query += table_data->tableColumns[column_count - 1];
	    create_query += " int";
	    if (column_count > 1)
	    {
		create_query += ",";
	    }
	    column_count -= 1;
	}
	std::multimap < std::string, IndexMetaData * >::iterator it;
	for (it = index_found.first; it != index_found.second; ++it)
	{
	    create_query += ",";
	    if (it->second->indexName != "PRIMARY KEY")
	    {
		create_query += "index ";
	    }
	    create_query += it->second->indexName;
	    create_query += "(";
	    int index_column_count = it->second->columnCount;

	    while (index_column_count != 0)
	    {
		create_query +=
		    it->second->indexColumns[index_column_count - 1];
		if (index_column_count > 1)
		{
		    create_query += ",";
		}
		index_column_count -= 1;
	    }
	    create_query += ")";

	    create_query += "using " + it->second->indexType;
	}
	create_query += " ) engine=ANALYSISENGINE;\n";

	/*
	 * Avoiding risk, dropping the table if it exists 
	 */
	if (mysql_query(mysql, drop_query.c_str()))
	{
	    std::cout << "problems running " << drop_query << " error " <<
		mysql_error(mysql);
	    return 2;
	}
	if (mysql_query(mysql, create_query.c_str()))
	{
	    std::cout << "problems running " << create_query << " error " <<
		mysql_error(mysql);
	    return 2;
	}
    }
    return 0;
}

int
EmbeddedMYSQL::updateStorageEngine(std::string & table_json_input)
{
    /*
     * Using IPC to send the data to the SE. Queralyzer acts as a client
     * for Storage Engine. 
     */
    int s, len;
    struct sockaddr_un saun;
    struct sockaddr *sa;

    /*
     * Get a socket to work with.  This socket will
     * be in the UNIX domain, and will be a stream socket.
     */
    if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) == -1)
    {
	perror("client: socket");
	return -1;
	// exit(1);
    }

    /*
     * Create the address we will be connecting to.
     */
    saun.sun_family = AF_UNIX;
    strcpy(saun.sun_path, ADDRESS);
    len = sizeof(saun.sun_family) + strlen(saun.sun_path);
    sa = (struct sockaddr *) &saun;
    if ((connect(s, sa, len)) == -1)
    {
	perror("client: connect");
	close(s);
	return -1;
	// exit(1);
    }
    int input_len = table_json_input.length();
    int sent_len = 0;

    while (sent_len < input_len)
    {
	int result =
	    send(s, (void *) (table_json_input.c_str()), input_len, 0);
	if (result == -1 && errno == EINTR)
	{
	    continue;
	}
	if (result == -1)
	{
	    perror("client: send");
	    close(s);
	    return -1;
	}
	sent_len += result;
    }
    close(s);
    return 0;
}
