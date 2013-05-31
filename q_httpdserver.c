#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <httpd.h>
#include "jsonparser/q_MetaData.h"

int queralyzer(char * query, char** query_op);
int get_tableData(TableMetaData *tableData, int *tableCount);
int set_tableData(TableMetaData *tableData, int *tableCount);

extern "C"
{
void dummy_html(httpd *server)
{
	httpdPrintf(server, "Welcome to the httpd queralyzer");
	httpdPrintf(server, "<P><FORM ACTION=query METHOD=POST>\n");
	httpdPrintf(server, "Enter your query <INPUT NAME=query SIZE=4096>\n");
	httpdPrintf(server, "<INPUT TYPE=SUBMIT VALUE=Click!><P></FORM>\n" );
	return;	
}

void query_html(httpd *server)
{
	char*  query_op;
	httpVar *variable;
	/*
	** Grab the symbol table entry to see if the variable exists
	*/
	variable = httpdGetVariableByName(server, "query");
	if (variable == NULL)
	{
		httpdPrintf(server,"Missing form data!");
		return;
	}
	char *query =variable->value;
	queralyzer(query, &query_op);
	httpdPrintf(server, "%s\n", query_op);
	return;	
}
void table_data_html(httpd *server)
{
	TableMetaData *tableData = new TableMetaData[10]; //currently hard coded
	int tableCount=0;
	if (!strcmp(httpdRequestMethodName(server), "GET"))
	{
		std::string getTableDataString;
		get_tableData(tableData, &tableCount);
		if(tableData==NULL)
			return;
		
		for (int i=0; i<tableCount; i++)
		{
			std::string eachTable;	
			JsonSerializer::serialize(tableData+i, eachTable);
			getTableDataString+=eachTable;
			if(i<tableCount-1)
				getTableDataString+=",";
		}
		std::string output ="[";
		output+=getTableDataString;
		output+="]";
		std::cout<<output<<std::endl;
		httpdPrintf(server, "%s\n", output.c_str());
		
	}
	else if (!strcmp(httpdRequestMethodName(server), "POST"))
	{
		httpVar *updateString;
		updateString = httpdGetVariableByName(server, "tablemetadata");
		char *updateTableDataString = updateString->value;
		if (updateTableDataString == NULL)
		{
			httpdPrintf(server,"Missing table meta data information");
		}
		std::string updateTableData;
		updateTableData.copy(updateTableDataString, strlen(updateTableDataString));
		if(!JsonSerializer::deserialize(tableData, updateTableData))
		{
			httpdPrintf(server,"Problem with updating Table Meta Data");
		}
		else
		{	//to be implemented
			//set_tableData(tableData, 0);

			
		}
	}
	tableCount=0;
	delete [] tableData;
	return;
}

void index_data_html(httpd *server)
{
	httpdSetResponse(server,"501 Not Implemented");
	return;
}

int main( int argc, char *argv[])
{
	httpd *server;
	/*
	** Create a server and setup our logging
	*/
	server = httpdCreate(NULL,1234);
	if (server == NULL)
	{
	perror("Can't create server");
	exit(1);
	}
	httpdSetAccessLog(server, stdout);
	httpdSetErrorLog(server, stderr);
	/*
	** Setup some content for the server
	*/
	httpdAddCContent(server,"/", "dummy", HTTP_TRUE, NULL, dummy_html);
	httpdSetFileBase(server, "/home/prabinb/queralyzer/queralyzerUI/");
	httpdAddFileContent(server, "/", "index.html", HTTP_TRUE, NULL, "index.html" );
	httpdAddWildcardContent(server, "/css", NULL, "css");
	httpdAddWildcardContent(server, "/img", NULL, "img");
	httpdAddWildcardContent(server, "/js", NULL, "js");
	httpdAddWildcardContent(server, "/js/lib", NULL, "js/lib");
	httpdAddWildcardContent(server, "/bootstrap", NULL, "bootstrap");
	httpdAddWildcardContent(server, "/bootstrap/css", NULL, "bootstrap/css");
	httpdAddWildcardContent(server, "/bootstrap/img", NULL, "bootstrap/img");
	httpdAddWildcardContent(server, "/bootstrap/js", NULL, "bootstrap/js");
	httpdAddCContent(server,"/", "query", HTTP_TRUE, NULL, query_html);
	httpdAddCContent(server,"/", "tablemetadata", HTTP_TRUE, NULL, table_data_html);
	httpdAddCContent(server,"/", "indexmetadata", HTTP_TRUE, NULL, index_data_html);
	/*
	** Go into our service loop
	*/
	while(1 == 1)
	{
	if (httpdGetConnection(server, 0) < 0)
		continue;
	if(httpdReadRequest(server) < 0)
	{
		httpdEndRequest(server);
		continue;
	}
	else
 	{
		httpdProcessRequest(server);
		httpdEndRequest(server);
	}
	}
}
}
