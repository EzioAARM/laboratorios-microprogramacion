.MODEL small

.DATA

.STACK

.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX

; Finalizar el programa
MOV AH, 4C  ; finaliza el proceso
INT 21H     ; Ejecuta la interrupción
END Programa