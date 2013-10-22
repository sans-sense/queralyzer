#ifdef USE_PRAGMA_IMPLEMENTATION
#pragma implementation				// gcc: Class implementation
#endif

#define MYSQL_SERVER 1

#include "sql_priv.h"
#include "unireg.h"
#include "probes_mysql.h"
#include "ha_analysisengine.h"
#include "sql_class.h"                          // THD, SYSTEM_THREAD_SLAVE_SQL
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/un.h>
#include <string>
#include <pthread.h>
#include <map>
#include "../src/meta_data.cc"

#define ADDRESS     "/tmp/queralyzer.sock"	/* addr to connect */

/* Static declarations for handlerton */

static bool is_slave_applier(THD *thd)
{
  return thd->system_thread == SYSTEM_THREAD_SLAVE_SQL ||
    thd->system_thread == SYSTEM_THREAD_SLAVE_WORKER;
}


static handler *analysisengine_create_handler(handlerton *hton,
                                         TABLE_SHARE *table,
                                         MEM_ROOT *mem_root)
{
  return new (mem_root) analysisengine(hton, table);
}


/* Static declarations for shared structures */

static mysql_mutex_t analysisengine_mutex;
static HASH analysisengine_open_tables;

static st_analysisengine_share *get_share(const char *table_name);
static void free_share(st_analysisengine_share *share);
void *queralyzer_accept_connection(void *ptr);
std::multimap<std::string, TableMetaData *> meta_data_multimap;

int queralyzer_msg_server()
{
    /* ToDo: for now it is table meta data only not index meta data, 
     * It would be nice to merge them both and use as single meta data,
     * the key is always the table name.
     */
    pthread_t thread1;
    pthread_attr_t *attr=NULL;
    int *arg=NULL;
    int s, ns, len;
    struct sockaddr_un saun, fsaun;
    struct sockaddr *sa, *fsa;
    arg = (int*)malloc(sizeof(int));
    /*
     * Get a socket to work with.  This socket
     * will be in the UNIX domain, and will be a
     * stream socket.
     */
    if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
    {
	perror("server: socket");
	return -1;
    }

    saun.sun_family = AF_UNIX;
    strcpy(saun.sun_path, ADDRESS);

    unlink(ADDRESS);
    len = sizeof(saun.sun_family) + strlen(saun.sun_path);
    sa = (struct sockaddr*)&saun;
    if (bind(s, sa, len) < 0)
    {
	perror("server: bind");
	return -1;
    }

    if (listen(s, 5) < 0)
    {
	perror("server: listen");
	return -1;
    }
    *arg=s;
    pthread_create(&thread1 , attr, queralyzer_accept_connection, (void*) arg);
}
void *queralyzer_accept_connection(void *ptr)
{
    /*
     * Accept connections. When we accept one, ns
     * will be connected to the client. fsaun will
     * contain the address of the client.
     */
    int ns, fromlen;
    int socket_sd;
    struct sockaddr_un *fsaun;
    struct sockaddr *fsa;
    void *buf;
    FILE *fp;
    socket_sd=*((int*)ptr);
    buf = (char*) malloc(sizeof(char)*4096);
    for ( ; ; )
    {
        fsa = (struct sockaddr*)&fsaun;
        //length = (struct socklen_t)fromlen;
        if ((ns = accept(socket_sd, fsa,(socklen_t*) &fromlen)) < 0)
        {
        	perror("server: accept");
                close(socket_sd);
                continue;
                //return;
        }
        fp = fdopen(ns, "r");
        recv(ns, buf, 4096, MSG_WAITALL);
        /* terminate it with null character, just a safety measure, 
         * we don't expect it to cross it, anyways.
         */
        ((char*)buf)[4095]='\0';
        printf("Read from scoket: %s\n", (char*) buf);
        std::string table_json_input = (char*)buf;
        meta_data_multimap.clear();
        deserializeMap(meta_data_multimap, table_json_input);
    }

    close(socket_sd);
    //return 0;
}


/*****************************************************************************
** ANALYSISENGINE tables
*****************************************************************************/

analysisengine::analysisengine(handlerton *hton,
                           TABLE_SHARE *table_arg)
  :handler(hton, table_arg)
{}


static const char *analysisengine_exts[] = {
  NullS
};

const char **analysisengine::bas_ext() const
{
  return analysisengine_exts;
}

