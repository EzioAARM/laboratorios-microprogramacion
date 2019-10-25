.MODEL small
.DATA
    Numero01 DB ?                   
    Numero02 DB ?                   
    Unidades DB ?                      
    Decenas DB ?                      
    ResultadoMultiplicacion DB 'El resultado es: $'
.STACK
.CODE
Programa:
    MOV AX,@DATA
    MOV DS, AX
    
    MOV AX, 03H
    INT 10H

    MOV AH, 01H
    INT 21H
    MOV Numero01, AL
    INT 21H
    MOV Numero02, AL

    SUB Numero01, 30h
    SUB Numero02, 30h

    XOR DX,DX
    MOV DX, OFFSET ResultadoMultiplicacion
    MOV AH, 09H
    INT 21H

    XOR AX,AX           
    XOR DX, DX
    MOV AL, Numero01        
    MOV CL, Numero02
    MOV DL, 0h
Multiplicar:
    ADD DL, Numero01
    Loop Multiplicar
    
    MOV CL, 05H
    ADD CL, 05H
    
    MOV AL, DL
    DIV CL
    MOV Decenas, AL          
    MOV Unidades, AH         
    XOR AX,AX
        
    ADD Decenas, 30H         
    ADD Unidades, 30H         
    MOV DL, Decenas
    MOV AH, 02H         
    INT 21H
    
    MOV DL, Unidades       
    INT 21H

    MOV AH,4CH
    INT 21H             
END Programa