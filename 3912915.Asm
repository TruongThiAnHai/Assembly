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
;�������� �������� ����� � ��������� ASCII 
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
cnt	dd 256 dup(0)	;���-�� ������ �� ���� � ������

buf	db 32 dup(0)
txt	db 64000 dup(0)
res	db 256 dup(0)

.code
_start:
menu1:
	invoke crt_puts,offset menu
	invoke crt__getch	;�������� ������� ����� �������
	cmp al,'1'	;���� ������ �� 1
	jnz n1
	invoke crt_puts,offset msg0
	invoke crt_gets,offset txt
	jmp menu1
	
n1:	cmp al,'2'		;���� ������ �� 2
	jnz n2			;�� �������
;���� �� �����	
	invoke crt_fopen,offset inf,offset s2	;�������� �������� �����
	test eax,eax		;���� ������ 
	jnz opened			;�������
	invoke crt_puts,offset msge3	;������� ��������� �� ������
	jmp menu1			;
opened:	mov ebx,eax		;��������� ����� ��������� �����
	invoke crt_fread,offset txt,1,64000,ebx
	mov txt[eax],0
	invoke crt_fclose,ebx
	invoke crt_puts,offset msg1	;������� ���������
	jmp menu1
n2: cmp al,'3'		;���� ������ �� 3
	jnz n3			;�� �������
;������� ��������� ���������� ������ �����	
	lea edi,cnt
	mov ecx,256
	xor eax,eax
	rep stosd
	lea edi,txt	;������ ������
	xor ebx,ebx
l1:	mov bl,[edi]		;����� ��������� ������
	cmp bl,0	;���� ���� ������
	jz f1		;�� �������
	cmp letters[ebx],0	;���� ��� �� �����, 
	jz sk			;�� ����������
	inc byte ptr cnt[ebx*4]	;��������� ���-�� ����� ����
sk:	inc edi			;��������� ������
	jmp l1			;������ �� ���� ������
f1: mov res,0		;��������� ����
	mov ebx,0		;ASCII ��� �������
l2:	mov eax,cnt[ebx*4]	;����� ���-�� ���������� �������
	cmp eax,1		;���� 1 ��� 0
	jbe nxt			;����������
	;����� �������� � ���������� ������
	invoke crt_sprintf,offset buf,offset fmt,ebx,eax
	invoke lstrcat,offset res,offset buf
nxt:
	inc ebx		;���� ������
	cmp ebx,256	;���� �� ������� �� ����
	jnz l2		;����������
	invoke crt_puts,offset msg2	;������� ���������
	jmp menu1
n3: cmp al,'5'		;���� ������ �� 5
	jnz n5			;�� �������
	invoke crt_fopen,offset outf,offset s3
	mov ebx,eax 
	invoke lstrlen,offset res
	invoke crt_fwrite,offset res,1,eax,ebx
	invoke crt_fclose,ebx
	invoke crt_puts,offset msg3	;������� ���������

	jmp menu1
n5: cmp al,'4'		;���� ������ �� 4
	jnz n4			;�� �������
	invoke crt_printf,offset res
	jmp menu1
n4: cmp al,'0'		;���� ������ �� 0
	jnz menu1		;�� �������
	invoke ExitProcess,0	;�����
end _start
end
