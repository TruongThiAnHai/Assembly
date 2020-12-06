.model small
.stack 256h
.data
 
step dw -1
stroka db 'VVEDITE NOMER STROKI COTORII NADO UDALIT',10,13,'$'
massive db 10,13,'PERVII MASSIV:',10,13,'$'
otvet db 10,13,'VTOROU MASSIV',10,13,'$'
mas     db 1,2,3,4,5
        db 1,2,4,1,7
        db 4,3,8,7,5
        db 5,4,3,7,7
        db 1,2,3,4,5
        db 5,4,1,7,4
len dw $-mas
 
.code
Start:
mov ax,@data
mov ds,ax
 
lea dx,stroka
mov ah,09h
int 21h
 
mov ah,01h ; ?????? ????? ??????
int 21h
sub ax,30h
cbw
push ax
 
mov dx,offset massive 
call call_output
 
mov dx,offset otvet
 
pop step
call call_output
 
Exit:
xor ax,ax
int 16h
 
mov ax,4c00h
int 21h
 
output:
push bp
mov bp,sp
 
mov dx,[bp+8]
mov ah,9
int 21h
 
mov cx,[bp+6]
mov si,[bp+4]
xor di,di
 
@1:
mov cx,5
 
@2:
inc di
cmp di,step
jnz @4
 
add si,5
jmp @3
 
@4:
lodsb
or al,30h
int 29h
mov al,20h
int 29h
 
loop @4
 
mov al,10
int 29h
 
@3:
cmp di,6
jnz @1
 
pop bp
ret 6
 
call_output:
 
push dx
push len
push offset mas
call output
ret
 
end Start