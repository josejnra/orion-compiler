%{
#define YYSTYPE char*
#include "y.tab.h"
char* mycat(char* orig, char* s);
int line_num = 1;
void lexemefoundSintatico();
%}

%%

while                           {lexemefound("palavra chave"); yylval = strdup(yytext); return WHILE; }
if                              {lexemefound("palavra chave"); yylval = strdup(yytext); return IF; }
else                            {lexemefound("palavra chave"); yylval = strdup(yytext); return ELSE; }
"begin"							{lexemefound("palavra chave"); yylval = strdup(yytext); return BEG; }
"boolean"						{lexemefound("palavra chave"); yylval = strdup(yytext); return BOOLEAN;}
"char"							{lexemefound("palavra chave"); yylval = strdup(yytext); return CHAR_LITERAL;}
"do"							{lexemefound("palavra chave"); yylval = strdup(yytext); return DO;}
"end"							{lexemefound("palavra chave"); yylval = strdup(yytext); return END;}
"false"							{lexemefound("palavra chave"); yylval = strdup(yytext); return FALSE;}
"endif"							{lexemefound("palavra chave"); yylval = strdup(yytext); return ENDIF;}
"endwhile"						{lexemefound("palavra chave"); yylval = strdup(yytext); return ENDWHILE;}
"exit"							{lexemefound("palavra chave"); yylval = strdup(yytext); return EXIT;}
"integer"						{lexemefound("palavra chave"); yylval = strdup(yytext); return INTEGER;}
"procedure"						{lexemefound("palavra chave"); yylval = strdup(yytext); return PROCEDURE;}
"program"                      	{lexemefound("palavra chave"); yylval = strdup(yytext); return PROGRAM;}
"reference"						{lexemefound("palavra chave"); yylval = strdup(yytext); return REFERENCE;}
"repeat"						{lexemefound("palavra chave"); yylval = strdup(yytext); return REPEAT;}
"read"							{lexemefound("palavra chave"); yylval = strdup(yytext); return READ;}
"return"						{lexemefound("palavra chave"); yylval = strdup(yytext); return RETURN;}
"then"							{lexemefound("palavra chave"); yylval = strdup(yytext); return THEN;}
"true"							{lexemefound("palavra chave"); yylval = strdup(yytext); return TRUE;}
"type"							{lexemefound("palavra chave"); yylval = strdup(yytext); return TYPE;}
"until"							{lexemefound("palavra chave"); yylval = strdup(yytext); return UNTIL;}
"value"							{lexemefound("palavra chave"); yylval = strdup(yytext); return VALUE;}
"write"							{lexemefound("palavra chave"); yylval = strdup(yytext); return WRITE;}


[|]							{lexemefound("operador"); yylval = strdup(yytext); return OR;}
&							{lexemefound("operador"); yylval = strdup(yytext); return AND;}
[<]							{lexemefound("operador"); yylval = strdup(yytext); return LT;}
[>]							{lexemefound("operador"); yylval = strdup(yytext); return GT;}
[=]							{lexemefound("operador"); yylval = strdup(yytext); return EQ;}
[<][=]						{lexemefound("operador"); yylval = strdup(yytext); return LE;}
[>][=]						{lexemefound("operador"); yylval = strdup(yytext); return GE;}
"not"[=]					{lexemefound("operador"); yylval = strdup(yytext); return NE;}
"not"						{lexemefound("operador"); yylval = strdup(yytext); return NOT;}
[+]						    {lexemefound("operador"); yylval = strdup(yytext); return PLUS;}
[-]							{lexemefound("operador"); yylval = strdup(yytext); return MINUS;}
[*]							{lexemefound("operador"); yylval = strdup(yytext); return MULT;}
[/]							{lexemefound("operador"); yylval = strdup(yytext); return DIV;}
[*]{2}						{lexemefound("operador"); yylval = strdup(yytext); return EXP;}


[:][=]							{lexemefound("atribuicao"); yylval = strdup(yytext); return ATTRIB;}

[:]							{lexemefound("caractere especial"); yylval = strdup(yytext); return DOUBLEDOTS;}
[,]							{lexemefound("caractere especial"); yylval = strdup(yytext); return COLON;}
[;]							{lexemefound("caractere especial"); yylval = strdup(yytext); return SEMICOLON;}
[(]							{lexemefound("caractere especial"); yylval = strdup(yytext); return OPENPAR;}
[)]							{lexemefound("caractere especial"); yylval = strdup(yytext); return CLOSEPAR;}

[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       		{} /* Comentário não é para ser impresso como lexema */
[/][*]                                    		{printf("\tErro lexico, comentario nao finalizado\n");}


[a-zA-Z][a-zA-Z0-9_]* {lexemefound("identificador"); yylval = strdup(yytext); return IDENTIFIER;}

[0-9]+ {lexemefound("valor"); yylval =  strdup(yytext); return NUM; }

[ \t\r]+ { }

\n line_num++;

.  {printf("Erro lexico, padrao nao identificado na linha: %d\n", line_num); exit(1);}

%%

/*** seção de código C ***/
void lexemefound(char *tipo){
	printf("lexema %s: %s \tna linha %d\n", tipo, yytext, line_num);
}

void lexemefoundSintatico(){
	printf("%s\n", yytext);
}
