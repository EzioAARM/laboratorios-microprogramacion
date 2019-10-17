Izquierda   EQU 0
Arriba      EQU 2
Filas       EQU 15
Columnas    EQU 45
Derecha     EQU Izquierda + Columnas
Abajo       EQU Arriba + Filas
.MODEL small
.DATA
    ; Mensaje en juego
    MsgJugando      DB "Disfruta tu partida, mientras dures$"
    ; Mensaje de bienvenida al juego
    MsgBienvenido   DB 173,"Bienvenido a MicroSnake!$"
    ; Mensaje con instrucciones
    Instrucciones   DB "Controles:",10,13,"WASD para moverte",10, 13,"X para salir$"
    ; Mensaje con error
    ErrorAccion     DB "Accion no permitida$"
    ; Mensaje de salida (al presionar X)
    MsgSalir        DB "Adios$"
    ; Mensaje de gameover
    MsgGameOver     DB "Game Over",10, 13,"looser$"
    ; Cabeza de la serpiente
    Cabeza          DB 'n',10,10
    ; Cuerpo de la serpiente
    Cuerpo          DB 'X',10,11, 3*15 DUP(0)
    ; Contador
    Contador        DB 1
    ; Comida
    Activa          DB 1
    ComidaPosX      DB 10
    ComidaPosY      DB 15
    ; Banderas
    Perdio          DB 0
    SalirJuego      DB 0
    TiempoEspera    DB 1
.STACK
    dw 128 dup(0)
.CODE
Programa:       ; Etiqueta de inicio del Programa
;inicializar el Programa
MOV AX, @DATA    ; Guardando dirección de inicio segmento de
MOV DS, AX

    MOV AX, 0B800H
    MOV ES, AX
    
    MOV AX, 0003H               ; Instrucción de limpiar la pantalla
    INT 10H                     ; Ejecutar la interrupción de video

    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 1EH                 ; Cambiamos el color a azul
    MOV CX, 0000H               ; Posición inicial para pintar
    MOV DX, 2555H               ; Ultima posición para pintar
    INT 10H                     ; Ejecutar la interrupción de video
    
    LEA DX, MsgBienvenido       ; Mensaje de bienvenida
    MOV AH, 09H                 ; Interrupción para mostrar texto
    INT 21H

    MOV AH, 07H                 ; Interrupción para leer caracer
    INT 21H                     ; Ejecuta la interrupción
    MOV AX, 0003H               ; Limpia la pantalla
    INT 10H                     ; Ejecuta la interrupción

    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 1EH                 ; Cambiamos el color a azul
    MOV CX, 0000H               ; Posición inicial para pintar
    MOV DX, 2555H               ; Ultima posición para pintar
    INT 10H                     ; Ejecutar la interrupción de video

    LEA DX, Instrucciones       ; Mensaje de bienvenida
    MOV AH, 09H                 ; Interrupción para mostrar texto
    INT 21H

    MOV AH, 07H                 ; Interrupción para leer caracer
    INT 21H                     ; Ejecuta la interrupción
    MOV AX, 0003H               ; Limpia la pantalla
    INT 10H                     ; Ejecuta la interrupción

    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 177D
    MOV CX, 0000H
    MOV DX, 2555H
    INT 10H
    
    CALL DibujarMapa

pantallaJuego:
    CALL Delay
    LEA BX, MsgJugando
    MOV DX, 00
    CALL posicionarString
    CALL MoverCulebra
    CMP Perdio, 1
    JE condicionPerdio
    CALL accionesUsuario
    CMP SalirJuego, 1
    JE TeclaSalir
    CALL ponerComida
    CALL pintar
    JMP pantallaJuego

condicionPerdio:
    MOV AX, 0003H                       ; Limpia en pantalla 
    INT 10H                             ; Hace la interrupcion 
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 40H                         ; Color Amarillo                    
    MOV CX, 0000H                       ; Posicion inicial que empieza a pintar 
    MOV DX, 244fH                       ; Posicion final que pinta  
    INT 10H
    MOV TiempoEspera, 50
    MOV DX, 0000H
    LEA BX, MsgGameOver
    CALL posicionarString
    CALL Delay
    JMP terminarPrograma


