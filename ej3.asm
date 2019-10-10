.MODEL small
.DATA

    N1 DB ?
    N2 DB ?
    N DB ?
    RESULT DB ?
    PD DB ?
    SD DB ?
    CONTADOR DB 0
    DIVIDIR DB 10

    MSG1 DB 10, 13, "Ingrese el primer numero: $"
    MSG2 DB 10, 13, "Ingrese el segundo numero: $"

    RES3 DB 10, 13, "Producto: $"
    RES5 DB 10, 13, "Cociente: $"
    RES6 DB 10, 13, "Residuo: $"

.STACK
.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX, @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX

    ;PRIMERA PARTE
    LEA DX, MSG1
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H
    SUB AL, 30H
    MOV N1, AL

    LEA DX, MSG2
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H
    SUB AL, 30H
    MOV N2, AL

    ;MULTIPLICACION SUMAS SUCESIVAS.
    MOV CL, N1

    Multi:
    MOV AL, N2
    ADD RESULT, AL
    LOOP Multi

    FinalMulti:
    MOV AX, 0000
    MOV AL, RESULT
    DIV DIVIDIR

    MOV PD, AL
    MOV SD, AH

    LEA DX, RES3
    MOV AH, 09
    INT 21H

    ADD PD, 30H

    MOV AH, 02
    MOV DL, PD
    INT 21H

    ADD SD, 30H

    MOV AH, 02
    MOV DL, SD
    INT 21H

    ;DIVISION SUMAS SUCESIVAS.
    MOV AL, N1
    MOV RESULT, AL
    MOV CL, N1

    Division:
    MOV AL, N2
    SUB RESULT, AL

    JS FinalDivision

    ADD CONTADOR, 1

    LOOP Division

    FinalDivision:

    ;COCIENTE
    LEA DX, RES5
    MOV AH, 09
    INT 21H

    ADD CONTADOR, 30H

    MOV AH, 02
    MOV DL, CONTADOR
    INT 21H

    ;RESIDUO
    LEA DX, RES6
    MOV AH, 09
    INT 21H

    SUB CONTADOR, 30H

    ;[MULTIPLICACION PARA CALCULAR EL RESIDUO] -> (CONTADOR*VALOR2) - VALOR1
    MOV AX, 0000
    MOV AL, N2
    MUL CONTADOR
    MOV BX, AX

    MOV AL, N1

    SUB AL, BL

    ADD AL, 30H
    MOV BL, AL

    MOV AH, 02
    MOV DL, BL
    INT 21H


; Finalizar el programa
MOV AH, 4CH  ; finaliza el proceso
INT 21H     ; Ejecuta la interrupción
END Programa