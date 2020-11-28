%{
	#include<string.h>
%}

%x COMMENT

%%
bool						return BOOLEAN;
int						return INTEGER;
char						return CHARACTER;
real						return REAL;
string						return STRING;
if						return IF;
else						return ELSE;
while						return WHILE;
var						return VAR;
func						return FUNC;
proc						return PROC;
return 					return RETURN;
null						return NULL;
Main						return MAIN;


int*						return INT_P;
char*						return CHAR_P;
real*						return REAL_P;


"/%"						BEGIN(COMMENT);
<COMMENT>"%/"					BEGIN(0);
<COMMENT>\n;
<COMMENT>.;


"&&"						return AND;
"/"						return DIV;
"="						return ASS;
"=="						return EQL;
">"						return BIG;
">="						return BIG_EQ;
"<"						return SML;
"<="						return SML_EQ;
"-"						return SUB;
"!"						return NOT;
"!="						return NOT_EQ;
"||"						return OR;
"+"						return ADD;
"*"						return MUL;
"&"						return AMP;
"^"						return CAR;
";"						return SEMI;
":"						return COL;
","						return COMMA;
"|"						return ABS;
"{"						return L_BRACE;
"}"						return R_BRACE;
"("						return L_PARENTHESE;
")"						return R_PARENTHESE;
"["						return L_BRACKET;
"]"						return R_BRACKET;


true|TRUE|false|FALSE				return BOOL_VAR;
[\'].[\']					return CHAR_VAR;
[-]?[1-9][0-9]*|0[x|X][1-9A-F][0-9A-F]*	return INT_VAR;
[-]?[0-9][.][0-9]+[[eE][-+][1-9][0-9]+]?	return REAL_VAR;
[\"][^\"]*[\"]					return STRING_VAR;
0|[1-9][
[a-zA-Z][_a-zA-Z0-9]*				return IDENTIFIER;


.|\n						return yytext[0];
[ \t];


%%