TeclaSalir:
    MOV AX, 0003H                       ; Limpia en pantalla 
    INT 10H                             ; Hace la interrupcion 
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 40H                         ; Color Amarillo                    
    MOV CX, 0000H                       ; Posicion inicial que empieza a pintar 
    MOV DX, 244fH                       ; Posicion final que pinta  
    INT 10H 
    MOV TiempoEspera, 50
    LEA BX, MsgSalir
    MOV AH, 09H
    INT 21H
    CALL Delay
    JMP terminarPrograma
    

; Procedimiento que ubica un string en la consola
posicionarString PROC
    PUSH DX                 ; Se guarda DX que contiene donde se quiere escribir el dato
    MOV AX, DX              ; Pasa el dato de DX a AX para operarlo
    MOV AX, 0FF00H          ; Pasa el valor 1111111100000000 al registro completo de AX
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    PUSH BX                 ; Guarda el dato de BX en la pila
    MOV BH, 160             ; Guarda 160 en BH
    MUL BH
    POP BX                  ; Obtiene el dato de BX
    AND DX, 0FFH            ; Hace un AND entre DX y 11111111
    SHL DX, 1               ; Hace un corrimiento de bits a la izquierda
    ADD AX, DX              ; Suma el dato de AX con DX y lo guarda en AX
    MOV DI, AX              ; Pasa el dato de AX al destino DI
escribirString:
    MOV AL, [BX]            ; Guarda el valor de BX en AL
    TEST AL, AL             ; Hace un AND temporal entre AL y AL
    JZ noEscribir           ; Si es cero salta a noEscribir
    MOV ES:[DI], AL         ; Guarda el dato de AL en la posicion DI de ES
    INC DI                  ; Incrementa DI
    INC DI                  ; Incrementa DI
    INC BX                  ; Incrementa BX
    JMP escribirString      ; Hace el mismo proceso de escribirString
noEscribir:
    POP DX                  ; Saca el dato de DX de la pila
    RET                     ; Return
posicionarString ENDP

; Pinta el mapa de la serpiente
DibujarMapa PROC
    MOV DH, Arriba          ; Guarda el valor de la variable Arriba
    MOV DL, Izquierda       ; Guarda el valor de la variable abajo
    MOV CX, Columnas        ; Guarda el valor de la variable Columnas
    MOV AH, 06H             ; Recorre la pantalla hasta 00H
    MOV AL, 00H
    MOV BH, 100D            ; Establece el color en amarillo
    INT 10H                 ; Ejecuta la interrupción
dibujarArriba:
    CALL posicionarChar     ; Posiciona el caracter
    INC DL                  ; Aumenta la cantidad de caracteres que llevamos pintados
    LOOP dibujarArriba      ; Llama a dibujarArriba de nuevo para seguir pintando
    MOV CX, Filas           ; Cambia el valor de incremento de CX para dibujar a la derecha
dibujarDerecha:
    CALL posicionarChar
    INC DH
    LOOP dibujarDerecha
    MOV CX, Columnas        ; Cambia el valor de incremento de CX para que dibuje la fila de abajo
dibujarAbajo:
    CALL posicionarChar
    DEC DL                  ; En este caso decrementa por la posición del cursor
    LOOP dibujarAbajo
    MOV CX, Filas
dibujarIzquierda:
    CALL posicionarChar
    DEC DH
    LOOP dibujarIzquierda
    RET                     ; Terminó de pintar el mapa
DibujarMapa ENDP

; Coloca un caracter en una posición especifica
; Se usa para dibujar el mapa
posicionarChar PROC
    PUSH DX                 ; Agrega DX a la pila
    MOV AX, DX              ; Mueve el valor de DX a AX
    AND AX, 0FF00H          ; Hace un AND con 1111111100000000
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    SHR AX, 1               ; Hace un corrimiento de bits a la derecha
    
    PUSH BX                 ; Agrega BX a la pila
    MOV BH, 160
    MUL BH              
    POP BX                  ; Saca BX de la pila
    AND DX, 0FFH            ; Suma 11111111 a DX
    SHL DX, 1               ; Hace un corrimiento de bits a la izquierda
    ADD AX, DX              ; Hace el movimiento entre derecha e izquierda
    MOV DI, AX              ; Pone AX en DI
    MOV ES:[DI], BL         ; Guarda BL en la posición DI de ES
    
    INC DI                  ; Incrementa DI
    INC DI                  ; Incrementa DI
    INC BX                  ; Incrementa BX
    POP DX                  ; Saca DX de la pila
    RET                     ; Return
