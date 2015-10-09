.model small
.stack 300h
.data
input_text db "Print string: $"
buf db 200, 200 dup ('$')
eol db 10, 13, '$'
vowels db "aAeEuUiIoO$"
.code

Return PROC
    MOV AX, 4C00h
    Int 21h
    Ret
Return ENDP

PrintString PROC
    PUSH AX
    
    MOV AH, 09h
    INT 21h

    POP AX
PrintString ENDP

PrintEOL PROC
    PUSH AX
    PUSH DX

    MOV DX, offset EOL
    MOV AH, 09h
    INT 21h

    POP DX
    POP AX
    RET
PrintEOL ENDP

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

start:
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX
    XOR AX, AX 

    MOV DX, offset input_text
    MOV AH, 09h
    INT 21h

    MOV DX, offset buf
    MOV AH, 0ah
    INT 21h
    CALL PrintEOL

    XOR CX, CX
    MOV CL, buf + 1     ; Length of the string
    MOV DX, 0           ; Count of words starting with vowel
    MOV BL, offset buf + 2     ; Current position in the buf
    MOV BP, 0           ; Current word lenght

    go_through_all_buff:
        PUSH CX
        XOR AX, AX
        MOV AL, [BX]
        INC BP

        CMP AL, ' '
        JNZ if_first_letter 
        XOR BP, BP 
        JMP continue

        if_first_letter:
            CMP BP, 1
            JNZ continue

        CLD
        MOV DI, offset vowels 
        
        MOV CX, 10 ; number of vowels
        REPNE SCASB
        JNZ continue
        INC DX

        continue:
            POP CX
            INC BX        
    LOOP go_through_all_buff
    
    MOV AX, DX
    CALL PrintWriter

    CALL Return
end start
