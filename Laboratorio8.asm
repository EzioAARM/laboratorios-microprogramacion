.386
.model flat, stdcall
option casemap:none

;includes
include \masm32\include\windows.inc ;incluye formularios 
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\masm32rt.inc ;hace llamada a la hora del sistema

;macros
include \Macros\macros.lib

;librerias
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

;Segmento de datos
.DATA
	msgReadNum db "Ingrese un numero (maximo 12): ",0
.DATA?
;;;;;;;;;;;;;;
numero DW 20 dup(?)
total DD 20 dup(?)
;;;;;;;;;;;;;;;;;

.CODE
programa:
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PEDIR EL PRIMER NUMERO
	INVOKE StdOut, addr msgReadNum
	INVOKE StdIn, addr numero, 8
	INVOKE atodw, addr numero
	;MOV numero1,EAX
	MOV numero, AX
	;print str$(AX)
	;print str$(numero)

	MOV EAX, 1
	MOV total,1
	MOV BX,0
	Contador:
		INC BX
		MOV CX, BX
		CMP CX,2
		JB Fin
		SUB CX, 1
		MOV EDX, total
		Ciclo:
			ADD EDX,total
			SUB CX,1
			CMP CX,0
			JA Ciclo
			MOV total, EDX
		Fin:
		CMP BX,numero
		JB Contador
	print str$(total)

	;finalizar
finalizar:
	INVOKE ExitProcess,0
END programa