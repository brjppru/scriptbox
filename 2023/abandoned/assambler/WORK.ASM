
CONVERT_TABLE           DB      0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0
                                0AH,0BH,0CH,0DH,0EH,0FH
WAIT:
                        MOV     AH,10H
                        INT     16H
CONVERT_IN_HEX:
                        MOV     DL,AL
                        MOV     AL,SOURCE_BYTE
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
                        JMP     WAIT
HEX_CONVERT:
                        LEA     BX,CONVERT_TABLE
                        XLAT    CONVERT_TABLE
                        MOV     AH,0AH
                        XCHG    AL,DL
                        XOR     BH,BH
                        MOV     CX,1
                        INT     10H

                        RET