#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <stdlib.h>
#define QUERY_BUFFER_LENGTH 4096
using namespace std;
extern int queralyzer_parser(const char* str, vector<string> *queries);
/*TODO */
int main()
{
	vector<string> queries;
	vector<string>::iterator queries_it;
	int parserResult = 1;
	const int command_fd = 0;//stdin
	FILE* command_pipe = fdopen(command_fd, "rb");
	
	if (!command_pipe) {
		perror("fdopen(command_fd)");
		return 1;
	}
	setlinebuf(command_pipe);
	char input_buffer[QUERY_BUFFER_LENGTH];
	cout<<"Type your query and hit enter, and check the file 'intermediate_create_queries'"<<endl;
	fgets(input_buffer, sizeof(input_buffer), command_pipe);
        parserResult= queralyzer_parser(input_buffer, &queries);
	if (parserResult)
	{
		cout<<"Problem while parsing, erroring out"<<endl;
		exit(1);
	}
        ofstream createQueryFile("intermediate_create_queries", ios::out);
        if(!createQueryFile)
        {
                cout<<"Error while opening the file for writing intermediate create queries"<<endl;
                exit(1);
        }
        for(queries_it=queries.begin(); queries_it!=queries.end(); ++queries_it)
        {
		createQueryFile<<*queries_it<<endl;
                //cout<<*queries_it<<endl;
        }

        createQueryFile.close();
	
/*  int runParser=1;
  runParser = system("parser/q_yacc");
  if(runParser)
  {
        printf("Some problem with the parser\n");
        exit(1);
  }     
*/
  /* this code needs to be integrated */
/*  FILE *createQuery = fopen("parser/intermediate_create_queries", "r");
  if(!createQuery)
  {
        printf("Some problem with reading the intermediate_create_queries file\n");
        exit(1);
  }     

  char queryBuffer[QUERY_BUFFER_LENGTH];
  while(fgets(queryBuffer, sizeof(queryBuffer), createQuery))
  {
        printf("%s\n", queryBuffer);
        run_query(mysql, queryBuffer);
        display_results();

  }     

  fclose(createQuery);
*/

	return parserResult;

}
