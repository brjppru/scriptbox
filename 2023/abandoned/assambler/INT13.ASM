      TITLE   INTR

      ORG   100h
        double segment
        assume cs:double

start:  jmp start1
intr        proc    far

       		data_1e     equ 13h*4
   		data_5      dw 0
		data_6      dw 0
		segpr	    dw 0
		offpr	    dw 0
		FN	    DB	10,13,"$"
		d	    dw 0	
	go:
		pushf
    		push    ax
		push	bx
		push	cx
    		push    dx
		push	bp
		push	di
		push	si
		push	es
		push    ds

		cmp	dl,0
		jne	go3
		sti
	c:
		JMP	c
	go3:
		pop	ds
		pop	es
		pop	si
		pop	di
		pop	bp
    		pop 	dx
		pop	cx
		pop	bx
    		pop 	ax
    		popf

	        pushf
                call dword ptr cs:data_5[100h]
                pop cs:offpr[100h]
                pop cs:segpr[100h]
                jc SetCarry
                popf
                clc
                jmp CarryAll
SetCarry:
                popf
                stc
CarryAll:
                pushf
                push cs:segpr[100h]
                push cs:offpr[100h]
		iret

intr    endp

veryend:

start1:
        push    ds
        xor     ax,ax
        mov     ds,ax
        les     ax,dword ptr ds:data_1e
        mov     cs:data_5[100h],ax
        mov     cs:data_6[100h],es
        cli
        mov     word ptr ds:data_1e+2,cs
        mov     ax,offset go+100h
        mov     ds:data_1e,ax
        sti
        pop     ds
        mov     dx,offset veryend+100h
        int     27h

double       ends



        end start