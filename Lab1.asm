.MODEL SMALL
.STACK 100h
.DATA
a db 5
b db 4 
c db 3
d db 2
e db 1
x dw ?
msg db "F=(2*(a+b*b)*(2*c-d*d))/(4*e)=$"  

.CODE  
main proc
    mov ax,@data
    mov ds,ax 
    
    mov ah,9
    lea dx,msg
    int 21h
    
    ;x1=2*(a+b*b)
    mov al,b
    ;mov bl,b
    imul al; result in ax
    add al,a ;lost info in ah => need sum ax with a
    ;#1 adc - ?  ; (add with carry) 
                    ;adc ax,bx    ax <- ax+bx+cf
    ;#2 cbw, cwd -?;cbw-convert byte word  (if al<80h, ah=0
                                                 ; else ah=0ffh)
                    ;cwd-convert word to bouble word (if al<800h, ah=0
                                                 ; else dx=0ffffh)
    mov bl,2
    imul bl
    mov x,ax 
     
    ;x2=x1*(2*c-d*d)
    mov al,d
    mov bl,d
    imul bl 
    mov bx,ax
    mov al,c
    mov dl,2
    imul dl
    sub ax,bx
    mov bx,x
    imul bx
    mov x,ax 
    
    ;x3=x2/(4*e)
    mov al,e
    mov bl,4
    imul bl
    mov bx,ax
    mov ax,x
    idiv bl
    mov x,ax
    
    call print 
    
    mov ah,4ch
    int 21h
main endp  

;-----------------------------   
;Print decimal number
print proc
    mov bx,10
    mov ax,x 
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

end         
