model small
.stack 100h
.data
error db "Some shit happened, try again please...", 10, 13, '$'
UpperBoundException db "UpperBoundException", 10, 13, '$'
eol db 10, 13, '$' ; End of line
firstNumber db "Printf first number: $" 
secondNumber db "Printf second number: $"
.code

Return PROC
    MOV AX, 4C00h
    INT 21h

    RET
Return ENDP


PrintBoundsException PROC
    CALL PrintEOL

    MOV DX, offset UpperBoundException
    MOV AH, 09h
    INT 21h

    CALL Return

    RET
PrintBoundsException ENDP


PrintEOL PROC
    PUSH AX
    PUSH DX

    MOV DX, offset eol
    MOV AH, 09h
    INT 21h

    POP DX
    POP AX

    RET
PrintEOL ENDP


PrintError PROC
    PUSH AX
    PUSH DX

    CALL PrintEOL

    MOV DX, offset error
    MOV AH, 09h
    INT 21h

    CALL Return

    POP DX
    POP AX

    RET
PrintError ENDP


InputReader PROC
    PUSH BX
    PUSH CX
    PUSH DX

    XOR AX, AX
    XOR BX, BX

    getchar:
        MOV AH, 08h
        INT 21h

        CMP AL, 13 ; if (AL == Enter)
        JZ getchar_stop

        CMP AL, 8
        JZ backspace_pressed

        CMP AL, '0'
        JB getchar

        CMP AL, '9'
        JA getchar


        XOR CX, CX
        XOR DX, DX
        MOV DL, AL
        MOV CL, AL

        XOR AX, AX
        MOV AH, 02h
        INT 21h

        XOR DX, DX
        MOV AX, BX
        MOV BX, 10
        MUL BX

        CMP DX, 0
        JNZ upper_bound_exception
        
        MOV BX, AX
        SUB CL, '0'
        ADD BX, CX
        JB upper_bound_exception
        XOR AX, AX

        JMP getchar

    getchar_stop:
        MOV AX, BX

    POP DX
    POP CX
    POP DX

    RET

    upper_bound_exception:
        CALL PrintBoundsException 

    RET

    backspace_pressed:
        CMP BX, 0
        JZ getchar

        MOV AX, BX
        XOR DX, DX
        MOV BX, 10
        DIV BX
        MOV BX, AX

        PUSH BX

        XOR AX, AX 
        XOR BX, BX
        XOR DX, DX

        MOV AH, 03h
        INT 10h

        XOR AX, AX
        MOV AH, 02h
        DEC DL
        INT 10h
        PUSH DX
        
        MOV AH, 02h
        MOV DL, ' '
        INT 21h

        POP DX
        MOV AH, 02h
        INT 10h

        POP BX
        JMP getchar
InputReader ENDP


PrintWriter PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    XOR BX, BX
    XOR CX, CX
    MOV BX, 10
    
    get_nums:
        XOR DX, DX
        DIV BX
        PUSH DX
        INC CX
        TEST AX, AX
        jnz get_nums

    print:
        MOV AH, 02h
        POP DX
        ADD DX, '0'
        INT 21h
    LOOP print

    POP DX
    POP CX
    POP BX
    RET
PrintWriter ENDP

start:
    MOV AX, @data
    MOV DS, AX

    MOV DX, offset firstNumber
    MOV AH, 09h
    INT 21h

    CALL InputReader
    CALL PrintEOL
    ; first number in CX
    MOV CX, AX

    MOV DX, offset secondNumber
    MOV AH, 09h
    INT 21h

    CALL InputReader
    CALL PrintEOL
    ; second number in BX
    MOV BX, AX
    ; first number in AX
    MOV AX, CX
    XOR DX, DX

    CMP BX, 0
    JZ show_error

    DIV BX

    CALL PrintWriter

    TEST DX, DX
    JZ finish 

    PUSH DX

    MOV AH, 02h
    MOV DX, ' '
    INT 21h

    POP AX
    CALL PrintWriter

    MOV AH, 02h
    MOV DX, '/'
    INT 21h

    MOV AX, BX
    CALL PrintWriter
   
    finish:
        CALL PrintEOL
        CALL Return

    show_error:
        CALL PrintError
end start
