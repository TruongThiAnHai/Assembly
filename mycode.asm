.model small
.stack 100h
.data
msg1    db  0Ah,0Dh,"Enter string <80(char)",0Ah,0Dh,'$'
string  db  80 dup(?)
msg2    db  0Ah,0Dh,"Reversing string",0Ah,0Dh,'$'
.code
start:  mov ax,@data
    mov ds,ax
    lea dx,msg1
    mov ah,09h
    int 21h
    mov cx,80
    xor si,si
l1:     mov ah,01h
    int 21h
    cmp al,0Dh
    je continue
    mov string[si],al
    inc si
    loop l1
continue:   mov ah,09h
    lea dx,msg2
    int 21h
    cmp si,0
    je exit
    dec si
    mov cx,si
l2: mov si,cx
    mov dl,string[si]
    mov ah,02h
    int 21h
    loop l2
    mov dl,string[0]
    mov ah,02h
    int 21h 
exit:    
    mov ah,4Ch 
    int 21h
    end start