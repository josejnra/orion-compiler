%{
#define YYSTYPE char*
#include "y.tab.h"
#include "tabela.h"
#include <stdlib.h>
#include <string.h>

int line_num = 1;
void lexemefoundSintatico();
void gravarSaida();
void instalarNaTS();

extern void Instala(char* X, simbolo_t atribut);
FILE *saida;

extern simbolo_t tabela_simbolos[TAB_SIZE];

%}

%%

while                           {gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return WHILE; }
if                              {gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return IF; }
else                            {gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return ELSE; }
"begin"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return BEG; }
"boolean"						{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return BOOLEAN;}
"char"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return CHAR;}
"do"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return DO;}
"end"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return END;}
"false"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return FALSE;}
"endif"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return ENDIF;}
"endwhile"						{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return ENDWHILE;}
"exit"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return EXIT;}
"integer"						{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return INTEGER;}
"procedure"						{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return PROCEDURE;}
"program"                      	{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return PROGRAM;}
"reference"						{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return REFERENCE;}
"repeat"						{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return REPEAT;}
"read"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return READ;}
"return"						{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return RETURN;}
"then"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return THEN;}
"true"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return TRUE;}
"type"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return TYPE;}
"until"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return UNTIL;}
"value"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return VALUE;}
"write"							{gravarSaida(); lexemefound("palavra chave"); yylval = strdup(yytext); return WRITE;}


[|]							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return OR;}
&							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return AND;}
[<]							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return LT;}
[>]							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return GT;}
[=]							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return EQ;}
[<][=]						{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return LE;}
[>][=]						{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return GE;}
"not"[=]					{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return NE;}
"not"						{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return NOT;}
[+]						    {gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return PLUS;}
[-]							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return MINUS;}
[*]							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return MULT;}
[/]							{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return DIV;}
[*]{2}						{gravarSaida(); lexemefound("operador"); yylval = strdup(yytext); return EXP;}


[:][=]							{gravarSaida(); lexemefound("atribuicao"); yylval = strdup(yytext); return ATTRIB;}

[:]							{gravarSaida(); lexemefound("caractere especial"); yylval = strdup(yytext); return DOUBLEDOTS;}
[,]							{gravarSaida(); lexemefound("caractere especial"); yylval = strdup(yytext); return COLON;}
[;]							{gravarSaida(); lexemefound("caractere especial"); yylval = strdup(yytext); return SEMICOLON;}
[(]							{gravarSaida(); lexemefound("caractere especial"); yylval = strdup(yytext); return OPENPAR;}
[)]							{gravarSaida(); lexemefound("caractere especial"); yylval = strdup(yytext); return CLOSEPAR;}

[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       		{} /* Comentário não é para ser impresso como lexema */
[/][*]                                    		{printf("\tErro lexico, comentario nao finalizado\n"); exit(1);}


[a-zA-Z][a-zA-Z0-9_]* {	gravarSaida();
						lexemefound("identificador");
						instalarNaTS();
						yylval = strdup(yytext);
						return IDENTIFIER;}

[0-9]+ {gravarSaida(); lexemefound("valor"); yylval =  strdup(yytext); return NUM; }

[ ] {gravarSaida(); printf(" ");}
[\t] {gravarSaida(); printf("\t");}
[\r] {gravarSaida(); printf("\r");}

\n {fprintf(saida, "\n%d ", line_num + 1); //printf("\n%d", line_num + 1); line_num++;
	}

.  {printf("\n***** Erro lexico, padrao nao identificado na linha: %d *****\n", line_num); exit(1);}

%%

/*** seção de código C ***/
void lexemefound(char *tipo){
	//printf("lexema %s: %s \tna linha %d\n", tipo, yytext, line_num);
	//printf("%s", yytext);
}

void lexemefoundSintatico(){
	printf("%s *****\n", yytext);
}

void gravarSaida(){
	fprintf(saida, "%s", yytext);
}

void instalarNaTS(){
	simbolo_t *s = malloc(sizeof(simbolo_t));
	strcpy(s->nome, strdup(yytext));
	Instala(s->nome, *s);
}
