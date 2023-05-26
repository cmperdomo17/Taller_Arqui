extern printf, scanf, system

section .data
    
    msjHexAnd db "Aplicando AND con los 2 numeros: %s BIN y %x HEX",10,0
    msjHexOr db "Aplicando OR con los 2 numeros: %s BIN y %x HEX",10,0
    msjHexXor db "Aplicando XOR con los 2 numeros: %s BIN y %x HEX",10,0
    tamanioOperador db "%x"
    tamanioClave equ 6
    contraseniaIng db "%ld",0
    ocultarClave db "stty -echo",0
    mostrarClave db "stty echo",0
    msjMenu db " ", 0x0a, 8, 13
    msjOp1 db "1. Realizar Suma y Resta con numeros en rango -16384 a 16383", 0x0a, 8, 14
    msjOp2 db "2. Realizar Multiplicacion y Division con numeros en rango -128 a 127", 0x0a, 8, 14
    msjOp3 db "3. Realizar operaciones logicas con numeros hexadecimales", 0x0a, 8, 14
    msjOp4 db "4. Salir", 0x0a, 8, 14
    range1 dq -16384
    range2 dq 16383
    tamanioNum db "%d"
    msjNum1 db "Digite el primer numero: ",10,0
    msjNum2 db "Digite el segundo numero: ",10,0
    msjResultSuma db "Suma: %d", 10, 0
    msjResultSumall db "Suma: %ld ",10,0
    msjRangoFuera db "El numero esta fuera del rango",10,0
    msjResultResta db "Resta: %ld ",10,0
    msjResultMult db "Multiplicacion: %ld",10,0
    msjResultDiv db "Division: %ld ",10,0
    msjClavell db "Ingrese su clave ",10,0
    msjNum1Bin db "Primer numero en Binario: %s ",10,0
    msjNum1BinNot db "Aplicando NOT: %s ",10,0
    msjNum2Bin db "Segundo numero en Binario: %s ",10,0
    msjNum2BinNot db "Aplicando NOT: %s ",10,0
    num1 dq 0
    num2 dq 0
    contrasenia dq 123456
    msjClave db " ", 0x0a
             db "Digite la contrasenia: ", 0x0a, 0
    msjError db "Digite la contrasenia: ", 0x0a, 0

section .bss
    resultado resq 1
    num1Hexa resq 1
    num2Hexa resq 1
    listaBinario resb 9
    listaBinarioNum1 resb 9
    listaBinarioNumNot1 resb 9
    listaBinarioNum2 resb 9
    listaBinarioNumNot2 resb 9
    hexa resq 2
    input resb 5
    ciclo resb 1

section .text
    global main

main:
    push rbp
    mov rbp, rsp

    mov rdi, msjClave
    mov rax, 0
    mov [ciclo], al
    call printf
    mov rdi, ocultarClave
    xor rax, rax
    call system

    mov rdi, contraseniaIng
    mov rsi, input
    call scanf

    mov rax, [input]
    mov rbx, [contrasenia]
    cmp rax, rbx
    je comprobador

    mov rdi, msjError
    mov rax, 0
    call printf
    jmp loopcomp

opciones:
    mov rax, 0

    mov rdi, contraseniaIng
    mov rsi, input
    call scanf

    mov rax, [input]
    cmp rax, 1
    je suma

    cmp rax, 2
    je multiplicacion

    cmp rax, 3
    je operadores

    cmp rax, 4
    je exit
   
loopcomp:
    mov rdi, contraseniaIng
    mov rsi, input
    call scanf

    mov rax, [input]
    mov rbx, [contrasenia]
    cmp rax, rbx
    je comprobador

    mov rdi, msjError
    mov rax, 0
    call printf

    inc r15
    cmp r15, 1
    jle loopcomp

    jmp exit

comprobador:
    mov rdi, 0
    mov rax, 0
    call printf
    jmp mostrar_menu

mostrar_menu:
    mov rdi, mostrarClave
    xor rax, rax
    call system

    mov rdi, msjMenu
    mov rax, 0
    call printf
    jmp opciones

suma:
    mov rdi, msjNum1
    call printf
    lea rdi, [contraseniaIng]
    lea rsi, [num1]
    mov rax, 0
    call scanf

    mov rdi, msjNum2
    call printf
    lea rdi, [contraseniaIng]
    lea rsi, [num2]
    mov rax, 0
    call scanf

    mov rax, [num1]
    add rax, [num2]
    mov rdi, msjResultSumall
    mov rsi, rax
    mov rax, 0
    call printf

    mov rax, [num1]
    mov rbx, [num2]
    sub rax, rbx
    mov rdi, msjResultResta
    mov rsi, rax
    mov rax, 0
    call printf

    jmp mostrar_menu
  
