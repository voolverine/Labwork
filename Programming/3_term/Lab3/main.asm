model small
.stack 100h
.data
error db "Some shit happened, try again please...", 10, 13, '$'
BoundsException db "BoundsException", 10, 13, '$'
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

    MOV DX, offset BoundsException
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
    XOR SI, SI

    getchar:
        MOV AH, 08h
        INT 21h

        CMP AL, 13 ; if (AL == Enter)
        JZ getchar_stop

        CMP AL, 8
        JZ backspace_pressed

        
        CMP AL, '9'
        JA getchar

        CMP AL, '-'
        JZ Zero_check

        CMP AL, '0'
        JB getchar
       

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

        CMP BX, 32767 
        JA upper_bound_exception
        XOR AX, AX

        Zero_check_return:
        JMP getchar

    getchar_stop:
        MOV AX, BX

    CMP SI, 1
    JNZ InputReader_finish
    NEG AX

    InputReader_finish:
        POP DX
        POP CX
        POP DX
    RET

    upper_bound_exception:
        CALL PrintBoundsException 

    RET

    backspace_pressed:
        CMP BX, 0
        JNZ delete_it
        or_if_negative:
            CMP SI, 1
            JNZ getchar
            XOR Si, SI

        delete_it:
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

    Zero_check:
        CMP BX, 0
        JNZ Zero_check_return 

        CMP SI, 1
        JZ Zero_check_return 

        MOV Si, 1
        MOV AH, 02h
        MOV DX, '-'
        INT 21h
        JMP Zero_check_return
InputReader ENDP


PrintWriter PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    XOR BX, BX
    XOR CX, CX
    XOR SI, SI
    MOV BX, 10

    TEST AX, AX
    JS negativate
    
    get_nums:
        XOR DX, DX
        DIV BX
        PUSH DX
        INC CX
        TEST AX, AX
        jnz get_nums
        CMP SI, 1
        JZ Print_minus

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

    negativate:
        MOV Si, 1
        NEG AX
        JMP get_nums
    Print_minus:
        MOV AH, 02h
        MOV DX, '-'
        INT 21h
        JMP print
PrintWriter ENDP

Make_positive PROC
    TEST AX, AX
    JNS end_make_positive_proc
    NEG AX
    end_make_positive_proc:
        RET
Make_positive ENDP

Make_answer_easier PROC
    ; ax / bx

    MOV CX, 182
    try_new_divisor:
        XOR DX, DX

        PUSH AX
        PUSH BX

        MOV BX, CX 
        DIV BX

        POP BX
        POP AX
        CMP DX, 0
        JNZ continue

        XOR DX, DX
        PUSH AX
        PUSH BX
        MOV AX, BX
        MOV BX, CX 

        DIV BX
        POP BX
        POP AX
        CMP DX, 0
        JNZ continue

        PUSH BX
        MOV BX, CX 
        DIV BX
        POP BX
        PUSH AX
        MOV AX, BX
        MOV BX, CX 
        DIV BX
        MOV BX, AX
        POP AX

        continue:
    LOOP try_new_divisor

    RET
Make_answer_easier ENDP

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
    
    CWD
    IDIV BX

    CALL PrintWriter

    TEST DX, DX
    JZ finish 

    PUSH DX
    MOV AH, 02h
    MOV DX, ' '
    INT 21h

    POP AX
    CALL Make_positive ; make ax positive
    PUSH AX
    MOV AX, BX
    CALL Make_positive ; make bx positive
    MOV BX, AX
    POP AX

    CALL Make_answer_easier

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
