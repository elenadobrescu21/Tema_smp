
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


;setting video mode
mov ah, 0h
mov al, 03h
int 10h 

;declarare constante
deplasareOriz equ 20 


mov al, 0
mov ah, 6h

mov bh, 32 ;changing the color to green
mov ch, 0
mov cl, 0
mov dh, 25 ;umple ecranul de 80x25 cu verde
mov dl, 80  
int 10h     

mov ch, 0  ;de unde incep sa desenez patratul
mov cl, 0
mov dh, 10 ;dimensiunile patratului
mov dl, 16 
push cx   ; salvam coordonatele 
push dx
mov bh, 0ffh ;changing the color to white
int 10h 

choose:      ;asteapta sa citeasca un caracter de la tastatura
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
    mov al, 0             
    mov ah, 6 
    
    mov bh, 32 
    mov ch, 0
    mov cl, 0
    mov dh, 25
    mov dl, 80 
    int 10h 

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
    jmp choose 

left:   ;deplasare spre stanga
    mov al, 0             
    mov ah, 6 
    
    mov bh, 32 
    mov ch, 0
    mov cl, 0
    mov dh, 25
    mov dl, 80 
    int 10h
    
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
    jmp choose 
     

finish:
    mov ax, 4c00h
    int 21h

ret




