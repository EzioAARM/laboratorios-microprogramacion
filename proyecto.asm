left EQU 0
top EQU 2
row EQU 20	;Se cambia la cantidad de numero de lineas
col EQU 50	;Se cambia la cantidad de numero de columnas
right EQU left+col
bottom EQU top+row

.MODEL small
.DATA          
    msg db "¡Bienvenido!$",0
    instructions db 0AH,0DH,"Usa las teclas W A S D para MOVerte",0AH,0DH,"Presiona la Q en cualquier momento para salir",0DH,0AH, "Presiona cualquier tecla para continuar...$"
    quitmsg db "Adios!",0
    gameovermsg db "GAME OVER", 0
    scoremsg db "Puntos: ",0
    head db 'n',10,10
    body db 'X',10,11, 3*15 DUP(0)
    segmentcount db 1
    fruitactive db 1
    fruitx db 8
    fruity db 8
    gameover db 0
    quit db 0   
    delaytime db 5
.STACK
    dw   128  dup(0)
.CODE

main PROC far
	MOV ax, @data
	MOV ds, ax 
	
	MOV ax, 0b800H
	MOV es, ax
	
	;clearing the screen
	MOV ax, 0003H
	INT 10H
	
	MOV AH, 06H
	MOV AL, 00H
    MOV bh, 100D		;cambia el colo arribita
	MOV CX, 0000H
	MOV DX, 2555H
	INT 10H
	
	LEA bx, msg
	MOV dx,00
	CALL writestringat
	
	LEA dx, instructions
	MOV ah, 09H
	INT 21h
	
	MOV ah, 07h
	INT 21h
	MOV ax, 0003H
	INT 10H
	
	
	MOV AH, 06H
	MOV AL, 00H
    MOV bh, 177D		;CAMBIA EL COLOR DE TODO
	MOV CX, 0000H
	MOV DX, 2555H
	INT 10H
	
    CALL printbox      
    
    
mainloop: 


    
	CALL delay  
	
    LEA bx, msg
    MOV dx, 00
	
    CALL writestringat
    CALL shiftsnake
    CMP gameover,1
    JE gameover_mainloop
    
    CALL keyboardfunctions
    CMP quit, 1
    JE quitpressed_mainloop
    CALL fruitgeneration
    CALL draw
    
    ;TODO: check gameover and quit
    
    JMP mainloop
    
gameover_mainloop:
    MOV AX, 0003H                       ; Limpia en pantalla 
    INT 10H                             ; Hace la interrupcion 
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 40H                         ; Color Amarillo                    
    MOV CX, 0000H                       ; Posicion inicial que empieza a pintar 
    MOV DX, 244fH                       ; Posicion final que pinta  
    INT 10H
    MOV delaytime, 100
    MOV dx, 0000H
    LEA bx, gameovermsg
    CALL writestringat
    CALL delay    
    JMP quit_mainloop    
    
quitpressed_mainloop:
    MOV ax, 0003H
	INT 10H    
    MOV delaytime, 100
    MOV dx, 0000H
    LEA bx, quitmsg
    CALL writestringat
    CALL delay    
    JMP quit_mainloop    

    
    

quit_mainloop:
;first clear screen
MOV ax, 0003H
INT 10h    
MOV ax, 4c00h
INT 21h  



         


delay PROC 
    
    ;this procedure uses 1A interrupt, more info can be found on   
    ;http://www.computing.dcu.ie/~ray/teaching/CA296/notes/8086_bios_and_dos_interrupts.html
    MOV ah, 00
    INT 1Ah
    MOV bx, dx
	
    
jmp_delay:
    INT 1Ah
	
    SUB dx, bx
    ;there are about 18 ticks in a second, 10 ticks are about enough
    CMP dl, delaytime                                                      
    JL jmp_delay    
    RET
    
delay endp
   
   


fruitgeneration proc
    MOV ch, fruity
    MOV cl, fruitx
	
regenerate:
    
    CMP fruitactive, 1
    JE ret_fruitactive
    MOV ah, 00
    INT 1Ah
    ;dx contains the ticks
	
    PUSH dx
    MOV ax, dx
    XOR dx, dx
    XOR bh, bh
    MOV bl, row
    DEC bl
    DIV bx
    MOV fruity, dl
    INC fruity
    
    
    POP ax
    MOV bl, col
    DEC dl
    XOR bh, bh
    XOR dx, dx
    DIV bx
    MOV fruitx, dl
    INC fruitx
    
    CMP fruitx, cl
    JNE nevermind
    CMP fruity, ch
    JNE nevermind
    JMP regenerate             
