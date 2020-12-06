

;Find sum of elements of the main diagonal

.MODEL small
.STACK 100h
.DATA
    matrix  db  91,4,7,1,2
            db  2,95,8,2,1
            db  3,6,99,3,2
            db  0,1,2,93,1
            
    rows    equ 4
    columns equ 5
    rez     dw  ?
 
.CODE
    mov ax, @data
    mov ds, ax
 
;In bx save index of row
;In si save index of column
;The whole numbering starts from 0.
    xor bx, bx
    xor di, di                
    xor ax, ax  
    mov cx, rows   
 
c_external: 
    push    cx  
    mov cx, columns 
    xor si, si  
    
    c_internal: 
        cmp di, si ;if index of row=index of column
        je summ    
        jne next   
    
    summ:
        add al, byte ptr matrix[bx][si]
        adc ah, 0h 
    next: 
    
        inc si      
        loop c_internal
    
        
    pop cx
    add bx,columns  
    inc di      

loop c_external
  
mov rez, ax 
mov ah, 4ch
int 21h   

end 

