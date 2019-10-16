left equ 0
top equ 2
row equ 20	;Se cambia la cantidad de numero de lineas
col equ 50	;Se cambia la cantidad de numero de columnas
right equ left+col
bottom equ top+row

.model small
.data          
    msg db "BIENVENIDOS",0
    instructions db "Usa:",10,13,"WASD para moverte",10,13,"X para salir$"
    quitmsg db "QUIT",0
    gameovermsg db "GAMEOVER", 0
    scoremsg db "PUNTOS: ",0
    head db 'n',10,10
    body db 'X',10,11, 3*15 DUP(0)
    segmentcount db 1
    fruitactive db 1
    fruitx db 8
    fruity db 8
    gameover db 0
    quit db 0   
    delaytime db 1
	
	
	

.stack
    dw   128  dup(0)


.code

main proc far
	mov ax, @data
	mov ds, ax 				; 			PARA ACCEDER A LOS DATOS
	
	mov ax, 0b800H
	mov es, ax
	
	
	mov ax, 0003H
	int 10H					;			LIMPIAMOS LA PANTALLA
	
	MOV AH, 06H
	MOV AL, 00H
    mov bh, 100D			;			CAMBIAMOS EL COLOR DE LA PANTALLA A AMARILLO
	MOV CX, 0000H
	MOV DX, 2555H
	INT 10H
	

    
	mov dx, 0000H
    mov ah,02h  
    mov dh,12                           ; Fila 
    mov dl,36                           ; Columna
    int 10h
    mov ah,09h
    mov bl,0eh                          ; Color
    mov cx,1                            
    mov al, msg                ; Mensaje de salida
    int 10h
    lea bx, msg
    call writestringat  
	
	mov ah, 07h
	int 21h
	mov ax, 0003H
	int 10H

    mov ax, 0003H
	int 10H					;			LIMPIAMOS LA PANTALLA
	
	MOV AH, 06H
	MOV AL, 00H
    mov bh, 100D			;			CAMBIAMOS EL COLOR DE LA PANTALLA A AMARILLO
	MOV CX, 0000H
	MOV DX, 2555H
	INT 10H

    mov dx, 0000H
    mov ah,02h  
    mov dh,09                           ; Fila 
    mov dl,36                           ; Columna
    int 10h
    mov ah,09h
    mov bl,0eh                          ; Color
    mov cx,1                            
    mov al, instructions                ; Mensaje de salida
    int 10h
    lea bx, instructions
    call writestringat
	
    mov ah, 07h
	int 21h
	mov ax, 0003H
	int 10H
	
	MOV AH, 06H
	MOV AL, 00H
    mov bh, 177D		;				CAMBIA EL COLOR DE A AZUL CON LETRAS NEGRAS
	MOV CX, 0000H
	MOV DX, 2555H
	INT 10H
	
    call printbox      

mainloop: 


    
	call delay  
	
    lea bx, msg
    mov dx, 00
	
    call writestringat
    call shiftsnake
    cmp gameover,1
    je gameover_mainloop
    
    call keyboardfunctions
    cmp quit, 1
    je quitpressed_mainloop
    call fruitgeneration
    call draw
    
    ;TODO: check gameover and quit
    
    jmp mainloop
    
gameover_mainloop: 
    MOV AX, 0003H                       ; Limpia en pantalla 
    INT 10H                             ; Hace la interrupcion 
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 40H                         ; Color Amarillo                    
    MOV CX, 0000H                       ; Posicion inicial que empieza a pintar 
    MOV DX, 244fH                       ; Posicion final que pinta  
    INT 10H
    mov delaytime, 100
    mov dx, 0000H
    lea bx, gameovermsg
    call writestringat
    call delay    
    jmp quit_mainloop    
    
