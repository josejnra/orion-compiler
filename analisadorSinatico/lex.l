/*** seção de definição ***/
%{
	/* definicoes de constantes manifestas */

#include "y.tab.h"
int qtdLexema = 0;
int linha = 1;
int qtdErros = 0;

FILE *saida;

extern void yyerror(const char *err);
extern void lexemefound();

%}

/* This tells flex to read only one input file */
%option noyywrap

/* definicoes regulares */

delim   		[ \t]
ws      		{delim}+
letter			[A-Za-z]
constante       	-?[0-9]+
valor           	-?(([0-9]+)|([0-9]*\.[0-9]+))
digit			[0-9]
number			{digit}+
positivo		\+?{number}
word			{letter}+
sufixoidentificador   	{letter}|{digit}

%%
	/*** seção de regras ***/
{ws}    			{/*nenhuma acao e nenhum retorno*/}

	/*Seção 2.1.1 - Identificadores (palavras chave)*/
"begin"							{lexemefound("palavra chave"); return BEG;}
"boolean"						{lexemefound("palavra chave"); return BOOLEAN;}
"char"							{lexemefound("palavra chave"); return CHAR_LITERAL;}
"do"							{lexemefound("palavra chave"); return DO;}
"else"							{lexemefound("palavra chave"); return ELSE;}
"end"							{lexemefound("palavra chave"); return END;}
"false"							{lexemefound("palavra chave"); return FALSE;}
"endif"							{lexemefound("palavra chave"); return ENDIF;}
"endwhile"						{lexemefound("palavra chave"); return ENDWHILE;}
"exit"							{lexemefound("palavra chave"); return EXIT;}
"if"							{lexemefound("palavra chave"); return IF;}
"integer"						{lexemefound("palavra chave"); return INTEGER;}
"procedure"						{lexemefound("palavra chave"); return PROCEDURE;}
"program"                      				{lexemefound("palavra chave"); return PROGRAM;}
"reference"						{lexemefound("palavra chave"); return REFERENCE;}
"repeat"						{lexemefound("palavra chave"); return REPEAT;}
"read"							{lexemefound("palavra chave"); return READ;}
"return"						{lexemefound("palavra chave"); return RETURN;}
"then"							{lexemefound("palavra chave"); return THEN;}
"true"							{lexemefound("palavra chave"); return TRUE;}
"type"							{lexemefound("palavra chave"); return TYPE;}
"until"							{lexemefound("palavra chave"); return UNTIL;}
"value"							{lexemefound("palavra chave"); return VALUE;}
"write"							{lexemefound("palavra chave"); return WRITE;}
"while"							{lexemefound("palavra chave"); return WHILE;}

	/*Seção 2.1.8 - Expressões */
[|]							{lexemefound("operador"); return OR;}
&							{lexemefound("operador"); return AND;}
[<]							{lexemefound("operador"); return LE;}
[>]							{lexemefound("operador"); return GT;}
[=]							{lexemefound("operador"); return EQ;}
[<][=]							{lexemefound("operador"); return LT;}
[>][=]							{lexemefound("operador"); return GE;}
"not"[=]						{lexemefound("operador"); return NE;}
"not"							{lexemefound("operador"); return NOT;}
[+]							{lexemefound("operador"); return PLUS;}
[-]							{lexemefound("operador"); return MINUS;}
[*]							{lexemefound("operador"); return MULT;}
[/]							{lexemefound("operador"); return DIV;}
[*]{2}							{lexemefound("operador"); return EXP;}

	/*Seção 2.1.12 - Atribuição */
[:][=]							{lexemefound("atribuicao"); return ATTRIB;}

	/*Outros caracteres...*/
[:]							{lexemefound("caractere especial"); return DOUBLEDOTS;}
[,]							{lexemefound("caractere especial"); return COLON;}
[;]							{lexemefound("caractere especial"); return SEMICOLON;}
 /* [']							{lexemefound("caractere especial"); return SIMPLEASPAS;} */
[(]							{lexemefound("caractere especial"); return OPENPAR;}
[)]							{lexemefound("caractere especial"); return CLOSEPAR;}

	/* 2.1.3 Comentários */
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       		{} /* Comentário não é para ser impresso como lexema */
[/][*]                                    		{printf("\tErro na linha: %d \tComentario não finalizado: %s \n", linha, yytext);
							fprintf(saida, "\tErro na linha: %d \tComentario não finalizado: %s \n", linha, yytext);
							qtdErros++;  }

	/*Seção 2.1.1 - Identificadores de tamanho 32 no máximo*/
{letter}{sufixoidentificador}{0,31}          		lexemefound("identificador");


    /* 2.1.2 Constantes */
{constante}       					lexemefound("constante");
 /* {valor}           lexemefound("valor"); */

	/* conta linhas */
\n linha++;
	

	/* erro de sintaxe */
.		yyerror("erro de sintaxe"); 		/* Ao encontrar um caractere, e este não se encaixar em nenhuma entrada, será identificado como um erro */
%%

/*** seção de código C ***/
void lexemefound(char *tipo)
{ 
	printf("%4d lexema %s: %s \tna linha %d\n", qtdLexema + 1, tipo, yytext, linha);
        fprintf(saida, "%4d lexema %s: %s \tna linha %d\n", qtdLexema + 1, tipo, yytext, linha);
        qtdLexema++;
}

void yyerror(const char *err)
{
	printf("\tErro na linha: %d \tcaractere desconhecido ou padrao nao encontrado: %s \n", linha, yytext);
	fprintf(saida, "\tErro na linha: %d \tcaractere desconhecido ou padrao nao encontrado: %s \n", linha, yytext);
	qtdErros++;     
}

/*int main(int argc, char *argv[]){
     /*executa o analisador léxico. 
	saida = fopen("saida.txt", "w");
	if(argc == 2){		
		yyin = fopen(argv[1], "r");
		if(yyin == NULL){
			printf("\tArquivo nao encontrado!\n");
			return 0;
		}	
		yylex();
		fclose(yyin);		
	}else{
		yylex();
	}

	printf("\tNumero total de lexemas reconhecidos = %d\n", qtdLexema);
	fprintf(saida, "\tNumero total de lexemas reconhecidos = %d\n", qtdLexema);
	printf("\tNumero total de erros = %d\n", qtdErros);
	fprintf(saida, "\tNumero total de erros = %d\n", qtdErros);

	fclose(saida);
    return 0;
}*/
