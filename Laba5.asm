
;FIND REVERSE OF EACH WORD IN A STRING
.MODEL small
.STACK 1000h
.DATA
    msg1 db 10,13,"Enter the string:$"
    msg2 db 10,13,"Reverse of the string:$"
    newline db 10,13,' $'
    buff db 60 dup(?)
    flag db 0
    stackempty db 1
.CODE
    print macro msg
        lea dx, msg
        mov ah,09h
        int 21h
    endm
main:
    mov   ax,@data
    mov   ds,ax
     
    print msg1
    print newline
    mov si,offset buff
    mov cx,0
    mov bx,0
    nxtchar:
        mov ah,01h
        int 21h
        inc bx
        cmp al,' '
        je popy
        cmp al,0dh
        je popy
        mov ah,0
        push ax
        mov stackempty,0
        inc cx
        jmp nxtchar
    popy:
        cmp stackempty,1
        je stackkaali
        cmp al,0dh
        jne noflag
        mov flag,1
    noflag:
        pop ax
        mov [si],al
        inc si
        loop noflag
        inc si
        mov stackempty,1
        cmp flag,1
        je display
        jmp nxtchar
        stackkaali:
        inc si
        jmp nxtchar
    display:
        print msg2
        print newline
        mov si,offset buff
        mov cx,bx
    dispnxt:
        mov dh,0
        mov dl,[si]
        mov ah,2
        int 21h
        inc si
        loop dispnxt 
    print buff    
    mov ah,04ch
    int 21h

End main