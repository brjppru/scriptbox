		TITLE	BADF.ASM
		PAGE	,132
		INCLUDE	DOS.INC

	STACK	SEGMENT PARA STACK 'STACK'

		DB	4 DUP('STACK')

	STACK ENDS
	DSEG	SEGMENT PARA PUBLIC 'DATA'

        OLDOFF          DW      0
        OLDSEG          DW      0
        FDAT            DB      0DFH,02H,25H,01H,12H,2AH,0FFH,0AH,0F6H,19H,04H
        CYL_NUMBER      DB      028h
        START_S_NUMB    DB      1
        HEAD_NUMB       DB      0
        FN              DB      "C:\REQREP.E",0
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
delay:
                MOV     AX,0201H
                MOV     CH,CYL_NUMBER
                MOV     CL,START_S_NUMB
                MOV     DH,HEAD_NUMB
                MOV     DL,0
                PUSH    DS
                POP     ES
                MOV     BX,OFFSET BUFFER
                INT     13H
		cmp	START_S_NUMB,12H
		je	exit
		add	start_s_numb,1
		jmp	delay
exit:
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

                MOV     DX,OLDOFF
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