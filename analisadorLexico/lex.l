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
constante       -?[0-9]+
valor           -?(([0-9]+)|([0-9]*\.[0-9]+))
digit			[0-9]
number			{digit}+
positivo		\+?{number}
word			{letter}+
sufixoidentificador   {letter}|{digit}

%%
	/*** seção de regras ***/
{ws}    			{/*nenhuma acao e nenhum retorno*/}

	/*Seção 2.1.1 - Identificadores (palavras chave)*/
"begin"							lexemefound("palavra chave");
"boolean"						lexemefound("palavra chave");
"char"							lexemefound("palavra chave");
"do"							lexemefound("palavra chave");
"else"							lexemefound("palavra chave");
"end"							lexemefound("palavra chave");
"false"						lexemefound("palavra chave");
"endif"							lexemefound("palavra chave");
"endwhile"						lexemefound("palavra chave");
"exit"							lexemefound("palavra chave");
"if"							lexemefound("palavra chave");
"integer"						lexemefound("palavra chave");
"procedure"					lexemefound("palavra chave");
"program"                      	lexemefound("palavra chave");
"reference"						lexemefound("palavra chave");
"repeat"						lexemefound("palavra chave");
"read"							lexemefound("palavra chave");
"return"						lexemefound("palavra chave");
"then"							lexemefound("palavra chave");
"true"							lexemefound("palavra chave");
"type"							lexemefound("palavra chave");
"until"						lexemefound("palavra chave");
"value"							lexemefound("palavra chave");
"write"							lexemefound("palavra chave");
"while"						lexemefound("palavra chave");

	/*Seção 2.1.8 - Expressões */
[|]							lexemefound("expressão");
&							lexemefound("expressão");
[<]							lexemefound("expressão");
[>]							lexemefound("expressão");
[=]							lexemefound("expressão");
[<][=]						lexemefound("expressão");
[>][=]						lexemefound("expressão");
"not"[=]					lexemefound("expressão");
"not"						lexemefound("expressão");
[+]							lexemefound("expressão");
[-]							lexemefound("expressão");
[*]							lexemefound("expressão");
[/]							lexemefound("expressão");
[*]{2}						lexemefound("expressão");

	/*Seção 2.1.12 - Atribuição */
[:][=]						lexemefound("atribuição");

	/*Outros caracteres...*/
[:]							lexemefound("caractere especial");
[,]							lexemefound("caractere especial");
[;]							lexemefound("caractere especial");
[']							lexemefound("caractere especial");
[(]							lexemefound("caractere especial");
[)]							lexemefound("caractere especial");

	/* 2.1.3 Comentários */
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       lexemefound("comentário");
[/][*]                                    { printf("\tErro na linha: %d \tComentário não finalizado: %s \n", linha, yytext);
											fprintf(saida, "\tErro na linha: %d \tComentário não finalizado: %s \n", linha, yytext);
											qtdErros++;   }

	/*Seção 2.1.1 - Identificadores de tamanho 32 no máximo*/
{letter}{sufixoidentificador}{0,31}          lexemefound("identificador");


    /* 2.1.2 Constantes */
{constante}       lexemefound("constante");
{valor}           lexemefound("valor");

	/* conta linhas */
\n linha++;
	

	/* erro de sintaxe */
.	;		error(); 		/* Ao encontrar um caractere, e este não se encaixar em nenhuma entrada, será identificado como um erro */
%%

/*** seção de código C ***/
void lexemefound(char *tipo)
{ 
	printf("%4d lexema %s: %s \tna linha %d\n", qtdLexema + 1, tipo, yytext, linha);
        fprintf(saida, "%4d lexema %s: %s \tna linha %d\n", qtdLexema + 1, tipo, yytext, linha);
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
	if(argc == 2){		
		yyin = fopen(argv[1], "r");
		if(yyin == NULL){
			printf("\tArquivo não encontrado!\n");
			return 0;
		}	
		yylex();
		fclose(yyin);		
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

