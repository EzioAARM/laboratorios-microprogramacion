.MODEL small

.DATA
; Variable que contiene el texto que queremos mostrar
cadena DB 'Hola mundo$'     ; $ significa el final de la cadena

.STACK
.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX, @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX

; Imprimir cadena
; Para la asignación es MOV destino, origen
MOV DX, OFFSET cadena   ; Asignando a DX la variable cadena
MOV AH, 09H             ; Decimos que se imprimirá una cadena
INT 21H                 ; Ejecuta la interrupción anterior

; Finalizar el programa
MOV AH, 4CH  ; finaliza el proceso
INT 21H     ; Ejecuta la interrupción
END Programa