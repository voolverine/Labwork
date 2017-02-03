.386p

RM_seg segment para public "code" use16
    assume CS:RM_seg, DS:PM_seg, SS:STACK_SEGMENT

open_a20 PROC
    in al, 92h
    or al, 2
    out 92h, al

    ret
open_a20 ENDP


forbit_interrupts PROC
    cli
    in al, 70h
    or al, 80h
    out 70h, al

    ret
forbit_interrupts ENDP


allow_interrupts PROC
    sti
    in al, 70h
    and al, 0FEh
    out 70h, al

    ret
allow_interrupts ENDP


enable_protected_mode PROC
    mov eax, cr0
    or al, 1
    mov cr0, eax

    ret
enable_protected_mode ENDP


enable_realtime_mode PROC
    mov eax, cr0
    and al, 0FEh
    mov cr0, eax

    ret
enable_realtime_mode ENDP


start:
    ; Prepare segment registers
    push PM_seg
    pop ds

    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h


    CALL open_a20

    xor eax, eax
    mov ax, RM_seg
    shl eax, 4
    mov word ptr GDT_16bitCS + 2, ax
    shr eax, 16
    mov byte ptr GDT_16bitCS + 4, al


    mov ax, PM_seg
    shl eax, 4
    mov word ptr GDT_32bitCS + 2, ax
    shr eax, 16
    mov byte ptr GDT_32bitCS + 4, al

    mov ax, STACK_SEGMENT
    shl eax, 4
    mov word ptr GDT_32bitSS + 2, ax
    shr eax, 16
    mov byte ptr GDT_32bitSS + 4, al

    ; Calculate linear adress of GDT
    xor eax, eax
    mov ax, PM_seg
    shl eax, 4
    push eax
    add eax, offset GDT
    mov dword ptr gdtr + 2, eax

    ; Load global descriptor table
    lgdt fword ptr gdtr


    ; Calculate linear adresses of task segments
    pop eax
    push eax
    add eax, offset TSS_0
    mov word ptr GDT_TSS0 + 2, ax
    shr eax, 16
    mov byte ptr GDT_TSS0 + 4, al

    pop eax
    push eax
    add eax, offset TSS_1
    mov word ptr GDT_TSS1 + 2, ax
    shr eax, 16
    mov byte ptr GDT_TSS1 + 4, al

    pop eax
    add eax, offset TSS_2
    mov word ptr GDT_TSS2 + 2, ax
    shr eax, 16
    mov byte ptr GDT_TSS2 + 4, al


    CALL forbit_interrupts
    CALL enable_protected_mode

    ; load new selector in cs registry
                    db 66h
                    db 0EAh     ; far jump command
                    dd offset PM_entry
                    dw SEL_32bitCS; selector


    RM_return:
        CALL enable_realtime_mode
        CALL allow_interrupts

        ; Clear future queue
            db 0EAh
            dw $ + 4
            dw RM_seg
        ; Setup Real Mode segment registry
        mov ax, PM_seg
        mov ds, ax
        mov es, ax
        mov ax, STACK_SEGMENT
        mov bx, stack_length_1
        mov ss, ax
        mov sp, bx


    mov ah, 4Ch
    int 21h

RM_seg ends

PM_seg segment para public "CODE" use32
    assume CS:PM_seg
