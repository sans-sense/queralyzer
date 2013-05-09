%{
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>
#include "q_table.h"
#define YYERROR_VERBOSE
using namespace std;
int yylex();
void yyerror(string s);
int queryCount=0;
extern int yydebug;
map<string, qTable*> qTableAliasMap;
map<string, qTable*>::iterator qTableAliasMap_it;
%}
%union {char *cptr; int val; qTable *qt; }
%token  END_QUERY 0 "end of line"
%token  ABORT_SYM                     /* INTERNAL (used in lex) */
%token  ACCESSIBLE_SYM
%token  ACTION                        /* SQL-2003-N */
%token  ADD                           /* SQL-2003-R */
%token  ADDDATE_SYM                   /* MYSQL-FUNC */
%token  AFTER_SYM                     /* SQL-2003-N */
%token  AGAINST
%token  AGGREGATE_SYM
%token  ALGORITHM_SYM
%token  ALL                           /* SQL-2003-R */
%token  ALTER                         /* SQL-2003-R */
%token  ANALYSE_SYM
%token  ANALYZE_SYM
%token  AND_AND_SYM                   /* OPERATOR */
%token  AND_SYM                       /* SQL-2003-R */
%token  ANY_SYM                       /* SQL-2003-R */
%token  AS                            /* SQL-2003-R */
%token  ASC                           /* SQL-2003-N */
%token  ASCII_SYM                     /* MYSQL-FUNC */
%token  ASENSITIVE_SYM                /* FUTURE-USE */
%token  AT_SYM                        /* SQL-2003-R */
%token  AUTOEXTEND_SIZE_SYM
%token  AUTO_INC
%token  AVG_ROW_LENGTH
%token  AVG_SYM                       /* SQL-2003-N */
%token  BACKUP_SYM
%token  BEFORE_SYM                    /* SQL-2003-N */
%token  BEGIN_SYM                     /* SQL-2003-R */
%token  BETWEEN_SYM                   /* SQL-2003-R */
%token  BIGINT                        /* SQL-2003-R */
%token  BINARY                        /* SQL-2003-R */
%token  BINLOG_SYM
%token  BIN_NUM
%token  BIT_AND                       /* MYSQL-FUNC */
%token  BIT_OR                        /* MYSQL-FUNC */
%token  BIT_SYM                       /* MYSQL-FUNC */
%token  BIT_XOR                       /* MYSQL-FUNC */
%token  BLOB_SYM                      /* SQL-2003-R */
%token  BLOCK_SYM
%token  BOOLEAN_SYM                   /* SQL-2003-R */
%token  BOOL_SYM
%token  BOTH                          /* SQL-2003-R */
%token  BTREE_SYM
%token  BY                            /* SQL-2003-R */
%token  BYTE_SYM
%token  CACHE_SYM
%token  CALL_SYM                      /* SQL-2003-R */
%token  CASCADE                       /* SQL-2003-N */
%token  CASCADED                      /* SQL-2003-R */
%token  CASE_SYM                      /* SQL-2003-R */
%token  CAST_SYM                      /* SQL-2003-R */
%token  CATALOG_NAME_SYM              /* SQL-2003-N */
%token  CHAIN_SYM                     /* SQL-2003-N */
%token  CHANGE
%token  CHANGED
%token  CHARSET
%token  CHAR_SYM                      /* SQL-2003-R */
%token  CHECKSUM_SYM
%token  CHECK_SYM                     /* SQL-2003-R */
%token  CIPHER_SYM
%token  CLASS_ORIGIN_SYM              /* SQL-2003-N */
%token  CLIENT_SYM
%token  CLOSE_SYM                     /* SQL-2003-R */
%token  COALESCE                      /* SQL-2003-N */
%token  CODE_SYM
%token  COLLATE_SYM                   /* SQL-2003-R */
%token  COLLATION_SYM                 /* SQL-2003-N */
%token  COLUMNS
%token  COLUMN_SYM                    /* SQL-2003-R */
%token  COLUMN_FORMAT_SYM
%token  COLUMN_NAME_SYM               /* SQL-2003-N */
%token  COMMENT_SYM
%token  COMMITTED_SYM                 /* SQL-2003-N */
%token  COMMIT_SYM                    /* SQL-2003-R */
%token  COMPACT_SYM
%token  COMPLETION_SYM
%token  COMPRESSED_SYM
%token  CONCURRENT
%token  CONDITION_SYM                 /* SQL-2003-R, SQL-2008-R */
%token  CONNECTION_SYM
%token  CONSISTENT_SYM
%token  CONSTRAINT                    /* SQL-2003-R */
%token  CONSTRAINT_CATALOG_SYM        /* SQL-2003-N */
%token  CONSTRAINT_NAME_SYM           /* SQL-2003-N */
%token  CONSTRAINT_SCHEMA_SYM         /* SQL-2003-N */
%token  CONTAINS_SYM                  /* SQL-2003-N */
%token  CONTEXT_SYM
%token  CONTINUE_SYM                  /* SQL-2003-R */
%token  CONVERT_SYM                   /* SQL-2003-N */
%token  COUNT_SYM                     /* SQL-2003-N */
%token  CPU_SYM
%token  CREATE                        /* SQL-2003-R */
%token  CROSS                         /* SQL-2003-R */
%token  CUBE_SYM                      /* SQL-2003-R */
%token  CURDATE                       /* MYSQL-FUNC */
%token  CURRENT_SYM                   /* SQL-2003-R */
%token  CURRENT_USER                  /* SQL-2003-R */
%token  CURSOR_SYM                    /* SQL-2003-R */
%token  CURSOR_NAME_SYM               /* SQL-2003-N */
%token  CURTIME                       /* MYSQL-FUNC */
%token  DATABASE
%token  DATABASES
%token  DATAFILE_SYM
%token  DATA_SYM                      /* SQL-2003-N */
%token  DATETIME
%token  DATE_ADD_INTERVAL             /* MYSQL-FUNC */
%token  DATE_SUB_INTERVAL             /* MYSQL-FUNC */
%token  DATE_SYM                      /* SQL-2003-R */
%token  DAY_HOUR_SYM
%token  DAY_MICROSECOND_SYM
%token  DAY_MINUTE_SYM
%token  DAY_SECOND_SYM
%token  DAY_SYM                       /* SQL-2003-R */
%token  DEALLOCATE_SYM                /* SQL-2003-R */
%token  DECIMAL_NUM
%token  DECIMAL_SYM                   /* SQL-2003-R */
%token  DECLARE_SYM                   /* SQL-2003-R */
%token  DEFAULT                       /* SQL-2003-R */
%token  DEFAULT_AUTH_SYM              /* INTERNAL */
%token  DEFINER_SYM
%token  DELAYED_SYM
%token  DELAY_KEY_WRITE_SYM
%token  DELETE_SYM                    /* SQL-2003-R */
%token  DESC                          /* SQL-2003-N */
%token  DESCRIBE                      /* SQL-2003-R */
%token  DES_KEY_FILE
%token  DETERMINISTIC_SYM             /* SQL-2003-R */
%token  DIAGNOSTICS_SYM               /* SQL-2003-N */
%token  DIRECTORY_SYM
%token  DISABLE_SYM
%token  DISCARD
%token  DISK_SYM
%token  DISTINCT                      /* SQL-2003-R */
%token  DIV_SYM
%token  DOUBLE_SYM                    /* SQL-2003-R */
%token  DO_SYM
%token  DROP                          /* SQL-2003-R */
%token  DUAL_SYM
%token  DUMPFILE
%token  DUPLICATE_SYM
%token  DYNAMIC_SYM                   /* SQL-2003-R */
%token  EACH_SYM                      /* SQL-2003-R */
%token  ELSE                          /* SQL-2003-R */
%token  ELSEIF_SYM
%token  ENABLE_SYM
%token  ENCLOSED
%token  END                           /* SQL-2003-R */
%token  ENDS_SYM
%token  END_OF_INPUT                  /* INTERNAL */
%token  ENGINES_SYM
%token  ENGINE_SYM
%token  ENUM
%token  EQ                            /* OPERATOR */
%token  EQUAL_SYM                     /* OPERATOR */
%token  ERROR_SYM
%token  ERRORS
%token  ESCAPED
%token  ESCAPE_SYM                    /* SQL-2003-R */
%token  EVENTS_SYM
%token  EVENT_SYM
%token  EVERY_SYM                     /* SQL-2003-N */
%token  EXCHANGE_SYM
%token  EXECUTE_SYM                   /* SQL-2003-R */
%token  EXISTS                        /* SQL-2003-R */
%token  EXIT_SYM
%token  EXPANSION_SYM
%token  EXPIRE_SYM
%token  EXPORT_SYM
%token  EXTENDED_SYM
%token  EXTENT_SIZE_SYM
%token  EXTRACT_SYM                   /* SQL-2003-N */
%token  FALSE_SYM                     /* SQL-2003-R */
%token  FAST_SYM
%token  FAULTS_SYM
%token  FETCH_SYM                     /* SQL-2003-R */
%token  FILE_SYM
%token  FIRST_SYM                     /* SQL-2003-N */
%token  FIXED_SYM
%token  FLOAT_NUM
%token  FLOAT_SYM                     /* SQL-2003-R */
%token  FLUSH_SYM
%token  FORCE_SYM
%token  FOREIGN                       /* SQL-2003-R */
%token  FOR_SYM                       /* SQL-2003-R */
%token  FORMAT_SYM
%token  FOUND_SYM                     /* SQL-2003-R */
%token  FROM
%token  FULL                          /* SQL-2003-R */
%token  FULLTEXT_SYM
%token  FUNCTION_SYM                  /* SQL-2003-R */
%token  GE
%token  GENERAL
%token  GEOMETRYCOLLECTION
%token  GEOMETRY_SYM
%token  GET_FORMAT                    /* MYSQL-FUNC */
%token  GET_SYM                       /* SQL-2003-R */
%token  GLOBAL_SYM                    /* SQL-2003-R */
%token  GRANT                         /* SQL-2003-R */
%token  GRANTS
%token  GROUP_SYM                     /* SQL-2003-R */
%token  GROUP_CONCAT_SYM
%token  GT_SYM                        /* OPERATOR */
%token  HANDLER_SYM
%token  HASH_SYM
%token  HAVING                        /* SQL-2003-R */
%token  HELP_SYM
%token  HEX_NUM
%token  HIGH_PRIORITY
%token  HOST_SYM
%token  HOSTS_SYM
%token  HOUR_MICROSECOND_SYM
%token  HOUR_MINUTE_SYM
%token  HOUR_SECOND_SYM
%token  HOUR_SYM                      /* SQL-2003-R */
%token  IDENT
%token  IDENTIFIED_SYM
%token  IDENT_QUOTED
%token  IF
%token  IGNORE_SYM
%token  IGNORE_SERVER_IDS_SYM
%token  IMPORT
%token  INDEXES
%token  INDEX_SYM
%token  INFILE
%token  INITIAL_SIZE_SYM
%token  INNER_SYM                     /* SQL-2003-R */
%token  INOUT_SYM                     /* SQL-2003-R */
%token  INSENSITIVE_SYM               /* SQL-2003-R */
%token  INSERT                        /* SQL-2003-R */
%token  INSERT_METHOD
%token  INSTALL_SYM
%token  INTERVAL_SYM                  /* SQL-2003-R */
%token  INTO                          /* SQL-2003-R */
%token  INT_SYM                       /* SQL-2003-R */
%token  INVOKER_SYM
%token  IN_SYM                        /* SQL-2003-R */
%token  IO_AFTER_GTIDS                /* MYSQL, FUTURE-USE */
%token  IO_BEFORE_GTIDS               /* MYSQL, FUTURE-USE */
%token  IO_SYM
%token  IPC_SYM
%token  IS                            /* SQL-2003-R */
%token  ISOLATION                     /* SQL-2003-R */
%token  ISSUER_SYM
%token  ITERATE_SYM
%token  JOIN_SYM                      /* SQL-2003-R */
%token  KEYS
%token  KEY_BLOCK_SIZE
%token  KEY_SYM                       /* SQL-2003-N */
%token  KILL_SYM
%token  LANGUAGE_SYM                  /* SQL-2003-R */
%token  LAST_SYM                      /* SQL-2003-N */
%token  LE                            /* OPERATOR */
%token  LEADING                       /* SQL-2003-R */
%token  LEAVES
%token  LEAVE_SYM
%token  LEFT                          /* SQL-2003-R */
%token  LESS_SYM
%token  LEVEL_SYM
%token  LEX_HOSTNAME
%token  LIKE                          /* SQL-2003-R */
%token  LIMIT
%token  LINEAR_SYM
%token  LINES
%token  LINESTRING
%token  LIST_SYM
%token  LOAD
%token  LOCAL_SYM                     /* SQL-2003-R */
%token  LOCATOR_SYM                   /* SQL-2003-N */
%token  LOCKS_SYM
%token  LOCK_SYM
%token  LOGFILE_SYM
%token  LOGS_SYM
%token  LONGBLOB
%token  LONGTEXT
%token  LONG_NUM
%token  LONG_SYM
%token  LOOP_SYM
%token  LOW_PRIORITY
%token  LT                            /* OPERATOR */
%token  MASTER_AUTO_POSITION_SYM
%token  MASTER_BIND_SYM
%token  MASTER_CONNECT_RETRY_SYM
%token  MASTER_DELAY_SYM
%token  MASTER_HOST_SYM
%token  MASTER_LOG_FILE_SYM
%token  MASTER_LOG_POS_SYM
%token  MASTER_PASSWORD_SYM
%token  MASTER_PORT_SYM
%token  MASTER_RETRY_COUNT_SYM
%token  MASTER_SERVER_ID_SYM
%token  MASTER_SSL_CAPATH_SYM
%token  MASTER_SSL_CA_SYM
%token  MASTER_SSL_CERT_SYM
%token  MASTER_SSL_CIPHER_SYM
%token  MASTER_SSL_CRL_SYM
%token  MASTER_SSL_CRLPATH_SYM
%token  MASTER_SSL_KEY_SYM
%token  MASTER_SSL_SYM
%token  MASTER_SSL_VERIFY_SERVER_CERT_SYM
%token  MASTER_SYM
%token  MASTER_USER_SYM
%token  MASTER_HEARTBEAT_PERIOD_SYM
%token  MATCH                         /* SQL-2003-R */
%token  MAX_CONNECTIONS_PER_HOUR
%token  MAX_QUERIES_PER_HOUR
%token  MAX_ROWS
%token  MAX_SIZE_SYM
%token  MAX_SYM                       /* SQL-2003-N */
%token  MAX_UPDATES_PER_HOUR
%token  MAX_USER_CONNECTIONS_SYM
%token  MAX_VALUE_SYM                 /* SQL-2003-N */
%token  MEDIUMBLOB
%token  MEDIUMINT
%token  MEDIUMTEXT
%token  MEDIUM_SYM
%token  MEMORY_SYM
%token  MERGE_SYM                     /* SQL-2003-R */
%token  MESSAGE_TEXT_SYM              /* SQL-2003-N */
%token  MICROSECOND_SYM               /* MYSQL-FUNC */
%token  MIGRATE_SYM
%token  MINUTE_MICROSECOND_SYM
%token  MINUTE_SECOND_SYM
%token  MINUTE_SYM                    /* SQL-2003-R */
%token  MIN_ROWS
%token  MIN_SYM                       /* SQL-2003-N */
%token  MODE_SYM
%token  MODIFIES_SYM                  /* SQL-2003-R */
%token  MODIFY_SYM
%token  MOD_SYM                       /* SQL-2003-N */
%token  MONTH_SYM                     /* SQL-2003-R */
%token  MULTILINESTRING
%token  MULTIPOINT
%token  MULTIPOLYGON
%token  MUTEX_SYM
%token  MYSQL_ERRNO_SYM
%token  NAMES_SYM                     /* SQL-2003-N */
%token  NAME_SYM                      /* SQL-2003-N */
%token  NATIONAL_SYM                  /* SQL-2003-R */
%token  NATURAL                       /* SQL-2003-R */
%token  NCHAR_STRING
%token  NCHAR_SYM                     /* SQL-2003-R */
%token  NDBCLUSTER_SYM
%token  NE                            /* OPERATOR */
%token  NEG
%token  NEW_SYM                       /* SQL-2003-R */
%token  NEXT_SYM                      /* SQL-2003-N */
%token  NODEGROUP_SYM
%token  NONE_SYM                      /* SQL-2003-R */
%token  NOT2_SYM
%token  NOT_SYM                       /* SQL-2003-R */
%token  NOW_SYM
%token  NO_SYM                        /* SQL-2003-R */
%token  NO_WAIT_SYM
%token  NO_WRITE_TO_BINLOG
%token  NULL_SYM                      /* SQL-2003-R */
%token  NUM
%token  NUMBER_SYM                    /* SQL-2003-N */
%token  NUMERIC_SYM                   /* SQL-2003-R */
%token  NVARCHAR_SYM
%token  OFFSET_SYM
%token  OLD_PASSWORD
%token  ON                            /* SQL-2003-R */
%token  ONE_SYM
%token  ONLY_SYM                      /* SQL-2003-R */
%token  OPEN_SYM                      /* SQL-2003-R */
%token  OPTIMIZE
%token  OPTIONS_SYM
%token  OPTION                        /* SQL-2003-N */
%token  OPTIONALLY
%token  OR2_SYM
%token  ORDER_SYM                     /* SQL-2003-R */
%token  OR_OR_SYM                     /* OPERATOR */
%token  OR_SYM                        /* SQL-2003-R */
%token  OUTER
%token  OUTFILE
%token  OUT_SYM                       /* SQL-2003-R */
%token  OWNER_SYM
%token  PACK_KEYS_SYM
%token  PAGE_SYM
%token  PARAM_MARKER
%token  PARSER_SYM
%token  PARTIAL                       /* SQL-2003-N */
%token  PARTITION_SYM                 /* SQL-2003-R */
%token  PARTITIONS_SYM
%token  PARTITIONING_SYM
%token  PASSWORD
%token  PHASE_SYM
%token  PLUGIN_DIR_SYM                /* INTERNAL */
%token  PLUGIN_SYM
%token  PLUGINS_SYM
%token  POINT_SYM
%token  POLYGON
%token  PORT_SYM
%token  POSITION_SYM                  /* SQL-2003-N */
%token  PRECISION                     /* SQL-2003-R */
%token  PREPARE_SYM                   /* SQL-2003-R */
%token  PRESERVE_SYM
%token  PREV_SYM
%token  PRIMARY_SYM                   /* SQL-2003-R */
%token  PRIVILEGES                    /* SQL-2003-N */
%token  PROCEDURE_SYM                 /* SQL-2003-R */
%token  PROCESS
%token  PROCESSLIST_SYM
%token  PROFILE_SYM
%token  PROFILES_SYM
%token  PROXY_SYM
%token  PURGE
%token  QUARTER_SYM
%token  QUERY_SYM
%token  QUICK
%token  RANGE_SYM                     /* SQL-2003-R */
%token  READS_SYM                     /* SQL-2003-R */
%token  READ_ONLY_SYM
%token  READ_SYM                      /* SQL-2003-N */
%token  READ_WRITE_SYM
%token  REAL                          /* SQL-2003-R */
%token  REBUILD_SYM
%token  RECOVER_SYM
%token  REDOFILE_SYM
%token  REDO_BUFFER_SIZE_SYM
%token  REDUNDANT_SYM
%token  REFERENCES                    /* SQL-2003-R */
%token  REGEXP
%token  RELAY
%token  RELAYLOG_SYM
%token  RELAY_LOG_FILE_SYM
%token  RELAY_LOG_POS_SYM
%token  RELAY_THREAD
%token  RELEASE_SYM                   /* SQL-2003-R */
%token  RELOAD
%token  REMOVE_SYM
%token  RENAME
%token  REORGANIZE_SYM
%token  REPAIR
%token  REPEATABLE_SYM                /* SQL-2003-N */
%token  REPEAT_SYM                    /* MYSQL-FUNC */
%token  REPLACE                       /* MYSQL-FUNC */
%token  REPLICATION
%token  REQUIRE_SYM
%token  RESET_SYM
%token  RESIGNAL_SYM                  /* SQL-2003-R */
%token  RESOURCES
%token  RESTORE_SYM
%token  RESTRICT
%token  RESUME_SYM
%token  RETURNED_SQLSTATE_SYM         /* SQL-2003-N */
%token  RETURNS_SYM                   /* SQL-2003-R */
%token  RETURN_SYM                    /* SQL-2003-R */
%token  REVERSE_SYM
%token  REVOKE                        /* SQL-2003-R */
%token  RIGHT                         /* SQL-2003-R */
%token  ROLLBACK_SYM                  /* SQL-2003-R */
%token  ROLLUP_SYM                    /* SQL-2003-R */
%token  ROUTINE_SYM                   /* SQL-2003-N */
%token  ROWS_SYM                      /* SQL-2003-R */
%token  ROW_FORMAT_SYM
%token  ROW_SYM                       /* SQL-2003-R */
%token  ROW_COUNT_SYM                 /* SQL-2003-N */
%token  RTREE_SYM
%token  SAVEPOINT_SYM                 /* SQL-2003-R */
%token  SCHEDULE_SYM
%token  SCHEMA_NAME_SYM               /* SQL-2003-N */
%token  SECOND_MICROSECOND_SYM
%token  SECOND_SYM                    /* SQL-2003-R */
%token  SECURITY_SYM                  /* SQL-2003-N */
%token  SELECT_SYM                    /* SQL-2003-R */
%token  SENSITIVE_SYM                 /* FUTURE-USE */
%token  SEPARATOR_SYM
%token  SERIALIZABLE_SYM              /* SQL-2003-N */
%token  SERIAL_SYM
%token  SESSION_SYM                   /* SQL-2003-N */
%token  SERVER_SYM
%token  SERVER_OPTIONS
%token  SET                           /* SQL-2003-R */
%token  SET_VAR
%token  SHARE_SYM
%token  SHIFT_LEFT                    /* OPERATOR */
%token  SHIFT_RIGHT                   /* OPERATOR */
%token  SHOW
%token  SHUTDOWN
%token  SIGNAL_SYM                    /* SQL-2003-R */
%token  SIGNED_SYM
%token  SIMPLE_SYM                    /* SQL-2003-N */
%token  SLAVE
%token  SLOW
%token  SMALLINT                      /* SQL-2003-R */
%token  SNAPSHOT_SYM
%token  SOCKET_SYM
%token  SONAME_SYM
%token  SOUNDS_SYM
%token  SOURCE_SYM
%token  SPATIAL_SYM
%token  SPECIFIC_SYM                  /* SQL-2003-R */
%token  SQLEXCEPTION_SYM              /* SQL-2003-R */
%token  SQLSTATE_SYM                  /* SQL-2003-R */
%token  SQLWARNING_SYM                /* SQL-2003-R */
%token  SQL_AFTER_GTIDS               /* MYSQL */
%token  SQL_AFTER_MTS_GAPS            /* MYSQL */
%token  SQL_BEFORE_GTIDS              /* MYSQL */
%token  SQL_BIG_RESULT
%token  SQL_BUFFER_RESULT
%token  SQL_CACHE_SYM
%token  SQL_CALC_FOUND_ROWS
%token  SQL_NO_CACHE_SYM
%token  SQL_SMALL_RESULT
%token  SQL_SYM                       /* SQL-2003-R */
%token  SQL_THREAD
%token  SSL_SYM
%token  STARTING
%token  STARTS_SYM
%token  START_SYM                     /* SQL-2003-R */
%token  STATS_AUTO_RECALC_SYM
%token  STATS_PERSISTENT_SYM
%token  STATS_SAMPLE_PAGES_SYM
%token  STATUS_SYM
%token  STDDEV_SAMP_SYM               /* SQL-2003-N */
%token  STD_SYM
%token  STOP_SYM
%token  STORAGE_SYM
%token  STRAIGHT_JOIN
%token  STRING_SYM
%token  SUBCLASS_ORIGIN_SYM           /* SQL-2003-N */
%token  SUBDATE_SYM
%token  SUBJECT_SYM
%token  SUBPARTITIONS_SYM
%token  SUBPARTITION_SYM
%token  SUBSTRING                     /* SQL-2003-N */
%token  SUM_SYM                       /* SQL-2003-N */
%token  SUPER_SYM
%token  SUSPEND_SYM
%token  SWAPS_SYM
%token  SWITCHES_SYM
%token  SYSDATE
%token  TABLES
%token  TABLESPACE
%token  TABLE_REF_PRIORITY
%token  TABLE_SYM                     /* SQL-2003-R */
%token  TABLE_CHECKSUM_SYM
%token  TABLE_NAME_SYM                /* SQL-2003-N */
%token  TEMPORARY                     /* SQL-2003-N */
%token  TEMPTABLE_SYM
%token  TERMINATED
%token  TEXT_STRING
%token  TEXT_SYM
%token  THAN_SYM
%token  THEN_SYM                      /* SQL-2003-R */
%token  TIMESTAMP                     /* SQL-2003-R */
%token  TIMESTAMP_ADD
%token  TIMESTAMP_DIFF
%token  TIME_SYM                      /* SQL-2003-R */
%token  TINYBLOB
%token  TINYINT
%token  TINYTEXT
%token  TO_SYM                        /* SQL-2003-R */
%token  TRAILING                      /* SQL-2003-R */
%token  TRANSACTION_SYM
%token  TRIGGERS_SYM
%token  TRIGGER_SYM                   /* SQL-2003-R */
%token  TRIM                          /* SQL-2003-N */
%token  TRUE_SYM                      /* SQL-2003-R */
%token  TRUNCATE_SYM
%token  TYPES_SYM
%token  TYPE_SYM                      /* SQL-2003-N */
%token  UDF_RETURNS_SYM
%token  ULONGLONG_NUM
%token  UNCOMMITTED_SYM               /* SQL-2003-N */
%token  UNDEFINED_SYM
%token  UNDERSCORE_CHARSET
%token  UNDOFILE_SYM
%token  UNDO_BUFFER_SIZE_SYM
%token  UNDO_SYM                      /* FUTURE-USE */
%token  UNICODE_SYM
%token  UNINSTALL_SYM
%token  UNION_SYM                     /* SQL-2003-R */
%token  UNIQUE_SYM
%token  UNKNOWN_SYM                   /* SQL-2003-R */
%token  UNLOCK_SYM
%token  UNSIGNED
%token  UNTIL_SYM
%token  UPDATE_SYM                    /* SQL-2003-R */
%token  UPGRADE_SYM
%token  USAGE                         /* SQL-2003-N */
%token  USER                          /* SQL-2003-R */
%token  USE_FRM
%token  USE_SYM
%token  USING                         /* SQL-2003-R */
%token  UTC_DATE_SYM
%token  UTC_TIMESTAMP_SYM
%token  UTC_TIME_SYM
%token  VALUES                        /* SQL-2003-R */
%token  VALUE_SYM                     /* SQL-2003-R */
%token  VARBINARY
%token  VARCHAR                       /* SQL-2003-R */
%token  VARIABLES
%token  VARIANCE_SYM
%token  VARYING                       /* SQL-2003-R */
%token  VAR_SAMP_SYM
%token  VIEW_SYM                      /* SQL-2003-N */
%token  WAIT_SYM
%token  WARNINGS
%token  WEEK_SYM
%token  WEIGHT_STRING_SYM
%token  WHEN_SYM                      /* SQL-2003-R */
%token  WHERE                         /* SQL-2003-R */
%token  WHILE_SYM
%token  WITH                          /* SQL-2003-R */
%token  WITH_CUBE_SYM                 /* INTERNAL */
%token  WITH_ROLLUP_SYM               /* INTERNAL */
%token  WORK_SYM                      /* SQL-2003-N */
%token  WRAPPER_SYM
%token  WRITE_SYM                     /* SQL-2003-N */
%token  X509_SYM
%token  XA_SYM
%token  XML_SYM
%token  XOR
%token  YEAR_MONTH_SYM
%token  YEAR_SYM                      /* SQL-2003-R */
%token  ZEROFILL
%type <cptr> 
	ident IDENT IDENT_sys 
	table_ident table_factor
	simple_ident_q simple_ident ident_list
	select_item expr simple_expr bit_expr
	predicate bool_pri 
	where_clause having_clause opt_table_alias