nevermind:
	
    MOV al, fruitx
    ROR al,1
    JC regenerate
    
    
    ADD fruity, top
    ADD fruitx, left 
    
    MOV dh, fruity
    MOV dl, fruitx
    CALL readcharat
    CMP bl, 'X'
    JE regenerate
    CMP bl, 'n'
    JE regenerate
    CMP bl, '('
    JE regenerate
    CMP bl, ')'
    JE regenerate
    CMP bl, 'U'			;Disque cabeza para abajo pero no creo que sea
    JE regenerate    
    
ret_fruitactive:
    RET
fruitgeneration endp


dispdigit proc
    ADD dl, '0'
    MOV ah, 02H
    INT 21H
    RET
dispdigit endp   
   
dispnum PROC   
	
    TEST ax,ax
    JZ retz
    XOR dx, dx
    ;ax contains the number to be displayed
    ;bx must contain 10
    MOV bx,10
    DIV bx
    ;dispnum ax first.
    PUSH dx
    CALL dispnum  
    POP dx
    CALL dispdigit
    RET
retz:
    MOV ah, 02  
    RET    
dispnum endp   



;sets the cursor position, ax and bx used, dh=row, dl = column
;preserves other registers
setcursorpos proc
	
    MOV ah, 02H
    PUSH bx
    MOV bh,0
    INT 10h
    POP bx
    RET
setcursorpos endp



draw proc

    LEA bx, scoremsg
    MOV dx, 0109
    CALL writestringat
    
    
    ADD dx, 7
    CALL setcursorpos
    MOV al, segmentcount
    DEC al
    XOR ah, ah
    CALL dispnum
        
    LEA si, head
draw_loop:
	
    MOV bl, ds:[si]
    TEST bl, bl
    JZ out_draw
    MOV dx, ds:[si+1]
    CALL writecharat
    ADD si,3   
    JMP draw_loop 

out_draw:
	
    MOV bl, 'O'
    MOV dh, fruity
    MOV dl, fruitx
    CALL writecharat
    MOV fruitactive, 1
    
    RET
    
    
    
draw endp



;dl contains the ascii character if keypressed, else dl contains 0
;uses dx and ax, preserves other registers
readchar proc
    MOV ah, 02H		;Parte que hace por presionar la tecla 2 veces la tecla para que funciona
    INT 16H
    JNZ keybdpressed
    XOR dl, dl
    RET
keybdpressed:
    ;extract the keystroke from the buffer
    MOV ah, 00H
    INT 16H
    MOV dl,al
    RET


readchar endp                    
         
         
         
                  
                    


keyboardfunctions proc
    
    CALL readchar
    CMP dl, 0
    JE next_14
    
    ;so a key was pressed, which key was pressed then solti?
    CMP dl, 'w'
    JNE next_11
    CMP head, 'U'		;Cabeza para abajo
	
    JE next_14
    MOV head, 'n'
    RET
next_11:
    CMP dl, 's'
    JNE next_12
    CMP head, 'n'
    JE next_14
	
    MOV head, 'U'		;Cabeza para abajo

    RET
next_12:
    CMP dl, 'a'
    JNE next_13
    CMP head, ')'
    JE next_14
    MOV head, '('
    RET
next_13:
    CMP dl, 'd'
    JNE next_14
    CMP head, '('		;Para hacer el MOVimiento
    JE next_14
    MOV head,')'
next_14:    
    CMP dl, 'q'
    JE quit_keyboardfunctions
    RET    
quit_keyboardfunctions:   
    ;conditions for quitting in here please  
    INC quit
    RET
    
keyboardfunctions endp


                    
                    
                    
                    
                    
                    
shiftsnake PROC     
    MOV bx, offset head
    
	
    ;determine the where should the head go solti?
    ;preserve the head
    XOR ax, ax
    MOV al, [bx]
    PUSH ax
    INC bx
    MOV ax, [bx]
    INC bx    
    INC bx
    XOR cx, cx
l:  
	
    MOV si, [bx]
    TEST si, [bx]
    JZ outside
    INC cx     
    INC bx
    MOV dx,[bx]
    MOV [bx], ax
    MOV ax,dx
    INC bx
    INC bx
    JMP l
    
