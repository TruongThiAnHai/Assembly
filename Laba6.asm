.MODEL medium
.STACK 1000h
.DATA
    menu    db  10, 13,10, "Please select an item:",10,13
            db  "1 - Input",10,13
            db  "2 - Output",10,13
            db  "3 - Exit",10,13
            db  "Enter item number: "
            db  '$' 
             
    msg0	db 10,13,"Enter the string: $",10,13
    msg2	db 10,13,"Reverse of the string: $",10,13
    msg3	db 10,13,"Text writed to output.txt$"
    outf	db  'output.txt',0 
    
    text  db 255 dup("$") 
    fhand   dw ?

    CrLf    db   10,13,'$'
    Sentence1 DB 255,?,255 dup("$")  
    str2 dw 255 dup("$")
    len dw ?
.CODE 

print macro msg
    lea     dx, msg 
    mov     ah, 09h
    int     21h  
endm 

main: 
    mov   ax,@data
    mov   ds,ax

ShowMenu:   
    print menu

getnum:       

    mov     ah, 1
    int     21h       

    cmp     al, '1'
    jl      ShowMenu  

    cmp     al, '4'
    jg      ShowMenu

    cmp     al, "1"
    je      Input
    
    cmp     al, "2"
    je      Output
    
    cmp     al, "3"
    je      Quit   
    
Input:

    print CrLf
    print msg0
        

    lea si, Sentence1
    mov ah, 0Ah
    mov dx, si
    int 21h

    ;Reverse String    
    mov cl, [si + 1]
    mov ch, 0
    add si, cx
    inc si
    lea di, str2

    jcxz EmptyString ;By-pass the reversal entirely!

    loop2:
        mov al, byte ptr[si]
        mov byte ptr[di], al
        dec si
        inc di
        loop loop2 
        
    ;Printing the reverse string (could be empty)    
    EmptyString:
        print msg2
        print str2  
   ;Open file to write
    mov ah,3dh ;open the file
    lea dx,outf
     mov al,02h
    int 21h
    ;PRESERVE FILE HANDLER RETURNED.
    mov  fhand, ax

    mov bx,ax
    mov  ah, 40h
    mov  bx, fhand
    mov  cx,21  ;max len
    mov  dx,offset str2
    int  21h

    ;CLOSE FILE (OR DATA WILL BE LOST).
    mov  ah, 3eh
    mov  bx, fhand
    int  21h  
    jmp ShowMenu 
    
Output:  
    print CrLf 
    mov ah,3dh ;open the file
    mov al,0   ;open for reading
    lea dx,outf
    int 21h
    mov fhand,ax
    mov si,0 
    
    ReadByte1:

        mov ah,3fh    ; Read data from the file
        mov bx,fhand  ; Address of data buffer
        mov cx,1      ;Read 1 Byte
        lea dx,text+si
        int 21h
        cmp ax,0     ; Did we successfully read all characters?
        JE EXIT1
        INC SI
        JMP ReadByte1

    EXIT1:

        MOV BYTE PTR text+si,"$"
        MOV AH,3EH
        INT 21H
        print text
    jmp ShowMenu 
             
Quit:
    mov   ah,4ch
    int   21h  
   
 

end main