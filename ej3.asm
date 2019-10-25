.MODEL small
.DATA
    Num1 DB ?
    Num2 DB ?
    Num3 DB ?
    Resi DB ?                      
    Coci DB ?                      
    AUX DB ?
.STACK
.CODE

Programa03:
    MOV AX,@DATA
    MOV DS, AX
    
    MOV AUX, 05H
    ADD AUX, 05h
    
    XOR AX, AX              ; Se limpia para evitar la impresion de basura
    MOV AH, 01H
    INT 21H
    MOV Num1, AL

    INT 21H
    MOV Num2, AL
    
    SUB Num1, 30h
    SUB Num2, 30h

    XOR AX, AX              ; Se limpia para evitar la impresion de basura        
    MOV AL, Num1        
    MUL AUX
    ADD AL, Num2       
    MOV Num1, AL
    
    MOV CL, Num1
    DEC CL             
    MOV Num3, CL
Ciclo:
    XOR AX, AX              ; Se limpia para evitar la impresion de basura
    MOV AL, Num1
    DIV Num3
    CMP AH, 0h
    JZ Impresion
Ciclo2:
    DEC Num3
    LOOP Ciclo
    JMP Finalizar
Impresion:
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    XOR AX, AX              ; Se limpia para evitar la impresion de basura
    MOV AL, Num3   
    DIV AUX
    MOV Coci, AL          
    MOV Resi, AH          
    XOR AX, AX              ; Se limpia para evitar la impresion de basura
    
    ADD Coci, 30H        
    ADD Resi, 30H         
    MOV DL, Coci
    MOV AH, 02H         
    INT 21H
    MOV DL, Resi       
    INT 21H
    JMP Ciclo2
Finalizar: 
    MOV AH,4CH
    INT 21H             
end Programa03