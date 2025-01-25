                Title Simple
                Include dos.inc
                .Model Small
Side1           Segment
Assume          cs:Side1,ds:Side1
                Org     100h
Start:          jmp     Begin
Handle          dw      0
Fname           db      "c:\master.tyt",0
Cant_Open       db      "Can't open file c:\master.tyt",10,13,"$"
Cant_Posit      db      "Can't position into file c:\master.tyt",10,13,"$"
ALLREADY        DB      "SIMPLE ALLREADY IS RESIDENT",10,13,"$"
ProcExec        dw      0
SegProc         dw      0
OffProc         dw      0
First           dw      0
Vector09        dw      0
Vector09h       dw      0
Vector33        dw      0
Vector33h       dw      0
Vector13        dw      0
Vector13h       dw      0
Vector21        dw      0
Vector21h       dw      0
Vector20        dw      0
Vector20h       dw      0
Vector27        dw      0
Vector27h       dw      0
Day             db      0
Month           db      0
Year            dw      0
ProcName        db      13 dup(0)
Int09l          dw      0
Int09h          dw      0
Int13l          dw      0
Int13h          dw      0
Int331          dw      0
Int332          dw      0
Int333          dw      0
Int334          dw      0
Control         db      0
                dw      0
Buffer          db      36 dup(0)
Lenght_Buff     dw      34d
;
;____________________________Procedures of interrrupts
Int_09h:
                inc cs:Int09l
                jnz Cont1
                inc cs:Int09h
Cont1:
                pushf
                call dword ptr cs:[Vector09]
                iret
Int_33h:
                inc cs:Int331
                jnz Cont2
                inc cs:Int332
                jnz Cont2
                inc cs:Int333
                jnz Cont2
                inc cs:Int334
Cont2:
                pushf
                call dword ptr cs:[Vector33]
                iret
Int_13h:
                inc cs:Int13l
                jnz Cont3
                inc cs:Int13h
Cont3:
                pushf
                call dword ptr cs:[Vector13]
                iret

Int_21h:
                sti
                push ax
                push bx
                push cx
                push es
                push di
                push si
                push bp
                push dx
                push ds
                cmp ax,4b00h
                jnz Coda
Continue:
                call Execs
                mov ax,0
                mov es,ax
                mov dx,cs:[Vector21]
                mov ax,cs:[Vector21h]
                mov es:[84h],dx
                mov es:[86h],ax
                pop ds
                pop dx
                pop bp
                pop si
                pop di
                pop es
                pop cx
                pop bx
                pop ax
                pushf
                call dword ptr cs:[Vector21]
                pop cs:[SegProc]
                pop cs:[OffProc]
                jc SetCarry
                popf
                clc
                jmp CarryAll
SetCarry:
                popf
                stc
CarryAll:
                pushf
                push cs:[OffProc]
                push cs:[SegProc]
                push ax
                push bx
                push cx
                push es
                push di
                push si
                push bp
                push dx
                push ds
                call Cancel
                call RecallVector
                pop ds
                pop dx
                pop bp
                pop si
                pop di
                pop es
                pop cx
                pop bx
                pop ax
                iret
;_ _ _ _ _ _ _ _ _ _ _ _Return outside of procedure
Coda:
                pop ds
                pop dx
                pop bp
                pop si
                pop di
                pop es
                pop cx
                pop bx
                pop ax
                jmp dword ptr cs:[Vector21]

RecallVector:
                push ax
                push es
                mov ax,0
                mov es,ax
                mov dx,es:[84h]
                mov ax,es:[86h]
                mov cs:[Vector21],dx
                mov cs:[Vector21h],ax
                mov ax,offset Int_21h
                mov es:[84h],ax
                mov es:[86h],cs
                pop es
                pop ax
                ret


;
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ Name of execution procedure to memory
Execs:
                mov ax,cs
                mov es,ax
;
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ Clearing name of procedure
                mov ah,20h
                mov si,offset ProcName
                mov cx,13d
ClearName:
                mov byte ptr es:[si],ah
                inc si
                loop ClearName