%left   JOIN_SYM INNER_SYM STRAIGHT_JOIN CROSS LEFT RIGHT
/* A dummy token to force the priority of table_ref production in a join. */
%left   TABLE_REF_PRIORITY
%left   SET_VAR
%left   OR_OR_SYM OR_SYM OR2_SYM
%left   XOR
%left   AND_SYM AND_AND_SYM
%left   BETWEEN_SYM CASE_SYM WHEN_SYM THEN_SYM ELSE
%left   EQ EQUAL_SYM GE GT_SYM LE LT NE IS LIKE REGEXP IN_SYM
%left   '|'
%left   '&'
%left   SHIFT_LEFT SHIFT_RIGHT
%left   '-' '+'
%left   '*' '/' '%' DIV_SYM MOD_SYM
%left   '^'
%left   NEG '~'
%right  NOT_SYM NOT2_SYM
%right  BINARY COLLATE_SYM
%left  INTERVAL_SYM

%%


select:
	  select_init
          {
          }
          ';'
        ;

opt_end_of_input:
          /* empty */
        | END_OF_INPUT
        ;

/* Need select_init2 for subselects. */
select_init:
          SELECT_SYM select_init2
	  {
	  }
        | '(' select_paren ')' union_opt
        ;

select_paren:
          SELECT_SYM select_part2
          {
          }
        | '(' select_paren ')'
        ;

