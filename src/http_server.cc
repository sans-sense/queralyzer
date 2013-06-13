#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string.h>
#include <httpd.h>
#include "query.h"
#include "meta_data.h"

extern "C"
{
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

    if (!(query->parseQuery ()) && !(query->initialiseQueryExecution ()))
      {
	if (!query->executeQuery ())
	  {
	    std::string mysql_json_output;
	    query->getQueryOutput (mysql_json_output);
	    httpdPrintf (server, "%s\n", mysql_json_output.c_str ());
	    std::cout << mysql_json_output << std::endl;
	  }
	else
	  {
	    httpdSetResponse (server, "403 Forbidden");
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
	std::cout << getTableDataString << std::endl;
      }
    else if (!strcmp (httpdRequestMethodName (server), "POST"))
      {
	httpVar *updateString;
	updateString = httpdGetVariableByName (server, "tablemetadata");
	if (updateString == NULL)
	  {
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
    httpdAddFileContent (server, "/", "index.html", HTTP_TRUE, NULL,
			 "index.html");
    httpdAddWildcardContent (server, "/css", NULL, "css");
    httpdAddWildcardContent (server, "/img", NULL, "img");
    httpdAddWildcardContent (server, "/js", NULL, "js");
    httpdAddWildcardContent (server, "/js/lib", NULL, "js/lib");
    httpdAddWildcardContent (server, "/bootstrap", NULL, "bootstrap");
    httpdAddWildcardContent (server, "/bootstrap/css", NULL, "bootstrap/css");
    httpdAddWildcardContent (server, "/bootstrap/img", NULL, "bootstrap/img");
    httpdAddWildcardContent (server, "/bootstrap/js", NULL, "bootstrap/js");
    httpdAddCContent (server, "/", "query", HTTP_TRUE, NULL, query_html);
    httpdAddCContent (server, "/", "tablemetadata", HTTP_TRUE, NULL,
		      table_data_html);
    httpdAddCContent (server, "/", "indexmetadata", HTTP_TRUE, NULL,
		      index_data_html);
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