; ==============================
; ========================= DATA
; ==============================

    GDT         label byte
                db 8 dup(0)

    GDT_flatDS  db 0FFh, 0FFh, 0, 0, 0, 10010010b, 11001111b, 0 ; PMode data
    GDT_16bitCS db 0FFh, 0FFh, 0, 0, 0, 10011010b, 0, 0         ; RMode code
    GDT_32bitCS db 0FFh, 0FFh, 0, 0, 0, 10011010b, 11001111b, 0 ; PMode code
    GDT_32bitSS db 0FFh, 0FFh, 0, 0, 0, 10010010b, 11001111b, 0 ; PMode stack
    GDT_TSS0    db 067h, 0, 0, 0, 0, 10001001b, 01000000b, 0    ; Start task
    GDT_TSS1    db 067h, 0, 0, 0, 0, 10001001b, 01000000b, 0
    GDT_TSS2    db 067h, 0, 0, 0, 0, 10001001b, 01000000b, 0

    GDT_l = $ - GDT
    gdtr        dw GDT_l - 1 ; 16bit limit of gdt
                dd ?         ; linear 32bit adress of gdt


    SEL_flatDS  equ 00001000b
    SEL_16bitCS equ 00010000b
    SEL_32bitCS equ 00011000b
    SEL_32bitSS equ 00100000b
    SEL_tss0    equ 00101000b
    SEL_tss1    equ 00110000b
    SEL_tss2    equ 00111000b

    EFLAGS dd 0

    TSS_0 dd 68h dup(0)
    TSS_1 dd 0, 0, 0, 0, 0, 0, 0, 0
          dd offset task_1
          ; Regular registry
          dd EFLAGS, 0, 0, 0, 0, stack_length_1, 0, 0, 0B8140h
          dd SEL_flatDS, SEL_32bitCS, SEL_32bitSS, SEL_32bitCS, 0, 0
          dd 0
          dd 0
    TSS_2 dd 0, 0, 0, 0, 0, 0, 0, 0
          dd offset task_2
          ; Regular registry
          dd EFLAGS, 0, 0, 0, 0, stack_length_1, 0, 0, 0B8140h
          dd SEL_flatDS, SEL_32bitCS, SEL_32bitSS, SEL_32bitCS, 0, 0
          dd 0
          dd 0

    ; ================================ OUTPUT
    null dd 0.0
    output dt 0.0
    temp dw 0
    output_len dw 0
    ten dd 10.0
    one dd 1.0
    negative_one dd -1.0
    empty_n_lines = 120
    steps dw 10
    ; ================================ OUTPUT

    two dd 2.0
    tempi dd 0.0
    trash dd 0.0

    pm_e db 'P', 2, 'r', 2, 'o', 2, 't', 2, 'e', 2, 'c', 2, 't', 2, 'e', 2, 'd', 2, ' ', 2, 'm', 2, 'o', 2, 'd', 2, 'e', 2, '.', 2
    pm_el dd 30

    pm_ex db 'P', 2, 'r', 2, 'o', 2, 't', 2, 'e', 2, 'c', 2, 't', 2, 'e', 2, 'd', 2, ' ', 2, 'm', 2, 'o', 2, 'd', 2, 'e', 2, ' ', 2, 'e', 2, 'x', 2, 'i', 2, 't', 2, '.', 2
    pm_exl dd 40

    pi_message db 'P', 7, 'i', 7, ' ', 7, '=', 7, ' ', 7
               db 100 dup(?)
    pi_message_l dd 10

    sum_message db 'S', 7, 'u', 7, 'm', 7, ' ', 7, '=', 7, ' ', 7
    sum_message_l dd 12

    text db 100 dup(?)
    text_l dd 0

    cur_n dd 0.0
    sum dd 0.0
    rest_scr  dd 0


add_new_symbol PROC
    mov eax, offset ds:text
    add eax, ds:text_l

    mov byte ptr [eax], dl
    inc eax
    mov byte ptr [eax], 7

    inc ds:text_l
    inc ds:text_l

    ret
add_new_symbol ENDP


OutputWriter PROC
    mov eax, 0
    mov ds:text_l, eax
    mov ds:output_len, ax

    fld ds:output
    fcom ds:null
    fstsw ax
    sahf
    jnc positive
        fmul ds:negative_one

        mov dl, '-'
        CALL add_new_symbol
    positive:

    fld ds:one
    fld st(1)
    fprem

    fxch st(1)
    fstp ds:one
    fxch st(1)
    fsub st(0), st(1)

    for2:
        fcom ds:null
        fstsw ax
        sahf
        jz end_good

        fld ds:ten
        fld st(1)
        fprem

        fsub st(2), st(0)
        fistp ds:temp
        mov ax, ds:temp
        push ax
        inc ds:output_len

        fdiv st(1), st(0)
        fistp ds:temp

        jmp for2
    end_good:

    fistp ds:temp
    mov cx, ds:output_len

    cmp cx, 0
    jz print_zero

    for3:
        pop dx
        add dl, '0'
        CALL add_new_symbol
    loop for3
    jmp last 

    print_zero:
        mov dl, '0'
        CALL add_new_symbol

    last:
        fcom ds:null
        fstsw ax
        sahf
        jz output_finish

        mov dl, '.'
        CALL add_new_symbol

        mov ds:output_len, 0

    for4:
        fcom ds:null
        fstsw ax
        sahf
        jz output_finish

        mov ax, ds:output_len
        cmp ax, 5
        jz output_finish

        fmul ds:ten
        fld ds:one
        fld st(1)
        fprem

        fxch st(2)
        fsub st(0), st(2)

        fistp ds:temp
        mov dx, ds:temp
        add dl, '0'
        CALL add_new_symbol

        fistp ds:temp
        inc ds:output_len
        jmp for4
    jmp for4


    output_finish:
        fistp ds:temp
        ret