/* The equivalent of select_paren for nested queries. */
select_paren_derived:
          SELECT_SYM select_part2_derived
          {
          }
        | '(' select_paren_derived ')'
        ;

select_init2:
          select_part2
          {
          }
          union_clause
        ;

select_part2:
          {
          }
          select_options select_item_list select_into select_lock_type
        ;

select_into:
          opt_order_clause opt_limit_clause {}
        | into
        | select_from
        | into select_from
        | select_from into
        ;

select_from:
          FROM join_table_list where_clause group_clause having_clause
          opt_order_clause opt_limit_clause procedure_analyse_clause
          {
          }
        | FROM DUAL_SYM where_clause opt_limit_clause
          /* oracle compatibility: oracle always requires FROM clause,
             and DUAL is system table without fields.
             Is "SELECT 1 FROM DUAL" any better than "SELECT 1" ?
          Hmmm :) */
        ;

select_options:
          /* empty*/
        | select_option_list
          {
          }
        ;

select_option_list:
          select_option_list select_option
        | select_option
        ;

select_option:
          query_expression_option
        | SQL_NO_CACHE_SYM
        | SQL_CACHE_SYM
        ;

select_lock_type:
          /* empty */
        | FOR_SYM UPDATE_SYM
        | LOCK_SYM IN_SYM SHARE_SYM MODE_SYM
        ;