int analysisengine::open(const char *name, int mode, uint test_if_locked)
{
  DBUG_ENTER("analysisengine::open");
  //printf("fn: analysisengine::open\n");
  if (!(share= get_share(name)))
    DBUG_RETURN(HA_ERR_OUT_OF_MEM);

  thr_lock_data_init(&share->lock, &lock, NULL);
  DBUG_RETURN(0);
}

int analysisengine::close(void)
{
  DBUG_ENTER("analysisengine::close");
  free_share(share);
  DBUG_RETURN(0);
}

int analysisengine::create(const char *name, TABLE *table_arg,
                         HA_CREATE_INFO *create_info)
{
  DBUG_ENTER("analysisengine::create");
  //printf("fn: analysisengine::create\n");
  DBUG_RETURN(0);
}

/*
  Intended to support partitioning.
  Allows a particular partition to be truncated.
*/
int analysisengine::truncate()
{
  DBUG_ENTER("analysisengine::truncate");
  DBUG_RETURN(0);
}

const char *analysisengine::index_type(uint key_number)
{
  DBUG_ENTER("analysisengine::index_type");
  DBUG_RETURN((table_share->key_info[key_number].flags & HA_FULLTEXT) ? 
              "FULLTEXT" :
              (table_share->key_info[key_number].flags & HA_SPATIAL) ?
              "SPATIAL" :
              (table_share->key_info[key_number].algorithm ==
               HA_KEY_ALG_RTREE) ? "RTREE" : "BTREE");
}

int analysisengine::write_row(uchar * buf)
{
  DBUG_ENTER("analysisengine::write_row");
  ha_statistic_increment(&SSV::ha_write_count);
  DBUG_RETURN(table->next_number_field ? update_auto_increment() : 0);
}

int analysisengine::update_row(const uchar *old_data, uchar *new_data)
{
  DBUG_ENTER("analysisengine::update_row");
  THD *thd= ha_thd();
  //if (thd->system_thread == SYSTEM_THREAD_SLAVE_SQL && thd->query() == NULL)
 if (is_slave_applier(thd) && thd->query() == NULL)
    DBUG_RETURN(0);
  DBUG_RETURN(HA_ERR_WRONG_COMMAND);
}

int analysisengine::delete_row(const uchar *buf)
{
  DBUG_ENTER("analysisengine::delete_row");
  THD *thd= ha_thd();
  ha_statistic_increment(&SSV::ha_delete_count);
  //if (thd->system_thread == SYSTEM_THREAD_SLAVE_SQL && thd->query() == NULL)
 if (is_slave_applier(thd) && thd->query() == NULL)
    DBUG_RETURN(0);
  DBUG_RETURN(HA_ERR_WRONG_COMMAND);
}

void analysisengine::set_buffer(uchar* buf, const uchar *value)
{
  /* Let's set all columns as nullable and some default value for them.
   */
  int column_no=0;
  //if(value[0] == 1)
  {
    buf[0]=(uchar)0;
    for (int bit=1; bit<=share->column_count; bit++)
    {
      buf[0] |= (1<<bit); //setting nullable bits for all the columns
    }
    buf[0]=~buf[0];
  }
    
  for (column_no=0; column_no<share->column_count; column_no++)
  {
    /*int byte=0;
    while(byte<sizeof(int))
    {
        int x = (value >> (8*byte)) & 0xff;
        buf[4*(column_no)+1+byte]=(uchar)x;
        byte++;
    }*/
    int i=0;
    while(value[i]!='\0')
    {
        buf[4*(column_no)+1+i]=value[i];
        i++;
    }
    while(i<sizeof(int))
    {
      buf[4*(column_no)+1+i]='\0';
      i++;
    }
  }
  buf[4*(column_no)+1]='\0';

  return;
}

int analysisengine::rnd_init(bool scan)
{
  DBUG_ENTER("analysisengine::rnd_init");
  DBUG_RETURN(0);
}


int analysisengine::rnd_next(uchar *buf)
{
  int rc;
  DBUG_ENTER("analysisengine::rnd_next");
  MYSQL_READ_ROW_START(table_share->db.str, table_share->table_name.str,
                       TRUE);
  THD *thd= ha_thd();
  //if (thd->system_thread == SYSTEM_THREAD_SLAVE_SQL && thd->query() == NULL)
/* if (is_slave_applier(thd) && thd->query() == NULL)
    rc= 0;
  else
    rc= HA_ERR_END_OF_FILE;
    */
  MYSQL_READ_ROW_DONE(rc);
  uchar value=1;
  set_buffer(buf, &value);
  rc=0;
  table->status= rc ? STATUS_NOT_FOUND : 0;
  DBUG_RETURN(rc);
}


