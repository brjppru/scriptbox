


		org 100h
		double segment
		assume cs:double

	      start:	jmp start1
	      usrprg  proc  far
	   home:
		FN	DB	"HLP.MY",0
		FH	DW	0000H	
		D	DB	8 DUP(0)

	   GO:
		PUSH	 BP
		MOV 	BP,SP
		PUSHF
		PUSH 	AX
		PUSH 	BX
		PUSH 	DS
		PUSH 	ES
		PUSH 	CS
		POP 	DS
		
		MOV	AX,3D02H
		MOV 	DX,0103H
		INT 	21H
		MOV 	WORD PTR DS:[010AH],AX
		JC	E

		MOV	AH,12H
		MOV	BL,10H
		INT	10H
		MOV 	WORD PTR DS:[010CH],BX
		MOV	WORD PTR DS:[010EH],CX

		MOV 	BX,WORD PTR DS:[010AH]
		MOV	DX,010CH
		MOV 	CX,4
		MOV	AH,40H
		INT 	21H
		
		MOV	AH,3EH
		MOV 	BX,WORD PTR DS:[010AH]
		INT 	21H

E:		POP	ES
		POP	DS
		POP	BX
		POP	AX
		POPF
		POP	BP
		IRET

	      usrprg endp
	      veryend:
		
	      start1:
		mov	 ax,0
		mov 	ds,ax
		mov 	bx,14h

		mov 	ax,offset GO + 100h 
		mov 	[bx],ax
		mov 	ax,cs
		mov 	[bx+2],ax
		push	 cs
		pop	 ds
		push	 cs
		pop 	es
		mov 	dx,offset veryend+100h
		int	 27h
	      quit:
		int	 20h

	      double ends

		end start				