model small
.stack 100h
.data
a dw 2
b dw 1
c dw 8
d dw 1
ans dw 0

.code
start:
    MOV AX, @data
    MOV DS, AX

    MOV AX, a
    MOV BX, b
    AND AX, BX ; a & b
    MOV CX, AX ; CX = a & b

    MOV AX, C
    MOV BX, C
    MUL BX ; AX = c ^ 2
    MUL BX ; AX = c ^ 3
    MUL BX ; AX = c ^ 4

    ; CX = a & b
    ; AX = c ^ 4

    CMP AX, CX ; if (CX == AX) -> equal1
    JZ equal1

    MOV AX, a
    MOV BX, a
    MUL BX ; AX = a ^ 2
    MUL BX ; AX = a ^ 3
    MOV CX, AX ; CX = a ^ 3

    MOV AX, b
    MOV BX, b
    MUL BX ; AX = b ^ 2
    MUL BX ; AX = b ^ 3
    ; CX = a ^ 3
    ADD AX, CX ; AX = a ^ 3 + b ^ 3

    MOV BX, c
    ADD BX, b ; BX = c + b

    ; AX = a ^ 3 + b ^ 3
    ; BX = c + b
    CMP AX, BX ; if (AX == BX) -> equal2
    JZ equal2
    
    ; otherwise ans = c >> 3
    MOV AX, c
    SHR AX, 3 ; AX >> 3
    MOV ans, AX
    JMP finish

    equal1:
        MOV AX, c
        MOV BX, d
        DIV BX ; AX = c / d
        MOV BX, b
        DIV BX ; AX = c / d / b
        ADD AX, a
        MOV ans, AX
        JMP finish

    equal2:
        MOV AX, a
        MOV BX, b
        ADD BX, c
        XOR AX, BX ; AX = a ^ (b + c)
        MOV ans, AX

    finish:
        ; AX == ans


    MOV AH, 4ch
    INT 21h
end start
