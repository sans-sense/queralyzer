#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "mysql.h"
#include <dlfcn.h>
#include <vector>
#include <string>

#define QUERY_BUFFER_LENGTH 4096
int queralyzer_parser(const char * str, std::vector<std::string> *create_queries);

MYSQL *mysql;
MYSQL_RES *results;
MYSQL_ROW row, end_row;
MYSQL_FIELD *field;

// break my_error.c:88, table.cc:697, my_lib.c:412
static char *server_options[] = \
  { "mysql_test", 
    "--defaults-file=my.init", 
    NULL };

int num_elements = (sizeof(server_options) / sizeof(char *)) - 1;

static char *server_groups[] = { "server",
                                 "client", NULL };


int run_query(MYSQL *mysql, const char *query);

// starts the embedded mode mysql server
int initialize_mysql();

int close_mysql();

int display_results();

int main() {
  using namespace std;
  const int command_fd = 0;//stdin
  const int response_fd = 1;//stdout
  int needsCleanup = 0;
  FILE* command_pipe = fdopen(command_fd, "rb");

  if (!command_pipe) {
    perror("fdopen(command_fd)");
    return 1;
  }
  setlinebuf(command_pipe);

  FILE* response_pipe = fdopen(response_fd, "wb");
  if (!response_pipe) {
    perror("fdopen(response_fd)");
    return 1;
  }
 setlinebuf(response_pipe);

  needsCleanup = initialize_mysql();

  char buf[QUERY_BUFFER_LENGTH];
  char strquit[] = "quit\n";
  printf("Type your query and hit enter, type 'quit' to end the session, test_aps is the default table\n");

  vector<string> create_queries;
  vector<string>::iterator create_queries_it;
  while (fgets(buf, sizeof(buf), command_pipe))
  {
	  if(strcmp(buf,strquit) == 0)
	  {
		break;	  
	  }
	  else
	  {
                  //print the input
                  if (fputs(buf, response_pipe) < 0) 
		  {
                          perror("CHILD> fputs");
                        break;
                  } 
	   	  else 
		  {
			if(queralyzer_parser(buf, &create_queries))
			{
				printf("Error while parsing\n");
				exit(1);
			}

			for (create_queries_it=create_queries.begin(); create_queries_it!=create_queries.end(); ++create_queries_it)
			{
				char create_query[QUERY_BUFFER_LENGTH];
				strcpy(create_query, (*create_queries_it).c_str());
				printf("%s\n", create_query);
				run_query(mysql, create_query);
				display_results();
			}
          	        run_query(mysql, buf);
	                display_results();
          	  }
	  }
	  fflush(response_pipe);
  }

  fclose(command_pipe);
  fclose(response_pipe);
  if (needsCleanup) {
    close_mysql();
  }
  return 0;
};


int initialize_mysql()
{
   mysql_library_init(num_elements, server_options, server_groups);
   mysql = mysql_init(NULL);
   if (mysql) {
     mysql_options(mysql, MYSQL_READ_DEFAULT_GROUP, "libmysqld_client");
     mysql_options(mysql, MYSQL_OPT_USE_EMBEDDED_CONNECTION, NULL);

     if (!mysql_real_connect(mysql, NULL,NULL,NULL, "test", 0,NULL,0)) {
       printf("mysql_real_connect failed: %s \n", mysql_error(mysql));
       return -1;
     }

     if (run_query(mysql, "create table IF NOT EXISTS test_aps (id int primary key, name varchar(100))")) {
       return -1;
     }
     /* Parser_state ps; */
     /* char sql_stmt[] = "select * from nonexistent"; */
     /* int length = strlen(sql_stmt); */
     /* ps.init(mysql->thd, sql_stmt, length); */

     return 0;
   } else {
     printf("mysql was never inited succesfully\n");
     return -1;
   }
}

int run_query(MYSQL *mysql, const char *query) {
  if (mysql_query(mysql, query)) {
    printf("problems running %s , error %s \n", query, mysql_error(mysql));
    return 1;
  } else {
    return 0;
  }
}

/**
 * Displays results of the previously run query, unfortunately mysql is kinda global, 
 * so have to query it to get all details rather than parameter passing 
 */
int display_results() {
  // select or update based on the field count
  if (mysql_field_count(mysql) > 0) {
    int num_fields, i;
    results = mysql_store_result(mysql);
    
    // used to determine if the query returned any results
    if (results) {
      num_fields = mysql_num_fields(results);

      // print the columns
      for( i = 0; field = mysql_fetch_field(results), i < num_fields; i++) {
        printf("%s\t", field->name?field->name: "NULL"); 
      }
      printf("\n");

      // print the values
      while((row = mysql_fetch_row(results))) {
        for (end_row = row + num_fields; row < end_row; ++row) {
          printf("%s\t", row ? (char*)*row : "NULL"); 
        }
        printf("\n");
      }
      mysql_free_result(results);
      return 0;
    } else {
      printf("Could not get any results\n");
      return 1;
    }
  } else {
    // update/insert so only rows impacted count available
    printf("Affected rows: %lld\n", mysql_affected_rows(mysql));
    return 0;
  }
}

int close_mysql() {
     mysql_close(mysql);
     mysql_library_end();
     return 0;
}