int analysisengine::rnd_pos(uchar * buf, uchar *pos)
{
  DBUG_ENTER("analysisengine::rnd_pos");
  MYSQL_READ_ROW_START(table_share->db.str, table_share->table_name.str,
                       FALSE);
  DBUG_ASSERT(0);
  MYSQL_READ_ROW_DONE(0);
  DBUG_RETURN(0);
}


void analysisengine::position(const uchar *record)
{
  DBUG_ENTER("analysisengine::position");
  DBUG_ASSERT(0);
  DBUG_VOID_RETURN;
}


int analysisengine::info(uint flag)
{
  DBUG_ENTER("analysisengine::info");
  //printf("fn:A analysisengine::info\n");

  memset(&stats, 0, sizeof(stats));
  std::multimap<std::string, TableMetaData *>::iterator metaDataMultiMap_it;
  /* share->table_name contains the complete path of the respective frm file.
   * Need to trim it, to get table name.
   */
  char *last_occu_of_slash = strrchr(share->table_name, '/');
  if (last_occu_of_slash == NULL)
  {
      //ToDo: error out
      
  }
  char table_name[40]; //not expecting table name to be greater than this;
  strcpy(table_name, last_occu_of_slash+1);
  
  metaDataMultiMap_it=meta_data_multimap.find(table_name);

  if(metaDataMultiMap_it != meta_data_multimap.end())
  {
      TableMetaData *table_data=metaDataMultiMap_it->second;
      share->row_count=table_data->rowCount;
      share->column_count=table_data->columnCount;
  }
  else
  {
    share->row_count=0; 
  }
  if (flag & HA_STATUS_VARIABLE)
  {
  //printf("fn:B analysisengine::info\n");
    //stats.records=3;
    //stats.deleted=0;
    stats.records=share->row_count;
  }
  stats.data_file_length=(stats.records) * ((share->column_count) * (sizeof(int))+1);
  stats.block_size=1024;//MyIsam Default
  stats.index_file_length=0;
  if (flag & HA_STATUS_AUTO)
    stats.auto_increment_value= 1;
  DBUG_RETURN(0);
}

int analysisengine::external_lock(THD *thd, int lock_type)
{
  DBUG_ENTER("analysisengine::external_lock");
  DBUG_RETURN(0);
}


THR_LOCK_DATA **analysisengine::store_lock(THD *thd,
                                         THR_LOCK_DATA **to,
                                         enum thr_lock_type lock_type)
{
  DBUG_ENTER("analysisengine::store_lock");
  if (lock_type != TL_IGNORE && lock.type == TL_UNLOCK)
  {
    /*
      Here is where we get into the guts of a row level lock.
      If TL_UNLOCK is set
      If we are not doing a LOCK TABLE or DISCARD/IMPORT
      TABLESPACE, then allow multiple writers
    */

    if ((lock_type >= TL_WRITE_CONCURRENT_INSERT &&
         lock_type <= TL_WRITE) && !thd_in_lock_tables(thd)
        && !thd_tablespace_op(thd))
      lock_type = TL_WRITE_ALLOW_WRITE;

    /*
      In queries of type INSERT INTO t1 SELECT ... FROM t2 ...
      MySQL would use the lock TL_READ_NO_INSERT on t2, and that
      would conflict with TL_WRITE_ALLOW_WRITE, blocking all inserts
      to t2. Convert the lock to a normal read lock to allow
      concurrent inserts to t2.
    */

    if (lock_type == TL_READ_NO_INSERT && !thd_in_lock_tables(thd))
      lock_type = TL_READ;

    lock.type= lock_type;
  }
  *to++= &lock;
  DBUG_RETURN(to);
}


int analysisengine::index_read_map(uchar * buf, const uchar * key,
                                 key_part_map keypart_map,
                             enum ha_rkey_function find_flag)
{
  int rc;
  DBUG_ENTER("analysisengine::index_read");
  MYSQL_INDEX_READ_ROW_START(table_share->db.str, table_share->table_name.str);
  THD *thd= ha_thd();
  //if (thd->system_thread == SYSTEM_THREAD_SLAVE_SQL && thd->query() == NULL)
 /*if (is_slave_applier(thd) && thd->query() == NULL)
    rc= 0;
 // else
    rc= HA_ERR_END_OF_FILE;
    */
  //int value=(int)key[0];
  set_buffer(buf,key);
  rc=0;
  MYSQL_INDEX_READ_ROW_DONE(rc);
  table->status= rc ? STATUS_NOT_FOUND : 0;
  DBUG_RETURN(rc);
}


