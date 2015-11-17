.186
.model tiny
.code
org 2Ch
envseg dw ?
org 80h
cmd_len db ?
cmd_line db ?
org 100h

lab:

jmp start

int21h_handler proc far
    jmp start_here
    old_int21h_handler dd ?
    new_str db 200 dup ('$')
    vowels db "aAqQoOiIuUyYeE"
    active dw ?

    start_here:
    pushf
    pusha
    cli
    cmp ah, 09h
    jnz only_old_handler

    mov ax, 0
    mov ax, cs:active
    cmp ax, 32400
    jnz only_old_handler

    mov cx, 2  
    mov si, offset new_str
    mov di, dx
    go_over_string:
        mov cx, 2
        mov al, [di]
        cmp al, '$'
        jz  loop_end
        push cx
        push di

        mov cx, 14
        mov di, offset vowels
        go_over_vowels:
            cmp al, byte ptr cs:[di]
            jz vowel
            inc di
        loop go_over_vowels

        not_a_vowel:
            pop di
            pop cx
            mov al, [di]
            mov [si], al            
            inc si
            inc di
            jmp next
        vowel:
            pop di
            pop cx
            inc di
    next:
    loop go_over_string

    loop_end:
    
    mov al, '$'
    mov [si], al

    popa
    mov dx, offset new_str
    popf
        jmp dword ptr cs:old_int21h_handler
    iret

    only_old_handler:
        popa 
        popf
        jmp dword ptr cs:old_int21h_handler
        iret
int21h_handler endp

already_installed db "Error. Int 21h Ah = 09h handler is already installed.$"
wrong_parametres db "Error. Please write correct parametres.$"
succes db "Int 21h Ah = 09h handler is successfully installed.$"
removed db "Int 21h Ah = 09h handler is successfully removed.$"
is_not_installed db "Error. Int 21h Ah = 09h handler is not installed yet.$"


start:
    mov ax, 3521h
    int 21h
    mov word ptr old_int21h_handler, bx
    mov word ptr old_int21h_handler + 2, es   
    
    mov ah, cmd_len
    cmp ah, 0
    jnz param

    mov ax, es:active
    cmp ax, 32400
    jz alr_inst

    mov dx, offset succes
    mov ah, 09h
    int 21h
   
    mov ax, 32400
    mov active, ax

    mov ax, 2521h
    mov dx, offset int21h_handler
    int 21h

    mov dx, offset start
    int 27h
    ret

    param:
        mov di, offset cmd_line
        mov al, [di + 1]
        cmp al, '-'
        jnz param_error

        mov al, [di + 2]
        cmp al, 'd'
        jnz param_error

        mov ax, es:active
        cmp ax, 32400
        jnz not_installed

        mov ax, 0
        mov es:active, ax ; deactivate handler

        mov dx, offset removed
        mov ah, 09h
        int 21h
        
        ret

    not_installed:
        mov dx, offset is_not_installed
        mov ah, 09h
        int 21h
        ret

    param_error:
        mov dx, offset wrong_parametres
        
        xor bx, bx ; if already installed, 0 if not    
        mov ax, es:active
        cmp ax, 32400
        jnz not_active 
        mov bx, 1

        mov ax, 0 ; Activate old handler
        mov es:active, ax

        not_active:
        mov ah, 09h
        int 21h
        
        cmp bx, 1
        jnz was_not_active

        mov ax, 32400 ; Activate new handler
        mov es:active, ax

        was_not_active:
        ret

    alr_inst:
        mov dx, offset already_installed

        mov ax, 0 ; Activate old handler
        mov es:active, ax

        mov ah, 09h
        int 21h

        mov ax, 32400 ; Activate new handler
        mov es:active, ax
        ret
end lab 
