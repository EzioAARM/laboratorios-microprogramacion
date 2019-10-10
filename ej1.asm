.MODEL small
.DATA
    NUM DB ?
    INMSG DB 10, 13, "Ingrese el numero: $"
    PAR DB 10, 13, "El numero es par: $"
    IMPAR DB 10, 13, "El numero es impar: $"
.STACK
.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX, @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX

    LEA DX, INMSG
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H
    SUB AL, 30H
    MOV NUM, AL

    MOV AH, NUM
    MOV BL, NUM

    CMP BL, 1

    JP EsPar
    JNP EsImpar

    EsPar:
    MOV AH, 09H
    LEA DX, PAR
    INT 21H
    JMP Terminar

    EsImpar:
    MOV AH, 09H
    LEA DX, IMPAR
    INT 21H
    JMP Terminar

Terminar:
; Finalizar el programa
MOV AH, 4CH  ; finaliza el proceso
INT 21H     ; Ejecuta la interrupción
END Programa