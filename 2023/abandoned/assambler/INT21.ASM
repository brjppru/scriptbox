SEG_A		SEGMENT
		ASSUME	CS:SEG_A, DS:SEG_A

		ORG	100H

RES		PROC	FAR

START:   	JMP	START1

       		DATA_1E     	EQU 	21H*4
   		OFF_21      	DW 	0
		SEG_21      	DW 	0
		FN	    	DB	"C:\REQREP.E",0
		FH     	   	DW	0
                REQ_BUF         DB      "REQ"
                FN_NUMBER       DB      0E3H
                REP_BUF         DB      "REP"
                A               DB      0
                SAY_REMOVE      DB      "Interrupt 21h handler uninstalled. $",13,10
                SAY_CAN_NOT     DB      "I can't uninstalled. $",13,10
                FLAGS           DB      0
                SUBFUNCTION     DB      0
                NUMBER_CYCLES   EQU     1
                FREQUENCY       EQU     3000
                PORT_B          EQU     61H
GO:
		CMP	AH,0ECh
   		JNE  	NEXT
		MOV	AL,0E2H
		IRET
NEXT:
		CMP	AH,0EEh
   		JNE  	NORELEASE
		JMP	RELEASE
NORELEASE:
		PUSHF
    		PUSH    AX
		PUSH	BX
		PUSH	CX
    		PUSH    DX
    		PUSH    DS

                CMP     AH,CS:FN_NUMBER                 ;Function number
   		JE  	GO1
	GO2:
		JMP	GO3

        GO1:
                TEST    CS:FLAGS,00000001B
                JZ      NO_SUBFUNCTION
                PUSH    AX
                MOV     AL,CS:SUBFUNCTION
                CMP     BYTE PTR DS:[SI+2],AL           ;Subfunction number
                POP     AX
                JNE     GO2
NO_SUBFUNCTION:
		PUSH	CS
		POP	DS
		MOV	AX,3D02H
		MOV 	DX,OFFSET FN
		INT 	21H
		JC	GO2
		MOV 	FH,AX

		XOR	CX,CX
		XOR	DX,DX
		MOV 	BX,FH
		MOV	AX,4202H
		INT	21H
		JC	GO2

                MOV     DX,OFFSET REQ_BUF
		XOR	CX,CX
                MOV     CL,4
		MOV	AH,40H
		INT	21H
                JC      GO2

		POP	DS
		MOV	DX,SI
		MOV 	CX,WORD PTR DS:[SI]
		ADD	CL,2
		MOV	AH,40H
		INT 	21H
		PUSH	DS
		JC	GO2
                CLI
                MOV     DX,NUMBER_CYCLES
                IN      AL,PORT_B
                AND     AL,11111110B
NEXT_CYCLE:     OR      AL,00000010B
                OUT     PORT_B,AL
                MOV     CX,FREQUENCY
FIRST_HALF:     LOOP    FIRST_HALF
                AND     AL,11111101B
                OUT     PORT_B,AL
                MOV     CX,FREQUENCY
SECOND_HALF:    LOOP    SECOND_HALF
                DEC     DX
                JNZ     NEXT_CYCLE
                STI

		MOV	AH,3EH
		INT 	21H

		POP	DS
		POP	DX
		POP	CX
		POP	BX
		POP	AX
		POPF
                TEST    CS:FLAGS,00000010B
		JZ	NO_CIRCLE
                STI
CIRCLE:
                JMP CIRCLE                      ;Circle Point
NO_CIRCLE:
		PUSHF
		CALL	DWORD PTR CS:OFF_21

		PUSHF
    		PUSH    AX
		PUSH	BX
		PUSH	CX
    		PUSH    DX
		PUSH	SI
		PUSH	DI
		PUSH	ES
    		PUSH    DS
		PUSH	CS
		POP	DS

                MOV     A,AL
		MOV	AX,3D02H
		MOV 	DX,OFFSET FN
		INT 	21H
		JC	GO4
		MOV 	FH,AX

		XOR	CX,CX
		XOR	DX,DX
		MOV 	BX,FH
		MOV	AX,4202H
		INT	21H
                JC      GO4

                MOV     DX,OFFSET REP_BUF
		XOR	CX,CX
                MOV     CL,3
		MOV	AH,40H
		INT	21H
                JC      GO4

                MOV     DX,OFFSET A
		XOR	CX,CX
                MOV     CL,1
		MOV	AH,40H
		INT	21H
                JC      GO4

		PUSH	DS
		PUSH	ES
		POP	DS
		MOV	DX,DI
		MOV 	CX,WORD PTR DS:[DI]
		ADD	CL,2
		MOV	AH,40H
		INT 	21H
		POP	DS
		JC	GO4

		MOV	AH,3EH
		INT 	21H

	GO4:
		POP	DS
		POP	ES
		POP	DI
		POP	SI
		POP	DX
		POP	CX
		POP	BX
		POP	AX
		POPF

		IRET

	GO3:
		POP	DS
    		POP 	DX
		POP	CX
		POP	BX
    		POP 	AX
    		POPF

    		JMP     DWORD PTR CS:OFF_21
