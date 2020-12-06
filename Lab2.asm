;Given bytes. Submit it in reverse code

.MODEL SMALL
.STACK 100H
.DATA
    a db 10111101b
    b db ?
    
.CODE
mov ax, @data
mov ds, ax
xor ax, ax
mov al, a
 
shl al,1 ; Shift left  
         ; al= 01111010b CF=MSB=1 (MSB-most significant bit) 
         ; if a>=0, after shl CF=0
         ; else CF=1
         
        
jnc plus  ; Jump if CF=0 

not al    ; al=10000101b CF=1
          
plus:
    rcr al, 1 ; Shift right with carry flag  
    mov b, al           
     
mov ah, 4ch
int 21h    

end