quitpressed_mainloop:
    MOV AX, 0003H                       ; Limpia en pantalla 
    INT 10H                             ; Hace la interrupcion 
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 40H                         ; Color Amarillo                    
    MOV CX, 0000H                       ; Posicion inicial que empieza a pintar 
    MOV DX, 244fH                       ; Posicion final que pinta  
    INT 10H  
    mov delaytime, 100
    mov dx, 0000H
    mov ah,02h  
    mov dh,10                           ; Fila 
    mov dl,40                           ; Columna
    int 10h
    mov ah,09h
    mov bl,0eh                          ; Color
    mov cx,1                            
    mov al, quitmsg                     ; Mensaje de salida
    int 10h
    lea bx, quitmsg
    call writestringat
    call delay    
    jmp quit_mainloop    

    
    

quit_mainloop:
;first clear screen
mov ax, 0003H
int 10h    
mov ax, 4c00h
int 21h  



         


delay proc 
    
    ;this procedure uses 1A interrupt, more info can be found on   
    ;http://www.computing.dcu.ie/~ray/teaching/CA296/notes/8086_bios_and_dos_interrupts.html
    mov ah, 00
    int 1Ah
    mov bx, dx
	
    
jmp_delay:
    int 1Ah
	
    sub dx, bx
    ;there are about 18 ticks in a second, 10 ticks are about enough
    cmp dl, delaytime                                                      
    jl jmp_delay    
    ret
    
delay endp
   
   


fruitgeneration proc
    mov ch, fruity
    mov cl, fruitx
	
regenerate:
    
    cmp fruitactive, 1
    je ret_fruitactive
    mov ah, 00
    int 1Ah
    ;dx contains the ticks
	
    push dx
    mov ax, dx
    xor dx, dx
    xor bh, bh
    mov bl, row
    dec bl
    div bx
    mov fruity, dl
    inc fruity
    
    
    pop ax
    mov bl, col
    dec dl
    xor bh, bh
    xor dx, dx
    div bx
    mov fruitx, dl
    inc fruitx
    
    cmp fruitx, cl
    jne nevermind
    cmp fruity, ch
    jne nevermind
    jmp regenerate             
nevermind:
	
    mov al, fruitx
    ror al,1
    jc regenerate
    
    
    add fruity, top
    add fruitx, left 
    
    mov dh, fruity
    mov dl, fruitx
    call readcharat
    cmp bl, 'X'
    je regenerate
    cmp bl, 'n'
    je regenerate
    cmp bl, '('
    je regenerate
    cmp bl, ')'
    je regenerate
    cmp bl, 'U'			;Disque cabeza para abajo pero no creo que sea
    je regenerate    
    
ret_fruitactive:
    ret
fruitgeneration endp


dispdigit proc
    add dl, '0'
    mov ah, 02H
    int 21H
    ret
dispdigit endp   
   
dispnum proc   
	
    test ax,ax 			;		AX CONTIENE EL NUMERO QUE SE VA A DESPLEGAR
    jz retz				;		"JUMP IF ZERO" es JZ
    xor dx, dx
    
    ;bx must contain 10
    mov bx,10
    div bx
    ;dispnum ax first.
    push dx
    call dispnum  
    pop dx
    call dispdigit
    ret
retz:
    mov ah, 02  
    ret    
dispnum endp   



;sets the cursor position, ax and bx used, dh=row, dl = column
;preserves other registers
setcursorpos proc
	
    mov ah, 02H
    push bx
    mov bh,0
    int 10h
    pop bx
    ret
setcursorpos endp



draw proc

    lea bx, scoremsg
    mov dx, 0109
    call writestringat
    
    
    add dx, 7
    call setcursorpos
    mov al, segmentcount
    dec al
    xor ah, ah
    call dispnum
        
    lea si, head
draw_loop:
	
    mov bl, ds:[si]
    test bl, bl
    jz out_draw
    mov dx, ds:[si+1]
    call writecharat
    add si,3   
    jmp draw_loop 

out_draw:
	
    mov bl, 'O'
    mov dh, fruity
    mov dl, fruitx
    call writecharat
    mov fruitactive, 1
    
    ret
    
    
    
