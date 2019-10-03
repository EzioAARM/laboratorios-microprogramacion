.MODEL small
.DATA
    NUM1 DB ?
    NUM2 DB ?
    RESULT DB ?
    PD DB ?
    SD DB ?
    DIVIDIR DB 10
    MSG1 DB 10, 13, "Ingrese el primer numero:$"
    MSG2 DB 10, 13, "Ingrese el segundo numero:$"
    RES1 DB 10, 13, "Total:$"
    RES2 DB 10, 13, "Diferencia:$"
    RES3 DB 10, 13, "Producto:$"
    RES4 DB 10, 13, "Cociente:$"
    RES5 DB 10, 13, "Residuo:$"
.STACK
.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX, @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX
    
    LEA DX, MSG1
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H
    SUB AL, 30H
    MOV NUM1, AL

    LEA DX, MSG2
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H
    SUB AL, 30H
    MOV NUM2, AL

    ;SUMA
    ADD AL, NUM1

    MOV AH, 0
    AAA
    ADD AH, 30H
    ADD AL, 30H

    MOV BX, AX

    ;IMPRIMIR SUMA
    LEA DX, RES1
    MOV AH, 09
    INT 21H

    MOV AH, 02
    MOV DL, BH
    INT 21H

    MOV AH, 02
    MOV DL, BL
    INT 21H

    ;RESTA
    MOV AX, 0000
    MOV AL, NUM1
    SUB AL, NUM2
    ;MOV RESULT, AL

    MOV AH, 0
    AAA
    ADD AH, 30H
    ADD AL, 30H

    MOV BX, AX

    ;IMPRIMIR RESTA
    LEA DX, RES2
    MOV AH, 09
    INT 21H

    MOV AH, 02
    MOV DL, BH
    INT 21H

    MOV AH, 02
    MOV DL, BL
    INT 21H

    ;MULTIPLICACION
    MOV CL, NUM1

    Multi:
    MOV AL, NUM2
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

    ;DIVISION
    MOV AX, 0000
    MOV AL, NUM1
    DIV NUM2

    MOV CH, AH
    ADD CH, 30H

    MOV AH, 0
    AAA
    ADD AH, 30H
    ADD AL, 30H

    MOV BX, AX

    ;IMPRIMIR DIVISION
    LEA DX, RES4
    MOV AH, 09
    INT 21H

    MOV AH, 02
    MOV DL, BL
    INT 21H

    LEA DX, RES5
    MOV AH, 09
    INT 21H

    MOV AH, 02
    MOV DL, CH
    INT 21H

    ; Finalizar el programa
    MOV AH, 4CH  ; finaliza el proceso
    INT 21H     ; Ejecuta la interrupción
End programa