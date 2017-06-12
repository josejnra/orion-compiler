%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int qtdLexema;
extern int linha;
extern int qtdErros;

FILE *saida;

extern void yyerror(const char *err);
extern void lexemefound();
extern int yylex(void);


%}
%token BEG
%token BOOLEAN
%token CHAR_LITERAL
%token DO
%token ELSE
%token END
%token FALSE
%token ENDIF
%token ENDWHILE
%token EXIT
%token IF
%token<NUM> INTEGER
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
/* %token SIMPLEASPAS */
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
%left UMINUS

%union {
        char *identificador;
        int i;
};

%token<IDENTIFIER> IDENTIFIER
%token<NUM> NUM

%%

program : PROGRAM M2 declaracoes M0 bloco 
        ;

bloco : BEG lista_de_comandos M0 END {printf("Bloco Completo\n");}
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

tipo : INTEGER
	 | BOOLEAN
	 | CHAR_LITERAL
	 | tipo_definido
	 ;

M0 :
   /*EMPTY*/
   ;

M1 :
   /*EMPTY*/
   ;

M2 :
   /*EMPTY*/
   ;

def_de_tipo : TYPE nome_do_tipo M0 EQ M1 definicao_de_tipo
		    ;

nome_do_tipo : identificador
			 ;

definicao_de_tipo : OPENPAR limites CLOSEPAR tipo
				  ;

limites : INTEGER DOUBLEDOTS INTEGER
		;

tipo_definido : identificador
			  ;

decl_de_proc : proc_cab pro_corpo
			 ;

proc_cab : tipo_retornado PROCEDURE M0 nome_do_proc
		 | espec_de_parametros
		 ;

pro_corpo : declaracoes M0 bloco emit_return
		  | emit_return
		  ;

emit_return : vazio
			;

lista_de_parametros : parametro 
					| lista_de_parametros COLON parametro
					;

tipo_retornado : INTEGER
			   | BOOLEAN
			   | CHAR_LITERAL
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
				  | rotulo DOUBLEDOTS 
				  | lista_de_comandos SEMICOLON M0 comando 
				  ;

lista_de_ids : identificador
			 | lista_de_ids COLON identificador
			 ;

vazio : 
	  /*empty*/
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
	 | expr GT expr
	 | expr GE expr
	 | expr LT expr
	 | expr PLUS expr
	 | expr MINUS expr
	 | expr MULT expr
	 | expr DIV expr
	 | expr EXP expr
	 | '-' expr %prec UMINUS
	 | variavel
	 | constante
	 | OPENPAR expr CLOSEPAR
	 ;

constante : int_ou_char
		  | booleano
		  ;

int_ou_char : inteiro
			| CHAR_LITERAL
			;

inteiro : NUM
		;

booleano : TRUE
		 | FALSE
		 ;

identificador : IDENTIFIER
			  ;

%%
int main(int argc, char *argv[]){
    /* executa o analisador léxico. */
	saida = fopen("saida.txt", "w");
	if(argc == 2){		
		yyin = fopen(argv[1], "r");
		if(yyin == NULL){
			printf("\tArquivo nao encontrado!\n");
			return 0;
		}	
		yylex();
		yyparse();
		fclose(yyin);		
	}else{
		yylex();
		yyparse();
	}

	printf("\tNumero total de lexemas reconhecidos = %d\n", qtdLexema);
	fprintf(saida, "\tNumero total de lexemas reconhecidos = %d\n", qtdLexema);
	printf("\tNumero total de erros = %d\n", qtdErros);
	fprintf(saida, "\tNumero total de erros = %d\n", qtdErros);

	fclose(saida);
    return 0;
}

