/***************************************************************************
Stack Machine
***************************************************************************/
/*=========================================================================
DECLARATIONS
=========================================================================*/
/* OPERATIONS: Internal Representation */
enum code_ops {

HALT, STORE, JMP_FALSE, GOTO, PUSH, LD_INT, LD_VAR, LTC, EQC, GTC, ADDC, SUBC, MULTC, DIVC,ORC,ANDC,NOTC,NEC,GEC

};

/* OPERATIONS: External Representation */
char *op_name[] = { "HALT", "STORE(1)", "JUMPIF(0)", "JUMP", "PUSH", "LOADL", "LOAD(1)",
                    "CALL(0)13[PB]", "CALL(0)17[PB]", "CALL(0)16[PB]", "CALL(0)8[PB]",
                    "CALL(0)9[PB]", "CALL(0)10[PB]", "CALL(0)11[PB]","CALL(0)4[PB]",
                    "CALL(0)3[PB]","CALL(0)2[PB]","CALL(0)18[PB]","CALL(0)15[PB]"};

int op_code[]={ 15, 4, 14, 12, 10, 3, 2, 6, 6, 6, 6, 6, 6, 6 ,6 ,6 ,6 , 6, 6 };
int n[]={ 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int r[]={ 0, 4, 4, 4, 0, 0, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 };
int d[]={ 0, 0, 0, 0, 0, 0, 0, 13, 17, 16, 8, 9, 10, 11, 4, 3, 2, 18, 15 };

struct instruction{
    enum code_ops op;
    int arg;
};

/* CODE Array */
struct instruction code[999];

/*************************** End Stack Machine **************************/