select_item_list:
          select_item_list ',' select_item
          {
          }
        | select_item
          {
          }
        | '*'
	  {
	  }
        ;

select_item:
          table_wild
        | expr select_alias
          {
                $$=$1;
          }
        ;

select_alias:
          /* empty */
        | AS ident
        | AS TEXT_STRING_sys
        | ident
        | TEXT_STRING_sys
        ;

optional_braces:
          /* empty */
        | '(' ')'
        ;

/* all possible expressions */
expr:
          expr or expr %prec OR_SYM
        | expr XOR expr %prec XOR
        | expr and expr %prec AND_SYM
        | NOT_SYM expr %prec NOT_SYM
        | bool_pri IS TRUE_SYM %prec IS
        | bool_pri IS not TRUE_SYM %prec IS
        | bool_pri IS FALSE_SYM %prec IS
        | bool_pri IS not FALSE_SYM %prec IS
        | bool_pri IS UNKNOWN_SYM %prec IS
        | bool_pri IS not UNKNOWN_SYM %prec IS
        | bool_pri
          {
                $$=$1;
          }
        ;

bool_pri:
          bool_pri IS NULL_SYM %prec IS
        | bool_pri IS not NULL_SYM %prec IS
        | bool_pri EQUAL_SYM predicate %prec EQUAL_SYM
        | bool_pri comp_op predicate %prec EQ
        | bool_pri comp_op all_or_any '(' subselect ')' %prec EQ
        | predicate
          {
                $$=$1;
          }
        ;

predicate:
          bit_expr IN_SYM '(' subselect ')'
        | bit_expr not IN_SYM '(' subselect ')'
        | bit_expr IN_SYM '(' expr ')'
        | bit_expr IN_SYM '(' expr ',' expr_list ')'
        | bit_expr not IN_SYM '(' expr ')'
        | bit_expr not IN_SYM '(' expr ',' expr_list ')'
        | bit_expr BETWEEN_SYM bit_expr AND_SYM predicate
        | bit_expr not BETWEEN_SYM bit_expr AND_SYM predicate
        | bit_expr SOUNDS_SYM LIKE bit_expr
        | bit_expr LIKE simple_expr opt_escape
        | bit_expr not LIKE simple_expr opt_escape
        | bit_expr REGEXP bit_expr
        | bit_expr not REGEXP bit_expr
        | bit_expr
          {
                $$=$1;
          }
        ;

bit_expr:
          bit_expr '|' bit_expr %prec '|'
        | bit_expr '&' bit_expr %prec '&'
        | bit_expr SHIFT_LEFT bit_expr %prec SHIFT_LEFT
        | bit_expr SHIFT_RIGHT bit_expr %prec SHIFT_RIGHT
        | bit_expr '+' bit_expr %prec '+'
        | bit_expr '-' bit_expr %prec '-'
        | bit_expr '+' INTERVAL_SYM expr interval %prec '+'
        | bit_expr '-' INTERVAL_SYM expr interval %prec '-'
        | bit_expr '*' bit_expr %prec '*'
        | bit_expr '/' bit_expr %prec '/'
        | bit_expr '%' bit_expr %prec '%'
        | bit_expr DIV_SYM bit_expr %prec DIV_SYM
        | bit_expr MOD_SYM bit_expr %prec MOD_SYM
        | bit_expr '^' bit_expr
        | simple_expr
          {
                $$=$1;
                //printf("Field name is %s\n", $1);
          }
        ;

or:
          OR_SYM
       | OR2_SYM
       ;

and:
          AND_SYM
       | AND_AND_SYM
       ;

not:
          NOT_SYM
        | NOT2_SYM
        ;

not2:
          '!'
        | NOT2_SYM
        ;

comp_op:
          EQ
        | GE
        | GT_SYM
        | LE
        | LT
        | NE
        ;

all_or_any:
          ALL
        | ANY_SYM
        ;

simple_expr:
          simple_ident
	  {
	  }
        | function_call_keyword
        | function_call_nonkeyword
        | function_call_generic
        | function_call_conflict
        | simple_expr COLLATE_SYM ident_or_text %prec NEG
        | literal
        | param_marker
        | variable
        | sum_expr
        | simple_expr OR_OR_SYM simple_expr
        | '+' simple_expr %prec NEG
        | '-' simple_expr %prec NEG
        | '~' simple_expr %prec NEG
        | not2 simple_expr %prec NEG
        | '(' subselect ')'
        | '(' expr ')'
        | '(' expr ',' expr_list ')'
        | ROW_SYM '(' expr ',' expr_list ')'
        | EXISTS '(' subselect ')'
        | '{' ident expr '}'
        | MATCH ident_list_arg AGAINST '(' bit_expr fulltext_options ')'
        | BINARY simple_expr %prec NEG
        | CAST_SYM '(' expr AS cast_type ')'
        | CASE_SYM opt_expr when_list opt_else END
        | CONVERT_SYM '(' expr ',' cast_type ')'
        | CONVERT_SYM '(' expr USING /*charset_name*/ ')'
        | DEFAULT '(' simple_ident ')'
        | VALUES '(' simple_ident_nospvar ')'
        | INTERVAL_SYM expr interval '+' expr %prec INTERVAL_SYM
        ;

/*
  Function call syntax using official SQL 2003 keywords.
  Because the function name is an official token,
  a dedicated grammar rule is needed in the parser.
  There is no potential for conflicts
*/
function_call_keyword:
          CHAR_SYM '(' expr_list ')'
        | CHAR_SYM '(' expr_list USING /*charset_name*/ ')'
        | CURRENT_USER optional_braces
        | DATE_SYM '(' expr ')'
        | DAY_SYM '(' expr ')'
        | HOUR_SYM '(' expr ')'
        | INSERT '(' expr ',' expr ',' expr ',' expr ')'
        | INTERVAL_SYM '(' expr ',' expr ')' %prec INTERVAL_SYM
        | INTERVAL_SYM '(' expr ',' expr ',' expr_list ')' %prec INTERVAL_SYM
        | LEFT '(' expr ',' expr ')'
        | MINUTE_SYM '(' expr ')'
        | MONTH_SYM '(' expr ')'
        | RIGHT '(' expr ',' expr ')'
        | SECOND_SYM '(' expr ')'
        | TIME_SYM '(' expr ')'
        | TIMESTAMP '(' expr ')'
        | TIMESTAMP '(' expr ',' expr ')'
        | TRIM '(' expr ')'
        | TRIM '(' LEADING expr FROM expr ')'
        | TRIM '(' TRAILING expr FROM expr ')'
        | TRIM '(' BOTH expr FROM expr ')'
        | TRIM '(' LEADING FROM expr ')'
        | TRIM '(' TRAILING FROM expr ')'
        | TRIM '(' BOTH FROM expr ')'
        | TRIM '(' expr FROM expr ')'
        | USER '(' ')'
        | YEAR_SYM '(' expr ')'
        ;

/*
  Function calls using non reserved keywords, with special syntaxic forms.
  Dedicated grammar rules are needed because of the syntax,
  but also have the potential to cause incompatibilities with other
  parts of the language.
  MAINTAINER:
  The only reasons a function should be added here are:
  - for compatibility reasons with another SQL syntax (CURDATE),
  - for typing reasons (GET_FORMAT)
  Any other 'Syntaxic sugar' enhancements should be *STRONGLY*
  discouraged.
*/
function_call_nonkeyword:
          ADDDATE_SYM '(' expr ',' expr ')'
        | ADDDATE_SYM '(' expr ',' INTERVAL_SYM expr interval ')'
        | CURDATE optional_braces
        | CURTIME func_datetime_precision
        | DATE_ADD_INTERVAL '(' expr ',' INTERVAL_SYM expr interval ')'
          %prec INTERVAL_SYM
        | DATE_SUB_INTERVAL '(' expr ',' INTERVAL_SYM expr interval ')'
          %prec INTERVAL_SYM
        | EXTRACT_SYM '(' interval FROM expr ')'
        | GET_FORMAT '(' date_time_type  ',' expr ')'
        /*| now*/
        | POSITION_SYM '(' bit_expr IN_SYM expr ')'
        | SUBDATE_SYM '(' expr ',' expr ')'
        | SUBDATE_SYM '(' expr ',' INTERVAL_SYM expr interval ')'
        | SUBSTRING '(' expr ',' expr ',' expr ')'
        | SUBSTRING '(' expr ',' expr ')'
        | SUBSTRING '(' expr FROM expr FOR_SYM expr ')'
        | SUBSTRING '(' expr FROM expr ')'
        | SYSDATE func_datetime_precision
        | TIMESTAMP_ADD '(' interval_time_stamp ',' expr ',' expr ')'
        | TIMESTAMP_DIFF '(' interval_time_stamp ',' expr ',' expr ')'
        | UTC_DATE_SYM optional_braces
        | UTC_TIME_SYM func_datetime_precision
        | UTC_TIMESTAMP_SYM func_datetime_precision
        ;

/*
  Functions calls using a non reserved keyword, and using a regular syntax.
  Because the non reserved keyword is used in another part of the grammar,
  a dedicated rule is needed here.
*/
function_call_conflict:
          ASCII_SYM '(' expr ')'
        | CHARSET '(' expr ')'
        | COALESCE '(' expr_list ')'
        | COLLATION_SYM '(' expr ')'
        | DATABASE '(' ')'
        | IF '(' expr ',' expr ',' expr ')'
        | FORMAT_SYM '(' expr ',' expr ')'
        | FORMAT_SYM '(' expr ',' expr ',' expr ')'
        | MICROSECOND_SYM '(' expr ')'
        | MOD_SYM '(' expr ',' expr ')'
        | OLD_PASSWORD '(' expr ')'
        | PASSWORD '(' expr ')'
        | QUARTER_SYM '(' expr ')'
        | REPEAT_SYM '(' expr ',' expr ')'
        | REPLACE '(' expr ',' expr ',' expr ')'
        | REVERSE_SYM '(' expr ')'
        | ROW_COUNT_SYM '(' ')'
        | TRUNCATE_SYM '(' expr ',' expr ')'
        | WEEK_SYM '(' expr ')'
        | WEEK_SYM '(' expr ',' expr ')'
        | WEIGHT_STRING_SYM '(' expr /*opt_ws_levels*/ ')'
        | WEIGHT_STRING_SYM '(' expr AS CHAR_SYM /*ws_nweights opt_ws_levels*/ ')'
        | WEIGHT_STRING_SYM '(' expr AS BINARY /*ws_nweights*/ ')'
        | WEIGHT_STRING_SYM '(' expr ',' ulong_num ',' ulong_num ',' ulong_num ')'
        | geometry_function
        ;