outside:    
    
    
    ;hopefully, the snake will be shifted, i.e. MOVed.
    ;now shift the head in its proper direction and then clear the last segment. 
    ;But don't clear the last segment if the snake has eaten the fruit
	
    POP ax
    ;al contains the snake head direction
    
    PUSH dx
    ;dx now consists the coordinates of the last segment, we can use this to clear it
    
    
    LEA bx, head
    INC bx
    MOV dx, [bx]
    
    CMP al, '('
    JNE next_1
    DEC dl
    DEC dl
    JMP done_checking_the_head
next_1:
    CMP al, ')'
    JNE next_2                
    INC dl 
    INC dl
    JMP done_checking_the_head
    
next_2:
    CMP al, 'n'
    JNE next_3 
    DEC dh               
                   
    
    JMP done_checking_the_head
    
next_3:
	
    ;must be 'v'
    INC dh
    
done_checking_the_head:    

	
    MOV [bx],dx
    ;dx contains the new position of the head, now check whats in that position   
    CALL readcharat ;dx
    ;bl contains the result
    
    CMP bl, 'O'
    JE i_ate_fruit
    
    ;if fruit was not eaten, then clear the last segment, 
    ;it will be cleared where?
    MOV cx, dx
    POP dx 
    CMP bl, 'X'    ;the snake bit itself, gameover
    JE game_over
    MOV bl, 0
    CALL writecharat
    MOV dx, cx
    
    
    
    
    
    ;check whether the snake is within the boundary
    CMP dh, top
    JE game_over
    CMP dh, bottom
    JE game_over
    CMP dl,left
    JE game_over
    CMP dl, right
    JE game_over
    
    
    
    ;balance the stack, number of segment and the coordinate of the last segment
    
    RET
game_over:
    INC gameover
    RET
i_ate_fruit:    

    ; add a new segment then
    MOV al, segmentcount
    XOR ah, ah
    
    
    LEA bx, body
    MOV cx, 3
    MUL cx
    
    POP dx
    ADD bx, ax
    MOV byte ptr ds:[bx], 'X'
    MOV [bx+1], dx
    INC segmentcount 
    MOV dh, fruity
    MOV dl, fruitx
    MOV bl, 0
    CALL writecharat
    MOV fruitactive, 0   
    RET 
shiftsnake endp
   
   
                               
                               
                               
                               
                               
                               
                               
                               
                               
   
         
;Printbox
printbox proc
;Draw a box around
    MOV dh, top
    MOV dl, left
    MOV cx, col
	MOV AH, 06H
	MOV AL, 00H
    MOV bh, 176D		;cambia el colo arribita
	INT 10H

l1:                 
    CALL writecharat
    INC dl
    loop l1    
    MOV cx, row
	
l2:
    CALL writecharat
    INC dh
    loop l2
    
    MOV cx, col
l3:
    CALL writecharat
    DEC dl
    loop l3

    MOV cx, row     
l4:
    CALL writecharat    
    DEC dh 
    loop l4    
    
    RET
printbox endp
              
              
              
              
              
              
              
              
              
;dx contains row, col
;bl contains the character to write
;uses di. 
writecharat proc
    ;80x25
	
	
    PUSH dx
    MOV ax, dx
    AND ax, 0FF00H
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    
	
    
    PUSH bx
    MOV bh, 160
    MUL bh 
    POP bx
    AND dx, 0FFH
    SHL dx,1
    ADD ax, dx
    MOV di, ax
    MOV es:[di], bl
    POP dx
    RET    
writecharat endp
            
            
            
            
            
            
            
            
            
;dx contains row,col
;returns the character at bl
;uses di
readcharat proc
    PUSH dx
    MOV ax, dx
    AND ax, 0FF00H
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1    
    PUSH bx
    MOV bh, 160
    MUL bh 
    POP bx
    AND dx, 0FFH
    SHL dx,1
    ADD ax, dx
    MOV di, ax
    MOV bl,es:[di]
    POP dx
    RET
readcharat endp        








;dx contains row, col
;bx contains the offset of the string
writestringat proc

	
    PUSH dx
    MOV ax, dx
    AND ax, 0FF00H
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    SHR ax,1
    
    PUSH bx
    MOV bh, 160
    MUL bh
    
    POP bx
    AND dx, 0FFH
    SHL dx,1
    ADD ax, dx
    MOV di, ax
loop_writestringat:
    
	
	
    MOV al, [bx]
    TEST al, al
    JZ exit_writestringat
    MOV es:[di], al
    INC di
    INC di
    INC bx
    JMP loop_writestringat
    
    
exit_writestringat:

    POP dx
    RET
    
    
writestringat endp
     
     
     
     
     
     
main endp
          
end main
