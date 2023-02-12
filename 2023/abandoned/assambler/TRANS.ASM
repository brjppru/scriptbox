SEG_A		SEGMENT
		ASSUME	CS:SEG_A, DS:SEG_A

		ORG	100H

TRANSLATE       PROC    FAR

                JMP     START
                INPUT_FNAME     DB      "C:\REQREP.E",0
                OUTPUT_FNAME    DB      "REQREP.TXT",0
                OPEN_ERROR      DB      13,10,"Error opening input file $"
                OPEN_ALLOC      DB      13,10,"Not enought memory $"
                BIG_ERROR       DB      13,10,"Input file more than 64K$"
                INP_HANDLE      DW      0
                BUF_SEG         DW      0
START:
                MOV     AX,3D00H
                LEA     DX,INPUT_FNAME
                INT     21H
                JNC     ALL_RIGHT
                MOV     AH,9
                LEA     DX,OPEN_ERROR
                INT     21H
                JMP     EXIT
ALL_RIGHT:
                MOV     INP_HANDLE,AX
		XOR	CX,CX
		XOR	DX,DX
                XCHG    BX,AX
		MOV	AX,4202H
                INT     21H
                CMP     CX,0
                JE      MALLOC
                MOV     AH,9
                LEA     DX,BIG_ERROR
                INT     21H
                JMP     EXIT
MALLOC:
                MOV     BX,DX
                MOV     CL,4
                SHR     BX,CL
                MOV     AH,49H
                INT     21H
                JNC     READ
                MOV     AH,9
                LEA     DX,BIG_ERROR
                INT     21H
                JMP     EXIT
READ:
                MOV     AH,3FH
                MOV     BX,INP_HANDLE
                XOR     DX,DX
                PUSH    DS
                MOV     DS,BUF_SEG
                INT     21H
                POP     DS

EXIT:           
		MOV	AX,4C00H
		INT	21H

TRANSLATE       ENDP

SEG_A		ENDS
		END	START