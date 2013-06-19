#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <fstream>
#include <stdlib.h>
#include "../meta_data.h"
#define QUERY_BUFFER_LENGTH 4096
using namespace std;
extern int queralyzer_parser (const char *queryBuffer,
		std::vector <std::string> &createTablesVector,
		std::map<std::string, TableMetaData*> &tableData,
		std::map<std::string, IndexMetaData*> &indexData);


/*TODO */
int
main ()
{
	std::map<std::string, TableMetaData*> tableData;
	std::map<std::string, IndexMetaData*> indexData;
	vector < string > table_vector;
	vector < string >::iterator table_vector_it;
	int parserResult = 1;
	const int command_fd = 0;	//stdin
	FILE *command_pipe = fdopen (command_fd, "rb");

	if (!command_pipe)
	{
		perror ("fdopen(command_fd)");
		return 1;
	}
	setlinebuf (command_pipe);
	char input_buffer[QUERY_BUFFER_LENGTH];
	cout <<
			"Type your query and hit enter, and check the file 'intermediate_create_queries'"
			<< endl;
	fgets (input_buffer, sizeof (input_buffer), command_pipe);
	parserResult = queralyzer_parser (input_buffer, table_vector, tableData, indexData);
	if (parserResult)
	{
		cout << "Problem while parsing, erroring out" << endl;
		exit (1);
	}
	ofstream createQueryFile ("intermediate_create_queries", ios::out);
	if (!createQueryFile)
	{
		cout <<"Error while opening the file for writing intermediate create table_vector"<< endl;
		exit (1);
	}
	for (table_vector_it = table_vector.begin (); table_vector_it != table_vector.end ();)
	{
			std::string table_name = *table_vector_it;

			TableMetaData *table_found = NULL;
			table_found = tableData[table_name];
			
			if(table_found == NULL)
			{
				cout<<"ERROR while searching the table in table map"<<endl;
				exit(1);
			}
			int column_count = table_found->columnCount;
			string create_query;
                        create_query = "create table if not exists ";
                        create_query += table_found->tableName;
                        create_query += " ( ";
			while(column_count!=0)
			{
                        	create_query += table_found->tableColumns[column_count-1];
                                create_query += " int";
                                if(column_count>1)
                                {
                                        create_query += ",";
                                }
                                column_count -= 1;
			}
                        create_query += " ) engine=qa_blackhole;\n";


		createQueryFile << create_query << endl;
		//cout<<create_table_vector<<endl;
		table_vector_it = table_vector.erase (table_vector_it);
	}

	createQueryFile.close ();
	return parserResult;

}
