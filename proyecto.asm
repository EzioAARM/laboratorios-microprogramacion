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
        MOV AH, 01      ; Interrupción de entrada del teclado
        INT 21H         ; Ejecución de la interrupción
        JMP LEER_W      ; Salta a verificar que tecla presionó

    ; codigo
    LEER_W:
        CMP AL, 57H                         ; Verifica que sea W
        JZ INICIAR_LECTURA_MOVIMIENTO       ; Si es W regresa a leer
        JNZ LEER_A                          ; Si no es W salta a otra verificación

    LEER_A:
        CMP AL, 41H                         ; Verifica que sea A
        JZ INICIAR_LECTURA_MOVIMIENTO       ; Si es A regresa a leer
        JNZ LEER_S                          ; Si no es A salta a otra verificación

    LEER_S:
        CMP AL, 53H                         ; Verifica que sea S
        JZ INICIAR_LECTURA_MOVIMIENTO       ; Si es S regresa a leer
        JNZ LEER_D                          ; Si no es S salta a otra verificación

    LEER_D:
        CMP AL, 44H                         ; Verifica que sea D
        JZ INICIAR_LECTURA_MOVIMIENTO       ; Si es D regresa a leer
        JNZ FIN                             ; Si no es D sale del programa

FIN:
; Finalizar el programa
MOV AH, 4CH  ; finaliza el proceso
INT 21H     ; Ejecuta la interrupción
END Programa