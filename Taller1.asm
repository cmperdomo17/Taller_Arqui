;MACROS

cargar_datos macro
                 mov ax, @data
                 mov ds, ax
                 mov es, ax
                 
endm
imprimir_caracter macro char
                      push ax
                      push dx
                      mov  dl, char
                      mov  ah, 02h
                      int  21h
                      pop  dx
                      pop  ax
endm
imprimir macro str
             mov  dx, offset str
             call prc_imprimir
endm

leer_char macro destino
              call     prc_leer_char
              mov      destino, al
              imprimir newline
endm

leer_string macro destino,maximos_digitos
                lea  dx, destino
                mov  destino, maximos_digitos
                call prc_leer_string
endm

comparar_string macro cad1, cad2, tam
                    mov cx, tam
                    lea si ,cad1
                    lea di, cad2
                    rep cmpsb
endm
imprimir_hex_bin macro nmbr
                     
                     imprimir             msghex
                     imprimir_bytehex2hex nmbr
                     imprimir_caracter    ','
                     imprimir_caracter    ' '
                     imprimir             msgbin
                     imprimir_bytehex2bin nmbr
                     imprimir             newline
endm
leer_hex macro dst
             push bx
             call prc_leer_hex
             mov  dst, bl
             pop  bx
endm
imprimir_bytehex2hex macro src
                         push cx
                         mov  cl, src
                         call prc_imprimir_bytehex2hex
                         pop  cx
endm
imprimir_bytehex2bin macro src
                         push cx
                         mov  cl, src
                         call prc_imprimir_bytehex2bin
                         pop  cx
endm
leer_numero macro dst, maxneg, maxpos
                push cx
                mov  limneg, maxneg
                mov  limpos, maxpos
                call prc_leer_numero
                mov  dst, cx
                pop  cx
endm

imprimir_numero macro num
                    push ax
                    mov  ax, num
                    call prc_imprimir_signumero
                    pop  ax
endm
.model small
.stack 200h
.data
    ;cosas generales
    newline                  db 10,13,'$'
    waitvar                  db 0
    msgsalida                db 'Saliendo...',10,13,'$'
    msgprestecla             db 'Presione una tecla para continuar...',10,13,'$'

    ;relacionado a contraseñas
    nummaxintentos           dw 3
    contrasenia              db '123456'
    msgcontrasenia           db 'Digite la contrasenia: ',10,13,'$'
    msgcontraseniaincorrecta db 'Las tres contrasenias ingresadas fueron incorrectas',10,13,'$'
    contraseniaingresada     db 'ci123456e','$'
    ;relacionado al menu
    msgmenu                  db '1. [Suma y Resta] con numeros en rango -16384 a 16383',10,13
                             db '2. [Multiplicacion Y Division] con numeros en rango -128 a 127',10,13
                             db '3. Realizar operaciones logicas con numeros hexadecimales',10,13
                             db '4. Salir',10,13,'$'
    opcionescogida           db 0,10,13,'$'
    ; relacionado a leer numeros decimales
    flgnegativo              db 0
    limpos                   dw 127
    limneg                   dw 128
    ten                      dw 10
    zero                     db '0'
    num1                     dw 0
    num2                     dw 0
    msgpedirnumero1          db 'Digite el primer numero: ',10,13,'$'
    msgpedirnumero2          db 'Digite el segundo numero: ',10,13,'$'
    msgsuma                  db 'Suma: $'
    msgresta                 db 'Resta: $'
    msgmultiplicacion        db 'Multiplicacion: $'
    msgdivision              db 'Division: $'
    ; relacionado a los hexadecimales
    msgnumero1ingresado      db 'Primer numero ingresado',10,13,'$'
    msgnumero2ingresado      db 'Segundo numero ingresado',10,13,'$'
    msgbin                   db 'BIN: $'
    msgnot                   db 'Aplicando NOT $'
    msgand                   db 'Aplicando AND con los 2 numeros $'
    msgor                    db 'Aplicando OR con los 2 numeros $'
    msgxor                   db 'Aplicando XOR con los 2 numeros $'
    msghex                   db 'HEX: $'
    msgdec                   db 'DEC: $'

    dictbin                  db '0000$'
                             db '0001$'
                             db '0010$'
                             db '0011$'
                             db '0100$'
                             db '0101$'
                             db '0110$'
                             db '0111$'
                             db '1000$'
                             db '1001$'
                             db '1010$'
                             db '1011$'
                             db '1100$'
                             db '1101$'
                             db '1110$'
                             db '1111$'
    dicthex                  db '0$'
                             db '1$'
                             db '2$'
                             db '3$'
                             db '4$'
                             db '5$'
                             db '6$'
                             db '7$'
                             db '8$'
                             db '9$'
                             db 'A$'
                             db 'B$'
                             db 'C$'
                             db 'D$'
                             db 'E$'
                             db 'F$'
    
    five                     db 5
    two                      db 2
    hex1                     db 0
    hex2                     db 0

