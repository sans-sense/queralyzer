#include <string>
#include "query.h"
Query::Query (std::string input)
{
    query_str=input;
}

Query::~Query ()
{

}

void
Query::setQuery (std::string query_input)
{
	query_str = query_input;
}

int
Query::parseQuery ()
{
		EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
                embedded_mysql->resetMYSQL();
		return (embedded_mysql->parseMYSQL (query_str, create_tables_vector));
}

int
Query::initialiseQueryExecution ()
{
	std::vector < std::string >::iterator create_tables_it;
	if (create_tables_vector.empty ())
	{
		std::cout << "Failed during initialising Query Execution";
		return 4;
	}
	EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
	
        for (create_tables_it = create_tables_vector.begin ();
			create_tables_it != create_tables_vector.end ();++create_tables_it)
	{
      if (embedded_mysql->createTableMYSQL (*create_tables_it))
		{
			std::cout << "Problem while table:" << '\n' << *create_tables_it<<std::endl;
			return 2;
		}
	}
	return 0;
}

int
Query::executeQuery ()
{
    EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
    explain_data_multimap.clear();
    /* Also fetch the optimizer output. And store it.
     */
    std::string query_explain_normal="EXPLAIN " + query_str;
    std::string query_explain_json="EXPLAIN format=JSON " + query_str;
    std::string optimizer_on="SET optimizer_trace='enabled=on';";
    std::string optimizer_off="SET optimizer_trace='enabled=off';";
    std::string optimizer_mem_size="SET OPTIMIZER_TRACE_MAX_MEM_SIZE=1000000;";
    std::string optimizer_query="SELECT TRACE FROM INFORMATION_SCHEMA.OPTIMIZER_TRACE;";
    embedded_mysql->executeOnlyMYSQL(optimizer_on);
    embedded_mysql->executeOnlyMYSQL(optimizer_mem_size);
    int result=-1;
    if ((result=embedded_mysql->executeMYSQL (query_explain_normal, explain_data_multimap))==0)
    {
        embedded_mysql->executeMYSQL (query_explain_json, explain_output_in_json);

    }
    if(!result)
    {
        embedded_mysql->executeMYSQL(optimizer_query, optimizer_trace_in_json);
    }
    embedded_mysql->executeOnlyMYSQL(optimizer_off);
    return result;
}


void
Query::getQueryOutput (std::string & explain_json_output)
{
	serializeMap(explain_data_multimap, explain_json_output);
}
