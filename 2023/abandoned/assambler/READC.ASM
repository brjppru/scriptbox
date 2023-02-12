		TITLE	BADF.ASM
		PAGE	,132
		INCLUDE	DOS.INC

	STACK	SEGMENT PARA STACK 'STACK'

		DB	4 DUP('STACK')

	STACK ENDS
	DSEG	SEGMENT PARA PUBLIC 'DATA'

        CYL_NUMBER      DB      0
        START_S_NUMB    DB      1
        HEAD_NUMB       DB      0
        FN              DB      "A:\REQREP.E",0
        BUFFER          DB      1024 DUP(0)

        DSEG ENDS

	CSEG	SEGMENT PARA PUBLIC 'CODE'
		ASSUME CS:CSEG,DS:DSEG,ES:DSEG,SS:STACK

	ENTRY	PROC FAR

		PUSH 	DS
		SUB 	AX,AX
		PUSH 	AX
		MOV 	AX,DSEG
		MOV 	DS,AX

                MOV     AX,0201H
                MOV     CH,CYL_NUMBER
                MOV     CL,START_S_NUMB
                MOV     DH,HEAD_NUMB
                MOV     DL,80h
                PUSH    DS
                POP     ES
                MOV     BX,OFFSET BUFFER
                INT     13H

		MOV	AX,3D02H
		MOV 	DX,OFFSET FN
		INT 	21H
                MOV     BX,AX

                MOV     DX,OFFSET BUFFER
                MOV     CX,512
		MOV	AH,40H
		INT	21H

		MOV	AH,3EH
		INT 	21H

		MOV	AX,4C00H
		INT	21H

	ENTRY ENDP
    	CSEG ENDS
		END ENTRY