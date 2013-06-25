#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string.h>
#include <httpd.h>
#include "query.h"
#include "meta_data.h"

extern "C"
{
  char *custom_error_messages[] = { // MYSQL errors
                                      "dummy_no_error",
                                      "Error, Mysql not initialized properly",
                                      "Error, while creating new tables",
                                      "Error, while running the input query",
                                      // Query Initialization and parsing
                                      "Error, during Query Initialization",
                                      "Error, while query parsing the input query"
  };

  int display_error_if_any(int result, httpd * server)
  {
    if(result == 0)
      return result;
    httpdSetResponse (server, "500");    
    printf("%s\n", custom_error_messages[result]);
    httpdPrintf(server, "%s\n", custom_error_messages[result]);
    return 1;
   }

  void dummy_html (httpd * server)
  {
	httpdPrintf (server, "Welcome to the httpd queralyzer");
	httpdPrintf (server, "<P><FORM ACTION=query METHOD=POST>\n");
	httpdPrintf (server, "Enter your query <INPUT NAME=query SIZE=4096>\n");
	httpdPrintf (server, "<INPUT TYPE=SUBMIT VALUE=Click!><P></FORM>\n");
	return;
  }

void query_html (httpd * server)
{
	char *query_op;
	httpVar *variable;
	variable = httpdGetVariableByName (server, "query");
	if (variable == NULL)
	{
		httpdPrintf (server, "Missing form data!");
		return;
	}
	char *query_input = variable->value;

	Query *query = new Query (query_input);
	if (query == NULL)
		printf ("Problem while creating Query object\n");

	if (!display_error_if_any(query->parseQuery (), server) && !display_error_if_any(query->initialiseQueryExecution (), server))
	{
      if (!display_error_if_any(query->executeQuery (), server))
		{
			std::string mysql_json_output;
			query->getQueryOutput (mysql_json_output);
			httpdPrintf (server, "%s\n", mysql_json_output.c_str ());
			std::cout << mysql_json_output << std::endl;
		}
	}
	return;
}
void table_data_html (httpd * server)
{
	EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();

	if (!strcmp (httpdRequestMethodName (server), "GET"))
	{
		std::string getTableDataString;
		embedded_mysql->getTableMetaDataMYSQL (getTableDataString);
		httpdPrintf (server, "%s\n", getTableDataString.c_str ());
		//std::cout << getTableDataString << std::endl;
	}
	else if (!strcmp (httpdRequestMethodName (server), "POST"))
	{
		httpVar *updateString;
		updateString = httpdGetVariableByName (server, "tablemetadata");
		if (updateString == NULL)
		{
			httpdSetResponse (server, "500");
			httpdPrintf (server, "Missing form data!");
			return;
		}
		std::string updateTableDataString = updateString->value;
		embedded_mysql->setTableMetaDataMYSQL (updateTableDataString);
	}
	return;
}

void index_data_html (httpd * server)
{
	httpdSetResponse (server, "501 Not Implemented");
	httpdPrintf (server, "Not Implemented");
	std::cout<<"Not Implemented"<<std::endl;
	return;
}

void reset_html (httpd * server)
{
	EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
	if (!strcmp (httpdRequestMethodName (server), "POST"))
	{
    	embedded_mysql->resetMYSQL();	
		httpdPrintf(server, "RESET DONE");
    }
	return;
}

int main ()
{

	EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance ();
	embedded_mysql->initializeMYSQL ();

	httpd *server;
	/*
	 ** Create a server and setup our logging
	 */
	server = httpdCreate (NULL, 1234);
	if (server == NULL)
	{
		perror ("Can't create server");
		exit (1);
	}
	httpdSetAccessLog (server, stdout);
	httpdSetErrorLog (server, stderr);
	/*
	 ** Setup some content for the server
	 */
	httpdAddCContent (server, "/", "dummy", HTTP_TRUE, NULL, dummy_html);
	httpdSetFileBase (server, "/home/prabinb/queralyzer/queralyzerUI/");
	httpdAddFileContent (server, "/", "index.html", HTTP_TRUE, NULL,"index.html");
	httpdAddWildcardContent (server, "/css", NULL, "css");
	httpdAddWildcardContent (server, "/img", NULL, "img");
	httpdAddWildcardContent (server, "/js", NULL, "js");
	httpdAddWildcardContent (server, "/js/lib", NULL, "js/lib");
	httpdAddWildcardContent (server, "/js/app", NULL, "js/app");
	httpdAddWildcardContent (server, "/bootstrap", NULL, "bootstrap");
	httpdAddWildcardContent (server, "/bootstrap/css", NULL, "bootstrap/css");
	httpdAddWildcardContent (server, "/bootstrap/img", NULL, "bootstrap/img");
	httpdAddWildcardContent (server, "/bootstrap/js", NULL, "bootstrap/js");
	httpdAddCContent (server, "/", "query", HTTP_TRUE, NULL, query_html);
	httpdAddCContent (server, "/", "tablemetadata", HTTP_TRUE, NULL,
			table_data_html);
	httpdAddCContent (server, "/", "indexmetadata", HTTP_TRUE, NULL,
			index_data_html);
	httpdAddCContent (server, "/", "reset", HTTP_TRUE, NULL,
			reset_html);
	/*
	 ** Go into our service loop
	 */
	while (1 == 1)
	{
		if (httpdGetConnection (server, 0) < 0)
			continue;
		if (httpdReadRequest (server) < 0)
		{
			httpdEndRequest (server);
			continue;
		}
		else
		{
			httpdProcessRequest (server);
			httpdEndRequest (server);
		}
	}

	//if(needs_clean_up)
	embedded_mysql->deinitializeMYSQL ();
	return 0;
}
}
