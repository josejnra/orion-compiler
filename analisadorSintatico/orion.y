%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define YYSTYPE char*
extern FILE* yyin; // para leitura do arquivo com código fonte
extern FILE* yyout; // gravação das operações no analisador sintático
int yylex();  // chamar o analisador léxico
int yyerror(char *s); // impressão de erro e o analisador para
int linha(); // imprime o número da linha ao ocorrer um error sintático

%}


%token NUM IDENTIFIER
%token BEG
%token BOOLEAN
%token CHAR_LITERAL
%token DO
%token END
%token FALSE
%token ENDIF
%token ENDWHILE
%token EXIT
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
CODE: program { printf("Programa sintaticamente correto\n"); }
    | 
	;

program : PROGRAM M2 declaracoes M0 bloco
        ;

bloco   : BEG lista_de_comandos M0 END //{printf("Bloco Completo\n");}
	      ;

declaracoes : declaracoes M0 declaracao SEMICOLON  //{printf("Encontrado um ponto e virgula na linha %d\n", linha());}
			      | vazio
			      ;

declaracao : decl_de_var //{printf("Encontrado declaracao de variaveis na linha %d\n", linha());}
		       | def_de_tipo
		       | decl_de_proc
		       ;

decl_de_var : tipo DOUBLEDOTS lista_de_ids //{printf("Encontrado dois pontos na linha %d\n", linha());}
			      ;

tipo : INTEGER //{printf("Encontrado INTEGER na linha %d\n", linha());}
	 | BOOLEAN //{printf("Encontrado BOOLEAN na linha %d\n", linha());}
	 | CHAR_LITERAL //{printf("Encontrado CHAR na linha %d\n", linha());}
	 | tipo_definido //{printf("Encontrado TIPODEFINIDO na linha %d\n", linha());}
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
				  | lista_de_comandos SEMICOLON M0 comando //{printf("Encontrado um ponto e virgula na linha %d\n", linha());}
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

comando : comando_de_atribuicao //{printf("Encontrado := na linha %d\n", linha());}
		| comando_while// {printf("Encontrado WHILE na linha %d\n", linha());}
		| comando_repeat //{printf("Encontrado REPEAT na linha %d\n", linha());}
		| comando_if //{printf("Encontrado IF na linha %d\n", linha());}
		| comando_read //{printf("Encontrado READ na linha %d\n", linha());}
		| comando_write //{printf("Encontrado WRITE na linha %d\n", linha());}
		| comando_return //{printf("Encontrado RETURN na linha %d\n", linha());}
		| comando_exit //{printf("Encontrado EXIT na linha %d\n", linha());}
		| chamada_de_procedimento
		| rotulo DOUBLEDOTS comando
		;

comando_de_atribuicao : variavel ATTRIB expr
					  ;

comando_while : WHILE M0 expr DO M0 lista_de_comandos ENDWHILE
			  ;

comando_repeat : REPEAT M0 lista_de_comandos UNTIL M0 expr
			   ;

comando_if : IF expr THEN M0 lista_de_comandos ENDIF //{printf("Encontrado THEN na linha %d\n", linha());}
		   | IF expr THEN M0 lista_de_comandos M1 
		     ELSE M0 lista_de_comandos ENDIF
		   ;

comando_read : READ variavel
			 ;

comando_write : WRITE expr //{printf("Encontrado WRITE na linha %d\n", linha());}
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
	 | NOT expr //{printf("Encontrado NOT na linha %d\n", linha());}
	 | expr NE expr //{printf("Encontrado NE na linha %d\n", linha());}
	 | expr GT expr //{printf("Encontrado GT na linha %d\n", linha());}
     | expr LT expr  //{printf("Encontrado LT na linha %d\n", linha());}	
     | expr GE expr //{printf("Encontrado GE na linha %d\n", linha());}
	 | expr LE expr //{printf("Encontrado LE na linha %d\n", linha());}
	 | expr PLUS expr //{printf("Encontrado PLUS na linha %d\n", linha());}
	 | expr MINUS expr //{printf("Encontrado MINUS na linha %d\n", linha());}
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

int_ou_char : inteiro //{printf("Encontrado um inteiro na linha %d\n", linha());}
			| CHAR_LITERAL
			;

inteiro : NUM 
		;

booleano : TRUE {printf("Encontrado TRUE na linha %d\n", linha());}
		 | FALSE {printf("Encontrado FALSE na linha %d\n", linha());}
		 ;

identificador : IDENTIFIER  //{printf("Encontrado IDENTIFICADOR na linha %d\n", linha());}
			  ;

%%

extern int line_num;
extern void lexemefoundSintatico();

int main(int argc, char* argv[]){	
	if(argc != 2){
		printf("Maneira correta de se usar o analisador sintatico: ./a.out arquivo_teste\n");
		exit(1);
	}

	yyin = fopen(argv[1], "r");

	yyparse();	
	
	return 0;
}


int linha(){
	return line_num;
}

int yyerror(char *s) {
	printf("Erro sintatico entre as linhas %d e %d proximo ao lexema: ", line_num - 1, line_num);
	lexemefoundSintatico();
}	
