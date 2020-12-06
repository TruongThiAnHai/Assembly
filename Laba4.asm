
;Count numbers of the given letter in string
.MODEL SMALL
.STACK 100h     
.DATA    
    msg0	db 10,13,"Enter text:$"
    s       db 'c'
    enter   db 10,13,'$'
    msg        db  13,10, "Which letter do you want to count?$"
    strBig db 0FFFFh    
    len db ? 
    
.CODE
start:  
    mov ax,@data
    mov ds,ax 
    
    lea     dx,msg0 
    mov     ah,09h
    int     21h 
    
    mov     ah, 0Ah
    lea     dx,strBig
    int     21h 
    
    mov ah,2  
    mov dl,10
    int 21h
    
 
    xor bx,bx ;clear counter 
    xor cx,cx
    mov cl,[len]    
    lea di,strBig ; es: di points to string 
    mov al,s 
 
m1:
    repne scasb ;search for character in string 
    jnz  exit  
m2:         
    inc bl    
    test cx,cx  
    jnz  m1   
 
exit:     
    mov ah,9
    lea dx,enter
    int 21h

    call print
    mov ah,4ch
    int 21h  
    
print proc 
    mov ax,bx
    mov bx,10 
    mov cx,0
divide:
    mov dx,0
    div bx
    inc cx
    push dx
    cmp al,0
    je output
    jmp divide
output:
    pop dx 
    add dl,30h
    mov ah,2
    int 21h
    dec cx
    cmp cx,0
    jne output
    ret
print endp
end start