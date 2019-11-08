.386
.model flat, stdcall
option casemap:none

; Includes
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\masm32rt.inc 

; Librer�as
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

; Segmento de Datos
.DATA  
msgSuma DB "El total de la suma de 7 + 1 = ",0
msgResta DB 0ah,0dh,"El total de la resta de 7 - 1 = ",0
msgIguales DB 0ah,0dh,"Los numeros son iguales",0
msgPrimMayor DB 0ah,0dh,"El primero numero es mayor",0
msgSecMayor DB 0ah,0dh,"El segundo numero es mayor",0
suma dword 0
resta dword 0
n1 dword 7                                           
n2 dword 1

.DATA?

; C�digo
.CODE 
 
Programa:
main PROC

	MOV EAX,n1
	ADD EAX,n2
	MOV suma,EAX

	MOV EAX,n1
	SUB EAX,n2
	MOV resta,EAX

	ADD suma,30h
	ADD resta,30h


	INVOKE StdOut, addr msgSuma
	INVOKE StdOut, addr suma

	INVOKE StdOut, addr msgResta
	INVOKE StdOut, addr resta

	MOV EAX,n1
	CMP EAX,n2

	JZ iguales
	JC primerMayor
	JNZ segundoMayor

	iguales:
    INVOKE StdOut, addr msgIguales
	JMP fin

	primerMayor:
	INVOKE StdOut, addr msgPrimMayor
	JMP fin

	segundoMayor:
	INVOKE StdOut, addr msgSecMayor
	JMP fin

	; Finalizar
	fin:
	INVOKE ExitProcess,0

main ENDP
END Programa