draw endp



;dl contains the ascii character if keypressed, else dl contains 0
;uses dx and ax, preserves other registers
readchar proc
    mov ah, 02H		;Parte que hace por presionar la tecla 2 veces la tecla para que funciona
    int 16H
    jnz keybdpressed
    xor dl, dl
    ret
keybdpressed:
    ;extract the keystroke from the buffer
    mov ah, 00H
    int 16H
    mov dl,al
    ret


readchar endp                    
         
         
         
                  
                    


keyboardfunctions proc
    
    call readchar
    cmp dl, 0
    je next_14
    
    ;so a key was pressed, which key was pressed then solti?
    cmp dl, 'w'
    jne next_11
    cmp head, 'U'		;Cabeza para abajo
	
    je next_14
    mov head, 'n'
    ret
next_11:
    cmp dl, 's'
    jne next_12
    cmp head, 'n'
    je next_14
	
    mov head, 'U'		;Cabeza para abajo

    ret
next_12:
    cmp dl, 'a'
    jne next_13
    cmp head, ')'
    je next_14
    mov head, '('
    ret
next_13:
    cmp dl, 'd'
    jne next_14
    cmp head, '('		;Para hacer el movimiento
    je next_14
    mov head,')'
next_14:    
    cmp dl, 'x'							; 		PARA SALIR DEL JUEGO SE UTILIZA LA LETRA X
    je quit_keyboardfunctions
    ret    
quit_keyboardfunctions:   
    ;conditions for quitting in here please  
    inc quit
    ret
    
keyboardfunctions endp


                    
                    
                    
                    
                    
                    
shiftsnake proc     
    mov bx, offset head
    
	
    ;determine the where should the head go solti?
    ;preserve the head
    xor ax, ax
    mov al, [bx]
    push ax
    inc bx
    mov ax, [bx]
    inc bx    
    inc bx
    xor cx, cx
l:  
	
    mov si, [bx]
    test si, [bx]
    jz outside
    inc cx     
    inc bx
    mov dx,[bx]
    mov [bx], ax
    mov ax,dx
    inc bx
    inc bx
    jmp l
    
outside:    
    
    
    ;hopefully, the snake will be shifted, i.e. moved.
    ;now shift the head in its proper direction and then clear the last segment. 
    ;But don't clear the last segment if the snake has eaten the fruit
	
    pop ax
    ;al contains the snake head direction
    
    push dx
    ;dx now consists the coordinates of the last segment, we can use this to clear it
    
    
    lea bx, head
    inc bx
    mov dx, [bx]
    
    cmp al, '('
    jne next_1
    dec dl
    dec dl
    jmp done_checking_the_head
next_1:
    cmp al, ')'
    jne next_2                
    inc dl 
    inc dl
    jmp done_checking_the_head
    
next_2:
    cmp al, 'n'
    jne next_3 
    dec dh               
                   
    
    jmp done_checking_the_head
    
next_3:
	
    ;must be 'v'
    inc dh
    
done_checking_the_head:    

	
    mov [bx],dx
    ;dx contains the new position of the head, now check whats in that position   
    call readcharat ;dx
    ;bl contains the result
    
    cmp bl, 'O'
    je i_ate_fruit
    
    ;if fruit was not eaten, then clear the last segment, 
    ;it will be cleared where?
    mov cx, dx
    pop dx 
    cmp bl, 'X'    ;the snake bit itself, gameover
    je game_over
    mov bl, 0
    call writecharat
    mov dx, cx
    
    
    
    
    
    ;VERIFICA SI LA SERPIENTE ESTA ADENTRO
	
    cmp dh, top
    je game_over
    cmp dh, bottom
    je game_over
    cmp dl,left
    je game_over
    cmp dl, right
    je game_over
    
    
    
    ;balance the stack, number of segment and the coordinate of the last segment
    
    ret
game_over:
    inc gameover
    ret
