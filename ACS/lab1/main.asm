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

welcomeMessage db "Ax^2 + Bx + C = 0", 10, 13, '$'
GiveMeA db "A = $"
GiveMeB db "B = $"
GiveMeC db "C = $"


a dt 0.0
b dt 0.0
c dt 0.0
four dt 4.0
two dt 2.0

xone db "x1 = $"
xtwo db "x2 = $"
noSolutions db "There is no real solutions exist$", 10, 13
Infinity db "There is inifinity solutions$", 10, 13

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
        mov ah, 02h
        mov dl, 10
        int 21h

        mov ah, 02h
        mov dl, 13
        int 21h
        fistp temp

        ret
OutputWriter ENDP



Equtation PROC
;                         1. a != 0 b != 0
;                         2. a != 0 b == 0 c <= 0
;                         3. a != 0 b == 0 c > 0
;                         4. a == 0 b != 0 
;                         5. a == 0 b == 0 c != 0
;                         6. a == 0 b == 0 c == 0


    fld a
    fcomp null  ; if (a == 0)
	fstsw ax
	sahf
    jnz AnotNull
        jmp AisNull
    AnotNull:
        fld b
        fcomp null ;if (b == 0 && a != 0)
        fstsw ax
        sahf
        jz BisNullinAnot
;==============================================  1
            fld b
            fld b
            fmulp

            fld four
            fmul negative_one
            fld a
            fmulp
            fld c
            fmulp
            faddp

            fcom null
            fstsw ax
            sahf
            jnb dovernull
                mov dx, offset noSolutions
                mov ah, 09h
                int 21h
                ret
            dovernull:

            fsqrt
            fld st(0)

                      
            fmul negative_one
            fld b
            fmul negative_one
            fadd st(2), st(0)
            faddp

            fld two
            fld a
            fmulp
            fdiv st(2), st(0)
            fdivp 

            mov dx, offset xone
            mov ah, 09h
            int 21h

            fstp output
            CALL OutputWriter

            mov dx, offset xtwo
            mov ah, 09h
            int 21h

            fstp output
            CALL OutputWriter

            jmp Equtation_finish
            ret
;==============================================  1
        BisNullinAnot:
            fld c
            fld a
            fdivp
            fcomp null
            fstsw ax
            sahf
            jb CisLessZeroAandnB
;==============================================  2
                mov dx, offset noSolutions
                mov ah, 09h
                int 21h

                ret
;==============================================  2
        CisLessZeroAandnB:
;==============================================  3
            fld c
            fmul negative_one
            fld a
            fdivp
            fsqrt

            mov dx, offset xone
            mov ah, 09h
            int 21h

            fstp output
            CALL OutputWriter

            ret
;==============================================  3

    AisNull:
        fld b
        fcomp null ;if (b == 0 && a == 0)
        fstsw ax
        sahf
        jz BisNullinAnull
;==============================================  4
            fld c
            fmul negative_one
            fld b
            fdivp

            mov dx, offset xone
            mov ah, 09h
            int 21h

            fstp output
            CALL OutputWriter

            ret
;==============================================  4
        BisNullinAnull:
            fld c
            fcomp null ;if (c == 0)
            fstsw ax
            sahf
            jz CisNull
;==============================================  5
                mov dx, offset noSolutions 
                mov ah, 09h
                int 21h
                ret
;==============================================  5
            CisNull:
;==============================================  6
                mov dx, offset Infinity 
                mov ah, 09h
                int 21h
                ret
;==============================================  6

    Equtation_finish:
        ret
Equtation ENDP




main:
    mov ax, @data
    mov ds, ax

    mov dx, offset welcomeMessage
    mov ah, 09h
    int 21h

    mov dx, offset GiveMeA
    mov ah, 09h
    int 21h
    
    CALL InputReader
    fld input
    fstp a
    
    mov dx, offset GiveMeB
    mov ah, 09h
    int 21h

    CALL InputReader
    fld input
    fstp b

    mov dx, offset GiveMeC
    mov ah, 09h
    int 21h

    CALL InputReader
    fld input
    fstp c
    
    CALL Equtation

    mov ax, 4C00h
    int 21h
end main
