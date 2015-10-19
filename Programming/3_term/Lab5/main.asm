.model small
.stack 1000h
.data

error db "Something happened, try again please...", 10, 13, '$'
BoundsException db "BoundsException", 10, 13, '$'
eol db 10, 13, '$' ; End of line
column_number db "Write number of columns: $"
rows_number db "Write number of rows: $"
print_matrix db "Write matrix ", 10, 13, '$'
print_key_number db "Print key number: $"
rows dw 0
columns dw 0
Matrix dw 50*50 dup(0)

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
    PUSH SI

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
        JNZ temp
        JMP zero_check

        temp:
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
        
        TEST SI, SI
        JNZ negativate_one

        positive_one:
            CMP BX, 32767 
            JA upper_bound_exception
            JMP back_one
        negativate_one:
            CMP BX, 32768
            JA upper_bound_exception

        back_one:
        XOR AX, AX

        Zero_check_return:
        JMP getchar

    getchar_stop:
        MOV AX, BX

    CMP SI, 1
    JNZ InputReader_finish
    NEG AX

    InputReader_finish:
        POP SI
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
    PUSH SI
    
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

    POP SI
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


ReadMatrix PROC
    PUSH CX
    PUSH SI

    MOV CX, rows
    MOV SI, offset Matrix

    line:
        PUSH CX
        MOV CX, columns

        read_line:
            CALL InputReader
            ;MOV [SI], AH
            ;INC SI
            ;MOV [SI], AL
            ;INC SI
            MOV [SI], AX
            ADD SI, 2
            CALL PrintEOL
        LOOP read_line

        POP CX        
    LOOP line

    POP SI
    POP CX

    RET
ReadMatrix ENDP

WriteMatrix PROC
    PUSH AX
    PUSH CX
    PUSH SI

    MOV CX, rows
    MOV SI, offset Matrix

    lines:
        PUSH CX
        MOV CX, columns

        read_line1:
            MOV AX, [SI]
            CALL PrintWriter 
            ADD SI, 2

            MOV AH, 02h
            MOV DL, ' '
            INT 21h
        LOOP read_line1

        POP CX        
        CALL PrintEOL
    LOOP lines

    POP SI
    POP CX
    POP AX

    RET
WriteMatrix ENDP

MODIFY PROC
    PUSH BX
    PUSH CX
    PUSH SI

    MOV CX, rows
    MOV SI, offset Matrix

    lines1:
        PUSH CX
        MOV CX, columns

        read_line2:
            MOV BX, [SI]
            CMP AX, BX
            JG good
            JZ good
            MOV BX, 0
            MOV [SI], BX   
            good:
                ADD SI, 2
        LOOP read_line2

        POP CX        
        CALL PrintEOL
    LOOP lines1

    POP SI
    POP CX
    POP BX

    RET
MODIFY ENDP


main:
    MOV AX, @data
    MOV DS, AX

    MOV AH, 09h
    MOV DX, offset rows_number
    INT 21h

    CALL InputReader
    MOV rows, AX
    CALL PrintEOL

    MOV BX, 1
    SHL BX, 15
    TEST AX, BX
    JS print_error
    TEST AX, AX
    JZ print_error

    MOV AH, 09h
    MOV DX, offset column_number
    INT 21h

    CALL InputReader
    MOV columns, AX
    CALL PrintEOL

    MOV BX, 1
    SHL BX, 15
    TEST AX, BX
    JS print_error
    TEST AX, AX
    JZ print_error

    MOV AH, 09h
    MOV DX, offset print_matrix
    INT 21h

    CALL ReadMatrix
    CALL PrintEOL
    CALL WriteMatrix

    MOV AH, 09h
    MOV DX, offset print_key_number
    INT 21h

    CALL InputReader
    CALL PrintEOL

    CALL MODIFY
    CALL WriteMatrix
    
    CALL Return

    print_error:
        CALL PrintError
end main
