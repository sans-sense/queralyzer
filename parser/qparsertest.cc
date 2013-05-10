#include <iostream>
extern int queralyzer_parser(const char* str);
/*TODO */
int main()
{
	int parserResult = 1;
	parserResult= queralyzer_parser("select t.c1, t.c2 from table t where t.c3 = 1;\n");
	return parserResult;

}
