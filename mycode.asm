
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h 

INCLUDE 'emu8086.inc' 

deplasareOriz equ 20 

jmp EnterNumber

EnterNumber:
    lea SI,msg 
    CALL print_string
    call scan_num
    PUTC 13
    PUTC 10 
    PRINT "You've entered:" 
    MOV AX, CX 
    CALL print_Num 
    PUTC 13 
    PUTC 10
    cmp cx, 4
    ja EnterNumber
    jl moveSquare
    
    
 
colorScreen PROC ; coloreaza fundalul cu verde
    mov al, 0             
    mov ah, 6     
    mov bh, 32 
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

   
   
moveSquare:     
    mov ah, 0h  ;setting video mode
    mov al, 03h
    int 10h 
    call colorScreen     
    mov ch, 0  ;de unde incep sa desenez patratul
    mov cl, 0
    mov dh, 10 ;dimensiunile patratului
    mov dl, 16 
    push cx   ; salvam coordonatele 
    push dx
    mov bh, 0ffh ;changing the color to white
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
    int 10h
    call beep
    jmp choose 
     

finish:
    mov ax, 4c00h
    int 21h
    
    
HLT
msg DW 'Enter a number:1, 2, 3 or 4: ', 0
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
 

ret




