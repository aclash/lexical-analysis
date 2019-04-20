%option noyywrap
%{
	#include <iostream>
	#include <string>
	#include <unordered_set>
	#include <vector>
	#include <stack>
	using namespace std;
    int line = 1;
	int scopeNum = -1;
	void Insert(string str);
	void MeetLeftBrace();
	void MeetRightBrace();
	void Print();
	struct Symbol {
		string str;
		int blockNum;
		Symbol(string _str, int _blockNum) {
			str = _str;
			blockNum = _blockNum;
		}
		bool operator== (const Symbol& other) const{
			return blockNum == other.blockNum && str == other.str;
		}
	};

	struct hashFunction {
		size_t operator()(const Symbol& key) const {
			size_t hashValue = 17;
			hashValue = 31 * hashValue + hash<string>()(key.str);
			hashValue = 31 * hashValue + hash<int>()(key.blockNum);
			return hashValue;
		}
	};

	unordered_set<Symbol, hashFunction> hashSet;
	vector<vector<string>> output;
	stack<int> curScope;
	int maxScope = 0;
%}

DIGIT [0-9]
INTEGER ("-")?[1-9]{DIGIT}*|0
FLOAT {INTEGER}"."({DIGIT}*)?|({INTEGER})?"."{DIGIT}*
BOOLEAN T|F
KEYWORDS "Program"|"Function"|"return"|"if"|"then"|"else"|"while"|"do"|"or"|"and"
IDENTIFIER [a-zA-Z]([a-zA-Z0-9]){0,5}
STRING "("[a-zA-Z0-9\\]+")"
SPECIAL_SYMBOLS "{"|"}"|"("|")"
COMPARISON_OPERATOR ">"|"<"|"<="|">="|"=="|"!="
PREDEFINED_FUNCTION "+"|"-"|"*"|"/"|"="|"%"|"print"
%%
\n {++line;}
{BOOLEAN} {printf("line%d: BOOLEAN: %s\n", line, yytext);}
{INTEGER} {printf("line%d: INTEGER: %s\n", line, yytext);}
{FLOAT} {printf("line%d: FLOAT: %s\n", line, yytext);}
{KEYWORDS} {printf("line%d: KEYWORDS: %s\n", line, yytext);}
{SPECIAL_SYMBOLS} { string tmp = yytext; if(tmp == "{") MeetLeftBrace(); if (tmp == "}") MeetRightBrace(); printf("line%d: SPECIAL_SYMBOLS: %s\n", line, yytext);}
{COMPARISON_OPERATOR} {printf("line%d: COMPARISON_OPERATOR: %s\n", line, yytext);}
{PREDEFINED_FUNCTION} {printf("line%d: PREDEFINED_FUNCTION: %s\n", line, yytext);}
{STRING} {printf("line%d: STRING: %s\n", line, yytext);}
{IDENTIFIER} {printf("line%d: IDENTIFIER: %s\n", line, yytext); string tmp = yytext; Insert(tmp);}
[ \t]+ {}
%%

void MeetLeftBrace(){
	++scopeNum;
	curScope.push(scopeNum);
	maxScope = max(maxScope, curScope.top());
}

void MeetRightBrace(){
	curScope.pop();
}

void Insert(string str){
	Symbol key(str, curScope.top());
	if (hashSet.count(key) == 0) {
		hashSet.insert(key);
	}
}

void Print(){
	cout << "Symbol Table as follows: " <<endl;
	output.resize(maxScope + 1);
	for (auto it = hashSet.begin(); it != hashSet.end(); ++it) {
		output[it->blockNum].push_back(it->str);
	}
	for (int i = 0; i < output.size(); ++i) {
		cout << "Scope " << i << ": ";
		for (int j = 0; j < output[i].size(); ++j) {
			cout << output[i][j] << " ";
		}
		cout << endl;
	}
}

main(){
	maxScope = 0;
	hashSet.clear();
	output.clear();
	while (!curScope.empty())
		curScope.pop();	
	yylex();
	Print();
	return 0;
}