        TITLE   EX.ASM
        PAGE    ,132
        INCLUDE DOS.INC

    STACK   SEGMENT PARA STACK 'STACK'

        DB  64 DUP('STACK')

    STACK ENDS
    DSEG    SEGMENT PARA PUBLIC 'DATA'

        FN  DB  "PIC.MY",0,"$"

    DSEG ENDS

    CSEG    SEGMENT PARA PUBLIC 'CODE'
        ASSUME CS:CSEG,DS:DSEG,SS:STACK

    ENTRY   PROC FAR

        PUSH    DS
        SUB     AX,AX
        PUSH    AX
        MOV     AX,DSEG
        MOV     DS,AX

        MOV     AL,ES:BYTE PTR [82h]

        MOV     AH,0
        SUB     AL,30H
        INT     10H
        RET

    ENTRY ENDP
        CSEG ENDS
        END ENTRY