int analysisengine::index_read_idx_map(uchar * buf, uint idx, const uchar * key,
                                 key_part_map keypart_map,
                                 enum ha_rkey_function find_flag)
{
  int rc;
  DBUG_ENTER("analysisengine::index_read_idx");
  MYSQL_INDEX_READ_ROW_START(table_share->db.str, table_share->table_name.str);
  THD *thd= ha_thd();
  //if (thd->system_thread == SYSTEM_THREAD_SLAVE_SQL && thd->query() == NULL)
  /*if (is_slave_applier(thd) && thd->query() == NULL)
    rc= 0;
  //else
    rc= HA_ERR_END_OF_FILE;
    */
  //int value=(int)(key[0]);
  set_buffer(buf,key);
  rc=0;
  MYSQL_INDEX_READ_ROW_DONE(rc);
  table->status= rc ? STATUS_NOT_FOUND : 0;
  DBUG_RETURN(rc);
}


int analysisengine::index_read_last_map(uchar * buf, const uchar * key,
                                      key_part_map keypart_map)
{
  int rc;
  DBUG_ENTER("analysisengine::index_read_last");
  MYSQL_INDEX_READ_ROW_START(table_share->db.str, table_share->table_name.str);
  THD *thd= ha_thd();
  //if (thd->system_thread == SYSTEM_THREAD_SLAVE_SQL && thd->query() == NULL)
/*  if (is_slave_applier(thd) && thd->query() == NULL)
    rc= 0;
  else
    rc= HA_ERR_END_OF_FILE;
    */
  //int value=(int)(key[0]);
  set_buffer(buf,key);
  rc=0;
  MYSQL_INDEX_READ_ROW_DONE(rc);
  table->status= rc ? STATUS_NOT_FOUND : 0;
  DBUG_RETURN(rc);
}


int analysisengine::index_next(uchar * buf)
{
  int rc;
  DBUG_ENTER("analysisengine::index_next");
  MYSQL_INDEX_READ_ROW_START(table_share->db.str, table_share->table_name.str);
  //rc= HA_ERR_END_OF_FILE;
  uchar value=1;
  set_buffer(buf,&value);
  rc=0;

  MYSQL_INDEX_READ_ROW_DONE(rc);
  table->status= STATUS_NOT_FOUND;
  DBUG_RETURN(rc);
}


int analysisengine::index_prev(uchar * buf)
{
  int rc;
  DBUG_ENTER("analysisengine::index_prev");
  MYSQL_INDEX_READ_ROW_START(table_share->db.str, table_share->table_name.str);
  rc= HA_ERR_END_OF_FILE;
  uchar value=1;
  set_buffer(buf,&value);
  rc=0;
  MYSQL_INDEX_READ_ROW_DONE(rc);
  table->status= STATUS_NOT_FOUND;
  DBUG_RETURN(rc);
}


int analysisengine::index_first(uchar * buf)
{
  int rc;
  DBUG_ENTER("analysisengine::index_first");
  MYSQL_INDEX_READ_ROW_START(table_share->db.str, table_share->table_name.str);
  rc= HA_ERR_END_OF_FILE;
  uchar value=1;
  set_buffer(buf,&value);
  rc=0;
  MYSQL_INDEX_READ_ROW_DONE(rc);
  table->status= STATUS_NOT_FOUND;
  DBUG_RETURN(rc);
}


int analysisengine::index_last(uchar * buf)
{
  int rc;
  DBUG_ENTER("analysisengine::index_last");
  MYSQL_INDEX_READ_ROW_START(table_share->db.str, table_share->table_name.str);
  rc= HA_ERR_END_OF_FILE;
  uchar value=1;
  set_buffer(buf,&value);
  rc=0;
  MYSQL_INDEX_READ_ROW_DONE(rc);
  table->status= STATUS_NOT_FOUND;
  DBUG_RETURN(rc);
}

/*int analysisengine::index_read_idx_map(uchar * buf, uint idx, const uchar * key,
                         key_part_map keypart_map,
                         enum ha_rkey_function find_flag)
{
    return 0;
}*/


