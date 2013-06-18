#include <string>
#include "query.h"
Query::Query (std::string input):query_str (input)
{
	//explain_map_it_begin = explain_data_map.begin();
	//explain_map_it_end = explain_data_map.end();
	//explain_data = new ExplainMetaData[50];
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
	if (query_str.empty ())
	{
		return 1;
	}
	else
	{
		EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
		return (embedded_mysql->parseMYSQL (query_str, create_queries_vector));
	}

}

int
Query::initialiseQueryExecution ()
{
	std::vector < std::string >::iterator create_queries_it;
	if (create_queries_vector.empty ())
	{
		std::cerr << "Failed during initialising Query Execution";
		return 1;
	}
	EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
	for (create_queries_it = create_queries_vector.begin ();
			create_queries_it != create_queries_vector.end ();)
	{
		if (embedded_mysql->executeMYSQL (*create_queries_it))
		{
			std::cerr << "Problem while running query:" << '\n' <<
					*create_queries_it;
			return 1;
		}
		create_queries_it = create_queries_vector.erase (create_queries_it);
	}
	return 0;
}

int
Query::executeQuery ()
{
	if (query_str.empty ())
	{
		return 1;
	}
	else
	{
		EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
		return (embedded_mysql->executeMYSQL (query_str, explain_data_map));
	}
}

void
Query::getQueryOutput (std::string & explain_json_output)
{
	JsonSerializer::serializeArray(explain_data_map, explain_json_output);
	return;
}

void
Query::displayQueryOutput ()
{

}
