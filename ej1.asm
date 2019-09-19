.MODEL small                    ; modelo
.DATA                           ; variables
nombre DB 'Axel Rodriguez$'     ; Variable con nombre
carnet DB '1229715$'            ; variable con carnet

.STACK
.CODE
Programa:                       ; Etiqueta de inicio
; Inicialización del programa
MOV AX, @DATA                   ; Guardando direccion de inicio segmento de
MOV DS, AX

; Imprime la cadena con el nombre
MOV DX, OFFSET nombre           ; Asignando la variable a DX
MOV AH, 09H                     ; Decir que la cadena se imprima
INT 21H                         ; Ejecuta la interrupción

MOV DL, 9                       ; Se asigna el ASCII 9 a DL para imprimirlo
MOV AH, 02                      ; Se asigna el valor para imprimirlo en pantalla
INT 21H                         ; Ejecuta la interrupcion

; Imprime la cadena con el carnet
MOV DX, OFFSET carnet           ; Asignando la variable a DX
MOV AH, 09H                     ; Decir que la cadena se imprima
INT 21H                         ; Ejecuta la interrupción

MOV AH, 4CH
INT 21H
END Programa