geometry_function:
          CONTAINS_SYM '(' expr ',' expr ')'
        | GEOMETRYCOLLECTION '(' expr_list ')'
        | LINESTRING '(' expr_list ')'
        | MULTILINESTRING '(' expr_list ')'
        | MULTIPOINT '(' expr_list ')'
        | MULTIPOLYGON '(' expr_list ')'
        | POINT_SYM '(' expr ',' expr ')'
        | POLYGON '(' expr_list ')'
        ;

/*
  Regular function calls.
  The function name is *not* a token, and therefore is guaranteed to not
  introduce side effects to the language in general.
  MAINTAINER:
  All the new functions implemented for new features should fit into
  this category. The place to implement the function itself is
  in sql/item_create.cc
*/
function_call_generic:
          IDENT_sys '('
        | ident '.' ident '(' opt_expr_list ')'
        ;

fulltext_options:
          opt_natural_language_mode opt_query_expansion
        | IN_SYM BOOLEAN_SYM MODE_SYM
        ;

opt_natural_language_mode:
          /* nothing */                         
        | IN_SYM NATURAL LANGUAGE_SYM MODE_SYM 
        ;

opt_query_expansion:
          /* nothing */              
        | WITH QUERY_SYM EXPANSION_SYM
        ;

opt_udf_expr_list:
        /* empty */     
        | udf_expr_list 
        ;

udf_expr_list:
          udf_expr
        | udf_expr_list ',' udf_expr
        ;

udf_expr:
          expr select_alias
        ;

sum_expr:
          AVG_SYM '(' in_sum_expr ')'
        | AVG_SYM '(' DISTINCT in_sum_expr ')'
        | BIT_AND  '(' in_sum_expr ')'
        | BIT_OR  '(' in_sum_expr ')'
        | BIT_XOR  '(' in_sum_expr ')'
        | COUNT_SYM '(' opt_all '*' ')'
        | COUNT_SYM '(' in_sum_expr ')'
        | COUNT_SYM '(' DISTINCT expr_list ')'
        | MIN_SYM '(' in_sum_expr ')'
        | MIN_SYM '(' DISTINCT in_sum_expr ')'
        | MAX_SYM '(' in_sum_expr ')'
        | MAX_SYM '(' DISTINCT in_sum_expr ')'
        | STD_SYM '(' in_sum_expr ')'
        | VARIANCE_SYM '(' in_sum_expr ')'
        | STDDEV_SAMP_SYM '(' in_sum_expr ')'
        | VAR_SAMP_SYM '(' in_sum_expr ')'
        | SUM_SYM '(' in_sum_expr ')'
        | SUM_SYM '(' DISTINCT in_sum_expr ')'
        | GROUP_CONCAT_SYM '(' opt_distinct
          expr_list opt_gorder_clause
          opt_gconcat_separator
          ')'
        ;

variable:
          '@'
          variable_aux
        ;

variable_aux:
          ident_or_text SET_VAR expr
        | ident_or_text
        | '@' opt_var_ident_type ident_or_text /*opt_component*/
        ;

opt_distinct:
          /* empty */ 
        | DISTINCT 
        ;

opt_gconcat_separator:
          /* empty */
        | SEPARATOR_SYM /*text_string*/
        ;

opt_gorder_clause:
          /* empty */
        | order_clause
        ;

in_sum_expr:
          opt_all
          expr
        ;

cast_type:
          BINARY opt_field_length
        | CHAR_SYM opt_field_length /*opt_binary*/
        | NCHAR_SYM opt_field_length
        | SIGNED_SYM
        | SIGNED_SYM INT_SYM
        | UNSIGNED
        | UNSIGNED INT_SYM
        | DATE_SYM
        | TIME_SYM type_datetime_precision
        | DATETIME type_datetime_precision
        | DECIMAL_SYM /*float_options*/
        ;

opt_field_length:
          /* empty */  
        | field_length 
        ;

opt_expr_list:
          /* empty */ 
        | expr_list 
        ;

expr_list:
          expr
        | expr_list ',' expr
        ;

ident_list_arg:
          ident_list  
        | '(' ident_list ')' 
        ;

ident_list:
          simple_ident
	  {
		//cout<<"Field Name is: "<<$1<<endl;
	  }
        | ident_list ',' simple_ident
	  {
		//cout<<"Field Name is: "<<$3<<endl;
	  }
        ;

opt_expr:
          /* empty */ 
        | expr  
        ;

opt_else:
          /* empty */ 
        | ELSE expr  
        ;

when_list:
          WHEN_SYM expr THEN_SYM expr
        | when_list WHEN_SYM expr THEN_SYM expr
        ;

/* Equivalent to <table reference> in the SQL:2003 standard. */
/* Warning - may return NULL in case of incomplete SELECT */
table_ref:
          table_factor
        | join_table
        ;

join_table_list:
          derived_table_list
        ;

/*
  The ODBC escape syntax for Outer Join is: '{' OJ join_table '}'
  The parser does not define OJ as a token, any ident is accepted
  instead in $2 (ident). Also, all productions from table_ref can
  be escaped, not only join_table. Both syntax extensions are safe
  and are ignored.
*/
esc_table_ref:
        table_ref 
      | '{' ident table_ref '}' 
      ;

/* Equivalent to <table reference list> in the SQL:2003 standard. */
/* Warning - may return NULL in case of incomplete SELECT */
derived_table_list:
          esc_table_ref 
        | derived_table_list ',' esc_table_ref
        ;

/*
  Notice that JOIN is a left-associative operation, and it must be parsed
  as such, that is, the parser must process first the left join operand
  then the right one. Such order of processing ensures that the parser
  produces correct join trees which is essential for semantic analysis
  and subsequent optimization phases.
*/
join_table:
          /* INNER JOIN variants */
          /*
            Use %prec to evaluate production 'table_ref' before 'normal_join'
            so that [INNER | CROSS] JOIN is properly nested as other
            left-associative joins.
          */
          table_ref normal_join table_ref %prec TABLE_REF_PRIORITY
        | table_ref STRAIGHT_JOIN table_factor
        | table_ref normal_join table_ref
          ON
          expr
        | table_ref STRAIGHT_JOIN table_factor
          ON
          expr
        | table_ref normal_join table_ref
          USING
          '(' using_list ')'
        | table_ref NATURAL JOIN_SYM table_factor
        | table_ref LEFT opt_outer JOIN_SYM table_ref
          ON
          expr
        | table_ref LEFT opt_outer JOIN_SYM table_factor
          USING '(' using_list ')'
        | table_ref NATURAL LEFT opt_outer JOIN_SYM table_factor
        | table_ref RIGHT opt_outer JOIN_SYM table_ref
          ON
          expr
        | table_ref RIGHT opt_outer JOIN_SYM table_factor
          USING '(' using_list ')'
        | table_ref NATURAL RIGHT opt_outer JOIN_SYM table_factor
        ;

normal_join:
          JOIN_SYM {}
        | INNER_SYM JOIN_SYM {}
        | CROSS JOIN_SYM {}
        ;

/*
  table PARTITION (list of partitions), reusing using_list instead of creating
  a new rule for partition_list.
*/
opt_use_partition:
          /* empty */
        | use_partition
        ;
        
use_partition:
          PARTITION_SYM '(' using_list ')' /*have_partitioning*/
        ;
  
/* 
   This is a flattening of the rules <table factor> and <table primary>
   in the SQL:2003 standard, since we don't have <sample clause>

   I.e.
   <table factor> ::= <table primary> [ <sample clause> ]
*/   
/* Warning - may return NULL in case of incomplete SELECT */
table_factor:
          table_ident opt_use_partition opt_table_alias opt_key_definition
	  {
	        qTableAliasMap_it = qTableAliasMap.find($3);
                if (qTableAliasMap_it != qTableAliasMap.end())
                {
                        qTable *qt_found=qTableAliasMap_it->second;
                        qt_found->tableName=$1;
                }
                else
                {
                        qTable *qt_new=new qTable();
                        qt_new->tableAlias=$3;
                        qt_new->tableName=$1;
                        qTableAliasMap.insert(pair<string,qTable*>($3, qt_new));
                }		
	  }
        | select_derived_init get_select_lex select_derived2
          /*
            Represents a flattening of the following rules from the SQL:2003
            standard. This sub-rule corresponds to the sub-rule
            <table primary> ::= ... | <derived table> [ AS ] <correlation name>
            
            The following rules have been flattened into query_expression_body
            (since we have no <with clause>).

            <derived table> ::= <table subquery>
            <table subquery> ::= <subquery>
            <subquery> ::= <left paren> <query expression> <right paren>
            <query expression> ::= [ <with clause> ] <query expression body>

            For the time being we use the non-standard rule
            select_derived_union which is a compromise between the standard
            and our parser. Possibly this rule could be replaced by our
            query_expression_body.
          */
        | '(' get_select_lex select_derived_union ')' opt_table_alias
        ;

/*
  This rule accepts just about anything. The reason is that we have
  empty-producing rules in the beginning of rules, in this case
  subselect_start. This forces bison to take a decision which rules to
  reduce by long before it has seen any tokens. This approach ties us
  to a very limited class of parseable languages, and unfortunately
  SQL is not one of them. The chosen 'solution' was this rule, which
  produces just about anything, even complete bogus statements, for
  instance ( table UNION SELECT 1 ).

  Fortunately, we know that the semantic value returned by
  select_derived is NULL if it contained a derived table, and a pointer to
  the base table's TABLE_LIST if it was a base table. So in the rule
  regarding union's, we throw a parse error manually and pretend it
  was bison that did it.

  Also worth noting is that this rule concerns query expressions in
  the from clause only. Top level select statements and other types of
  subqueries have their own union rules.
 */
