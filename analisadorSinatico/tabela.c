#include <string.h>
#include <stdio.h>
#include “tabela.h”

#define NMax 10 /* numero maximo de niveis */

int escopo[10];
int nivel;  /* guarda o nivel atual */
int L;      /* indice do ultimo elemento da Tabela de Simbolos */

void iniciaListaNO()
{
	L = 1;    /* Considera-se que a primeira posicao da tabela eh a de indice 1. */
	nivel = 1;           /* O primeiro nivel eh o 1 */
	escopo[nivel] = L;   /* escopo[1] contem o indice do primeiro elemento */
}

/************  Funcao que define os erros provaveis de ocorrer **********/

void Erro(int num)
{
	switch (num) {
		case 1: printf("Tabela de Simbolos cheia\n"); break;
		case 2: printf("Item nao foi encontrado\n"); break;
		case 3: printf("Item ja foi inserido\n"); break;
		default: ;
	}
}

/******************* Funcao de entrada num bloco ********************/

 void Entrada_Bloco()
{
	nivel++;
	if (nivel > NMax) Erro(1);
	else escopo[nivel] = L;
}

/******************** Funcao de saida de um bloco ***********************/

 void Saida_Bloco()
{
	L = escopo[nivel];
	nivel--;
}

/****************  Funcao que pesquisa item na tabela*******************/
/* Pesquisa o simbolo "X" e retorna o indice da Tabela de simbolos onde ele se encontra */

int Recupera_Entrada(char* X)
{
	int K; /* percorre a lista */
	K = L;

	while (K > 1)
	{
        K--;
        if( !strcmp(X, tabela_simbolos[K].nome ) ) return K;		// X foi encontrado
	}
    	/*Erro(2);*/
	return 0;
}

/***************  Funcao que instala o item na tabela*****************/
/* Instala o simbolo "X" com os atributos na Tabela de Simbolos */

 void Instala(char* X, simbolo_t atribut)
{
	int K;
	K = L;

	while (K > escopo[nivel]) {
        K--;
        if( !strcmp(X, tabela_simbolos[K].nome) ) {	// X ja pertence aa tabela
			Erro(3);
			return;
		}
	}
	tabela_simbolos[L] = atribut;
	L++;
}

/******  Funcao que imprime alguns atributos da tabela de simbolos***********/

void Imprime_Tabela()
{
	int i;
	printf("Tabela de Simbolos:\n");
	printf("===================\n\n");
	printf("INDICE\t\tTIPO\t\tNOME\n");
	printf("======\t\t====\t\t====\n");
	for (i = 1; i < L ; i++ )
	{
		printf("%d\t\t%d\t\t%s\n", i, tabela_simbolos[i].tipo, tabela_simbolos[i].nome);
	}
}
