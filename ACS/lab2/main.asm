.286
.model small
.stack 100h
.data

;================================= INPUT
num dw 40 dup (0)
leng dw 0
minus dw 0
dot dw 0

ten dd 10.0
one dd 1.0
negative_one dd -1.0
input dt 0.0
; ================================ INPUT

; ================================ OUTPUT
null dd 0.0
output dt 0.0
temp dw 0
output_len dw 0
; ================================ OUTPUT

; ================================ ANSWERS
Y dt 500 dup(0.0)
S dt 500 dup(0.0)
X dt 500 dup(0.0)
N dw 500 dup(0)
; ================================ ANSWERS

; ================================ FROM_USER
a dd 0.0 
b dd 0.0
h dd 0.0
eps dd 0.0
; ================================ FROM_USER

; ================================ Programmatic
hungred dd 100.0
minimalEps dd 0.0001
in_err db "Incorrect input. Try again plese.", 10, 13, '$'
converage_err db "Series converges only at (-1, 1). Try again please.$"
tab db 10
i dw 0
k dw 0
pid4 dt 0.7853981
negative_two dt -2.0
temporary dt 0.0

gA db "a = $"
gB db "b = $"
gH db "h = $"
gEps db "eps = $"

XColumn db "X$"
YColumn db "Y(X)$"
SColumn db "S(X)$"
NColumn db "n$"

; ================================ Programmatic


.code

InputReader PROC
    mov ax, 0
    mov leng, ax
    mov minus, ax
    mov dot, ax

    getchar:
        mov ah, 08h
        int 21h

        cmp al, 13
        jnz goto1
            jmp getchar_stop 
        goto1:

        cmp al, 8
        jnz not_backspase
            jmp backspace_pressed
        not_backspase:


        cmp leng, 10
        ja getchar

        cmp al, '-'
        jnz not_minus
            jmp minus_pressed
        not_minus:

        cmp al, '.'
        jnz not_dot
            jmp dot_pressed
        not_dot:

        cmp al, '0'
        jb getchar

        cmp al, '9'
        ja getchar

        push ax
        mov dl, al
        mov ah, 02h
        int 21h
        pop ax

        sub al, '0'
        xor ah, ah

        mov di, offset num
        add di, leng
        add di, leng

        mov dx, 1
        cmp minus, 1
        jnz goto5
            sub di, 2
        goto5:

        mov dx, 0
        cmp dot, dx
        jz goto6
            sub di, 2
        goto6:

        mov [di], ax

        inc leng

        mov ax, 0 
        cmp dot, ax
        jz getchar
            inc dot
        jmp getchar

    dot_pressed:

        mov ax, dot
        cmp ax, 0
        jnz getchar

        mov ax, minus
        cmp ax, 1
        jz already_minus

            mov ax, 0
            cmp leng, ax
            jnz yeah_delete_it
                jmp getchar
            yeah_delete_it:

            mov dl, '.'
            mov ah, 02h
            int 21h

            mov ax, leng
            inc ax
            mov leng, ax

            mov ax, dot
            inc ax
            mov dot, ax

            jmp getchar
        already_minus:

            mov ax, leng 
            cmp ax, 2
            jnb yeah_delete_it2
                jmp getchar 
            yeah_delete_it2:

            mov dl, '.'
            mov ah, 02h
            int 21h

            inc leng
            inc dot

            jmp getchar
    backspace_pressed:
        mov ax, 0
        cmp ax, leng 
        jnz goto4
            jmp getchar

        goto4:
            mov ax, 1
            cmp dot, ax
            jz delete_dot
         
            cmp minus, ax
            jnz noo_minus
            
            cmp leng, ax
            jnz noo_minus
            jmp delete_minus

            noo_minus:
            
            jmp clear_character

        delete_minus:
            dec minus
            jmp clear_character

        delete_dot:
            dec dot
            jmp clear_character

        clear_character:
            dec leng 
            
            xor ax, ax 
            xor bx, bx
            xor dx, dx

            mov ah, 03h
            int 10h

            xor ax, ax
            mov ah, 02h
            dec dl
            int 10h
            push dx
            
            mov ah, 02h
            mov dl, ' '
            int 21h

            pop dx
            mov ah, 02h
            int 10h

            mov ax, 0
            cmp dot, ax
            jz skip
                dec dot

        skip:
            jmp getchar
            
    minus_pressed:  
        mov ax, minus
        cmp ax, 1
        jnz goto2
            jmp getchar
        goto2:

        mov ax, leng
        cmp ax, 0
        jz goto3
            jmp getchar
        goto3:

        mov ax, 1
        mov minus, ax

        mov dl, '-'
        mov ah, 02h
        int 21h
        
        mov ax, 1
        mov leng, ax
        
        jmp getchar
    getchar_stop:

        mov ax, 0
        cmp leng, ax
        jnz have_numbers
            jmp getchar
        have_numbers:

        mov ax, 1
        cmp minus, ax
        jnz noo_minus3
            mov ax, 2
            cmp leng, 1
            jnz noo_minus3
            jmp getchar
        noo_minus3:

        mov ax, 1
        cmp dot, ax
        jnz no_end_dot
            jmp getchar
        no_end_dot:

        mov cx, leng
        mov ax, 1
        cmp minus, ax
        jnz noo_minus2
            dec cx
        noo_minus2:

        mov ax, 0
        cmp dot, ax
        jz no_dot2
            dec cx
        no_dot2:
        mov di, offset num
        
        fld null 

        for:
            fmul ten
            fiadd word ptr [di]
            add di, 2
        loop for


        mov ax, 0
        cmp ax, dot
        jz finish_it
        
        dec dot

        mov cx, dot
        fld one

        for1:
            fmul ten
        loop for1
        fdivp

    finish_it:
        mov ax, 1
        cmp minus, ax
        jnz return
            fmul negative_one 

    return:
        fstp input
        mov dl, 13
        mov ah, 02h
        int 21h
        mov dl, 10
        mov ah, 02h
        int 21h
        ret
