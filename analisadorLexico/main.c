#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include <unistd.h>

int main(){
    menu();
    return 0;
}

void menu(){
    int tipoEntrada = 0;
    do{
        printf("\n\t* * * * * * * * * * * * * ANALISADOR LEXICO * * * * * * * * * * *\n");
        printf("\t*                                                               *\n");
        printf("\t*\t(1) Entrada por arquivo                                 *\n");
        printf("\t*\t(2) Entrada manual                                      *\n");
        printf("\t*\t(0) Finalizar Analisador Léxico                         *\n");
        printf("\t*                                                               *");
        printf("\n\t* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n ");
        printf("\tQual entrada? ");
        scanf("%d", &tipoEntrada);
        limparBuffer();
        switch(tipoEntrada){
        case 1:
            system("clear || cls");
            lerArquivo();
            break;
        case 2:
            system("clear || cls");
            entradaManual();
            break;
        case 0:
            printf("\n\tSimulador Finalizado com sucesso.\n");
            return;
            break;
        default:
            system("clear || cls");
            printf("\n\tOpção inválida! Digite novamente.\n");
            break;
        }
    }
    while(tipoEntrada != 0);

}

void lerArquivo(){
    printf("\n\t* * * * * * *ENTRADA POR ARQUIVO* * * * * * *\n");
    char nomeArq[100];
    char programaLex[] = "./a.out 1 ";
    printf("\tNome do arquivo de entrada: ");
    gets(&nomeArq);
    strcat(programaLex, nomeArq);
    system(programaLex);
    printf("\tPressione ENTER para continuar...");
    getchar();
    system("clear || cls");
    //menu();
}

void entradaManual(){
    printf("\n\t* * * * * * *ENTRADA MANUAL* * * * * * *\n");
    system("./a.out");
    printf("\tPressione ENTER para continuar...");
    getchar();
    system("clear || cls");
}

void limparBuffer(){
    char c;
    while((c = getchar()) != '\n' && c != EOF);
}