i_ate_fruit:    

    ; add a new segment then
    mov al, segmentcount
    xor ah, ah
    
    
    lea bx, body
    mov cx, 3
    mul cx
    
    pop dx
    add bx, ax
    mov byte ptr ds:[bx], 'X'
    mov [bx+1], dx
    inc segmentcount
    mov dh, fruity
    mov dl, fruitx
    mov bl, 0
    call writecharat
    mov fruitactive, 0   
    ret 
shiftsnake endp
   
   
                               
                               
                               
                               
                               
                               
                               
                               
                               
   
         
;Printbox
printbox proc
;Draw a box around
    mov dh, top
    mov dl, left
    mov cx, col
	MOV AH, 06H
	MOV AL, 00H
    mov bh, 176D			;cambia el colo arribita
	INT 10H

l1:                 
    call writecharat		;Lo mueve de tal manera de hacer la distancia de izquierda a derecha
    inc dl
    loop l1    
    mov cx, row
	
l2:
    call writecharat		;Pinta todo los cuadritos de arriba para abajo del lado derecho
    inc dh
    loop l2
    
    mov cx, col
l3:							;Pinta todo los cuadritos de abajo
    call writecharat
    dec dl
    loop l3

    mov cx, row     		;Lo mueve de tal manera de hacer la distancia
l4:							;Pinta todo los cuadritos de lado izquierdo
    call writecharat    
    dec dh 
    loop l4    				
    
    ret
printbox endp
              
              
              
              
              
              
              
              
; POR ACA VOY     
;dx contains row, col
;bl contains the character to write
;uses di. 
writecharat proc
    ;80x25
	
	
    push dx
    mov ax, dx
    and ax, 0FF00H
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    
	
    
    push bx
    mov bh, 160
    mul bh 
    pop bx
    and dx, 0FFH
    shl dx,1
    add ax, dx
    mov di, ax
    mov es:[di], bl
    pop dx
    ret    
writecharat endp
            
            
            
            
            
            
            
            
;ESTA PARTE HACE LA VALIDACION DEL CIRCULO CON LA BOLITA, VALIDA SI SE LA 
;COME O NO Y HACE EL PROCESO         
;dx contains row,col
;returns the character at bl
;uses di
readcharat proc
    push dx
    mov ax, dx				; cambia los valores de ax y dx
    and ax, 0FF00H
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1    
    push bx
    mov bh, 160
    mul bh 
    pop bx
    and dx, 0FFH
    shl dx,1
    add ax, dx
    mov di, ax
    mov bl,es:[di]
    pop dx
    ret
readcharat endp        








;DX CONTIENE LAS COLUMNAS Y LINEAS
;bx contains the offset of the string
writestringat proc

	
    push dx				; LUEGO TRANSFIERE EL CONTENIDO DEL OPERANDO FUENTE A LA NEUVA DIRECCION 
						;RESULTANTE EN EL REGISTRO RECIEN MODIFICAO
						
    mov ax, dx
    and ax, 0FF00H
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    
    push bx
    mov bh, 160
    mul bh
    
    pop bx
    and dx, 0FFH
    shl dx,1			; SE UTILIZA PARA DESPLAZAR EL OPERANDO DE LA IZQUIERDA, QUE ES SIEMPRE TRATADO COMO SIN SIGNO
    add ax, dx
    mov di, ax
loop_writestringat:			
    
	
	
    mov al, [bx]
    test al, al
    jz exit_writestringat	; "JUMP IF ZERO" es JZ	IMPRIMIE TODO LO QUE TIENE QUE IMPRIMIR HASTA QUE YA NO HAYA NADAWW
    mov es:[di], al			; lo imprime en pantalla el primer mensaje
    inc di					; para imprimir
    inc di					; para imprimir
    inc bx					; para imprimir
    jmp loop_writestringat
    
    
exit_writestringat:

    pop dx	
    ret						; Retorna al metodo desde que se llamo		
    
    
writestringat endp
     
     
     
     
     
     
main endp
          
end main
