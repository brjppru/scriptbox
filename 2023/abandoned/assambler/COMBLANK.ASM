SEG_A		SEGMENT
		ASSUME	CS:SEG_A, DS:SEG_A

		ORG	100H

RES		PROC	FAR

START:   	JMP	GO			


GO:


RES		ENDP


SEG_A		ENDS
		END	START