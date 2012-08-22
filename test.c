#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "mysql.h"

MYSQL *mysql;
MYSQL_RES *results;
MYSQL_ROW record;
// break my_error.c:88, table.cc:697, my_lib.c:412
static char *server_options[] = \
  { "mysql_test", 
    "--defaults-file=my.init", 
    "--debug", 
    "--core-file=1",
    NULL };

int num_elements = (sizeof(server_options) / sizeof(char *)) - 1;

static char *server_groups[] = { "server",
                                 "client", NULL };

int main(void)
{
   printf("1\n");
   mysql_library_init(num_elements, server_options, server_groups);
   printf("1.1.1\n");
   mysql = mysql_init(NULL);
   printf("1.1\n");
   if (mysql) {
     mysql_options(mysql, MYSQL_READ_DEFAULT_GROUP, "libmysqld_client");
     mysql_options(mysql, MYSQL_OPT_USE_EMBEDDED_CONNECTION, NULL);

     mysql_real_connect(mysql, NULL,NULL,NULL, "database1", 0,NULL,0);
     printf("2\n");

     mysql_query(mysql, "explain SELECT 2 FROM dual");

     results = mysql_store_result(mysql);

     if (results) {
       while((record = mysql_fetch_row(results))) {
         printf("%s - %s \n", record[0], record[1]);
       }
       mysql_free_result(results);
     } else {
       printf("Could not get any results\n");
     }
     mysql_close(mysql);
     mysql_library_end();

     return 0;
   } else {
     printf("mysql was never inited succesfully\n");
     return -1;
   }
}
