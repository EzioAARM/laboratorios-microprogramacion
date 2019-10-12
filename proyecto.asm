.MODEL small
.DATA
    ; variables
.STACK
.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX, @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX
    
    INICIAR_LECTURA_MOVIMIENTO:
        MOV AH, 01
        INT 21H
        JMP LEER_W

    ; codigo
    LEER_W:
        CMP AL, 57H
        JZ INICIAR_LECTURA_MOVIMIENTO
        JNZ LEER_A

    LEER_A:
        CMP AL, 41H
        JZ INICIAR_LECTURA_MOVIMIENTO
        JNZ LEER_S

    LEER_S:
        CMP AL, 53H
        JZ INICIAR_LECTURA_MOVIMIENTO
        JNZ LEER_D

    LEER_D:
        CMP AL, 44H
        JZ INICIAR_LECTURA_MOVIMIENTO
        JNZ FIN

FIN:
; Finalizar el programa
MOV AH, 4CH  ; finaliza el proceso
INT 21H     ; Ejecuta la interrupción
END Programa