.MODEL small
.DATA
    Msg DB 'Para salir presione la tecla Enter$'
.STACK
.CODE
Programa:
    MOV AX,@DATA
    MOV DS, AX
    
    MOV AX, 03H
    INT 10H
    
    LEA DX, Msg
    MOV AH, 09H
    INT 21h
Leer:
    XOR DX,DX           ;Se limpian los registros para evitar imprimir basura
    MOV AH, 07H
    INT 21H
    
    CMP AL, 0DH
    JZ Terminar
    CMP AL, 'X'         ;ODH es el código hexadecimal del Enter
    JNE Leer
    
    MOV DL, 'X'
    MOV AH, 02h
    INT 21H
    JMP Leer
Terminar: 
    MOV AH,4CH
    INT 21H             
END Programa