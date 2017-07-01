%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ST.c" /* Symbol Table */
#include "SM.c" /* Stack Machine */
#include "CG.c" /* Code Generator */

int yydebug = 0; /* For Debugging */

int yylex();          // chamar o analisador léxico
int yyerror(char *s); // impressão de erro e o analisador sintatico para


int errors; /* Error Count */

struct lbs{ /* Labels for data, if and while */
    int for_goto;
    int for_jmp_false;
};

struct lbs * newlblrec(){ /* Allocate space for the labels */
    return (struct lbs *) malloc(sizeof(struct lbs));
}


/*-------------------------------------------------------------------------
Install identifier & check if previously defined.
-------------------------------------------------------------------------*/
install( char *sym_name ){

	symrec *s;
	s = getsym (sym_name);
	if (s == 0)
		s = putsym (sym_name);
	else{ 
		errors++;
		//printf( "%s is already defined\n", sym_name );
	}
}

/*-------------------------------------------------------------------------
If identifier is defined, generate code
-------------------------------------------------------------------------*/
context_check( enum code_ops operation, char *sym_name ){
	symrec *identifier;
	identifier = getsym( sym_name );
	if ( identifier == 0 ){
		errors++;
        printf( "%s", sym_name );
        printf( "%s\n", " is an undeclared identifier" );
    }
	else gen_code( operation, identifier->offset );
}

%}

%union semrec{ /* The Semantic Records */
	int intval; /* Integer values */
	char *id; /* Identifiers */
	struct lbs *lbls; /* For backpatching */
}

%start CODE
%token <intval> NUM /* Simple integer */
%token <id> IDENTIFIER /* Simple identifier */
%token <lbls> WHILE IF REPEAT /* For backpatching labels */

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
%token READ
%token RETURN
%token THEN
%token TRUE
%token TYPE
%token VALUE
%token UNTIL
%token WRITE
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
%nonassoc ELSE

%%
CODE: program
	;

program : PROGRAM M2 declaracoes M0 bloco 
        ;

bloco   : BEG { gen_code( PUSH, data_location() - 1 ); } lista_de_comandos M0 END { gen_code( HALT, 0 ); YYACCEPT; }
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
	 | CHAR             
	 | tipo_definido                
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

comando_de_atribuicao : IDENTIFIER ATTRIB expr { context_check( STORE, $1 ); }
					  ;

comando_while : WHILE { $1 = (struct lbs *) newlblrec(); $1->for_goto = gen_label(); } 
                M0 expr { $1->for_jmp_false = reserve_loc();}
                DO M0 lista_de_comandos ENDWHILE { gen_code( GOTO, $1->for_goto ); back_patch( $1->for_jmp_false,
                                                   JMP_FALSE, gen_label() ); };
			  ;

comando_repeat : REPEAT { $1 = (struct lbs *) newlblrec(); $1->for_goto = gen_label(); }		
                 M0 lista_de_comandos UNTIL M0 expr { gen_code( JMP_FALSE, gen_label()+2 ); gen_code( GOTO, $1->for_goto );}
			   ;

comando_if : IF expr THEN M0 lista_de_comandos ENDIF
		   | IF expr { $1 = (struct lbs *) newlblrec(); $1->for_jmp_false = reserve_loc(); }
             THEN M0 lista_de_comandos { $1->for_goto = reserve_loc(); }
             M1 ELSE { back_patch( $1->for_jmp_false, JMP_FALSE, gen_label() ); }
             M0 lista_de_comandos ENDIF { back_patch( $1->for_goto, GOTO, gen_label() ); }
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

variavel : IDENTIFIER { context_check( LD_VAR, $1 ); }
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

expr : expr OR M0 expr { gen_code( ORC, 0 ); }
	 | expr AND M0 expr { gen_code( ANDC, 0 ); }
	 | NOT expr { gen_code( NOTC, 0 ); }
	 | expr NE expr { gen_code( NEC, 0 ); }
	 | expr LT expr { gen_code( LTC, 0 ); }
     | expr GT expr { gen_code( GTC, 0 ); }
     | expr GE expr { gen_code( GEC, 0 ); }
	 | expr LE expr
	 | expr PLUS expr { gen_code( ADDC, 0 ); }
	 | expr MINUS expr { gen_code( SUBC, 0 ); }
	 | expr MULT expr { gen_code( MULTC, 0 ); }
	 | expr DIV expr { gen_code( DIVC, 0 ); }
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
			| CHAR
			;

inteiro : NUM { gen_code( LD_INT, $1 ); }
		;

booleano : TRUE
		 | FALSE
		 ;

identificador : IDENTIFIER { install($1); }
			  ;

%%

extern int line_num;
extern void lexemefoundErroSintatico();
extern FILE *saida;
FILE *yyin;

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
	//printf("%d ", line_num);

	errors = 0;
	// Executar o analisador sintático, retorna 0 quando o programa está correto
	if(!yyparse()){
		 printf("\n\n***** Programa sintaticamente correto! *****\n");
	}
	
	printf("\n");	

	fclose(saida);

    /* Imprimir codigo 3 endereços */
    print_code();

	/* Imprimir Tabela de Símbolos */	
	printarTS();

	//printf("\n\nNumero de errors: %d\n", errors);

	return 0;
}

int yyerror(char *s) {
	errors++;
	printf("\n\n***** Erro sintatico na linha %d ou %d, verificar na vizinhanca do token: ", line_num - 1, line_num);
	fprintf(saida, "\n\n***** Erro sintatico na linha %d ou %d, verificar na vizinhanca do token: ", line_num - 1, line_num);
	lexemefoundErroSintatico();
}	

