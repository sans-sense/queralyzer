%{
#include "q_table.h"
#include "q_parser.h"

#define yyparse         q_sql_parse
#define yylex           q_sql_lex
#define yyerror         q_sql_error
#define yylineno        q_sql_lineno
#define yylval          q_sql_lval
#define yychar          q_sql_char
#define yydebug         q_sql_debug
#define yynerrs         q_sql_nerrs

#define yyterminate() return 0 

#define SYM(A) A,0 
#define array_elements(A) ((uint) (sizeof(A)/sizeof(A[0])))
extern char yyerrtext[4024];

typedef struct _symbol
{
    char *name;
    uint tok;
    uint length;
} SYMBOL;

static SYMBOL symbols[]=
{
{"SELECT", SYM(SELECT_SYM)},
{"FROM", SYM(FROM)},
{"WHERE", SYM(WHERE)},
{"HAVING", SYM(HAVING)},
{"GROUP", SYM(GROUP_SYM)},
{"ORDER", SYM(ORDER_SYM)},
{"BY", SYM(BY)},
{"DESCRIBE", SYM(DESCRIBE)},
{"EXPLAIN", SYM(DESCRIBE)},
{"DESC", SYM(DESCRIBE)},
{"JOIN", SYM(JOIN_SYM)},
{"UNION", SYM(UNION_SYM)},
{"BETWEEN", SYM(BETWEEN_SYM)},
{"AND", SYM(AND_SYM)},
{"AS", SYM(AS)},
{"IN", SYM(IN_SYM)},
{"ON", SYM(ON)},
{"INTO", SYM(INTO)},
{"ALL", SYM(ALL)},
{"DISTINCT", SYM(DISTINCT)},
{"CURDATE", SYM(CURDATE)},
{"CURTIME", SYM(CURTIME)},
{"INTERVAL", SYM(INTERVAL_SYM)},
{"DATE_ADD", SYM(DATE_ADD_INTERVAL)},
{"DATE_SUB", SYM(DATE_SUB_INTERVAL)},
{"ADDDATE", SYM(ADDDATE_SYM)},
{"BIT_AND", SYM(BIT_AND)},
{"BIT_OR", SYM(BIT_OR)},
{"BIT_XOR", SYM(BIT_XOR)},
{"CAST", SYM(CAST_SYM)},
{"SUM", SYM(SUM_SYM)},
{"SYSDATE", SYM(SYSDATE)},
{"SYSTEM_USER", SYM(USER)},
{"SUBDATE", SYM(SUBDATE_SYM)},
{"AVG", SYM(AVG_SYM)},
{"COUNT", SYM(COUNT_SYM)},
{"SUM", SYM(SUM_SYM)},
{"DATE", SYM(DATE_SYM)},
{"DATETIME", SYM(DATETIME)},
{"CURRENT_DATE", SYM(CURDATE)},
{"CURRENT_TIME", SYM(CURTIME)},
{"CURRENT_TIMESTAMP", SYM(NOW_SYM)},
{"DAY", SYM(DAY_SYM)},
{"DAY_HOUR", SYM(DAY_HOUR_SYM)},
{"DAY_MICROSECOND", SYM(DAY_MICROSECOND_SYM)},
{"DAY_MINUTE", SYM(DAY_MINUTE_SYM)},
{"DAY_SECOND", SYM(DAY_SECOND_SYM)},
{"EVENT", SYM(EVENT_SYM)},
{"EVENTS", SYM(EVENTS_SYM)},
{"CURRENT_USER", SYM(CURRENT_USER)},
{"NOT", SYM(NOT_SYM)},
{"SUBSTRING", SYM(SUBSTRING)},
{"SUBSTR", SYM(SUBSTRING)},
{"TRIM", SYM(TRIM)},
{"MATCH", SYM(MATCH)},
{"AGAINST", SYM(AGAINST)},
{"LEFT", SYM(LEFT)},
{"RIGHT", SYM(RIGHT)},
{"STRAIGHT_JOIN", SYM(STRAIGHT_JOIN)},
{"INNER", SYM(INNER_SYM)},
{"INOUT", SYM(INOUT_SYM)},
{"LIKE", SYM(LIKE)},
{"EXISTS", SYM(EXISTS)},
{"OUTER", SYM(OUTER)},
{"MAX_ROWS", SYM(MAX_ROWS)},
{"MAX_SIZE", SYM(MAX_SIZE_SYM)},
{"MAX_UPDATES_PER_HOUR", SYM(MAX_UPDATES_PER_HOUR)},
{"MAX_USER_CONNECTIONS", SYM(MAX_USER_CONNECTIONS_SYM)},
{"MAXVALUE", SYM(MAX_VALUE_SYM)},
{"MAX", SYM(MAX_SYM)},
{"MID", SYM(SUBSTRING)},    /* unireg function */
{"MIN", SYM(MIN_SYM)},
{"NOW", SYM(NOW_SYM)},
{"POSITION", SYM(POSITION_SYM)},
{"SESSION_USER", SYM(USER)},
{"STD", SYM(STD_SYM)},
{"STDDEV", SYM(STD_SYM)},
{"STDDEV_POP", SYM(STD_SYM)}
};

void load_symbols()
{
    for(uint i=0; i<array_elements(symbols);i++)
    {
        symbols[i].length=strlen(symbols[i].name);
    }
}

int resword(char *ip)
{
    char *input = NULL;
    uint ip_length = 0;
    if (ip!=NULL)
    {
        ip_length=strlen(ip);
        input = strdup(ip);
        for(int i=0; i<ip_length; i++)
        {
            input[i] = toupper(ip[i]);
        }
        for(uint i=0; i<array_elements(symbols);i++)
        {
            if ((symbols[i].length==ip_length) && (!strncmp(symbols[i].name, input, symbols[i].length)))
            {
                return (int)(symbols[i].tok);
            }
        }
    }
    return -1;
}

%}