posicionarChar ENDP

; Realiza el movimiento e indica si el jugador perdió
MoverCulebra PROC
    MOV BX, OFFSET Cabeza       ; Obtiene el simbolo que tendrá la cabeza
    ; Lo siguiente nos dice a donde se tiene que mover
    XOR AX, AX
    MOV AL, [BX]                ; Usa el valor de BX
    PUSH AX
    INC BX
    MOV AX, [BX]
    INC BX
    INC BX
    XOR CX, CX
contenidoMovimiento:
    MOV SI, [BX]
    TEST SI, [BX]
    JZ FueraLimites             ; La posición a la que se movió está fuera de los límites
    INC CX
    INC BX
    MOV DX, [BX]
    MOV [BX], AX
    MOV AX, DX
    INC BX
    INC BX
    JMP contenidoMovimiento
FueraLimites:
    ; Se mueve la cabeza y se quita el ultimo segmento, pero si comió no se quita nada
    POP AX                      ; El registro AL tiene la cabeza
    PUSH DX                     ; dx tiene las coordenadas del ultimo segmento

    LEA BX, Cabeza
    INC BX
    MOV DX, [BX]
    CMP AL, '('                 ; Cabeza para la izquierda
    JNE CabezaDerechaMoverCulebra
    DEC DL
    DEC DL
    JMP ValidoCabeza
CabezaDerechaMoverCulebra:
    CMP AL, ')'                 ; Cabeza para la derecha
    JNE CabezaIzquierdaMoverCulebra
    INC DL
    INC DL
    JMP ValidoCabeza
CabezaIzquierdaMoverCulebra:
    CMP AL, 'n'
    JNE CabezaAbajoMoverCulebra
    DEC DH
    JMP ValidoCabeza
CabezaAbajoMoverCulebra:
    ; En este caso solo puede llegar el valor de la cabeza apuntando hacia abajo
    ; No hay otro caso
    INC DH
ValidoCabeza:
    MOV [BX], DX                ; DX guarda la posición de la cabeza
    CALL verCaracter            ; Esta "devuelve" un valor en BL
    CMP BL, 'O'
    JE siComio                  ; Si come salta a la etiqueta siComio

    ; Si no comió fruta borra el ultimo segmento
    MOV CX, DX
    POP DX
    CMP BL, 'X'                 ; Este caso es si la serpiente se choca consigo misma
    JE PerdioSalida
    MOV BL, 0
    CALL posicionarChar
    MOV DX, CX

    ; Esta parte es para ver que siga adentro del cuadro
    CMP DH, Arriba
    JE PerdioSalida
    CMP DH, Abajo
    JE PerdioSalida
    CMP DL, Izquierda
    JE PerdioSalida
    CMP DL, Derecha
    JE PerdioSalida
    RET
PerdioSalida:
    INC Perdio
    RET
siComio:
    MOV AL, Contador
    XOR AH, AH
    LEA BX, Cuerpo
    MOV CX, 3
    MUL CX
    POP DX
    ADD BX, AX
    MOV BYTE PTR DS:[BX], 'X'
    MOV [BX + 1], DX
    INC Contador
    MOV DH, ComidaPosY
    MOV DL, ComidaPosX
    MOV BL, 0
    CALL posicionarChar
    MOV Activa, 0
    RET    
MoverCulebra ENDP

Delay PROC
    MOV AH, 00
    INT 1AH                     ; Usa la interrupción del reloj del sistema
    MOV BX, DX
tickDelay:
    INT 1AH
    SUB DX, BX                  ; Espera 10 ticks del reloj, es poco menos de un segundo
    CMP DL, TiempoEspera
    JL tickDelay
    RET
Delay ENDP

ponerComida PROC
    MOV CH, ComidaPosY
    MOV CL, ComidaPosX
nuevo:
    CMP Activa, 1
    JE salirPonerComida
    MOV AH, 00
    INT 1AH                     ; Los ticks van a DX
    PUSH DX
    MOV AX, DX
    XOR DX, DX
    XOR BH, BH
    MOV BL, Filas
    DEC BL
    DIV BX
    MOV ComidaPosY, DL
    INC ComidaPosY
    POP AX
    MOV BL, Columnas
    DEC DL
    XOR BH, BH
    XOR DX, DX
    DIV BX
    MOV ComidaPosX, DL
    INC ComidaPosX
    CMP ComidaPosX, CL
    JNE sinComida
    CMP ComidaPosY, CH
    JNE sinComida
    JMP nuevo
