%{
#define YYSTYPE char*
#include "y.tab.h"
#include "tabela.h"
#include <stdlib.h>
#include <string.h>

int line_num = 1;
void lexemefoundErroSintatico();
void instalarNaTS();

extern void Instala(char* X, simbolo_t atribut);
FILE *saida;

extern simbolo_t tabela_simbolos[TAB_SIZE];

%}

%%

 /******  Palavras Reservadas ***********/
while                           { lexemefound("palavra chave"); return WHILE; }
if                              { lexemefound("palavra chave"); return IF; }
else                            { lexemefound("palavra chave"); return ELSE; }
"begin"							{ lexemefound("palavra chave"); return BEG; }
"boolean"						{ lexemefound("palavra chave"); return BOOLEAN; }
"char"							{ lexemefound("palavra chave"); return CHAR; }
"do"							{ lexemefound("palavra chave"); return DO; }
"end"							{ lexemefound("palavra chave"); return END; }
"false"							{ lexemefound("palavra chave"); return FALSE; }
"endif"							{ lexemefound("palavra chave"); return ENDIF; }
"endwhile"						{ lexemefound("palavra chave"); return ENDWHILE; }
"exit"							{ lexemefound("palavra chave"); return EXIT; }
"integer"						{ lexemefound("palavra chave"); return INTEGER; }
"procedure"						{ lexemefound("palavra chave"); return PROCEDURE; }
"program"                      	{ lexemefound("palavra chave"); return PROGRAM; }
"reference"						{ lexemefound("palavra chave"); return REFERENCE; }
"repeat"						{ lexemefound("palavra chave"); return REPEAT; }
"read"							{ lexemefound("palavra chave"); return READ; }
"return"						{ lexemefound("palavra chave"); return RETURN; }
"then"							{ lexemefound("palavra chave"); return THEN; }
"true"							{ lexemefound("palavra chave"); return TRUE; }
"type"							{ lexemefound("palavra chave"); return TYPE; }
"until"							{ lexemefound("palavra chave"); return UNTIL; }
"value"							{ lexemefound("palavra chave"); return VALUE; }
"write"							{ lexemefound("palavra chave"); return WRITE; }

	/******  Operadores ***********/
[|]							{ lexemefound("operador"); return OR; }
&							{ lexemefound("operador"); return AND; }
[<]							{ lexemefound("operador"); return LT; }
[>]							{ lexemefound("operador"); return GT; }
[=]							{ lexemefound("operador"); return EQ; }
[<][=]						{ lexemefound("operador"); return LE; }
[>][=]						{ lexemefound("operador"); return GE; }
"not"[=]					{ lexemefound("operador"); return NE; }
"not"						{ lexemefound("operador"); return NOT; }
[+]						    { lexemefound("operador"); return PLUS; }
[-]							{ lexemefound("operador"); return MINUS; }
[*]							{ lexemefound("operador"); return MULT; }
[/]							{ lexemefound("operador"); return DIV; }
[*]{2}						{ lexemefound("operador"); return EXP; }


[:][=]							{ lexemefound("atribuicao"); return ATTRIB; }
	
	/******  Caracteres Especiais ***********/
[:]							{ lexemefound("caractere especial"); return DOUBLEDOTS; }
[,]							{ lexemefound("caractere especial"); return COLON; }
[;]							{ lexemefound("caractere especial"); return SEMICOLON; }
[(]							{ lexemefound("caractere especial"); return OPENPAR; }
[)]							{ lexemefound("caractere especial"); return CLOSEPAR; }

	/******  Comentários ***********/
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       		{} /* Comentário não é para ser impresso como lexema */
[/][*]                                    		{ printf("\tErro lexico, comentario nao finalizado\n"); exit(1); }


	/******  Identificador ***********/
[a-zA-Z][a-zA-Z0-9_]* {	
						lexemefound("identificador");
						instalarNaTS();
						yylval = strdup(yytext);
						return IDENTIFIER; }

	/******  Numeros ***********/
[0-9]+ { lexemefound("valor"); yylval =  strdup(yytext); return NUM; }

	/******  Espaços em branco e quebra de linhas ***********/
[ ] { lexemefound("espaco em branco"); }
[\t] { lexemefound("espaco em branco"); }
[\r] { lexemefound("espaco em branco"); }

\n { fprintf(saida, "\n%d ", line_num + 1); printf("\n%d ", line_num + 1); line_num++; }

	/******  Padrão desconhecido ***********/
.  { printf("\n***** Erro lexico, padrao nao identificado na linha: %d *****\n", line_num); exit(1); }

%%

/*** seção de código C ***/

/******  Função que imprime o código na tela do programa fonte ***********/
void lexemefound(char *tipo){
	//printf("lexema %s: %s \tna linha %d\n", tipo, yytext, line_num);
	printf("%s", yytext);

	// Gravar o código do programa fonte em um arquivo de saída 
	fprintf(saida, "%s", yytext);
}

/******  Função que imprime o último lexema onde foi identificado um erro sintático próximo ***********/
void lexemefoundErroSintatico(){
	printf("%s *****\n", yytext);
	fprintf(saida, "%s *****\n", yytext);
}

/******  Função que instala identificadores na Tabela de Simbolos (TS) ***********/
void instalarNaTS(){
	simbolo_t *s = malloc(sizeof(simbolo_t));
	strcpy(s->nome, strdup(yytext));
	Instala(s->nome, *s);
}