RELEASE:
        	XOR     AX,AX
        	MOV     DS,AX
        	MOV     AX,CS
		CMP     AX,WORD PTR DS:DATA_1E+2
		JE	CONT_RELEASE
		MOV	AH,9
		PUSH	CS
		POP	DS
		MOV 	DX,OFFSET SAY_CAN_NOT
		INT	21H
		IRET
CONT_RELEASE:
        	MOV     AX,CS:OFF_21
        	MOV     ES,CS:SEG_21

		CLI
        	MOV     WORD PTR DS:DATA_1E+2,ES
        	MOV     WORD PTR DS:DATA_1E,AX
        	STI

		MOV	AX,CS
		MOV	ES,AX
		MOV	AH,49H
		INT	21H
		MOV	AX,CS:[002CH]
		MOV	ES,AX
		MOV	AH,49H
		INT	21H
		MOV	AH,9
		PUSH	CS
		POP	DS
                MOV     DX,OFFSET SAY_REMOVE
		INT	21H

		IRET
VERYEND:
CONVERT_TABLE           DB      0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0
                        DB      0AH,0BH,0CH,0DH,0EH,0FH
SAY_IN_FN_NUMBER        DB      "Input function number (E3-'Enter'): $"
SAY_IN_SUBFUNCTION      DB      13,10,"Input subfunction number ('Enter' for none): $"
SAY_IN_CIRCLE           DB      13,10,"Make stop point ('Enter' for no): $"
SAY_WARRANT             DB      13,10,"Be sure that AFD is already resident"
			DB	" if you want to make stop point !!!$"
SAY_YES                 DB      13,10,"Interrupt 21h handler installed. $"

START1:
		MOV	AH,0ECH
		INT	21H
		CMP	AL,0E2H
		JNE	MAKE_RES
                MOV     AH,0EEH
                INT     21H
		MOV	AX,4C00H
		INT	21H
MAKE_RES:
		MOV	AH,9
                LEA     DX,SAY_IN_FN_NUMBER
		INT	21H
                CALL    WAIT_INPUT
                CMP     DL,0DH
                JZ      INPUT_SUBF
                MOV     CL,4
                SHL     DL,CL
                MOV     FN_NUMBER,DL
                CALL    WAIT_INPUT
                OR      FN_NUMBER,DL
INPUT_SUBF:
		MOV	AH,9
                LEA     DX,SAY_IN_SUBFUNCTION
		INT	21H
                CALL    WAIT_INPUT
                CMP     DL,0DH
                JZ      INPUT_CIRCLE
                OR      FLAGS,00000001B
                MOV     CL,4
                SHL     DL,CL
                MOV     SUBFUNCTION,DL
                CALL    WAIT_INPUT
                OR      SUBFUNCTION,DL
INPUT_CIRCLE:
                MOV     AH,9
                LEA     DX,SAY_WARRANT
                INT     21H
		MOV	AH,9
                LEA     DX,SAY_IN_CIRCLE
                INT     21H

                CALL    DEFINE_CIRCLE
                XOR     AX,AX                           ;==================
        	MOV     DS,AX
        	LES     AX,DWORD PTR DS:DATA_1E
        	MOV     CS:OFF_21,AX
        	MOV     CS:SEG_21,ES

		CLI
        	MOV     WORD PTR DS:DATA_1E+2,CS
        	MOV     AX,OFFSET GO
        	MOV     DS:DATA_1E,AX
        	STI
		PUSH	CS
		POP	DS
		MOV	AH,9
                MOV     DX,OFFSET SAY_YES
		INT	21H

        	MOV     DX,OFFSET VERYEND
                INT     27H

WAIT_INPUT      PROC    NEAR
WAIT_PUSH:
                        MOV     AH,10H
                        INT     16H
CONVERT_IN_HEX:
                        MOV     DL,AL
                        CMP     AL,30H
                        JB      NOT_HEX
                        CMP     AL,3AH
                        JB      HEX_CONVERT
CHECK_CHAR:
                        CMP     AL,41H
                        JB      NOT_HEX
                        CMP     AL,47H
                        JB      HEX_CONVERT
                        SUB     AL,20H
                        CMP     AL,47H
                        JB      CHECK_CHAR
NOT_HEX:
                        CMP     AL,0DH
                        JNZ     WAIT_PUSH
                        XCHG    AL,DL
                        RET
HEX_CONVERT:
			SUB	AL,30H
                        LEA     BX,CONVERT_TABLE
                        XLAT    CONVERT_TABLE
                        MOV     AH,0EH
                        XCHG    AL,DL
                        XOR     BH,BH
                        INT     10H
                        RET
WAIT_INPUT      ENDP

DEFINE_CIRCLE   PROC    NEAR
WAIT_IN:
                        MOV     AH,10H
                        INT     16H

                        CMP     AL,4EH
                        JE      NO_ANSWER
                        CMP     AL,59H
                        JE      YES_ANSWER
                        CMP     AL,6EH
                        JE      NO_ANSWER
                        CMP     AL,79H
                        JE      YES_ANSWER
                        CMP     AL,0DH
                        JNE     WAIT_IN
                        RET
NO_ANSWER:
                        JMP     ERET
YES_ANSWER:
                        OR      FLAGS,00000010B
ERET:
                        MOV     AH,0EH
                        XOR     BH,BH
                        INT     10H
                        RET
DEFINE_CIRCLE   ENDP

RES		ENDP

SEG_A		ENDS
		END	START