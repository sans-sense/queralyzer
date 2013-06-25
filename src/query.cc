#include <string>
#include "query.h"
Query::Query (std::string input):query_str (input)
{
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
		return (embedded_mysql->executeMYSQL (query_str, explain_data_map));
}

void
Query::getQueryOutput (std::string & explain_json_output)
{
	serializeMap(explain_data_map, explain_json_output);
}