%%

[a-zA-Z%_]*               {   int i;
                            strcat(yyerrtext, yytext);
                            strcat(yyerrtext, " ");
                            if((i = resword(yytext)) == -1)
                            {
                                yylval.cptr=strdup(yytext);
                                return IDENT;                    
                            }
                            else
                            {
                                return i;
                            }
                        }
"<"                     {   strcat(yyerrtext, yytext);return LT;}
">"                     {   strcat(yyerrtext, yytext);return GT_SYM;}
"<="                    {   strcat(yyerrtext, yytext);return LE;}
">="                    {   strcat(yyerrtext, yytext);return GE;}
"="                     {   strcat(yyerrtext, yytext);return EQ;}
"!="                    {   strcat(yyerrtext, yytext);return NE;}
"<>"                    {   strcat(yyerrtext, yytext);return NE;}
"<=>"                   {   strcat(yyerrtext, yytext);return EQUAL_SYM;}
"<<"                    {   strcat(yyerrtext, yytext);return SHIFT_LEFT;}
">>"                    {   strcat(yyerrtext, yytext);return SHIFT_RIGHT;}
"&&"                    {   strcat(yyerrtext, yytext);return AND_AND_SYM;}
"||"                    {   strcat(yyerrtext, yytext);return OR_OR_SYM;}
[a-zA-Z0-9_$]* 	        {   strcat(yyerrtext, yytext);
                            strcat(yyerrtext, " ");
                            yylval.cptr=strdup(yytext); 
                            return IDENT;
                        }

[.,*{}()+-/%&|~^!@;]   	{   strcat(yyerrtext, yytext);
                            //strcat(yyerrtext, " ");
                            return *yytext; 
                        }
[\n]     	            {   strcat(yyerrtext, yytext);
                            strcat(yyerrtext, " ");
                            return END_QUERY;
                        }
.            	;
%%
int yywrap(void)
{
	//printf("reached end of file\n");
	return 1;
}

