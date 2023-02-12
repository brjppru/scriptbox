; Illustrate int 27h (TSR) - from Norton "Programmer's guide..."
;
Program segment para public 'code'
	assume	cs:Program
TSR	proc
Beginning:
	jmp	Initialize
Start_resident:
	nop
	nop
	nop
	nop
	nop
;............................ here resident code .............
End_resident:
resident_length equ End_resident - Start_resident
resident_offset equ Start_resident - Beginning + 100h
psp_amount	equ 92
;
Initialize:
	push	cs
	pop	es
	push	cs
	pop	ds
	mov	di,psp_amount
	mov	si,resident_offset
	mov	cx,resident_length
	cld
   rep	movsb
;		now we are ready to int 27h
	mov	dx,psp_amount + resident_length
	int	27h
TSR	endp
Program ends
	end
