/*** seção de definição ***/
%{
	/* definicoes de constantes manifestas */

int qtdLexema = 0;
int linha = 1;
int qtdErros = 0;

FILE *saida;

extern void error();
extern void lexemefound();

%}

/* This tells flex to read only one input file */
%option noyywrap

/* definicoes regulares */

delim   		[ \t]
ws      		{delim}+
letter			[A-Za-z]
digit			[0-9]
number			{digit}+
positivo		\+?{number}
word			{letter}+


%%
	/*** seção de regras ***/
{ws}    			{/*nenhuma acao e nenhum retorno*/}
{positivo}          					lexemefound();

	/*Seção 2.1.1 - Identificadores */
"begin"							lexemefound();
"boolean "						lexemefound();
"char "							lexemefound();
"do "							lexemefound();
"else "							lexemefound();
"end"							lexemefound();
"false "						lexemefound();
"endif"							lexemefound();
"endwhile"						lexemefound();
"exit"							lexemefound();
"if "							lexemefound();
"integer "						lexemefound();
"procedure "						lexemefound();
"program"                      			 	lexemefound();
"reference"						lexemefound();
"repeat "						lexemefound();
"read "							lexemefound();
"return "						lexemefound();
"then "							lexemefound();
"true "							lexemefound();
"type "							lexemefound();
"until "						lexemefound();
"value"							lexemefound();
"write"							lexemefound();
"while "						lexemefound();

	/*Seção 2.1.8 - Expressões */
[|]							lexemefound();
&							lexemefound();
[<]							lexemefound();
[>]							lexemefound();
[=]							lexemefound();
[<][=]							lexemefound();
[>][=]							lexemefound();
"not"[=]						lexemefound();
"not"							lexemefound();
[+]							lexemefound();
[-]							lexemefound();
[*]							lexemefound();
[/]							lexemefound();
[*]{2}							lexemefound();

	/*Seção 2.1.12 - Atribuição */
[:][=]							lexemefound();

	/*Outros caracteres...*/
[:]							lexemefound();
[,]							lexemefound();
[;]							lexemefound();
[']							lexemefound();
[(]							lexemefound();
[)]							lexemefound();


	/* conta linhas */
\n linha++;
	

	/* erro de sintaxe */
.	;		error(); 		/* Ao encontrar um caractere, e este não se encaixar em nenhuma entrada, será identificado como um erro */
%%

/*** seção de código C ***/
void lexemefound()
{ 
	printf("%4d lexema: %s \tna linha %d\n", qtdLexema + 1, yytext, linha);
        fprintf(saida, "%4d lexema: %s \tna linha %d\n", qtdLexema + 1, yytext, linha);
        qtdLexema++;
}
void error()
{
	printf("\tErro na linha: %d \tcaractere desconhecido: %s \n", linha, yytext);
	fprintf(saida, "\tErro na linha: %d \tcaractere desconhecido: %s \n", linha, yytext);
	qtdErros++;     
}

int main(int argc, char *argv[]){
    /* executa o analisador léxico. */
	saida = fopen("saida.txt", "w");
	if(argc == 3){
		if(atoi(argv[1]) == 1){
			yyin = fopen(argv[2], "r");
			if(yyin == NULL){
				printf("\tArquivo não encontrado!\n");
				return 0;
			}	
			yylex();
			fclose(yyin);
		}
	}else{
		yylex();
	}

	printf("\tNúmero total de lexemas reconhecidos = %d\n", qtdLexema);
	fprintf(saida, "\tNumero total de lexemas reconhecidos = %d\n", qtdLexema);
	printf("\tNúmero total de erros = %d\n", qtdErros);
	fprintf(saida, "\tNúmero total de erros = %d\n", qtdErros);

	fclose(saida);
    return 0;
}

