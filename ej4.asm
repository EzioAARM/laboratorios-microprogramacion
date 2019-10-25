.MODEL small
.STACK
.DATA
   Cad  db 9 dup ('$')
   V1 db ?
   N1  db ?
   Aux  db ?
.CODE
Programa: 
   MOV V1, 0            ;Residuo de cero
   MOV AH, 01H          ;Utilizado con la interrupcu?n siguiente
   INT 21H              ;Interrupci?n para leer
   SUB AL, 30H          ;Obtenci?n de valor real
   MOV N1, AL          ;N?mero con que trabajaremos

   MOV AL, N1  
   MOV BL, 10           ;Movemos a bl 10
   MUL BL               ;Multiplicamos 10 por el n?mero a convertir
   MOV Aux, AL          ;Asignamos a aux el residuo

   MOV V1, 0            ;Para segundo d?gito se repite
   MOV AH, 01h
   INT 21H      
   SUB AL, 30H
   ADD Aux, AL          ;Lo agregamos al n?mero anterior multiplicado por 10
   MOV BL, Aux          ;?ste ya no necesita ser multiplicado
   MOV N1, BL           ;El n?mero resultante a bl

   MOV AH, 02h          ;Imprimimos signo de igual
   MOV DL, '='
   INT 21H

   MOV SI, 6

   bin:        

      MOV AH, 00H       ;Aseguramos residuo de 0
      MOV AL, N1
      MOV BL, 2
      DIV BL
      MOV V1, AH
      MOV N1, AL

      MOV DL, V1
      ADD DL, 30H

      MOV Cad[SI], DL   ;Concatenamos resultados

      CMP N1, 1         ;Hacemos comparaci?n
      DEC SI
      JNE bin           ;Indicamos volver a etiqueta bin o:
      JE salida         ;Ir a etiqueta salir



      CMP N1, 0         ;Comparacion con 0
      JNE bin
      JMP salida

   salida:              ;Etiqueta de salida

      XOR DX, DX
      MOV DL, N1        ;Proceso para imprimir cadena final con numero binario
      ADD DL, 30H

   XOR AL, AL
   XOR AX, AX
   XOR AH, AH
   XOR BL, BL
   XOR DL, DL
   XOR DX, DX
   MOV AH, 09h
   LEA DX, Cad
   INT 21H
   MOV AH, 4CH
   INT 21H

END Programa