multiplicacion:
    mov rdi, msjNum1
    call printf

    mov rdi, contraseniaIng
    mov rsi, num1
    mov rax, 0
    call scanf

    mov rdi, msjNum2
    call printf

    mov rdi, contraseniaIng
    mov rsi, num2
    mov rax, 0
    call scanf

    mov rbp, rsp
    mov rax, [num1]
    mov rbx, [num2]

    mov rax, [num1]
    imul rax, rbx

    mov rdi, msjResultMult
    mov rsi, rax
    mov rax, 0
    call printf

    mov rax, 0
    mov rbp, rsp
    mov rax, [num1]
    mov rbx, [num2]

    mov rax, [num1]
    idiv qword rbx

    mov rdi, msjResultDiv
    mov rsi, rax
    mov rax, 0
    call printf

    jmp mostrar_menu

operadores:
    mov rdi, msjNum1
    call printf

    mov rdi, tamanioOperador
    mov rsi, num1Hexa
    mov rax, 0
    call scanf

    mov rdi, msjNum2
    call printf

    mov rdi, tamanioOperador
    mov rsi, num2Hexa
    mov rax, 0
    call scanf

    xor rcx, rcx
    xor rax, rax
    xor rbx, rbx
    mov al, [num1Hexa]
    mov rcx, 7

cicloBinarioNum1:
    mov bl, al
    and bl, 0x1
    add bl, '0'
    shr al, 1
    mov [listaBinarioNum1+rcx], bl
    dec rcx
    cmp rcx, 0
    jge cicloBinarioNum1

    mov bl, 0
    mov [listaBinarioNum1+8], bl
    mov rdi, msjNum1Bin
    mov rsi, listaBinarioNum1
    mov rax, 0
    call printf

    mov al, [num1Hexa]
    not al
    mov rcx, 7

cicloBinarioNum1Not:
    mov bl, al
    and bl, 0x1
    add bl, '0'
    shr al, 1
    mov [listaBinarioNumNot1+rcx], bl
    dec rcx
    cmp rcx, 0
    jge cicloBinarioNum1Not

    mov bl, 0
    mov [listaBinarioNumNot1+8], bl
    mov rdi, msjNum1BinNot
    mov rsi, listaBinarioNumNot1
    mov rax, 0
    call printf

    mov al, [num2Hexa]
    mov rcx, 7
 
cicloBinarioNum2:
    mov bl, al
    and bl, 0x1
    add bl, '0'
    shr al, 1
    mov [listaBinarioNum1+rcx], bl
    dec rcx
    cmp rcx, 0
    jge cicloBinarioNum2

    mov bl, 0
    mov [listaBinarioNum1+8], bl
    mov rdi, msjNum2Bin
    mov rsi, listaBinarioNum1
    mov rax, 0
    call printf

    mov al, [num2Hexa]
    not al
    mov rcx, 7

cicloBinarioNum2Not:
    mov bl, al
    and bl, 0x1
    add bl, '0'
    shr al, 1
    mov [listaBinarioNumNot1+rcx], bl
    dec rcx
    cmp rcx, 0
    jge cicloBinarioNum2Not

    mov bl, 0
    mov [listaBinarioNumNot1+8], bl
    mov rdi, msjNum1BinNot
    mov rsi, listaBinarioNumNot1
    mov rax, 0
    call printf

    mov al, [num1Hexa]
    mov bl, [num2Hexa]

    and rax, rbx
    mov [hexa], al
    mov rcx, 7

cicloBinarioAnd:
    mov bl, al
    and bl, 0x1
    add bl, '0'
    shr al, 1
    mov [listaBinario+rcx], bl
    dec rcx
    cmp rcx, 0
    jge cicloBinarioAnd

    mov bl, 0
    mov [listaBinario+8], bl
    mov rdi, msjHexAnd
    mov rsi, listaBinario
    mov rdx, [hexa]
    mov rax, 0
    call printf

    mov al, [num1Hexa]
    mov bl, [num2Hexa]

    or rax, rbx
    mov [hexa], al
    mov rcx, 7

cicloBinarioOR:
    mov bl, al
    and bl, 0x1
    add bl, '0'
    shr al, 1
    mov [listaBinario+rcx], bl
    dec rcx
    cmp rcx, 0
    jge cicloBinarioOR

    mov bl, 0
    mov [listaBinario+8], bl
    mov rdi, msjHexOr
    mov rsi, listaBinario
    mov rdx, [hexa]
    mov rax, 0
    call printf

    mov al, [num1Hexa]
    mov bl, [num2Hexa]

    xor rax, rbx
    mov [hexa], al
    mov rcx, 7

cicloBinarioXOr:
    mov bl, al
    and bl, 0x1
    add bl, '0'
    shr al, 1
    mov [listaBinario+rcx], bl
    dec rcx
    cmp rcx, 0
    jge cicloBinarioXOr

    mov bl, 0
    mov [listaBinario+8], bl
    mov rdi, msjHexXor
    mov rsi, listaBinario
    mov rdx, [hexa]
    mov rax, 0
    call printf

    jmp mostrar_menu

jmp exit

menor:
    mov rdi, msjRangoFuera
    mov rsi, rax
    mov rax, 0
    call printf
    jmp exit

exit: 
    mov rsp,rbp
    pop rbp 
    ret