InputReader ENDP


OutputWriter PROC
    mov ax, 0
    mov output_len, ax

    fld output 
    fcom null
    fstsw ax
    sahf
    jnc positive
        fmul negative_one

        mov dl, '-'
        mov ah, 02h
        int 21h
    positive:

    fld one
    fld st(1)
    fprem
   
    fxch st(1)
    fstp one
    fxch st(1)
    fsub st(0), st(1)

    for2:
        fcom null
        fstsw ax
        sahf
        jz end_good
        
        fld ten
        fld st(1)
        fprem

        fsub st(2), st(0)
        fistp temp
        mov ax, temp
        push ax 
        inc output_len 
        
        fdiv st(1), st(0)
        fistp temp

        jmp for2
    end_good:

    fistp temp
    mov cx, output_len

    cmp cx, 0
    jz print_zero

    for3:
        pop dx
        add dl, '0' 
        mov ah, 02h
        int 21h
    loop for3
    jmp last

    print_zero:
        mov dl, '0'
        mov ah, 02h
        int 21h

    last:
        fcom null
        fstsw ax
        sahf
        jz output_finish

        mov dl, '.'
        mov ah, 02h
        int 21h

        mov output_len, 0

    for4: 
        fcom null
        fstsw ax
        sahf
        jz output_finish

        mov ax, output_len
        cmp ax, 5
        jz output_finish

        fmul ten
        fld one
        fld st(1)
        fprem

        fxch st(2)
        fsub st(0), st(2)

        fistp temp
        mov dx, temp
        add dl, '0'
        mov ah, 02h
        int 21h

        fistp temp
        inc output_len
        jmp for4
    jmp for4

    
    output_finish:
        fistp temp
        ret
OutputWriter ENDP


funY PROC
    mov ax, 0
    mov i, ax

    fld a

    fromAtoB:
        fcom b
        fstsw ax
        sahf
        ja MoreThanB


        fld pid4
        .386
        fsin
        .286
        fmul st, st(1)
        fld st(1)
        fmul st, st(2) 
        fadd one
        fld negative_two
        fmul st, st(3)
        fld pid4
        .386
        fcos
        .286
        fmulp
        faddp
        fdivp    
    
        CALL funS

        mov si, offset Y
        add si, i
        fstp tbyte ptr [si]
        
        mov si, offset X
        add si, i
        fstp temporary
        fld temporary

        fstp tbyte ptr [si]
        fld tbyte ptr [si]

        fadd h 
        mov ax, i
        add ax, 10
        mov i, ax
    jmp fromAtoB

    MoreThanB:


    ret
        