select_derived_union:
          select_derived opt_union_order_or_limit
        | select_derived_union
          UNION_SYM
          union_option
          query_specification
          opt_union_order_or_limit
        ;

/* The equivalent of select_init2 for nested queries. */
select_init2_derived:
          select_part2_derived
        ;

/* The equivalent of select_part2 for nested queries. */
select_part2_derived:
          opt_query_expression_options select_item_list
          opt_select_from select_lock_type
        ;

/* handle contents of parentheses in join expression */
select_derived:
          get_select_lex
          derived_table_list
        ;

select_derived2:
          select_options select_item_list
          opt_select_from
        ;

get_select_lex:
          /* Empty */
        ;

select_derived_init:
          SELECT_SYM
	  {
               // qTable *qt=new qTable();
               // qTableStack.push(*qt);
               // queryArr[queryCount++]=qt;
	  }
        ;

opt_outer:
          /* empty */
        | OUTER 
        ;

index_hint_clause:
          /* empty */
        | FOR_SYM JOIN_SYM
        | FOR_SYM ORDER_SYM BY
        | FOR_SYM GROUP_SYM BY
        ;

index_hint_type:
          FORCE_SYM  
        | IGNORE_SYM 
        ;

index_hint_definition:
          index_hint_type key_or_index index_hint_clause
          '(' key_usage_list ')'
        | USE_SYM key_or_index index_hint_clause
          '(' opt_key_usage_list ')'
       ;

index_hints_list:
          index_hint_definition
        | index_hints_list index_hint_definition
        ;

opt_index_hints_list:
          /* empty */
        | index_hints_list
        ;

opt_key_definition:
          opt_index_hints_list
        ;

opt_key_usage_list:
          /* empty */
        | key_usage_list {}
        ;

key_usage_element:
          ident
        | PRIMARY_SYM
        ;

key_usage_list:
          key_usage_element
        | key_usage_list ',' key_usage_element
        ;

key_or_index:
          KEY_SYM {}
        | INDEX_SYM {}
        ;

using_list:
          ident
        | using_list ',' ident
        ;

interval:
          interval_time_stamp    
        | DAY_HOUR_SYM          
        | DAY_MICROSECOND_SYM  
        | DAY_MINUTE_SYM         
        | DAY_SECOND_SYM         
        | HOUR_MICROSECOND_SYM   
        | HOUR_MINUTE_SYM        
        | HOUR_SECOND_SYM        
        | MINUTE_MICROSECOND_SYM 
        | MINUTE_SECOND_SYM      
        | SECOND_MICROSECOND_SYM 
        | YEAR_MONTH_SYM         
        ;

interval_time_stamp:
          DAY_SYM         
        | WEEK_SYM        
        | HOUR_SYM        
        | MINUTE_SYM     
        | MONTH_SYM       
        | QUARTER_SYM     
        | SECOND_SYM      
        | MICROSECOND_SYM 
        | YEAR_SYM        
        ;

date_time_type:
          DATE_SYM 
        | TIME_SYM
        | TIMESTAMP
        | DATETIME
        ;

table_alias:
          /* empty */
        | AS
        | EQ
        ;

opt_table_alias:
          /* empty */ 
        | table_alias ident
	  {
		$$=$2;
	  }
        ;

opt_all:
          /* empty */
        | ALL
        ;

where_clause:
          /* empty */ 
        | WHERE
          expr
	  {
		//cout<<"Field in the where clause:"<<$2<<endl;
                //printf("Field in the where clause: %s\n",$2);
	  }
        ;

having_clause:
          /* empty */
        | HAVING
          expr
	  {
		//cout<<"Field in the having clause:"<<$2<<endl;
                //printf("Field in the having clause: %s\n",$2);
	  }
        ;

opt_escape:
          ESCAPE_SYM simple_expr 
        | /* empty */
        ;

/*
   group by statement in select
*/

group_clause:
          /* empty */
        | GROUP_SYM BY group_list olap_opt
        ;

group_list:
          group_list ',' order_ident order_dir
        | order_ident order_dir
        ;

olap_opt:
          /* empty */ {}
        | WITH_CUBE_SYM
        | WITH_ROLLUP_SYM
        ;

/*
  Order by statement in ALTER TABLE
*/

alter_order_clause:
          ORDER_SYM BY alter_order_list
        ;

alter_order_list:
          alter_order_list ',' alter_order_item
        | alter_order_item
        ;

alter_order_item:
          simple_ident_nospvar order_dir
        ;

/*
   Order by statement in select
*/

opt_order_clause:
          /* empty */
        | order_clause
        ;

order_clause:
          ORDER_SYM BY
          order_list
        ;

order_list:
          order_list ',' order_ident order_dir
        | order_ident order_dir
        ;

order_dir:
          /* empty */
        | ASC  
        | DESC 
        ;

opt_limit_clause_init:
          /* empty */
        | limit_clause {}
        ;

opt_limit_clause:
          /* empty */ {}
        | limit_clause {}
        ;

limit_clause:
          LIMIT limit_options
        ;

limit_options:
          limit_option
        | limit_option ',' limit_option
        | limit_option OFFSET_SYM limit_option
        ;

limit_option:
        ident
        | param_marker
        | ULONGLONG_NUM
        | LONG_NUM
        | NUM
        ;

delete_limit_clause:
          /* empty */
        | LIMIT limit_option
        ;

ulong_num:
          NUM         
        | HEX_NUM    
        | LONG_NUM  
        | ULONGLONG_NUM 
        | DECIMAL_NUM  
        | FLOAT_NUM   
        ;

real_ulong_num:
          NUM           
        | HEX_NUM      
        | LONG_NUM    
        | ULONGLONG_NUM 
        | dec_num_error 
        ;

ulonglong_num:
          NUM           
        | ULONGLONG_NUM 
        | LONG_NUM      
        | DECIMAL_NUM   
        | FLOAT_NUM     
        ;

real_ulonglong_num:
          NUM           
        | ULONGLONG_NUM 
        | LONG_NUM      
        | dec_num_error 
        ;

dec_num_error:
          dec_num
        ;

dec_num:
          DECIMAL_NUM
        | FLOAT_NUM
        ;

procedure_analyse_clause:
          /* empty */
        | PROCEDURE_SYM ANALYSE_SYM
          '(' opt_procedure_analyse_params ')'
        ;

opt_procedure_analyse_params:
          /* empty */ {}
        | procedure_analyse_param
        | procedure_analyse_param ',' procedure_analyse_param
        ;

procedure_analyse_param:
          NUM
        ;

select_var_list_init:
          select_var_list
          {}
        ;

select_var_list:
          select_var_list ',' select_var_ident
        | select_var_ident {}
        ;

select_var_ident:  
          '@' ident_or_text
        | ident_or_text
        ;

into:
          INTO
          into_destination
        ;

into_destination:
          OUTFILE TEXT_STRING_filesystem
          /*opt_load_data_charset*/
          /*opt_field_term  opt_line_term*/
        | DUMPFILE TEXT_STRING_filesystem
        | select_var_list_init
        ;

/*
  DO statement
*/

/*
** Insert : add new data to table
*/

/* Common definitions */

text_literal:
          TEXT_STRING
          {
          }
        | NCHAR_STRING
          {
          }
        | UNDERSCORE_CHARSET TEXT_STRING
          {
          }
        | text_literal TEXT_STRING_literal
          {
          }
        ;
text_string:
          TEXT_STRING_literal
          {
          }
        | HEX_NUM
          {
          }
        | BIN_NUM
          {
          }
        ;


param_marker:
          PARAM_MARKER
          {
          }
        ;

/*signed_literal:
          literal 
        | '+' NUM_literal 
        | '-' NUM_literal
          {
          }
        ;
*/

literal:
          text_literal 
        | NUM_literal 
        | temporal_literal 
        | NULL_SYM
          {
          }
        | FALSE_SYM
          {
          }
        | TRUE_SYM
          {
          }
        | HEX_NUM
          {
          }
        | BIN_NUM
          {
          }
        | UNDERSCORE_CHARSET HEX_NUM
          {
          }
        | UNDERSCORE_CHARSET BIN_NUM
          {
          }
        ;

NUM_literal:
          NUM
          {
          }
        | LONG_NUM
          {
          }
        | ULONGLONG_NUM
          {
          }
        | DECIMAL_NUM
          {
          }
        | FLOAT_NUM
          {
          }
        ;


temporal_literal:
        DATE_SYM TEXT_STRING
          {
          }
        | TIME_SYM TEXT_STRING
          {
          }
        | TIMESTAMP TEXT_STRING
          {
          }
        ;




/**********************************************************************
** Creating different items.
**********************************************************************/

/*insert_ident:
          simple_ident_nospvar { $$=$1; }
        | table_wild { $$=$1; }
        ;
*/
table_wild:
          ident '.' '*'
          {
           
          }
        | ident '.' ident '.' '*'
          {
           
          }
        ;

order_ident:
          expr 
        ;

simple_ident:
          ident
          {
		$$=$1;
		//printf("field name is %s\n", $1);
          }
        | simple_ident_q
	  {
		$$=$1;
	  } 
        ;

simple_ident_nospvar:
          ident
          {
		
          }
        | simple_ident_q 
        ;

simple_ident_q:
          ident '.' ident
          {
		qTableAliasMap_it = qTableAliasMap.find($1);
		if (qTableAliasMap_it != qTableAliasMap.end())
		{
                        qTable *qt_found=qTableAliasMap_it->second;
                        qt_found->columnSet.insert($3);
		}
		else
		{
			qTable *qt_new=new qTable();
                        qt_new->tableAlias=$1;
                        qt_new->columnSet.insert($3);
                        qTableAliasMap.insert(pair<string,qTable*>($1, qt_new));
		}
		$$=$3;
          }
        | '.' ident '.' ident
	  {
                qTableAliasMap_it = qTableAliasMap.find($2);
                if (qTableAliasMap_it != qTableAliasMap.end())
                {
                        qTable *qt_found=qTableAliasMap_it->second;
                        qt_found->columnSet.insert($4);
                }
                else
                {
                        qTable *qt_new=new qTable();
                        qt_new->tableAlias=$2;
                        qt_new->columnSet.insert($4);
                        qTableAliasMap.insert(pair<string,qTable*>($2, qt_new));
                }
		$$=$4;
	  }
        | ident '.' ident '.' ident
	  {
                qTableAliasMap_it = qTableAliasMap.find($3);
                if (qTableAliasMap_it != qTableAliasMap.end())
                {
                        qTable *qt_found=qTableAliasMap_it->second;
                        qt_found->columnSet.insert($5);
                }
                else
                {
                        qTable *qt_new=new qTable();
                        qt_new->tableAlias=$3;
                        qt_new->columnSet.insert($5);
                        qTableAliasMap.insert(pair<string,qTable*>($3, qt_new));
                }
		$$=$5;
	  }
        ;

