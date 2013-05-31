%{
#include "q_table.h"
#include "q_parser.h"

#define yyparse         q_sql_parse
#define yylex           q_sql_lex
#define yyerror         q_sql_error
#define yylval          q_sql_lval
#define yychar          q_sql_char
#define yydebug         q_sql_debug
#define yynerrs         q_sql_nerrs

#define yyterminate() return 0 

%}

%%

"explain"     	return DESCRIBE;
"describe"     	return DESCRIBE;
"desc"     	return DESCRIBE;
"select"     	return SELECT_SYM;
"from"       	return FROM;
"where"	     	return WHERE;
"having"     	return HAVING;
"order"   	return ORDER_SYM;
"join"		return JOIN_SYM;
"count"		return COUNT_SYM;
"group"		return GROUP_SYM;
"by"		return BY;
"between"	return BETWEEN_SYM;
"and"		return AND_SYM;
"as"		return AS;
"in"		return IN_SYM;
"into"		return INTO;
"all"		return ALL;
"distinct"	return DISTINCT;
"curdate"	return CURDATE;
"avg"		return AVG_SYM;
"sum"		return SUM_SYM;
"union"		return UNION_SYM;
"<"		return LT;
">"		return GT_SYM;
"<="		return LE;
">="		return GE;
"="		return EQ;
"!="		return NE;
"<>"		return NE;
"<=>"		return EQUAL_SYM;
"<<"		return SHIFT_LEFT;
">>"		return SHIFT_RIGHT;
"&&" 		return AND_AND_SYM;
"||"		return OR_OR_SYM;
[a-zA-Z0-9_$]* 	yylval.cptr=strdup(yytext); return IDENT;
[.,*{}()+-/%&|~^!@;]   	/*yylval.cptr=strdup(yytext);*/ return *yytext; 
[\n]     	return END_QUERY;
.            	;
%%
int yywrap(void)
{
	//printf("reached end of file\n");
	return 1;
}

