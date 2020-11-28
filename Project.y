/*_____________________C DECLARATIONS_____________________*/

%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

typedef struct node
{
	char *token;
	node *left;
	node *center;
	node *right;
} node;

node *mknode (char *token, node *left, node* middle, node *right);
void printtree (node *tree, int tab);
#define YYSTYPE struct node*
%}

/*_____________________YACC DECLARATIONS_____________________*/

%token BOOLEAN, INTEGER, CHARACTER, REAL, STRING, INT_P, CHAR_P, REAL_P, VAR, FUNC, PROC, IDENTIFIER
%token IF, ELSE, WHILE
%token RETURN, NULL
%token AND, DIV, ASS, EQL, BIG, BIG_EQ, SML, SML_EQ, OR, ADD, MUL, AMP, CAR, SEMI, COL, COMMA, ABS, L_BRACE, R_BRACE, L_PARENTHESE, R_PARENTHESE, L_BRACKET, R_BRACKET
%token BOOL_VAR, CHAR_VAR, INT_VAR, REAL_VAR, STRING_VAR


%right ASS SEMI NOT
%left L_PARENTHESE R_PARENTHESE
%left EQL BIG BIG_EQ SML SML_EQ NOT_EQ
%left ADD SUB AND OR
%left MUL DIV

/*_____________________GRAMMER RULES_____________________*/

%%
s: main {printtree($1, 0);};

main: proc_or_func main_proc
	| main_proc;


/*-------PROCEDURES-------*/
proc_or_func: proc | func;

proc: PROC id L_PARENTHESE args R_PARENTHESE L_BRACE body R_BRACE;

func: FUNC id L_PARENTHESE args R_PARENTHESE RETURN var_type L_BRACE body R_BRACE;

main_proc: PROC MAIN L_PARENTHESE R_PARENTHESE L_BRACE body R_BRACE;

args: args_insertion | ;

args_insertion: id COMMA args_insertion
	| id COL var_type SEMI args_insertion
	| id COL var_type;

body: ;

/*-------DECLARATION-------*/

var_declare: VAR var_id COL var_type SEMI;

string_declare: VAR var_id COL STRING L_BRACKET num R_BRACKET;

var_id: id | id COMMA var_id;

var_type: BOOLEAN
	| INTEGER
	| CHARACTER
	| REAL
	| INT_P
	| CHAR_P
	| REAL_P;

/*-------STATEMENTS-------*/

statements: statement statements
	| statement
	| return_statement;
	
statement: if_statement
	| while_statement
	| assignment_statement;

if_statement: IF L_PARENTHESE EXP R_PARENTHESE L_BRACE body R_BRACE
	| IF L_PARENTHESE EXP R_PARENTHESE L_BRACE body R_BRACE ELSE L_BRACE body R_BRACE
	| IF L_PARENTHESE EXP R_PARENTHESE statement
	| IF L_PARENTHESE EXP R_PARENTHESE statement ELSE statement;

while_statement: WHILE L_PARENTHESE EXP R_PARENTHESE L_BRACE body R_BRACE
	| WHILE L_PARENTHESE EXP R_PARENTHESE statement;

return_statement: RETURN exp SEMI;

assignment_statement: id ASS exp SEMI;

func_proc_call: id L_PARENTHESE args R_PARENTHESE;

/*-------EXPRESSIONS-------*/

exp: exp OR exp {$$ = mknode("||", $1, NULL, $3);}
	| exp AND exp {$$ = mknode("&&", $1, NULL, $3);}
	| exp EQL exp {$$ = mknode("==", $1, NULL, $3);}
	| exp SML exp {$$ = mknode("<", $1, NULL, $3);}
	| exp SML_EQ exp {$$ = mknode("<=", $1, NULL, $3);}
	| exp BIG exp {$$ = mknode(">", $1, NULL, $3);}
	| exp BIG_EQ exp {$$ = mknode(">=", $1, NULL, $3);}
	| exp NOT_EQ exp {$$ = mknode("!=", $1, NULL, $3);}
	| NOT exp {$$ = mknode("!", NULL, NULL, $2);}
	| exp ADD exp {$$ = mknode("+", $1, NULL, $3);}
	| exp SUB exp {$$ = mknode("-", $1, NULL, $3;}
	| exp MUL exp {$$ = mknode("*", $1, NULL, $3);}
	| exp DIV exp {$$ = mknode("/", $1, NULL, $3);}
	| const
	| pointers
	| L_PARENTHESE exp R_PARENTHESE;

const: num | boolean | string | char | id | pointers | func_proc_call ;

id: ID {$$ = mknode(yytext, NULL, NULL, NULL);};

pointers: CAR id
	| AMP id
	| AMP id L_BRACKET num R_BRACKET;
	
num: INT_VAR {$$ = mknode(yytext, NULL, NULL, NULL);}
	| REAL_VAR {$$ = mknode(yytext, NULL, NULL, NULL);};

boolean: BOOL_VAR {$$ = mknode(yytext, NULL, NULL, NULL);};
	
string: STRING_VAR {$$ = mknode(yytext, NULL, NULL, NULL);};

char: CHAR_VAR {$$ = mknode(yytext, NULL, NULL, NULL);};
	
%%

/*_____________________ADDITIONAL C CODE_____________________*/

#include "lex.yy.c"

int main()
{
	return yyparse();
}

node *mknode(char *token, node *left, node *center, node *right)
{
	node *newnode = (node*)malloc (sizeof(node));
	char *newstr = (char*)malloc (sizeof(token) + 1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->middle = middle;
	newnode->right = right;
	newnode->token = newstr;
	return newnode;
}

void printtree(node *tree, int tab_num)
{
	for(int i = 0; i < tab_num; i++)
		printf("\t");
	printf("%s\n", tree->token);
	if(tree->left)
		printtree(tree->left, tab_num + 1);
	if(tree->middle)
		printtree(tree->middle), tab_num + 1;
	if(tree->right)
		printtree(tree->right, tab_num + 1);
}

int yyerror()
{
	printf("MY ERROR\n");
	return 0;
}



