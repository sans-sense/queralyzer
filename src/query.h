#include <mysql.h>
#include <vector>
#include "meta_data.h"
#include "embedded_mysql.h"

#ifndef QUERY
#define QUERY
class Query
{
private:
  std::string query_str;
  std::string * query_tables;
  std::string * query_indexes;
  ExplainMetaData *explain_data;
    std::vector < std::string > create_queries_vector;
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
  void displayQueryOutput ();
};

#endif
