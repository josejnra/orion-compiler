/***************************************************************************
Code Generator
***************************************************************************/
/*-------------------------------------------------------------------------
Data Segment
-------------------------------------------------------------------------*/

int data_offset = 0; /* Initial offset */

int data_location(){ /* Reserves a data location */
    return data_offset++;
}

/*-------------------------------------------------------------------------
Code Segment
-------------------------------------------------------------------------*/
int code_offset = 0; /* Initial offset */

int gen_label() {/* Returns current offset */
    return code_offset;
}

int reserve_loc() {/* Reserves a code location */
    return code_offset++;
}

/* Generates code at current location */
void gen_code( enum code_ops operation, int arg ){
    code[code_offset].op = operation;
    code[code_offset++].arg = arg;
}


/* Generates code at a reserved location */
void back_patch( int addr, enum code_ops operation, int arg ){
	code[addr].op = operation;
	code[addr].arg = arg;
}

/*-------------------------------------------------------------------------
Print Code to stdio
-------------------------------------------------------------------------*/
void print_code(){
	int i = 0;
	char *storecc = "STORE(1)";
	char *jumpifcc = "JUMPIF(0)";
	char *jumpcc = "JUMP";
	char *loadcc = "LOAD(1)";
	char *opnamecc = "a";
	while (i < code_offset){
        opnamecc = op_name[(int) code[i].op];

        if ( strcmp(opnamecc, "STORE(1)") == 0 || strcmp(opnamecc, jumpifcc) == 0 || 
			 strcmp(opnamecc, jumpcc) == 0 || strcmp(opnamecc, loadcc) == 0 || 
             strcmp(opnamecc,"CALL(0)13[PB]") == 0 || strcmp(opnamecc,"CALL(0)17[PB]") == 0 ||
             strcmp(opnamecc,"CALL(0)16[PB]") == 0 || strcmp(opnamecc,"CALL(0)8[PB]") == 0 ||
             strcmp(opnamecc,"CALL(0)9[PB]") == 0 || strcmp(opnamecc,"CALL(0)10[PB]") == 0 ||
             strcmp(opnamecc,"CALL(0)11[PB]") == 0 || strcmp(opnamecc,"CALL(0)4[PB]") == 0 ||
             strcmp(opnamecc,"CALL(0)3[PB]") == 0 || strcmp(opnamecc,"CALL(0)2[PB]") == 0 ||
             strcmp(opnamecc,"CALL(0)18[PB]") == 0 || strcmp(opnamecc,"CALL(0)15[PB]") == 0) { 
			
             if( strcmp(opnamecc,"CALL(0)13[PB]") == 0 || strcmp(opnamecc,"CALL(0)17[PB]") == 0 ||
                 strcmp(opnamecc,"CALL(0)16[PB]") == 0 || strcmp(opnamecc,"CALL(0)8[PB]") == 0 ||
                 strcmp(opnamecc,"CALL(0)9[PB]") == 0 || strcmp(opnamecc,"CALL(0)10[PB]") == 0 ||
                 strcmp(opnamecc,"CALL(0)11[PB]") == 0 || strcmp(opnamecc,"CALL(0)4[PB]") == 0 ||
                 strcmp(opnamecc,"CALL(0)3[PB]") == 0 || strcmp(opnamecc,"CALL(0)2[PB]") == 0 ||
                 strcmp(opnamecc,"CALL(0)18[PB]") == 0 || strcmp(opnamecc,"CALL(0)15[PB]") == 0){
					
                    //printf("%3ld: %-10s\n",i,op_name[(int) code[i].op] );
                    //printf("op:%d r:%d  n:%d  d:%d\n", op_code[(int) code[i].op], r[(int) code[i].op], n[(int) code[i].op], d[(int) code[i].op]);
                    printf("%d %d  %d  %d\n", op_code[(int) code[i].op], r[(int) code[i].op], n[(int) code[i].op], d[(int) code[i].op]);

             }else{

                    //printf("%3ld: %-10s%4ld[SB]\n",i,op_name[(int) code[i].op], code[i].arg );
                    //printf("op:%d r:%d  n:%d  d:%d\n", op_code[(int) code[i].op], r[(int) code[i].op], n[(int) code[i].op], code[i].arg);
                    printf("%d %d  %d  %d\n", op_code[(int) code[i].op], r[(int) code[i].op], n[(int) code[i].op], code[i].arg);
             }
        }
        else{
             //printf("%3ld: %-10s%4ld\n",i,op_name[(int) code[i].op], code[i].arg );
             //printf("op:%d r:%d  n:%d  d:%d\n", op_code[(int) code[i].op], r[(int) code[i].op], n[(int) code[i].op], code[i].arg);
             printf("%d %d  %d  %d\n", op_code[(int) code[i].op], r[(int) code[i].op], n[(int) code[i].op], code[i].arg);
        }
	
        i++;
   }
}
/************************** End Code Generator **************************/
