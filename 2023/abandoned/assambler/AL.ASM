        org 100h
        double segment
        assume cs:double

          start:    jmp start1
          usrprg  proc  far
          home:
        DB  00H
        DW  01B7H
        DW  017CH
        DW  0001H
        DW  11C7H
        DW  11C7H
        DW  0FE6H
        DW  0E28H
        DW  11C7H
        DW  0E28H
        DW  0FE6H
        DW  17C4H
        DW  11C7H
        DW  11C7H
        DW  0FE6H
        DW  0E28H
        DW  11C7H
        DW  11C7H
        DW  11C7H
        DW  11C7H
        DW  0FE6H
        DW  0E28H
        DW  0D59H
        DW  0E28H
        DW  0FE6H
        DW  11C7H
        DW  12EFH
        DW  17C4H
        DW  152CH
        DW  12EFH
        DW  11C7H
        DW  11C7H
        DW  152CH
        DW  12EFH
        DW  152CH
        DW  1AC5H
        DW  152CH
        DW  12EFH
        DW  11C7H

        DW  152CH
        DW  17C4H
        DW  152CH
        DW  17C4H
        DW  1AC5H
        DW  1C67H
        DW  1AC5H
        DW  17C4H
        DW  152CH
        DW  12EFH
        DW  152CH
        DW  1AC5H
        DW  152CH
        DW  12EFH
        DW  11C7H
        DW  152CH
        DW  17C4H
        DW  11C7H
        DW  12EFH
        DW  0FE6H
        DW  11C7H
        DW  11C7H
        DW  0FFFFH
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0909H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0909H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0506H
        DW  0505H
        DW  0505H
        DW  0505H
        DW  0506H
        DW  0505H
        DW  0905H
        DW  0FE09H
        DW  7A06H
        DW  0FE7DH
        DW  0FB06H
        DW  0747DH

       GO:
        PUSH     BP
        MOV     BP,SP
        PUSHF
        PUSH    AX
        PUSH    BX
        PUSH    DS
        PUSH    ES
        PUSH    CS
        POP     DS

        MOV     AX,0040H
        MOV     ES,AX
        CMP     BYTE PTR DS:[0010],0FFH
        JZ      LOC_1
        MOV     BYTE PTR DS:[0010],0FFH

        MOV     BYTE PTR DS:[0108H],00
        MOV     WORD PTR DS:[0104H],017EH
        MOV     WORD PTR DS:[0106H],010AH
        LOC_1:
        CMP     BYTE PTR DS:[0108H],01
        JZ LOC_2
        CMP     BYTE PTR DS:[0103H],00H
        JZ LOC_3
        DEC  BYTE PTR DS:[0103H]
        JMP LOC_2
        LOC_3:
        MOV  BX,WORD PTR DS:[0106H]
        CMP     WORD PTR DS:[BX],-01
        JNZ LOC_4
        IN  AL,61H
        AND AL,0FCH
        OUT     61H,AL
        MOV     BYTE PTR DS:[0108H],01
        JMP LOC_2
        LOC_4:
        MOV  AL,0B6H
        OUT     43H,AL
        MOV     AX,[BX]
        OUT     42H,AL
        MOV  AL,AH
        OUT     42H,AL
        IN  AL,61H
        OR   AL,03H
        OUT     61H,AL
        ADD WORD PTR DS:[0106H],+02H
        MOV BX,WORD PTR DS:[0104H]
        MOV AL,BYTE PTR DS:[BX]
        DEC AL
        MOV BYTE PTR DS:[0103H],AL
        INC WORD PTR DS:[0104H]
        LOC_2:
        POP ES
        POP DS
        POP BX
        POP AX
        POPF
        POP BP
        IRET

          usrprg endp
          veryend:

          start1:
        cli
        mov  ax,0
        mov     ds,ax
        mov     bx,70h

        mov     ax,offset GO + 100h
        mov     [bx],ax
        mov     ax,cs
        mov     [bx+2],ax
        push     cs
        pop  ds
        push     cs
        pop     es
        mov     dx,offset veryend+100h
        sti
        int  27h
          quit:
        int  20h

          double ends

        end start