/*field_ident:
          ident 
        | ident '.' ident '.' ident
          {
          }
        | ident '.' ident
          {
          }
        | '.' ident // For Delphi 
        ;
*/
table_ident:
          ident
          {
		//cout<<"Table name is: "<<$1<<endl;
          }
        | ident '.' ident
          {
		$$=$3;
          }
        | '.' ident
          {
            /* For Delphi */
          }
        ;

/*table_ident_opt_wild:
          ident opt_wild
          {
          }
        | ident '.' ident opt_wild
          {
          }
        ;
*/
/*table_ident_nodb:
          ident
          {
          }
        ;
*/
IDENT_sys:
          IDENT 
	  {
		$$=$1;
	  } 
        | IDENT_QUOTED
          {
          }
        ;

TEXT_STRING_sys_nonewline:
          TEXT_STRING_sys
          {
          }
        ;

TEXT_STRING_sys:
          TEXT_STRING
          {
          }
        ;

TEXT_STRING_literal:
          TEXT_STRING
          {
          }
        ;

TEXT_STRING_filesystem:
          TEXT_STRING
          {
          }
        ;

ident:
          IDENT_sys 
	  {
                $$=$1;
	  } 
        | keyword
          {
          }
        ;

/*label_ident:
          IDENT_sys  
        | keyword_sp
        ;
*/
ident_or_text:
          ident 
        | TEXT_STRING_sys 
        | LEX_HOSTNAME 
        ;

user:
          ident_or_text
          {
          }
        | ident_or_text '@' ident_or_text
          {
          }
        | CURRENT_USER optional_braces
          {
          }
        ;

/* Keyword that we allow for identifiers (except SP labels) */
keyword:
          keyword_sp            {}
        | ASCII_SYM             {}
        | BACKUP_SYM            {}
        | BEGIN_SYM             {}
        | BYTE_SYM              {}
        | CACHE_SYM             {}
        | CHARSET               {}
        | CHECKSUM_SYM          {}
        | CLOSE_SYM             {}
        | COMMENT_SYM           {}
        | COMMIT_SYM            {}
        | CONTAINS_SYM          {}
        | DEALLOCATE_SYM        {}
        | DO_SYM                {}
        | END                   {}
        | EXECUTE_SYM           {}
        | FLUSH_SYM             {}
        | FORMAT_SYM            {}
        | HANDLER_SYM           {}
        | HELP_SYM              {}
        | HOST_SYM              {}
        | INSTALL_SYM           {}
        | LANGUAGE_SYM          {}
        | NO_SYM                {}
        | OPEN_SYM              {}
        | OPTIONS_SYM           {}
        | OWNER_SYM             {}
        | PARSER_SYM            {}
        | PORT_SYM              {}
        | PREPARE_SYM           {}
        | REMOVE_SYM            {}
        | REPAIR                {}
        | RESET_SYM             {}
        | RESTORE_SYM           {}
        | ROLLBACK_SYM          {}
        | SAVEPOINT_SYM         {}
        | SECURITY_SYM          {}
        | SERVER_SYM            {}
        | SIGNED_SYM            {}
        | SOCKET_SYM            {}
        | SLAVE                 {}
        | SONAME_SYM            {}
        | START_SYM             {}
        | STOP_SYM              {}
        | TRUNCATE_SYM          {}
        | UNICODE_SYM           {}
        | UNINSTALL_SYM         {}
        | WRAPPER_SYM           {}
        | XA_SYM                {}
        | UPGRADE_SYM           {}
        ;

/*
 * Keywords that we allow for labels in SPs.
 * Anything that's the beginning of a statement or characteristics
 * must be in keyword above, otherwise we get (harmful) shift/reduce
 * conflicts.
 */