sinComida:
    MOV AL, ComidaPosX
    ROR AL, 1
    JC nuevo
    ADD ComidaPosY, Arriba
    ADD ComidaPosX, Izquierda
    MOV DH, ComidaPosY
    MOV DL, ComidaPosX
    CALL verCaracter
    CMP BL, 'X'
    JE nuevo
    CMP BL, 'n'
    JE nuevo
    CMP BL, '('
    JE nuevo
    CMP BL, ')'
    JE nuevo
    CMP BL, 'U'
    JE nuevo
salirPonerComida:
    RET
ponerComida ENDP

terminarPrograma:
    MOV AX, 0003H
    INT 10H
    ; Finalizar el programa
    MOV AH, 4CH  ; finaliza el proceso
    INT 21H     ; Ejecuta la interrupción

; Aca valida si comió o con que chocó

verCaracter PROC
    PUSH DX
    MOV AX, DX
    AND AX, 0FF00H
    SHR AX, 1
    SHR AX, 1
    SHR AX, 1
    SHR AX, 1
    SHR AX, 1
    SHR AX, 1
    SHR AX, 1
    SHR AX, 1
    PUSH BX
    MOV BH, 160
    MUL BH
    POP BX
    AND DX, 0FFH
    SHL DX, 1
    ADD AX, DX
    MOV DI, AX
    MOV BL, ES:[DI]
    POP DX
    RET
verCaracter ENDP

colorcarCursor PROC
    MOV AH, 02H
    PUSH BX
    MOV BH, 0
    INT 10H
    POP BX
    RET
colorcarCursor ENDP

pintar PROC
    LEA SI, Cabeza
pintarTodo:
    MOV BL, DS:[SI]
    TEST BL, BL
    JZ terminarDibujar
    MOV DX, DS:[SI + 1]
    CALL posicionarChar
    ADD SI, 3
    JMP pintarTodo
terminarDibujar:
    MOV BL, '0'
    MOV DH, ComidaPosY
    MOV DL, ComidaPosX
    CALL posicionarChar
    MOV Activa, 1
    RET
pintar ENDP

leerCaracter PROC
    MOV AH, 02H
    INT 16H
    JNZ Presionada
    XOR DL, DL
    RET
Presionada:
    MOV AH, 00H
    INT 16H
    MOV DL, AL
    RET
leerCaracter ENDP

accionesUsuario PROC
    CALL leerCaracter
    CMP DL, 0
    JE condicionSalida
    ; En esta parte verifica que no sea otra tecla para mostrar mensaje de error
    CMP DL, 'W'
    JE iniciarVerificacion
    CMP DL, 'A'
    JE iniciarVerificacion
    CMP DL, 'S'
    JE iniciarVerificacion
    CMP DL, 'D'
    JE iniciarVerificacion
    CMP DL, 'X'
    JE iniciarVerificacion
    MOV DX, 0000H
    MOV AH, 02H
    MOV DH, 09
    MOV DL, 56
    INT 10H
    LEA DX, ErrorAccion
    MOV AH, 09H
    INT 21H
iniciarVerificacion:
    CMP DL, 'W'
    JNE compararS
    CMP Cabeza, 'U'
    JE condicionSalida
    MOV Cabeza, 'n'
    RET
compararS:
    CMP DL, 'S'
    JNE compararA
    CMP Cabeza, 'n'
    JE condicionSalida
    MOV Cabeza, 'U'
    RET
compararA:
    CMP DL, 'A'
    JNE compararD
    CMP Cabeza, ')'
    JE condicionSalida
    MOV Cabeza, '('
    RET
compararD:
    CMP DL, 'D'
    JNE condicionSalida
    CMP Cabeza, '('
    JE condicionSalida
    MOV Cabeza, ')'
    RET
condicionSalida:
    CMP DL, 'X'
    JE terminarAcciones
    RET
terminarAcciones:
    INC SalirJuego
    RET
accionesUsuario ENDP

END Programa