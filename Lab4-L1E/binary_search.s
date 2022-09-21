.globl binary_search
binary_search:
 MOV R4,#0  //startIndex
 SUB R5,R2,#1 //endIndex
 MOV R6,R5,LSR #1 //middleIndex
 MOV R7,#-1 //keyIndex
 MOV R8,#1 //NumIters
LOOP:
 CMP R7,#-1 //Loop compair
 BNE found //Not equal go to found
 CMP R4,R5 //If compair
 BGT not_found

 LDR R9,[R0,R6,LSL #2] //Else
 CMP R9,R1
 BEQ EQ
 BGT BIGER
 BLT SMALLER

assign:
 RSB R8,R8,#0
 STR R8,[R0,R6,LSL #2]
 RSB R8,R8,#0
 SUB R12,R5,R4
 ADD R6,R4,R12,LSR #1
 ADD R8,R8,#1
 B LOOP

EQ:
 MOV R7,R6
 B assign

BIGER:
 SUB R10,R6,#1
 MOV R5,R10
 B assign

SMALLER:
 ADD R11,R6,#1
 MOV R4,R11
 B assign

found:
 MOV R0,R7
 B END

not_found:
 MOV R0,#-1
 B END

END:
 MOV PC,LR