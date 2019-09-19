.MODEL small                                ; modelo
.DATA                                       ; variables
texto DB 'El simbolo escogido es: $'        ; Variable con nombre

.STACK
.CODE
Programa:                       ; Etiqueta de inicio
; Inicialización del programa
MOV AX, @DATA                   ; Guardando direccion de inicio segmento de
MOV DS, AX

; Imprime la cadena con el texti que quiero
MOV DX, OFFSET texto            ; Asignando la variable a DX
MOV AH, 09H                     ; Decir que la cadena se imprima
INT 21H                         ; Ejecuta la interrupción

MOV DL, 38                      ; Se asigna el ASCII 9 a DL para imprimirlo
MOV AH, 02                      ; Se asigna el valor para imprimirlo en pantalla
INT 21H                         ; Ejecuta la interrupcion

MOV AH, 4CH
INT 21H
END Programa