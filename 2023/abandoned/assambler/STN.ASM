	  PAGE	  60,132
	  TITLE	  LOGOUT

	  DOSSEG
	  .MODEL  small

	  INCLUDE dos.inc
	  INCLUDE bios.inc

	  .STACK  100h

	  .DATA

	PUBLIC str1
	str1	db	"Station number : $"	
	h	db	0
	l	db	0
	  .CODE

START:
	push	ds
	sub	ax,ax
	push	ax
	mov	ax,@DATA		; Initialize data segment
	mov	ds,ax

	MOV	AH,0DCH
	INT	21H
	mov	h,cl
	mov	l,ch
	@DispStr str1
	@DispCh h
	@dispCh l
	pop	ds
		
	@Exit	0
	  END	 start