keyword_sp:
          ACTION                   {}
        | ADDDATE_SYM              {}
        | AFTER_SYM                {}
        | AGAINST                  {}
        | AGGREGATE_SYM            {}
        | ALGORITHM_SYM            {}
        | ANALYSE_SYM              {}
        | ANY_SYM                  {}
        | AT_SYM                   {}
        | AUTO_INC                 {}
        | AUTOEXTEND_SIZE_SYM      {}
        | AVG_ROW_LENGTH           {}
        | AVG_SYM                  {}
        | BINLOG_SYM               {}
        | BIT_SYM                  {}
        | BLOCK_SYM                {}
        | BOOL_SYM                 {}
        | BOOLEAN_SYM              {}
        | BTREE_SYM                {}
        | CASCADED                 {}
        | CATALOG_NAME_SYM         {}
        | CHAIN_SYM                {}
        | CHANGED                  {}
        | CIPHER_SYM               {}
        | CLIENT_SYM               {}
        | CLASS_ORIGIN_SYM         {}
        | COALESCE                 {}
        | CODE_SYM                 {}
        | COLLATION_SYM            {}
        | COLUMN_NAME_SYM          {}
        | COLUMN_FORMAT_SYM        {}
        | COLUMNS                  {}
        | COMMITTED_SYM            {}
        | COMPACT_SYM              {}
        | COMPLETION_SYM           {}
        | COMPRESSED_SYM           {}
        | CONCURRENT               {}
        | CONNECTION_SYM           {}
        | CONSISTENT_SYM           {}
        | CONSTRAINT_CATALOG_SYM   {}
        | CONSTRAINT_SCHEMA_SYM    {}
        | CONSTRAINT_NAME_SYM      {}
        | CONTEXT_SYM              {}
        | CPU_SYM                  {}
        | CUBE_SYM                 {}
        /*
          Although a reserved keyword in SQL:2003 (and :2008),
          not reserved in MySQL per WL#2111 specification.
        */
        | CURRENT_SYM              {}
        | CURSOR_NAME_SYM          {}
        | DATA_SYM                 {}
        | DATAFILE_SYM             {}
        | DATETIME                 {}
        | DATE_SYM                 {}
        | DAY_SYM                  {}
        | DEFAULT_AUTH_SYM         {}
        | DEFINER_SYM              {}
        | DELAY_KEY_WRITE_SYM      {}
        | DES_KEY_FILE             {}
        | DIAGNOSTICS_SYM          {}
        | DIRECTORY_SYM            {}
        | DISABLE_SYM              {}
        | DISCARD                  {}
        | DISK_SYM                 {}
        | DUMPFILE                 {}
        | DUPLICATE_SYM            {}
        | DYNAMIC_SYM              {}
        | ENDS_SYM                 {}
        | ENUM                     {}
        | ENGINE_SYM               {}
        | ENGINES_SYM              {}
        | ERROR_SYM                {}
        | ERRORS                   {}
        | ESCAPE_SYM               {}
        | EVENT_SYM                {}
        | EVENTS_SYM               {}
        | EVERY_SYM                {}
        | EXCHANGE_SYM             {}
        | EXPANSION_SYM            {}
        | EXPIRE_SYM               {}
        | EXPORT_SYM               {}
        | EXTENDED_SYM             {}
        | EXTENT_SIZE_SYM          {}
        | FAULTS_SYM               {}
        | FAST_SYM                 {}
        | FOUND_SYM                {}
        | ENABLE_SYM               {}
        | FULL                     {}
        | FILE_SYM                 {}
        | FIRST_SYM                {}
        | FIXED_SYM                {}
        | GENERAL                  {}
        | GEOMETRY_SYM             {}
        | GEOMETRYCOLLECTION       {}
        | GET_FORMAT               {}
        | GRANTS                   {}
        | GLOBAL_SYM               {}
        | HASH_SYM                 {}
        | HOSTS_SYM                {}
        | HOUR_SYM                 {}
        | IDENTIFIED_SYM           {}
        | IGNORE_SERVER_IDS_SYM    {}
        | INVOKER_SYM              {}
        | IMPORT                   {}
        | INDEXES                  {}
        | INITIAL_SIZE_SYM         {}
        | IO_SYM                   {}
        | IPC_SYM                  {}
        | ISOLATION                {}
        | ISSUER_SYM               {}
        | INSERT_METHOD            {}
        | KEY_BLOCK_SIZE           {}
        | LAST_SYM                 {}
        | LEAVES                   {}
        | LESS_SYM                 {}
        | LEVEL_SYM                {}
        | LINESTRING               {}
        | LIST_SYM                 {}
        | LOCAL_SYM                {}
        | LOCKS_SYM                {}
        | LOGFILE_SYM              {}
        | LOGS_SYM                 {}
        | MAX_ROWS                 {}
        | MASTER_SYM               {}
        | MASTER_HEARTBEAT_PERIOD_SYM {}
        | MASTER_HOST_SYM          {}
        | MASTER_PORT_SYM          {}
        | MASTER_LOG_FILE_SYM      {}
        | MASTER_LOG_POS_SYM       {}
        | MASTER_USER_SYM          {}
        | MASTER_PASSWORD_SYM      {}
        | MASTER_SERVER_ID_SYM     {}
        | MASTER_CONNECT_RETRY_SYM {}
        | MASTER_RETRY_COUNT_SYM   {}
        | MASTER_DELAY_SYM         {}
        | MASTER_SSL_SYM           {}
        | MASTER_SSL_CA_SYM        {}
        | MASTER_SSL_CAPATH_SYM    {}
        | MASTER_SSL_CERT_SYM      {}
        | MASTER_SSL_CIPHER_SYM    {}
        | MASTER_SSL_CRL_SYM       {}
        | MASTER_SSL_CRLPATH_SYM   {}
        | MASTER_SSL_KEY_SYM       {}
        | MASTER_AUTO_POSITION_SYM {}
        | MAX_CONNECTIONS_PER_HOUR {}
        | MAX_QUERIES_PER_HOUR     {}
        | MAX_SIZE_SYM             {}
        | MAX_UPDATES_PER_HOUR     {}
        | MAX_USER_CONNECTIONS_SYM {}
        | MEDIUM_SYM               {}
        | MEMORY_SYM               {}
        | MERGE_SYM                {}
        | MESSAGE_TEXT_SYM         {}
        | MICROSECOND_SYM          {}
        | MIGRATE_SYM              {}
        | MINUTE_SYM               {}
        | MIN_ROWS                 {}
        | MODIFY_SYM               {}
        | MODE_SYM                 {}
        | MONTH_SYM                {}
        | MULTILINESTRING          {}
        | MULTIPOINT               {}
        | MULTIPOLYGON             {}
        | MUTEX_SYM                {}
        | MYSQL_ERRNO_SYM          {}
        | NAME_SYM                 {}
        | NAMES_SYM                {}
        | NATIONAL_SYM             {}
        | NCHAR_SYM                {}
        | NDBCLUSTER_SYM           {}
        | NEXT_SYM                 {}
        | NEW_SYM                  {}
        | NO_WAIT_SYM              {}
        | NODEGROUP_SYM            {}
        | NONE_SYM                 {}
        | NUMBER_SYM               {}
        | NVARCHAR_SYM             {}
        | OFFSET_SYM               {}
        | OLD_PASSWORD             {}
        | ONE_SYM                  {}
        | ONLY_SYM                 {}
        | PACK_KEYS_SYM            {}
        | PAGE_SYM                 {}
        | PARTIAL                  {}
        | PARTITIONING_SYM         {}
        | PARTITIONS_SYM           {}
        | PASSWORD                 {}
        | PHASE_SYM                {}
        | PLUGIN_DIR_SYM           {}
        | PLUGIN_SYM               {}
        | PLUGINS_SYM              {}
        | POINT_SYM                {}
        | POLYGON                  {}
        | PRESERVE_SYM             {}
        | PREV_SYM                 {}
        | PRIVILEGES               {}
        | PROCESS                  {}
        | PROCESSLIST_SYM          {}
        | PROFILE_SYM              {}
        | PROFILES_SYM             {}
        | PROXY_SYM                {}
        | QUARTER_SYM              {}
        | QUERY_SYM                {}
        | QUICK                    {}
        | READ_ONLY_SYM            {}
        | REBUILD_SYM              {}
        | RECOVER_SYM              {}
        | REDO_BUFFER_SIZE_SYM     {}
        | REDOFILE_SYM             {}
        | REDUNDANT_SYM            {}
        | RELAY                    {}
        | RELAYLOG_SYM             {}
        | RELAY_LOG_FILE_SYM       {}
        | RELAY_LOG_POS_SYM        {}
        | RELAY_THREAD             {}
        | RELOAD                   {}
        | REORGANIZE_SYM           {}
        | REPEATABLE_SYM           {}
        | REPLICATION              {}
        | RESOURCES                {}
        | RESUME_SYM               {}
        | RETURNED_SQLSTATE_SYM    {}
        | RETURNS_SYM              {}
        | REVERSE_SYM              {}
        | ROLLUP_SYM               {}
        | ROUTINE_SYM              {}
        | ROWS_SYM                 {}
        | ROW_COUNT_SYM            {}
        | ROW_FORMAT_SYM           {}
        | ROW_SYM                  {}
        | RTREE_SYM                {}
        | SCHEDULE_SYM             {}
        | SCHEMA_NAME_SYM          {}
        | SECOND_SYM               {}
        | SERIAL_SYM               {}
        | SERIALIZABLE_SYM         {}
        | SESSION_SYM              {}
        | SIMPLE_SYM               {}
        | SHARE_SYM                {}
        | SHUTDOWN                 {}
        | SLOW                     {}
        | SNAPSHOT_SYM             {}
        | SOUNDS_SYM               {}
        | SOURCE_SYM               {}
        | SQL_AFTER_GTIDS          {}
        | SQL_AFTER_MTS_GAPS       {}
        | SQL_BEFORE_GTIDS         {}
        | SQL_CACHE_SYM            {}
        | SQL_BUFFER_RESULT        {}
        | SQL_NO_CACHE_SYM         {}
        | SQL_THREAD               {}
        | STARTS_SYM               {}
        | STATS_AUTO_RECALC_SYM    {}
        | STATS_PERSISTENT_SYM     {}
        | STATS_SAMPLE_PAGES_SYM   {}
        | STATUS_SYM               {}
        | STORAGE_SYM              {}
        | STRING_SYM               {}
        | SUBCLASS_ORIGIN_SYM      {}
        | SUBDATE_SYM              {}
        | SUBJECT_SYM              {}
        | SUBPARTITION_SYM         {}
        | SUBPARTITIONS_SYM        {}
        | SUPER_SYM                {}
        | SUSPEND_SYM              {}
        | SWAPS_SYM                {}
        | SWITCHES_SYM             {}
        | TABLE_NAME_SYM           {}
        | TABLES                   {}
        | TABLE_CHECKSUM_SYM       {}
        | TABLESPACE               {}
        | TEMPORARY                {}
        | TEMPTABLE_SYM            {}
        | TEXT_SYM                 {}
        | THAN_SYM                 {}
        | TRANSACTION_SYM          {}
        | TRIGGERS_SYM             {}
        | TIMESTAMP                {}
        | TIMESTAMP_ADD            {}
        | TIMESTAMP_DIFF           {}
        | TIME_SYM                 {}
        | TYPES_SYM                {}
        | TYPE_SYM                 {}
        | UDF_RETURNS_SYM          {}
        | FUNCTION_SYM             {}
        | UNCOMMITTED_SYM          {}
        | UNDEFINED_SYM            {}
        | UNDO_BUFFER_SIZE_SYM     {}
        | UNDOFILE_SYM             {}
        | UNKNOWN_SYM              {}
        | UNTIL_SYM                {}
        | USER                     {}
        | USE_FRM                  {}
        | VARIABLES                {}
        | VIEW_SYM                 {}
        | VALUE_SYM                {}
        | WARNINGS                 {}
        | WAIT_SYM                 {}
        | WEEK_SYM                 {}
        | WORK_SYM                 {}
        | WEIGHT_STRING_SYM        {}
        | X509_SYM                 {}
        | XML_SYM                  {}
        | YEAR_SYM                 {}
        ;


/*
   UNIONS : glue selects together
*/


union_clause:
          /* empty */ {}
        | union_list
        ;

union_list:
          UNION_SYM union_option
          select_init
          {
            /*
              Remove from the name resolution context stack the context of the
              last select in the union.
            */
          }
        ;

union_opt:
          /* Empty */ 
        | union_list 
        | union_order_or_limit 
        ;

opt_union_order_or_limit:
	  /* Empty */ 
	| union_order_or_limit 
	;

union_order_or_limit:
          order_or_limit
        ;

order_or_limit:
          order_clause opt_limit_clause_init
        | limit_clause
        ;

union_option:
          /* empty */ 
        | DISTINCT 
        | ALL
        ;

query_specification:
          SELECT_SYM select_init2_derived
	  {
	  }
        | '(' select_paren_derived ')'
        ;

query_expression_body:
          query_specification opt_union_order_or_limit
        | query_expression_body
          UNION_SYM union_option 
          query_specification
          opt_union_order_or_limit
        ;

/* Corresponds to <query expression> in the SQL:2003 standard. */
subselect:
          subselect_start query_expression_body subselect_end
        ;

subselect_start:
        ;

subselect_end:
          {
          }
        ;

opt_query_expression_options:
          /* empty */
        | query_expression_option_list
        ;

query_expression_option_list:
          query_expression_option_list query_expression_option
        | query_expression_option
        ;

query_expression_option:
          STRAIGHT_JOIN 
        | HIGH_PRIORITY
        | DISTINCT     
        | SQL_SMALL_RESULT
        | SQL_BIG_RESULT 
        | SQL_BUFFER_RESULT
        | SQL_CALC_FOUND_ROWS
        | ALL 
        ;

opt_select_from:
          opt_limit_clause {}
        | select_from select_lock_type
        ;

opt_var_ident_type:
          /* empty */  
        | GLOBAL_SYM '.'
        | LOCAL_SYM '.'  
        | SESSION_SYM '.' 
        ;

opt_wild:
          /* empty */ {}
        | '.' '*' {}
        ;

field_length:
          '(' LONG_NUM ')'    
        | '(' ULONGLONG_NUM ')'
        | '(' DECIMAL_NUM ')'  
        | '(' NUM ')'           

func_datetime_precision:
          /* empty */     
        | '(' ')'     
        | '(' NUM ')'
           {
           }
        ;

type_datetime_precision:
          /* empty */ 
        | '(' NUM ')'   
        ;

%%
int main(void)
{
	using namespace std;
	//yydebug = 1;
	int parseResult = yyparse();
	//cout<<"Parse Returned: "<<parseResult<<endl;
	set<string>::iterator it;
	//cout<<"OUTPUT:"<<endl;
	ofstream createQueryFile("intermediate_create_queries", ios::out);

	if(!createQueryFile)
	{
		cout<<"Error while opening the file for writint intermediate create queries"<<endl;
		exit(1);
	}

	for (qTableAliasMap_it = qTableAliasMap.begin(); qTableAliasMap_it!=qTableAliasMap.end(); ++qTableAliasMap_it)
	{
		qTable *qt = qTableAliasMap_it->second;
                if(!(qt->tableName.empty()))
		{
			createQueryFile<<"create table if not exist "<< qt->tableName <<" ( ";		
			//cout<<"Table Name: "<<qt->tableName<<endl;
			//cout<<"Table Alias: "<<qt->tableAlias<<endl;
			set<string>::iterator columnSet_it;
			int columnCount=qt->columnSet.size();
			for(columnSet_it=qt->columnSet.begin(); columnSet_it!=qt->columnSet.end(); ++columnSet_it)
			{
				//cout<<*columnSet_it<<" ";
				createQueryFile<<*columnSet_it<< " int";
				if(columnCount>1)
				{
					createQueryFile<<", ";
					columnCount -= 1;
				}
			}
			createQueryFile<<" ) engine=qa_blackhole;"<<endl;
			//cout<<endl;

		}
	}
	createQueryFile.close();
	return 0;
}
void yyerror(string s)
{
  std::cout<< s <<std::endl;
}

