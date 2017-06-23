%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabela.h"

int yylex();          // chamar o analisador léxico
int yyerror(char *s); // impressão de erro e o analisador sintatico para

%}


%token NUM IDENTIFIER
%token BEG
%token BOOLEAN
%token CONST_CHAR
%token CHAR
%token DO
%token END
%token FALSE
%token ENDIF
%token ENDWHILE
%token EXIT
%token INTEGER
%token PROCEDURE
%token PROGRAM
%token REFERENCE
%token REPEAT
%token READ
%token RETURN
%token THEN
%token TRUE
%token TYPE
%token VALUE
%token UNTIL
%token WRITE
%token WHILE
%token ATTRIB
%token DOUBLEDOTS
%token COLON
%token SEMICOLON
%token OPENPAR
%token CLOSEPAR

%left OR
%left AND
%left LE
%left GT
%left EQ
%left LT
%left GE
%left NE
%left NOT
%left PLUS
%left MINUS
%left MULT
%left DIV
%right EXP
%right UMINUS
%left '+' '-'
%left '*' '/'
%right '='
%nonassoc IF
%nonassoc ELSE


%%
CODE: program
	;

program : PROGRAM M2 declaracoes M0 bloco 
        ;

bloco   : BEG lista_de_comandos M0 END 
	    ;

declaracoes : declaracoes M0 declaracao SEMICOLON
			| vazio
			;

declaracao : decl_de_var
		   | def_de_tipo
		   | decl_de_proc
		   ;

decl_de_var : tipo DOUBLEDOTS lista_de_ids 
			;

tipo : INTEGER { // tipo 0
                }
	 | BOOLEAN { // tipo 1
                }
	 | CHAR { // tipo 2
                }
	 | tipo_definido { // tipo 3
                }
	 ;

M0 : vazio
   ;

M1 : vazio
   ;

M2 : vazio
   ;

def_de_tipo : TYPE nome_do_tipo M0 EQ M1 definicao_de_tipo
		    ;

nome_do_tipo : identificador
			 ;

definicao_de_tipo : OPENPAR limites CLOSEPAR tipo
				  ;

limites : inteiro DOUBLEDOTS inteiro
		;

tipo_definido : identificador
			  ;

decl_de_proc : proc_cab pro_corpo 
			 ;

proc_cab : tipo_retornado PROCEDURE M0 nome_do_proc espec_de_parametros
		 ;

pro_corpo : DOUBLEDOTS declaracoes M0 bloco emit_return
		  | emit_return
		  ;

emit_return : vazio 
			;

lista_de_parametros : parametro
					| lista_de_parametros COLON parametro
					;

tipo_retornado : INTEGER
			   | BOOLEAN
			   | CHAR
			   | vazio
			   ;

parametro : modo tipo DOUBLEDOTS identificador
		  ;

modo : VALUE
	 | REFERENCE
	 ;

nome_do_proc : identificador
			 ;

lista_de_comandos : comando				  
				  | lista_de_comandos SEMICOLON M0 comando
				  ;

lista_de_ids : identificador
			 | lista_de_ids COLON identificador
			 ;

vazio : /*Epsilon*/
	  ;

espec_de_parametros : OPENPAR lista_de_parametros CLOSEPAR
					| vazio
					;

comando : comando_de_atribuicao
		| comando_while
		| comando_repeat
		| comando_if
		| comando_read
		| comando_write
		| comando_return
		| comando_exit
		| chamada_de_procedimento
		| rotulo DOUBLEDOTS comando
		;

comando_de_atribuicao : variavel ATTRIB expr
					  ;

comando_while : WHILE M0 expr DO M0 lista_de_comandos ENDWHILE
			  ;

comando_repeat : REPEAT M0 lista_de_comandos UNTIL M0 expr
			   ;

comando_if : IF expr THEN M0 lista_de_comandos ENDIF
		   | IF expr THEN M0 lista_de_comandos M1 
		     ELSE M0 lista_de_comandos ENDIF
		   ;

comando_read : READ variavel
			 ;

comando_write : WRITE expr
			  ;

comando_return :  RETURN expr
			   ;

comando_exit : EXIT identificador
			 ;

rotulo : identificador
	   ;

variavel : identificador
 		 | chamada_ou_indexacao
 		 ;

chamada_ou_indexacao : indices CLOSEPAR
					 ;

chamada_de_procedimento : identificador
						| chamada_ou_indexacao
						;

indices : variavel2 OPENPAR  expr
		| indices COLON expr
		;

variavel2 : identificador
		  ;

expr : expr OR M0 expr
	 | expr AND M0 expr
	 | NOT expr
	 | expr NE expr
	 | expr LT expr 
     | expr GT expr
     | expr GE expr
	 | expr LE expr
	 | expr PLUS expr
	 | expr MINUS expr
	 | expr MULT expr
	 | expr DIV expr
	 | expr EXP expr
	 | MINUS expr %prec UMINUS
	 | variavel
	 | constante
	 | OPENPAR expr CLOSEPAR
	 ;

constante : int_ou_char
		  | booleano
		  ;

int_ou_char : inteiro
			| CONST_CHAR
			;

inteiro : NUM
		;

booleano : TRUE
		 | FALSE
		 ;

identificador : IDENTIFIER {instalarNaTS();} //instalar identificador na Tabela de Símbolos (TS)
			  ;

%%

extern int line_num;
extern void lexemefoundErroSintatico();
extern FILE *saida;
extern simbolo_t tabela_simbolos[TAB_SIZE];


int main(int argc, char* argv[]){	
	if(argc != 2){
		printf("Maneira correta de se usar o analisador sintatico: ./a.out arquivo_teste\n");
		exit(1);
	}
		
	yyin = fopen(argv[1], "r"); // para leitura do arquivo com código fonte
	if(yyin == NULL){
		printf("Arquivo nao encontrado.\n");
		return 1;
	}

	// arquivo de saida com o programa fonte
	saida = fopen("saida.txt", "w");
	
	// Iniciar numeração do programa fonte no arquivo e no terminal, com valor 1
	fprintf(saida, "%d ", line_num);
	printf("%d ", line_num);

	// iniciar TS
	iniciaListaNO();

	// Executar o analisador sintático, retorna 0 quando o programa está correto
	if(!yyparse()){
		 printf("\n\n***** Programa sintaticamente correto! *****\n");
	}
	
	printf("\n");

	// Imprime a tabela de simbolos
	Imprime_Tabela();

	fclose(saida);
	return 0;
}

int yyerror(char *s) {
	printf("\n\n***** Erro sintatico na linha %d ou %d, verificar na vizinhanca do token: ", line_num - 1, line_num);
	fprintf(saida, "\n\n***** Erro sintatico na linha %d ou %d, verificar na vizinhanca do token: ", line_num - 1, line_num);
	lexemefoundErroSintatico();
}	