static st_analysisengine_share *get_share(const char *table_name)
{
  st_analysisengine_share *share;
  uint length;
  std::multimap<std::string, TableMetaData *>::iterator metaDataMultiMap_it;

  length= (uint) strlen(table_name);
  mysql_mutex_lock(&analysisengine_mutex);
    
  if (!(share= (st_analysisengine_share*)
        my_hash_search(&analysisengine_open_tables,
                       (uchar*) table_name, length)))
  {
    if (!(share= (st_analysisengine_share*) my_malloc(sizeof(st_analysisengine_share) +
                                                 length,
                                                 MYF(MY_WME | MY_ZEROFILL))))
    {
      goto error;
    }

    share->table_name_length= length;
    share->table_name= (char*) malloc(sizeof(char)*(length+1));
    strmov(share->table_name, table_name);
    
    if (my_hash_insert(&analysisengine_open_tables, (uchar*) share))
    {
      my_free(share);
      share= NULL;
      goto error;
    }
    
    thr_lock_init(&share->lock);
  }
  metaDataMultiMap_it=meta_data_multimap.find(table_name);

  if(metaDataMultiMap_it != meta_data_multimap.end())
  {
      TableMetaData *table_data=metaDataMultiMap_it->second;
      share->row_count=table_data->rowCount;
      share->column_count=table_data->columnCount;
  }
  else
  {
    share->row_count=0; //ToDo: should error out.
  }
  share->use_count++;
  //share->row_count = 2; //default
  //share->column_count = 0; //default
error:
  mysql_mutex_unlock(&analysisengine_mutex);
  return share;
}

static void free_share(st_analysisengine_share *share)
{
  mysql_mutex_lock(&analysisengine_mutex);
  if (!--share->use_count)
    my_hash_delete(&analysisengine_open_tables, (uchar*) share);
  mysql_mutex_unlock(&analysisengine_mutex);
}

static void analysisengine_free_key(st_analysisengine_share *share)
{
  thr_lock_delete(&share->lock);
  my_free(share);
}

static uchar* analysisengine_get_key(st_analysisengine_share *share, size_t *length,
                                my_bool not_used __attribute__((unused)))
{
  *length= share->table_name_length;
  return (uchar*) share->table_name;
}

#ifdef HAVE_PSI_INTERFACE
static PSI_mutex_key bh_key_mutex_analysisengine;

static PSI_mutex_info all_analysisengine_mutexes[]=
{
  { &bh_key_mutex_analysisengine, "analysisengine", PSI_FLAG_GLOBAL}
};

void init_analysisengine_psi_keys()
{
  const char* category= "analysisengine";
  int count;

  /*if (PSI_server == NULL)
    return;
*/
  count= array_elements(all_analysisengine_mutexes);
  //PSI_server->register_mutex(category, all_analysisengine_mutexes, count);
  mysql_mutex_register(category, all_analysisengine_mutexes, count);

}
#endif

static int analysisengine_init(void *p)
{
  handlerton *analysisengine_hton;

#ifdef HAVE_PSI_INTERFACE
  init_analysisengine_psi_keys();
#endif

  analysisengine_hton= (handlerton *)p;
  analysisengine_hton->state= SHOW_OPTION_YES;
  analysisengine_hton->db_type= DB_TYPE_UNKNOWN;
  analysisengine_hton->create= analysisengine_create_handler;
  analysisengine_hton->flags= HTON_CAN_RECREATE;

  printf("initializes the analysisengine\n");

  mysql_mutex_init(bh_key_mutex_analysisengine,
                   &analysisengine_mutex, MY_MUTEX_INIT_FAST);
  (void) my_hash_init(&analysisengine_open_tables, system_charset_info,32,0,0,
                      (my_hash_get_key) analysisengine_get_key,
                      (my_hash_free_key) analysisengine_free_key, 0);

  /* start the message server used for receiving the data from queralyzer */
  queralyzer_msg_server();

  return 0;
}

static int analysisengine_fini(void *p)
{
  my_hash_free(&analysisengine_open_tables);
  mysql_mutex_destroy(&analysisengine_mutex);

  return 0;
}


struct st_mysql_storage_engine analysisengine_storage_engine=
{ MYSQL_HANDLERTON_INTERFACE_VERSION };

mysql_declare_plugin(analysisengine)
{
  MYSQL_STORAGE_ENGINE_PLUGIN,
  &analysisengine_storage_engine,
  "ANALYSISENGINE",
  "MySQL AB",
  "/dev/null storage engine (anything you write to it disappears)",
  PLUGIN_LICENSE_GPL,
  analysisengine_init, /* Plugin Init */
  analysisengine_fini, /* Plugin Deinit */
  0x0100 /* 1.0 */,
  NULL,                       /* status variables                */
  NULL,                       /* system variables                */
  NULL,                       /* config options                  */
  0,                          /* flags                           */
}
mysql_declare_plugin_end;

