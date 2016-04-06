org 100h 

INCLUDE 'emu8086.inc' 

deplasareOriz equ 20 ;declarare constanta

jmp EnterNumber
     
colorScreen PROC ;coloreaza fundalul cu alb
    mov al, 0             
    mov ah, 6     
    mov bh, 0ffh ;cod de culoare pentru alb
    mov ch, 0    
    mov cl, 0
    mov dh, 25   ;coloreaza ecranul de 80x25
    mov dl, 80 
    int 10h 
    ret 
colorScreen ENDP

clearScreen PROC ;curata ecranul si sare la meniu
    mov al, 0
    mov ah, 6    
    mov ch, 0
    mov cl, 0
    mov dh, 25
    mov dl, 80
    int 10h
    jmp EnterNumber
clearScreen ENDP

beep PROC        ;genereaza un beep
    mov ah, 02
    mov dl, 07h
    int 21h
    ret
beep ENDP

EnterNumber:    ;meniu
    mov al, 0
    mov ah, 6    
    mov ch, 0
    mov cl, 0 
    mov bh, 56
    mov dh, 25
    mov dl, 80
    int 10h
    
    lea SI,msg 
    CALL print_string
    PUTC 13     ;trecere la rand nou
    PUTC 10
    PRINT "1: Animation"
    PUTC 13
    PUTC 10
    PRINT "2: Move square"
    PUTC 13
    PUTC 10
    call scan_num
    PUTC 13
    PUTC 10
    PRINT "You've entered:" 
    PUTC 13
    PUTC 10
    MOV AX, CX 
    CALL print_Num
    PUTC 13
    PUTC 10 
    cmp cx, 2   ;se verifica numarul introdus de la tastatura
    ja EnterNumber  
    jl animation
    je moveSquare
           
animation: 
    mov ah, 0h  ;setare mod video
    mov al, 03h ;text mode, 80x25
    int 10h
    call colorScreen
    mov ch, 0
    mov cl, 0
    mov dh, 5  ;dimensiuni patrat
    mov dl, 8
    mov bh, 32 ;schimba culoarea in cyan
    int 10h
     
    josVerticala 1
    josVerticala 2
    josVerticala 3
    josVerticala 4
    josVerticala 5 
         
    spreDreapta 2
    spreDreapta 4
    spreDreapta 6
    spreDreapta 8
    spreDreapta 10
    spreDreapta 12
    spreDreapta 14
    spreDreapta 16
    spreDreapta 18
    spreDreapta 23
    spreDreapta 26
    spreDreapta 29
    spreDreapta 33
    spreDreapta 37
    spreDreapta 42
    spreDreapta 47
    spreDreapta 50
    spreDreapta 55
    spreDreapta 60
 
    call Beep
    
    jmp clearScreen
   
    
josVerticala MACRO p1  ;muta patratul in jos cu nr de randuri specificat prin p1
    call colorScreen  
    mov ch, p1
    mov cl, 0
    mov dh, 5+p1
    mov dl, 8
    mov bh, 32 
    int 10h
ENDM  

spreDreapta MACRO p1   ;muta patratul spre dreapta cu nr de coloane specificat prin p1
    call colorScreen
    mov ch, 5
    mov cl, p1
    mov dl, 8+p1
    mov dh, 10
    mov bh, 56
    int 10h
ENDM
       
moveSquare:     
    mov ah, 0h  ;setare mod video
    mov al, 03h ;text mode, 80x25
    int 10h 
    call colorScreen     
    mov ch, 0   ;de unde incep sa desenez patratul
    mov cl, 0
    mov dh, 10  ;dimensiunile patratului
    mov dl, 16 
    push cx     ;salvam coordonatele pe stiva
    push dx
    mov bh, 56 
    int 10h
   
choose:         ;asteapta sa citeasca un caracter de la tastatura
    mov ah, 1
    mov bh, 32
    int 21h
    cmp al, 'e'
    je finish
    cmp al, 'd'
    je right 
    cmp al, 'a'
    je left
    cmp al, 'b'
    je clearScreen
    

right:          ;Deplasare spre dreapta
    call colorScreen 
    mov bh, 0ffh
    mov ch, 0
    pop dx
    add dl, deplasareOriz
    pop cx 
    add cl, deplasareOriz
    mov dh, 10
    push cx
    push dx
    mov bh, 56
    int 10h
    call beep
    jmp choose 

left:           ;deplasare spre stanga
    call colorScreen    
    mov bh, 0ffh
    mov ch, 0
    pop dx
    sub dl, deplasareOriz
    pop cx 
    sub cl, deplasareOriz
    mov dh, 10
    push cx
    push dx
    mov bh, 56
    int 10h
    call beep
    jmp choose
         
finish:
    mov ax, 4c00h
    int 21h
    
HLT
msg DB 'Enter a number ', 0
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

ret