OutputWriter ENDP


PiFunc PROC
    mov ecx, 3001
    mov ax, 0

    fld ds:null
    fld ds:negative_one

    pi_main_loop:
        cmp cx, 0
        jz ending_calculation

        fadd ds:two
        fld ds:two
        fadd ds:two
        fdiv st, st(1)

        test ax, 1
        jz positive_item
            fsub st(2), st
            xor ax, ax
            jmp next_pi_iteration

        positive_item:
            add ax, 1
            fadd st(2), st

        next_pi_iteration:
            fstp ds:trash
    loop pi_main_loop

    ending_calculation:
        fstp ds:trash
        ret
PiFunc ENDP


SummFunc PROC
    fld ds:cur_n
    fadd ds:one
    fst ds:cur_n

    fld ST(0)
    fmulp
    fadd ds:sum
    fstp ds:sum

    ret
SummFunc ENDP


print_first_n_empty_lines PROC
    mov edi, 0B8000h
    mov eax, 07200720h
    mov ecx, empty_n_lines
    rep stosd

    ret
print_first_n_empty_lines ENDP


clear_rested_screen PROC
    mov eax, 07200720h
    mov ecx, 1000
    rep stosd

    ret
clear_rested_screen ENDP


PM_entry:
    ; Prepare registry

    xor eax, eax
    mov ax, SEL_flatDS
    mov ds, ax
    mov es, ax
    mov ax, SEL_32bitSS
    mov ebx, stack_length_1
    mov ss, ax
    mov esp, ebx

    mov ax, SEL_TSS0
    ltr ax

    mov ebx,offset GDT + SEL_TSS0
    or  byte ptr [ ebx + 5 ], 10b

    db 0EAh
    dd 0
    dw SEL_TSS1


    task_1:
        mov ax, ds:steps
        cmp ax, 10
        jnz next
        mov edi, 0B8000h

        mov esi, offset ds:pm_e
        mov ecx, ds:pm_el
        rep movsb

        next:
        mov ax, ds:steps
        cmp ax, 0
        jz go_to_real_mode

        dec ds:steps

        CALL PiFunc
        fstp ds:output
        CALL OutputWriter

        mov esi, offset ds:pi_message
        mov ecx, ds:pi_message_l
        rep movsb

        mov esi, offset ds:text
        mov ecx, ds:text_l
        rep movsb

        mov cx, 80

        xor dx, dx
        mov eax, ds:pi_message_l
        mov bx, 2
        div bx
        sub cx, ax

        xor dx, dx
        mov eax, ds:text_l
        mov bx, 2
        div bx
        sub cx, ax
        mov ax, 0720h
        rep stosw 

        jmp task_2

            db 0EAh                 ; far jump command
            dd 0                    ; 32bit shift
            dw SEL_TSS2

    task_2:
        CALL SummFunc
        fld ds:sum
        fstp ds:output
        CALL OutputWriter

        mov esi, offset ds:sum_message
        mov ecx, ds:sum_message_l
        rep movsb

        mov esi, offset ds:text
        mov ecx, ds:text_l
        rep movsb

        mov cx, 80

        xor dx, dx
        mov eax, ds:sum_message_l
        mov bx, 2
        div bx
        sub cx, ax

        xor dx, dx
        mov eax, ds:text_l
        mov bx, 2
        div bx
        sub cx, ax
        mov ax, 0720h
        rep stosw 

        jmp task_1

    go_to_real_mode:
        mov ebx, 30
        sub edi, ebx
        mov esi, offset ds:pm_ex
        mov ecx, ds:pm_exl
        rep movsb

            db 0EAh                 ; far jump command
            dd offset RM_return     ; 32bit shift
            dw SEL_16bitCS

PM_seg ends


STACK_SEGMENT segment para stack "STACK"
    stack_task_0 db  100h dup(?)
    stack_length_0 = $ - stack_task_0
    stack_task_1 db  100h dup(?)
    stack_length_1 = $ - stack_task_1

STACK_SEGMENT ends

end start
