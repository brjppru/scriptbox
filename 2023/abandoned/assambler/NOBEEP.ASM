      TITLE   INTR

      ORG   100h
        double segment
        assume cs:double

start:  jmp start1
intr        proc    far

                data_1e     equ 8h*4
                port_b      equ 61h
                data_5      dw 0
		data_6      dw 0
		segpr	    dw 0
		offpr	    dw 0
		FN	    DB	10,13,"$"
		d	    dw 0
        GO:
                pushf
                call dword ptr cs:data_5[100h]
                PUSH AX
                IN AL,PORT_B
                AND AL,11111110B
                OUT PORT_B,AL
                POP AX
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