.code

main proc near
                                cargar_datos
                                mov               cx, nummaxintentos
                                call              prc_limpiar_pantalla
    ; Autentica la contraseña ingresada por teclado
    autenticacion:              
                                imprimir          msgcontrasenia
                                leer_string       contraseniaingresada, 7                   ; en realidad lee 6 caracteres y el enter
                                push              cx
                                comparar_string   contrasenia, contraseniaingresada[2],6
                                je                autenticado
                                pop               cx
                                loop              autenticacion

                                imprimir          msgcontraseniaincorrecta
                                imprimir          msgsalida
                                imprimir          msgprestecla
                                leer_char         waitvar
                                mov               ah,4ch
                                int               21h
                            

    autenticado:                
                                call              prc_limpiar_pantalla
                                call              prc_cambiar_color
                                imprimir          msgmenu
                                leer_char         opcionescogida

                                cmp               opcionescogida[0],'1'
                                je                opcion_1

                                cmp               opcionescogida[0],'2'
                                je                link_opcion_2

                                cmp               opcionescogida[0],'3'
                                je                link_opcion_3

                                cmp               opcionescogida[0],'4'
                                jne               autenticado
                                imprimir          msgsalida
                                imprimir          msgprestecla
                                leer_char         waitvar
                                mov               ah,4ch
                                int               21h
    link_opcion_2:              
                                jmp               opcion_2
    link_opcion_3:              
                                jmp               opcion_3
    ; opciones
    opcion_1:                   
                                call              prc_limpiar_pantalla
                                call              prc_cambiar_color
                                imprimir          msgpedirnumero1
                                leer_numero       num1, 16384, 16383
                                imprimir          msgpedirnumero2
                                leer_numero       num2, 16384, 16383
                                mov               bx, num1
                                add               bx, num2
                                imprimir          newline
                                imprimir          msgsuma
                                imprimir          newline
                                imprimir_numero   bx
                                mov               bx, num1
                                sub               bx, num2
                                imprimir          newline
                                imprimir          msgresta
                                imprimir          newline
                                imprimir_numero   bx
                                imprimir          newline
                                jmp               volver_al_menu

    opcion_2:                   
                                call              prc_limpiar_pantalla
                                call              prc_cambiar_color
                                imprimir          msgpedirnumero1
                                leer_numero       num1, 128, 127
                                imprimir          msgpedirnumero2
                                leer_numero       num2, 128, 127

                                mov               ax, num1
                                imul              num2
                                mov               bx, ax
                                imprimir          newline
                                imprimir          msgmultiplicacion
                                imprimir          newline
                                imprimir_numero   bx

                                mov               ax, num1
                                idiv              num2
                                mov               bx, ax
                                imprimir          newline
                                imprimir          msgdivision
                                imprimir          newline
                                imprimir_numero   bx
                                imprimir          newline
                                jmp               volver_al_menu

    opcion_3:                   
                                call              prc_limpiar_pantalla
                                call              prc_cambiar_color
    ; pedir los datos
                                imprimir          msgpedirnumero1
                                leer_hex          hex1
                                imprimir          newline
                                imprimir          msgpedirnumero2
                                leer_hex          hex2
                                imprimir          newline

    ;imprimir el primer dato
                                imprimir          msgnumero1ingresado
                                imprimir_hex_bin  hex1

    ;NOT
                                mov               bh ,hex1
                                not               bh
                                imprimir          msgnot
                                imprimir          newline

                                imprimir_hex_bin  bh
                                imprimir          newline
    ;imprimir el segundo dato
                                imprimir          msgnumero2ingresado
                                imprimir_hex_bin  hex2

    ;NOT
                                mov               bh ,hex2
                                not               bh
                                imprimir          msgnot
                                imprimir          newline

                                imprimir_hex_bin  bh
                                imprimir          newline
    ;AND
                                imprimir          msgand
                                imprimir          newline
                                mov               bh, hex1
                                and               bh, hex2
                                imprimir_hex_bin  bh
                                imprimir          newline

    ;OR
                                imprimir          msgor
                                imprimir          newline
                                mov               bh, hex1
                                or                bh, hex2
                                imprimir_hex_bin  bh
                                imprimir          newline

    ;XOR
                                imprimir          msgxor
                                imprimir          newline
                                mov               bh, hex1
                                xor               bh, hex2
                                imprimir_hex_bin  bh
                                imprimir          newline

                                jmp               volver_al_menu
                                
    volver_al_menu:             
                                imprimir          msgprestecla
                                leer_char         waitvar
                                call              prc_limpiar_pantalla
                                jmp               autenticado
    
