
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h 

INCLUDE 'emu8086.inc' 

deplasareOriz equ 20 ;declarare constanta

jmp EnterNumber
     
colorScreen PROC ; coloreaza fundalul cu verde
    mov al, 0             
    mov ah, 6     
    mov bh, 0ffh 
    mov ch, 0
    mov cl, 0
    mov dh, 25
    mov dl, 80 
    int 10h 
    ret 
colorScreen ENDP 

beep PROC 
    mov ah, 02
    mov dl, 07h
    int 21h
    ret
beep ENDP

EnterNumber:
    lea SI,msg 
    CALL print_string
    PUTC 13
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
    cmp cx, 2
    ja EnterNumber
    jl animation
    je moveSquare
           
animation: 
    mov ah, 0h  ;setting video mode
    mov al, 03h ;text mode, 80x25
    int 10h
    call colorScreen
    mov ch, 0
    mov cl, 0
    mov dh, 5
    mov dl, 8
    mov bh, 32 ;changing the color to blue-ish
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
   
    mov ax, 4c00h
    int 21h   
   
    
josVerticala MACRO p1
    call colorScreen  
    mov ch, p1
    mov cl, 0
    mov dh, 5+p1
    mov dl, 8
    mov bh, 32 ;changing the color to blue-ish
    int 10h
ENDM  

spreDreapta MACRO p1
    call colorScreen
    mov ch, 5
    mov cl, p1
    mov dl, 8+p1
    mov dh, 10
    mov bh, 56
    int 10h
ENDM
       
moveSquare:     
    mov ah, 0h  ;setting video mode
    mov al, 03h ;text mode, 80x25
    int 10h 
    call colorScreen     
    mov ch, 0  ;de unde incep sa desenez patratul
    mov cl, 0
    mov dh, 10 ;dimensiunile patratului
    mov dl, 16 
    push cx   ; salvam coordonatele 
    push dx
    mov bh, 56 ;changing the color to white
    int 10h
   
choose:   ;asteapta sa citeasca un caracter de la tastatura
    mov ah, 1
    mov bh, 32
    int 21h
    cmp al, 'e'
    je finish
    cmp al, 'd'
    je right 
    cmp al, 'a'
    je left

right:  ;Deplasare spre dreapta
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

left:   ;deplasare spre stanga
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