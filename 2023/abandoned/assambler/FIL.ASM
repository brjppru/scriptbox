	  PAGE	  60,132
	  TITLE	  FIL

	  DOSSEG
	  .MODEL  small

	  INCLUDE dos.inc
	  INCLUDE bios.inc

	  .STACK  100h

          .DATA

	PUBLIC names,sdta,ndta,filename,prompt2,prompt3,prompt4,space
names 	LABEL	WORD
ncom  	  DB	"*.com",0
nexe	  DB	"*.exe",0
sdta	  DW	 ?
ndta	  DB	"*.*",0
olddrv	  DB	?
newdrv	  DB	?
pass      DW	0
filename  DB	66 DUP(0)
pr	  DB	"File : $"
dbak	  DB	"..",0
pr1	  DB	"Default drive is : $"
pr2	  DB    "Default directory is : $"
slash	  DB	":\$"
drv	  DB	"0:\",0,"$"
space	  DB	"                                         $"
prompt2	  DB	"Yes$"
prompt3   DB	"Bad file.$"
prompt4	  DB	"To kill music virus ? $"
pr5	  DB	13,10,"            FILER V1.0 (C) Copyright Gorjunov O.A. 1990$"	

	PUBLIC buf,sbuf,fsize,oldattr,fhandle
buf	LABEL	WORD
sbuf	  DW	0
fhandle	  DW	?
fsize	  DW	?
oldattr	  DW	?
set	  DW    ?

	  .CODE
	  EXTRN    Killer:PROC

		mov ax,@DATA
		mov ds,ax

		cli
		mov ss,ax
		mov sp,OFFSET STACK
		sti
		mov bx,sp
		mov cl,4
		shr bx,cl
		add ax,bx
		mov bx,es
		sub ax,bx
		@ModBlok ax

		@Cls
cmdchk:		@GetDrv
		mov olddrv,al
		cmp es:BYTE PTR [83h],":"
		jz dr
cdr:		mov dl,olddrv
		mov newdrv,dl
		jmp na
dr:		mov dl,es:BYTE PTR [82h]
		and dl,00001111b
		sub dl,1
		mov newdrv,dl
		mov ah,0Eh
		int 21h
		jb cdr

na:		add newdrv,"A"
		mov si,OFFSET drv
		mov dl,newdrv
		mov ds:BYTE PTR [si],dl
		@ChDir si,ds
		@GetBlok 0FFh
		mov sbuf,ax
		@DispStr pr5

chdir:		call filer
		mov dx,OFFSET ndta
		@GetFirst dx,10h,ds
		jb e0
calk1:		push ds
		mov ds,sdta
		TEST ds:BYTE PTR [15h],10h
		pop ds
		jz next
		push ds
		mov ds,sdta
		cmp ds:BYTE PTR [1Eh],"."
		pop ds
		jz next
		call namer
		call con1
		jmp cd2
w:		@GetKey 0,1,0
		ret
e0:		jmp quit

next:		mov dx,OFFSET ndta
		@GetNext dx,10h,ds
		jb cd1
		jmp calk1

cd2:		push sdta
		mov dx,OFFSET filename
		@ChDir dx
		jmp chdir

cd1:		mov dx,OFFSET dbak
		@ChDir dx
		jb e0
		@FreeBlok sdta
		pop sdta
		push ds
		mov ds,sdta
		xor dx,dx
		mov ax,1A00h
		int 21h
		pop ds
		jmp next

filer:		push es
		@GetBlok 0FFh
		mov sdta,ax
		pop es
		push ds
		mov ds,sdta
		xor dx,dx
		mov ax,1A00h
		int 21h
		pop ds
		mov dx,OFFSET ncom
start:		mov set,dx
		@GetFirst dx,07h,ds
		jb ex
calk:		call namer
		call con
		call killer
		mov dx,set
		@GetNext dx,07h,ds
		jb ex
		jmp calk
ex:		cmp pass,01
		jz home
		mov pass,01
		mov dx,OFFSET nexe
		jmp start
home:		mov pass,00
		ret

con:		push dx
		mov dx,0A0Ah
		@SetCurPos
		@DispStr space
		mov dx,0A0Ah
		@SetCurPos
		@DispStr pr
		@DispStr filename
		pop dx
		ret

quit:		@FreeBlok sbuf
		@SetDrv olddrv
		@Exit 0

namer:		push dx
		push es
		push ds
		pop es
		push ds
		mov ds,sdta
		mov di,OFFSET filename
		mov si,1Eh
		mov cx,13
get:		movs es:BYTE PTR [di],ds:BYTE PTR [si]
		cmp ds:BYTE PTR [si],0
		jz go
		loop get
go:		mov es:BYTE PTR [di],0
		mov es:BYTE PTR [di+1],"$"
		pop ds
		pop es
		pop dx
		ret

con1:		push cx
		push dx
		push ax
		push si
		mov si,OFFSET filename
		cmp ds:BYTE PTR [si],0
		jz c
		jmp cc		
c:		mov ds:BYTE PTR [si],"$"
cc:		mov dx,080Ah
		@SetCurPos
		@DispStr pr1
		@DispStr drv
		mov dx,090Ah
		@SetCurPos
		@DispStr space
		mov dx,090Ah
		@SetCurPos
		@DispStr pr2
		@DispStr filename
		pop si
		pop ax
		pop dx
		pop cx
		ret

END