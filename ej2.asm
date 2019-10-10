.MODEL small
.DATA
    N1 DB ?
    N2 DB ?
    IGUALES DB 10,13,"Los numeros son iguales$"
    MENOR DB 10,13,"El primer numero es mayor al segundo$"
    MAYOR DB 10,13,"El segundo numero es mayor al primero$"
    IN1 DB 10,13,"Ingrese el primero numero: $"
    IN2 db 10,13,"Ingrese el segundo numero: $"
.STACK
.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX, @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX

    LEA DX, IN1
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H

    MOV N1, AL

    LEA DX, IN2
    MOV Ah, 09
    INT 21H

    MOV AH, 01
    INT 21H

    MOV N2, aL

    MOV DL, N2

    CMP DL, N1

    JG MAYORET

    JL MENORET

    JZ IGUALET

    IGUALET:
    LEA DX, IGUALES
    MOV AH, 09
    INT 21H
    JMP FINAL

    MAYORET:
    LEA DX, MAYOR
    MOV AH, 09
    INT 21H
    JMP FINAL

    MENORET:
    LEA DX, MENOR
    MOV AH, 09
    INT 21H
    JMP FINAL

    FINAL:
; Finalizar el programa
MOV AH, 4CH  ; finaliza el proceso
INT 21H     ; Ejecuta la interrupción
END Programa