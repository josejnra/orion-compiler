#ifndef __TABELA_H__
#define __TABELA_H__

#include <stdlib.h>
#include <stdio.h>

#define T_VOID 1
#define T_PROCEDURE 2
#define T_BOOLEAN 3
#define T_INT 4
#define T_CHAR 5

#define MAX_NOME 50		/* tamanho maximo para um string */
#define MAX_PARAMETROS 10	/* limite para o numero de parametros em um procedimento */
#define TAB_SIZE 100		/* tamanho da tabela de simbolos */

typedef struct procedimento_str {
    char nome[MAX_NOME];
    int parametro[MAX_PARAMETROS];
    int modo[MAX_PARAMETROS];
    int numero_parametros;
    int tipo_retornado;
} procedimento_t;

typedef struct tipo_definido_str {
    char nome[MAX_NOME];
    int limites[50][2];
    int dimensoes;
    int tipo_apontado;
} tipo_definido_t;

typedef struct simbolo_str
{
	char nome[MAX_NOME];
	int tipo;
	int valor_inteiro;
	int nivel;
	int width;	// quantidade de palavras para alocar a variavel
	int offset;	// deslocamento
	char valor_char;
	int valor_boolean;
	int local;
	int constante;
	int quad;
	procedimento_t procedimento;
	tipo_definido_t tipo_definido;
} simbolo_t;

simbolo_t tabela_simbolos[TAB_SIZE];

#ifndef YYSTYPE
#define YYSTYPE simbolo_t	/* Cada elemento da gramatica sera deste tipo */
#endif

extern YYSTYPE yylval;
extern int linha;
extern FILE *yyin, *yyout;

//Funcoes da TS
void iniciaListaNO(void);
void Entrada_Bloco(void);
void Saida_Bloco(void);
void Erro(int numero);
int  Recupera_Entrada(char *X);
void Instala(char *X, simbolo_t atribut);
void Imprime_Tabela();

// Tabela de Simbolos
int escopo[10];
int nivel;    /* inteiro que contem o numero do nivel atual */
int L;     		/* inteiro que contem o indice do ultimo elemento da Tabela de Simbolos */
int Raiz;   /* inteiro que contem o indice do primeiro elemento da Tabela de Simbolos */

#endif