main endp


prc_imprimir proc
                                mov               ah, 09h
                                int               21h
                                ret
prc_imprimir endp
    
prc_leer_char proc
                                mov               ah, 1
                                int               21h
                                ret
prc_leer_char endp
prc_cambiar_color proc
                                mov               ax, 3
                                int               10h

                                mov               ax, 1003h
                                mov               bx, 0                                     ; desactiva los parpadeos
                                int               10h
                         
                                mov               ah, 06h
                                xor               al, al
                                xor               cx, cx
                                mov dh, 79
                                mov dl, 79
                                mov               dx, 184fh
                                mov               bh, 17h                   ; color a poner
                                int               10h
                                ret
prc_cambiar_color endp
prc_limpiar_pantalla proc
                                mov               ah ,00
                                mov               al, 02
                                int               10h
                                ret
prc_limpiar_pantalla endp

prc_leer_string proc
                                mov               ah,10
                                int               21h
                                ret
prc_leer_string endp
    ; lee un numero hexadecimal en bl
    ; lee un numero hexadecimal en bl
prc_leer_hex proc
                                mov               cx ,2
                                mov               bl, 0
                                mov               ax ,0                                     ; limpiar ax
    leyendo:                    
             
                                call              prc_leer_char
                                cmp               al, 8
                                je                no_valido
                                cmp               al , '0'
                                jb                no_valido
                                cmp               al, 'f'
                                ja                no_valido
                                cmp               al, '9'
                                jbe               numero
                                cmp               al, 'a'
                                jb                no_valido
                                sub               al, 57h
                                jmp               mover_4_bits
    numero:                     
                                sub               al, 30h
                                jmp               mover_4_bits
    mover_4_bits:               
                                push              cx
                                mov               cl ,4
                                shl               bl, cl
                                pop               cx
                                or                bl, al
                                loop              leyendo
                                ret
    
    no_valido:                  
                                push              cx
                                mov               cl, 4
                                shr               bl,cl
                                pop               cx
                                imprimir_caracter 8
                                imprimir_caracter ' '
                                imprimir_caracter 8
                                inc               cx
                                inc               cx
                                loop              leyendo



prc_leer_hex endp
prc_imprimir_bytehex2hex proc
                                mov               ah, 0
                                mov               al, cl
                                and               al, 0f0h
                                push              cx
                                mov               cl, 4
                                shr               al,cl
                                pop               cx
                                mul               two
                                mov               si,ax

                                lea               dx,  dicthex[si]
                                call              prc_imprimir

 
                                mov               ah, 0
                                mov               al,cl
                                and               al,0fh
                                mul               two
                                mov               si, ax

                                lea               dx,  dicthex[si]
                                call              prc_imprimir

                                ret
prc_imprimir_bytehex2hex endp
    ; imprime el byte que este en cl a binario
prc_imprimir_bytehex2bin proc
                                mov               ah, 0
                                mov               al, cl
                                and               al, 0f0h
                                push              cx
                                mov               cl, 4
                                shr               al,cl
                                pop               cx
                                mul               five
                                mov               si,ax

                                lea               dx,  dictbin[si]
                                call              prc_imprimir


 
                                mov               ah, 0
                                mov               al,cl
                                and               al,0fh
                                mul               five
                                mov               si, ax

                                lea               dx,  dictbin[si]
                                call              prc_imprimir
                                ret
prc_imprimir_bytehex2bin endp
    ; lee un numero en cx
