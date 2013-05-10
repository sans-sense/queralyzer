#include<string>
#include<set>
using namespace std;
class qTable{
public:
	qTable():tableName(""),tableAlias(""),noColumnFound(false), columnCount(0){
	}
	string tableName;
	string tableAlias;
	set<string> columnSet;	
	bool noColumnFound;
	int columnCount;
};
