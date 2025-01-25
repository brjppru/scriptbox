		TITLE	BADF.ASM
		PAGE	,132
		INCLUDE	DOS.INC

	STACK	SEGMENT PARA STACK 'STACK'

		DB	4 DUP('STACK')

	STACK ENDS
	DSEG	SEGMENT PARA PUBLIC 'DATA'

        OLDOFF          DW      0
        OLDSEG          DW      0
        FDAT            DB      0DFH,02H,25H,01H,12H,2AH,0FFH,0AH,0F6H,94H,32H
        SAY_FIND        DB      13,10,"One. $"
        SAY_CYL         DB      "Cylinder. $",13,10
        CYL_NUMBER      DB      0
        START_S_NUMB    DB      1
        HEAD_NUMB       DB      0
        BUFFER          DB      512 DUP(0)

        DSEG ENDS

	CSEG	SEGMENT PARA PUBLIC 'CODE'
		ASSUME CS:CSEG,DS:DSEG,ES:DSEG,SS:STACK

	ENTRY	PROC FAR

		PUSH 	DS
		SUB 	AX,AX
		PUSH 	AX
		MOV 	AX,DSEG
		MOV 	DS,AX

		MOV 	AX,351EH
		INT	21H
		MOV	OLDSEG,ES
		MOV	OLDOFF,BX


                MOV     DX,OFFSET FDAT
		MOV	AX,251EH
		INT	21H
DELAY:
                MOV     AX,0201H
                MOV     CH,CYL_NUMBER
                MOV     CL,START_S_NUMB
                MOV     DH,HEAD_NUMB
                MOV     DL,0
                PUSH    DS
                POP     ES
                MOV     BX,OFFSET BUFFER
                INT     13H
		CMP 	AH,04
                JE      COMP_SECTOR
		MOV	AH,9
                LEA     DX,SAY_FIND
                INT     21H
COMP_SECTOR:
                CMP     START_S_NUMB,12H
                JE      COMP_HEAD
                ADD     START_S_NUMB,1
                JMP     DELAY
COMP_HEAD:
                CMP     HEAD_NUMB,0
                JNE     COMP_CYL
                MOV     HEAD_NUMB,1
                MOV     START_S_NUMB,1
                JMP     DELAY
COMP_CYL:
                MOV     START_S_NUMB,1
                MOV     HEAD_NUMB,0
		MOV	AH,9
                LEA     DX,SAY_CYL
                INT     21H
                ADD     CYL_NUMBER,1
                CMP     CYL_NUMBER,40
                JE      EXIT
                JMP     DELAY

EXIT:
		MOV	DX,OLDOFF
		PUSH	DS
		PUSH	OLDSEG
		POP	DS
		MOV	AX,251EH
		INT	21H
		POP	DS

		MOV	AX,4C00H
		INT	21H

	ENTRY ENDP
    	CSEG ENDS
		END ENTRY