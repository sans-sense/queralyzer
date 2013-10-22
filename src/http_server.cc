#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string.h>
#include <httpd.h>
#include "query.h"
#include "meta_data.h"
extern getParserErrorText();
extern "C"
{
    /*
     * This is a global object, for storing the query information. The
     * memory is being allocated inside query_html(). 
     */
    Query *query;
    Query *client_query;
    char *custom_error_messages[] = {
        // MYSQL errors
        "dummy_no_error",
        "Error, Mysql not initialized properly",
        "Error, while creating new tables",
        "Error, while running the input query",
        // Query Initialization and parsing
        "Error, during Query Initialization",
        "Error, while query parsing the input query",
        // IPC errors
        "Error, while sending data to the storage engine."
    };

    int display_error_if_any(int result, httpd * server)
    {
        if (result == 0)
            return result;
        httpdSetResponse(server, "500");
        printf("%s\n", custom_error_messages[result]);
        httpdPrintf(server, "%s\n", custom_error_messages[result]);
        return 1;
    }

    void dummy_html(httpd * server)
    {
        httpdPrintf(server, "Welcome to the httpd queralyzer");
        httpdPrintf(server, "<P><FORM ACTION=bypass_queralyzer METHOD=POST>\n");
        httpdPrintf(server, "Enter your query <INPUT NAME=c_query SIZE=4096>\n");
        httpdPrintf(server, "<INPUT TYPE=SUBMIT VALUE=Click!><P></FORM>\n");
        return;
    }

    void explain_json_html(httpd *server)
    {
        if (query == NULL)
        {
            printf("There is no existing query in backhand\n");
            httpdPrintf(server, "Missing form data!");
            return;
        }
        if (!query->explain_output_in_json.empty())
        {
            //httpdPrintf(server, query->explain_output_in_json.c_str());
            //replace the '<' and '>' in the string, which will be send to
            //client.
            char *cpJson = query->explain_output_in_json.c_str();
            int i=0;
            char c;
           /* while ((c=cpJson[i])!='\0'){
                if (c=='<'){
                    cpJson[i]='(';
                }
                else if(c=='>'){
                    cpJson[i]=')';
                }
                i++;
            }*/
            httpdOutput(server, query->explain_output_in_json.c_str());
            std::cout << query->explain_output_in_json << std::endl;
            return;
        }

        if (!display_error_if_any(query->parseQuery(), server))
        {
            if ((!display_error_if_any(query->initialiseQueryExecution(),
                            server))
                    && (!display_error_if_any(query->executeQuery(), server)))
            {
                std::string mysql_json_output;
                query->getQueryOutput(mysql_json_output);
                httpdPrintf(server, "%s\n", mysql_json_output.c_str());
               // httpdOutput(server, mysql_json_output.c_str());
                std::cout << mysql_json_output << std::endl;
            }
        }
        else
        {
            httpdPrintf(server, "%s\n", getParserErrorText());
        }
        return;
    }

    void optimizer_trace_html(httpd *server)
    {
        if (query == NULL)
        {
            printf("There is no existing query in backhand\n");
            httpdPrintf(server, "Missing form data!");
            return;
        }
        if (!query->optimizer_trace_in_json.empty())
        {
            char *cpJson = query->optimizer_trace_in_json.c_str();
            int i=0;
            char c;
            /*while ((c=cpJson[i])!='\0'){
                if (c=='<'){
                    cpJson[i]='(';
                }
                else if(c=='>'){
                    cpJson[i]=')';
                }
                i++;
            }*/
            httpdPrintf(server, query->optimizer_trace_in_json.c_str());
            std::cout << query->optimizer_trace_in_json << std::endl;
            return;
        }
    }

    void bypass_queralyzer_html(httpd *server)
    {
        httpVar *variable = httpdGetVariableByName(server, "c_query");
        if (variable == NULL)
        {
            httpdPrintf(server, "Missing form data!");
            return;
        }
        char *query_input = variable->value;
        httpdPrintf(server, query_input);
        //        client_query = new Query(query_input);
        //	if (client_query == NULL)
        //	    printf("Problem while creating Query object\n");
        EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance();
        MYSQL *mysql = embedded_mysql->getMYSQL();
        MYSQL_RES *results;
        MYSQL_ROW row, end_row;
        MYSQL_FIELD *field;

        if (mysql_query(mysql, query_input)) 
        {
            httpdPrintf(server, "problems running %s , error %s \n", query, mysql_error(mysql));
            return;
        }
        if (mysql_field_count(mysql) > 0) {
            int num_fields, i;
            results = mysql_store_result(mysql);

            // used to determine if the query returned any results
            if (results) {
                num_fields = mysql_num_fields(results);

                // print the columns
                for( i = 0; field = mysql_fetch_field(results), i < num_fields; i++) {
                    httpdPrintf(server, "%s\t", field->name?field->name: "NULL"); 
                }
                httpdPrintf(server, "\n");

                // print the values
                while((row = mysql_fetch_row(results))) {
                    for (end_row = row + num_fields; row < end_row; ++row) {
                        httpdPrintf(server, "%s\t", row ? (char*)*row : "NULL"); 
                    }
                    httpdPrintf(server, "\n");
                }
                mysql_free_result(results);
                return;
            } else {
                httpdPrintf(server, "Could not get any results\n");
                return;
            }
        } else {
            // update/insert so only rows impacted count available
            httpdPrintf(server, "Affected rows: %lld\n", mysql_affected_rows(mysql));
            return;
        }
        return;
    }

    void query_html(httpd * server)
    {
        char *query_op;
        httpVar *variable;

        variable = httpdGetVariableByName(server, "query");
        if (variable == NULL)
        {
            httpdPrintf(server, "Missing form data!");
            return;
        }
        char *query_input = variable->value;

        printf("%s\n", query_input);
        if (query != NULL)
        {
            delete query;
            query = NULL;
        }

        query = new Query(query_input);

        if (query == NULL)
            printf("Problem while creating Query object\n");

        if (!display_error_if_any(query->parseQuery(), server))
        {
            if ((!display_error_if_any(query->initialiseQueryExecution(),
                            server))
                    && (!display_error_if_any(query->executeQuery(), server)))
            {
                std::string mysql_json_output;
                query->getQueryOutput(mysql_json_output);
                httpdPrintf(server, "%s\n", mysql_json_output.c_str());
                std::cout << mysql_json_output << std::endl;
            }
        }
        else
        {
            httpdPrintf(server, "%s\n", getParserErrorText());
        }
        return;
    }
    void table_data_html(httpd * server)
    {

        EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance();

        if (!strcmp(httpdRequestMethodName(server), "GET"))
        {
            std::string getTableDataString;
            embedded_mysql->getTableMetaDataMYSQL(getTableDataString);
            httpdPrintf(server, "%s\n", getTableDataString.c_str());
            std::cout << getTableDataString << std::endl;
        }
        else if (!strcmp(httpdRequestMethodName(server), "POST"))
        {
            httpVar *updateString;

            updateString = httpdGetVariableByName(server, "tablemetadata");
            if (updateString == NULL)
            {
                httpdSetResponse(server, "500");
                httpdPrintf(server, "Missing form data!");
                return;
            }
            std::string updateTableDataString = updateString->value;
            std::cout << updateTableDataString << std::endl;
            if ((query)
                    &&
                    (!display_error_if_any(embedded_mysql->
                                           setTableMetaDataMYSQL(updateTableDataString), server))
                    && (!display_error_if_any(query->executeQuery(), server)))
            {
                std::string mysql_json_output;
                query->getQueryOutput(mysql_json_output);
                httpdPrintf(server, "%s\n", mysql_json_output.c_str());
                std::cout << mysql_json_output << std::endl;
            }
            // httpdPrintf(server, "UPDATE DONE"); // dummy
        }
        return;
    }

    void index_data_html(httpd * server)
    {
        EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance();

        if (!strcmp(httpdRequestMethodName(server), "GET"))
        {
            std::string getIndexDataString;
            embedded_mysql->getIndexMetaDataMYSQL(getIndexDataString);
            httpdPrintf(server, "%s\n", getIndexDataString.c_str());
            std::cout << getIndexDataString << std::endl;
        }
        else if (!strcmp(httpdRequestMethodName(server), "POST"))
        {
            httpVar *updateString;

            updateString = httpdGetVariableByName(server, "indexmetadata");
            if (updateString == NULL)
            {
                httpdSetResponse(server, "500");
                httpdPrintf(server, "Missing form data!");
                return;
            }
            std::string updateIndexDataString = updateString->value;
            std::cout << updateIndexDataString << std::endl;

            if ((query)
                    &&
                    (!display_error_if_any(embedded_mysql->
                                           setIndexMetaDataMYSQL(updateIndexDataString), server))
                    && (!display_error_if_any(query->executeQuery(), server)))
            {
                std::string mysql_json_output;
                query->getQueryOutput(mysql_json_output);
                httpdPrintf(server, "%s\n", mysql_json_output.c_str());
                std::cout << mysql_json_output << std::endl;
            }
            // httpdPrintf(server, "UPDATE DONE"); // dummy
        }
        return;
    }

    void table_alias_html(httpd * server)
    {
        EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance();
        std::string json_output;
        embedded_mysql->getTableAliasDataMYSQL(json_output);
        if (!strcmp(httpdRequestMethodName(server), "GET"))
        {
            httpdPrintf(server, "%s\n", json_output.c_str());
        }
        return;
    }

    void reset_html(httpd * server)
    {
        EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance();

        if (!strcmp(httpdRequestMethodName(server), "POST"))
        {
            embedded_mysql->resetMYSQL();
            httpdPrintf(server, "RESET DONE");	// dummy
        }
        return;
    }

    int main()
    {

        EmbeddedMYSQL *embedded_mysql = EmbeddedMYSQL::getInstance();

        embedded_mysql->initializeMYSQL();

        httpd *server;

        /*
         ** Create a server and setup our logging
         */
        server = httpdCreate(NULL, 4321);
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
        httpdAddCContent(server, "/", "dummy", HTTP_TRUE, NULL, dummy_html);
        httpdAddCContent(server, "/", "bypass_queralyzer", HTTP_TRUE, NULL, bypass_queralyzer_html);
        httpdSetFileBase(server, "../../queralyzerUI/");
        httpdAddFileContent(server, "/", "index.html", HTTP_TRUE, NULL, "index.html");
        httpdAddFileContent(server, "/", "Layout.html", HTTP_TRUE, NULL, "Layout.html");
        httpdAddWildcardContent(server, "/css", NULL, "css");
        httpdAddWildcardContent(server, "/data", NULL, "data");
        httpdAddWildcardContent(server, "/img", NULL, "img");
        httpdAddWildcardContent(server, "/js", NULL, "js");
        httpdAddWildcardContent(server, "/codemirror", NULL, "codemirror");
        httpdAddWildcardContent(server, "/js/lib", NULL, "js/lib");
        httpdAddWildcardContent(server, "/js/app", NULL, "js/app");
        httpdAddWildcardContent(server, "/bootstrap", NULL, "bootstrap");
        httpdAddWildcardContent(server, "/bootstrap/css", NULL, "bootstrap/css");
        httpdAddWildcardContent(server, "/bootstrap/img", NULL, "bootstrap/img");
        httpdAddWildcardContent(server, "/bootstrap/js", NULL, "bootstrap/js");
        httpdAddCContent(server, "/", "query", HTTP_TRUE, NULL, query_html);
        httpdAddCContent(server, "/", "explainjson", HTTP_TRUE, NULL, explain_json_html);
        httpdAddCContent(server, "/", "optimizertrace", HTTP_TRUE, NULL, optimizer_trace_html);
        httpdAddCContent(server, "/", "tablemetadata", HTTP_TRUE, NULL,
                table_data_html);
        httpdAddCContent(server, "/", "indexmetadata", HTTP_TRUE, NULL,
                index_data_html);
        httpdAddCContent(server, "/", "tablealiasdata", HTTP_TRUE, NULL,
                table_alias_html);
        httpdAddCContent(server, "/", "reset", HTTP_TRUE, NULL, reset_html);
        /*
         ** Go into our service loop
         */
        while (1 == 1)
        {
            if (httpdGetConnection(server, 0) < 0)
                continue;
            if (httpdReadRequest(server) < 0)
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

        // if(needs_clean_up)
        embedded_mysql->deinitializeMYSQL();
        return 0;
    }
}