funY ENDP

funS PROC
    mov ax, 0
    mov k, ax
    
    fld null

    endless:
        mov ax, k
        cmp ax, 100
        jnz go 
            fstp temporary
            fld null 
            jmp stopEndless
        go:

        fld
        fsub st, st(1)
        fabs
        fcomp eps
        fstsw ax
        sahf
        jb stopEndless

        fld one 
        mov cx, k

        power:
            cmp cx, 0
            jz powered

            fmul st, st(3)
        loop power

        powered:
            fld pid4
            fild k
            fmulp
            .386
            fsin
            .286
            fmulp
            faddp
            inc k
    jmp endless

    stopEndless:
        mov si, offset S
        add si, i
        fstp tbyte ptr [si] 

        mov si, offset N

        add si, i
        mov ax, k
        mov word ptr [si], ax

        ret
funS ENDP 


tableViewPrint PROC
   
    xor dx, dx
    xor ax, ax

    mov ah, 03h
    int 10h

    push dx
    
    mov ah, 09h
    mov dx, offset XColumn
    int 21h

    pop dx
    add dl, tab 
    push dx

    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dx, offset YColumn
    int 21h

    pop dx
    add dl, tab 
    push dx

    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dx, offset SColumn
    int 21h


    pop dx
    add dl, tab 

    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dx, offset NColumn
    int 21h

; ================================ New line
        mov dl, 13
        mov ah, 02h
        int 21h
        mov dl, 10
        mov ah, 02h
        int 21h
; ================================ New line


    fld a
    mov ax, 0
    mov i, ax

    endlessPrint:
        fld b
        fstp temporary
        fcom b
        fstsw ax
        sahf
        ja stopPrint

        mov ah, 03h
        int 10h
        
        push dx
        mov si, offset X
        add si, i
        fld tbyte ptr [si]
        fstp output
        CALL OutputWriter


        pop dx
        add dl, tab 
        push dx

        mov ah, 02h
        int 10h

        mov si, offset Y
        add si, i
        fld tbyte ptr [si]
        fstp output
        CALL OutputWriter


        pop dx
        add dl, tab 
        push dx

        mov ah, 02h
        int 10h

        mov si, offset S
        add si, i
        fld tbyte ptr [si]
        fstp output
        CALL OutputWriter


        pop dx
        add dl, tab 

        mov ah, 02h
        int 10h

        mov si, offset N
        add si, i
        fild word ptr [si] 
        fstp output
        CALL OutputWriter


        mov ax, i
        add ax, 10 
        mov i, ax

        mov dl, 13
        mov ah, 02h
        int 21h
        mov dl, 10
        mov ah, 02h
        int 21h
    
        fadd h
    jmp endlessPrint

    stopPrint:

    ret
tableViewPrint ENDP

main:
    mov ax, @data
    mov ds, ax

    mov dx, offset gA
    mov ah, 09h
    int 21h

    CALL InputReader
    fld input
    fstp a

    mov dx, offset gB
    mov ah, 09h
    int 21h

    CALL InputReader
    fld input
    fstp b

    mov dx, offset gH
    mov ah, 09h
    int 21h

    CALL InputReader
    fld input
    fstp h

    mov dx, offset gEps
    mov ah, 09h
    int 21h

    CALL InputReader
    fld input
    fstp eps

    fld a
    fcomp negative_one
    fstsw ax
    sahf
    jna Conver_err

    fld b
    fcomp one
    fstsw ax
    sahf
    jnb Conver_err

    fld h
    fcomp null
    ja InputERROR

    fld b
    fcomp a
    fstsw ax
    sahf
    jb InputERROR

    fld b
    fsub a
    fdiv h

    fcomp hungred
    fstsw ax
    sahf
    ja InputERROR
    fld minimalEps
    fcomp eps
    fstsw ax
    sahf
    ja InputERROR

    fld b
    fadd minimalEps
    fstp b

    CALL funY
    CALL tableViewPrint 
    mov ax, 4C00h
    int 21h

    InputERROR:
        mov dx, offset in_err 
        mov ah, 09h
        int 21h

    mov ax, 4C00h
    int 21h

    Conver_err:
        mov dx, offset converage_err
        mov ah, 09h
        int 21h

    mov ax, 4C00h
    int 21h


end main