;
;_ _ _ _ _ _ _ _ _ _ _ _ _ _Find name and extention
                mov di,dx
                mov bx,dx
                mov cx,256d
FindName:
                cmp byte ptr ds:[di],0
                jz Founded
                cmp byte ptr ds:[di],'\'
                jnz Step
                mov bx,di
Step:
                inc di
                loop FindName
;
;_ _ _ _ _ _ _ _ _ _ Copiring name to buffer
Founded:
                mov di,bx
                mov cx,13d
                mov si,offset ProcName
CopyName:
                mov ah,byte ptr ds:[di]
                or ah,ah
                jz StopCopy
                mov byte ptr es:[si],ah
                inc si
                inc di
                loop CopyName
;
;_ _ _ _ _ _ _ _ _ _Geting date
StopCopy:
                @GetDate
                mov ax,cs
                mov ds,ax
                mov Day,dh
                mov Month,dl
                mov Year,cx
                ret
;
;_ _ _ _ _ _ _ _ _ _Open or creating statistics file
Cancel:
                mov ax,cs
                mov ds,ax
Forward:
                push ds
                @OpenFil Fname,2
                pop ds
                jnc  Okey
                push ds
                @MakFil Fname
                pop ds
                jnc  Okey
                @DispStr Cant_Open
                ret
;
;_ _ _ _ _ _ _ _ _ _Positioning to the end of file
Okey:
                mov Handle,ax
                mov bx,ax
                push ds
                mov ax,4202h
                xor cx,cx
                xor dx,dx
                int 21h
                pop ds
                jnc Well
                @DispStr Cant_Posit
                ret
Well:
;
;_ _ _ _ _ _ _ _ _ _ _ _ _Control suming and security
                mov di,offset Month
                mov cx,32d
                mov al,Day
Control1:
                sub al,byte ptr ds:[di]
                inc di
                loop Control1
                mov Control,al
                mov di,offset Day
                mov si,offset Buffer
                mov cx,36d
CopyBuffer:
                mov al,byte ptr ds:[di]
                mov byte ptr ds:[si],al
                inc si
                inc di
                loop CopyBuffer
                mov al,Control
                mov di,offset Buffer
                mov cx,33d
Control2:
                add byte ptr ds:[di],al
                inc di
                loop Control2
;
;_ _ _ _ _ _ _ _ _ _ _ _Writing data to file
                push ds
                mov dx,offset Buffer
                @Write dx,Lenght_Buff,Handle
                pop ds
                push ds
                @ClosFil Handle
                pop ds
;
;_ _ _ _ _ _ _ _ _ _ _ _Clearing data buffer
                xor cx,cx
                mov  word ptr Int13l,cx
                mov  word ptr Int13h,cx
                mov  word ptr Int09l,cx
                mov  word ptr Int09h,cx
                mov  word ptr Int334,cx
                mov  word ptr Int333,cx
                mov  word ptr Int332,cx
                mov  word ptr Int331,cx
                ret
;
;___________________________Block procedure geting interupts points
Begin:
                mov ax,cs
                mov ds,ax
                mov ax,3509h
                int 21h
                cmp bx,offset Int_09h
                jnz ContInst
                jmp AllreadyInst
ContInst:
                mov Vector09,bx
                mov Vector09h,es
                mov ax,3533h
                int 21h
                mov Vector33,bx
                mov Vector33h,es
                mov ax,3513h
                int 21h
                mov Vector13,bx
                mov Vector13h,es
                mov ax,3521h
                int 21h
                mov Vector21,bx
                mov Vector21h,es
;
;___________________________Block procedure seting points
                mov dx,offset Int_09h
                mov ax,2509h
                int 21h
                mov dx,offset Int_13h
                mov ax,2513h
                int 21h
                mov dx,offset Int_33h
                mov ax,2533h
                int 21h
                mov dx,offset Int_21h
                mov ax,2521h
                int 21h
;
;_______________________________Suspend and stay rezident
                mov cs:[First],1
                mov dx,offset Begin
                mov cl,4
                shr dx,cl
                inc dx
                mov ax,3100h
                int 21h
AllreadyInst:
                @DispStr Allready
                @Exit 0
Side1           ends
                end start