prc_leer_numero proc
                                push              dx
                                push              ax
                                push              si
        
                                mov               cx, 0
                                mov               flgnegativo, 0

    leer_digito:                


                                call              prc_leer_char

                                cmp               al, '-'
                                je                signo_negativo

                                cmp               al, 13
                                jne               verificar_borrado
                                jmp               fin_lectura
    verificar_borrado:          


                                cmp               al, 8
                                jne               verificar_numero
    borrar:                     
                                mov               dx, 0
                                mov               ax, cx
                                div               ten                                       ; ax/10, quita el ultimo digito
                                mov               cx, ax
                                imprimir_caracter ' '
                                imprimir_caracter 8
                                jmp               leer_digito
    verificar_numero:           


    
                                cmp               al, '0'
                                jae               es_mayor_a_cero
                                jmp               quitar_caracter_nonum
    es_mayor_a_cero:            
                                cmp               al, '9'
                                jbe               numero_verificado
    quitar_caracter_nonum:      
                                imprimir_caracter 8                                         ; mueve el cursor a la izquierda
                                imprimir_caracter ' '                                       ; pone espacio
                                imprimir_caracter 8                                         ; vuelve a mover el cursor
                                jmp               leer_digito
    numero_verificado:          

    ; hace espacio para el proximo digito
                                push              ax
                                mov               ax, cx
                                mul               ten
                                mov               cx, ax
                                pop               ax

    ; verificar si esta en el rango
                                call              prc_verificar_limites
                                ja                overflow_por_multiplicacion

    ;paso a ascii
                                sub               al, 30h

    ;suma lo leido a cx
                                push              ax
                                mov               ah, 0
                                mov               dx, cx                                    ; guarda en caso de overflow
                                add               cx, ax
                                pop               ax
                                call              prc_verificar_limites
                                ja                overflow_por_suma                         ; si el numero pasa los limites quita lo ingresado

                                jmp               leer_digito

    signo_negativo:             
                                mov               flgnegativo, 1
                                jmp               leer_digito
    overflow_por_suma:          
                                mov               ah, 0
                                sub               cx, ax
    overflow_por_multiplicacion:
                                imprimir_caracter 8
                                jmp               borrar
        
        
    fin_lectura:                
                                cmp               flgnegativo, 0
                                je                numero_positivo
                                neg               cx
    numero_positivo:            

                                pop               si
                                pop               ax
                                pop               dx
                                ret
prc_leer_numero endp
    ; verifica si cx esta dentro del rango deseado
prc_verificar_limites proc
    verificar_flag_signo:       
                                cmp               flgnegativo, 0
                                je                verificar_limite_positivo
    
    verificar_limite_negativo:  
                                cmp               cx,limneg
                                jmp               retornar
    verificar_limite_positivo:  
                                cmp               cx,limpos
                                jmp               retornar
    retornar:                   
                                ret
prc_verificar_limites endp
    ; imprime un numero en ax
prc_imprimir_signumero proc
                                push              dx
                                push              ax
                                cmp               ax, 0
                                jnz               verificar_signo
                                imprimir_caracter '0'
                                jmp               fin_impresign

    verificar_signo:            
                                cmp               ax, 0                                     ; afecta las banderas (Nos interesa la de signo)
                                jns               positivo
                                neg               ax
                                imprimir_caracter '-'
    positivo:                   
                                call              prc_imprimir_numero
    fin_impresign:              
                                pop               ax
                                pop               dx
                                ret
prc_imprimir_signumero endp
prc_imprimir_numero proc near
                                push              ax
                                push              bx
                                push              cx
                                push              dx
                                mov               cx,1                                      ; hay ceros
                                mov               bx, 10000                                 ; maximos digitos
                                cmp               ax, 0
                                jz                imprimir_cero
    impresion:                  
                                cmp               bx,0                                      ; si el divisor es cero, ya no quedan digitos
                                jz                fin_impresion
                        
                                cmp               cx, 0
                                je                extraer_digito
                                cmp               ax, bx
                                jb                reducir_divisor                           ; si el resto es mayor al divisor, reducir el divisor
    extraer_digito:             
                                mov               cx, 0                                     ; no hay ceros
                                mov               dx,0
                                div               bx                                        ; divide ax por bx y guarda en al, y guarda el resto en dx
                                add               al, 30h
                                imprimir_caracter al
                                mov               ax, dx                                    ; guarda el resto para extraer mas caracteres
    reducir_divisor:            
                                push              ax                                        ; guarda ax, porque la division lo usa
                                mov               dx, 0
                                mov               ax, bx
                                div               ten                                       ; quita un digito al divisor
                                mov               bx, ax
                                pop               ax
                                jmp               impresion


    imprimir_cero:              
                                imprimir_caracter '0'
                                ret
    fin_impresion:              
                                pop               dx
                                pop               cx
                                pop               bx
                                pop               ax
                                ret
prc_imprimir_numero endp
end main