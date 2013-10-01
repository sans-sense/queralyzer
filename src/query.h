#include <mysql.h>
#include <vector>
#include "meta_data.h"
#include "embedded_mysql.h"

#ifndef QUERALYZER_QUERY_H_
#define QUERALYZER_QUERY_H_
class Query
{
private:
	std::string query_str;
	std::multimap<std::string, ExplainMetaData*> explain_data_multimap;
	std::vector < std::string > create_tables_vector;
	std::string output_str;
	bool data_updated;
	Query ();
public:
	Query (std::string input);
	~Query ();
	void setQuery (std::string query_input);
	int parseQuery ();
	int initialiseQueryExecution ();
	int executeQuery ();
	void getQueryOutput (std::string &);
};

#endif  //QUERALYZER_QUERY_H_
