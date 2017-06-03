/*** seção de definição ***/
%{

int qtdLexema = 0;
int linha = 1;
int qtdErros = 0;
FILE *saida;
/* definicoes de constantes manifestas */

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
{positivo}          { printf("%4d lexema: %s \tna linha %d\n", qtdLexema + 1, yytext, linha);
                      fprintf(saida, "%4d lexema: %s \tna linha %d\n", qtdLexema + 1, yytext, linha);
                      qtdLexema++;
                    }
\n linha++;
\{|\}                   { printf("\tErro na linha: %d \tcaractere desconhecido: %s \n", linha, yytext);
                      fprintf(saida, "\tErro na linha: %d \tcaractere desconhecido: %s \n", linha, yytext);
                      qtdErros++;
                    }
.	;				/* Qualquer caractere exceto \n", assim sempre saltará de linha quando não identificar uma entrada,
                     não imprimindo nada na tela*/

%%

/*** seção de código C ***/


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

