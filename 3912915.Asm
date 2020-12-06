.586
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib

.data
menu	db '1 - Input from keyboard',13,10
		db '2 - Input from file',13,10
		db '3 - Process',13,10
		db '4 - Output to display',13,10
		db '5 - Output to file',13,10
		db '0 - Exit',0

msg0	db 'Enter text.',0
msg1	db 'Text readed from input.txt',0
msg2	db 'Text processed.',0
msg3	db 'Text writed to output.txt',0
inf	db 'input.txt',0
outf	db 'output.txt',0
msge3	db 13,10,'Cant open input.txt.',0
s1	db 'CON',0
s2	db 'rb',0
s3	db 'wb',0
fmt	db '%c - %d',13,10,0
;единицей отмечены буквы в кодировке ASCII 
letters	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1	;A-Z
	db 1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
	db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1	;a-z
	db 1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
cnt	dd 256 dup(0)	;кол-во каждой из букв в строке

buf	db 32 dup(0)
txt	db 64000 dup(0)
res	db 256 dup(0)

.code
_start:
menu1:
	invoke crt_puts,offset menu
	invoke crt__getch	;ожидание нажатия любой клавиши
	cmp al,'1'	;если нажата не 1
	jnz n1
	invoke crt_puts,offset msg0
	invoke crt_gets,offset txt
	jmp menu1
	
n1:	cmp al,'2'		;если нажата не 2
	jnz n2			;то переход
;ввод из файла	
	invoke crt_fopen,offset inf,offset s2	;открытие входного файла
	test eax,eax		;если открыт 
	jnz opened			;переход
	invoke crt_puts,offset msge3	;вывести сообщение об ошибке
	jmp menu1			;
opened:	mov ebx,eax		;сохранить хэндл открытого файла
	invoke crt_fread,offset txt,1,64000,ebx
	mov txt[eax],0
	invoke crt_fclose,ebx
	invoke crt_puts,offset msg1	;вывести сообщение
	jmp menu1
n2: cmp al,'3'		;если нажата не 3
	jnz n3			;то переход
;очистка количеств повторений каждой буквы	
	lea edi,cnt
	mov ecx,256
	xor eax,eax
	rep stosd
	lea edi,txt	;начало текста
	xor ebx,ebx
l1:	mov bl,[edi]		;взять очередной символ
	cmp bl,0	;если конц текста
	jz f1		;то переход
	cmp letters[ebx],0	;если это не буква, 
	jz sk			;то пропустить
	inc byte ptr cnt[ebx*4]	;увеличить кол-во соотв букв
sk:	inc edi			;следующий символ
	jmp l1			;пройти по всем буквам
f1: mov res,0		;результат пуст
	mov ebx,0		;ASCII код символа
l2:	mov eax,cnt[ebx*4]	;взять кол-во повторений символа
	cmp eax,1		;если 1 или 0
	jbe nxt			;пропустить
	;иначе добавить к результату строку
	invoke crt_sprintf,offset buf,offset fmt,ebx,eax
	invoke lstrcat,offset res,offset buf
nxt:
	inc ebx		;след символ
	cmp ebx,256	;пока не пройдем по всем
	jnz l2		;продолжить
	invoke crt_puts,offset msg2	;вывести сообщение
	jmp menu1
n3: cmp al,'5'		;если нажата не 5
	jnz n5			;то переход
	invoke crt_fopen,offset outf,offset s3
	mov ebx,eax 
	invoke lstrlen,offset res
	invoke crt_fwrite,offset res,1,eax,ebx
	invoke crt_fclose,ebx
	invoke crt_puts,offset msg3	;вывести сообщение

	jmp menu1
n5: cmp al,'4'		;если нажата не 4
	jnz n4			;то переход
	invoke crt_printf,offset res
	jmp menu1
n4: cmp al,'0'		;если нажата не 0
	jnz menu1		;то переход
	invoke ExitProcess,0	;выход
end _start
end
