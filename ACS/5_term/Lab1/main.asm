.386p

RM_seg segment para public "code" use16
    assume CS:RM_seg, SS:RM_stack

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
    push cs
    push ds

    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h


    CALL open_a20

    ; Calculate linear adress of PM_entry
    xor eax, eax
    mov ax, PM_seg
    shl eax, 4
    add eax, offset PM_entry
    mov dword ptr pm_entry_off, eax


    ; Calculate base for global_descriptor_table_16bit_code_segment
    ; and for global_descriptor_table_16bit_data_segment
    xor eax, eax
    mov ax, cs
    shl eax, 4
    push eax
    mov word ptr GDT_16bitCS+2, ax
    mov word ptr GDT_16bitDS+2, ax
    shr eax, 16
    mov byte ptr GDT_16bitCS+4, al
    mov byte ptr GDT_16bitDS+4, al

    ; Calculate global_descriptor_table absolute adress
    ; top of stack is linear adress of RM_seg
    pop eax
    add ax, offset GDT
    mov dword ptr gdtr+2, eax

    ; Load global descriptor table
    lgdt fword ptr gdtr

    CALL forbit_interrupts
    CALL enable_protected_mode

    ; load new selector in cs registry
                    db 66h
                    db 0EAH     ; far jump command
    pm_entry_off    dd ?
                    dw SEL_flatCS ; selector


    RM_return:
        CALL enable_realtime_mode
        CALL allow_interrupts

    mov ah, 4Ch
    int 21h

    ; ==============================
    ; ========================= DATA
    ; ==============================
    GDT         label byte
                db 8 dup(0)
    GDT_flatCS  db 0FFh, 0FFh, 0, 0, 0, 10011010b, 11001111b, 0 ; PMode code selector
    GDT_flatDS  db 0FFh, 0FFh, 0, 0, 0, 10010010b, 11001111b, 0 ; PMode data selector
    GDT_16bitCS db 0FFh, 0FFh, 0, 0, 0, 10011010b, 0, 0         ; RMode code selector
    GDT_16bitDS db 0FFh, 0FFh, 0, 0, 0, 10010010b, 0, 0         ; RMode data selector

    GDT_l = $ - GDT
    gdtr        dw GDT_l - 1 ; 16bit limit of gdt
                dd ?         ; linear 32bit adress of gdt


    SEL_flatCS equ 00001000b
    SEL_flatDS equ 00010000b
    SEL_16bitCS equ 00011000b
    SEL_16bitDS equ 00100000b

    ; ================================ OUTPUT
    null dd 0.0
    output dt 0.0
    temp dw 0
    output_len dw 0
    ten dd 10.0
    one dd 1.0
    negative_one dd -1.0
    empty_n_lines = 120
    ; ================================ OUTPUT

    two dd 2.0
    tempi dd 0.0
    trash dd 0.0

    message db 'P', 7, 'i', 7, ' ', 7, '=', 7, ' ', 7
            db 100 dup(?)
    message_l dd 10
    rest_scr  dd 0
RM_seg ends


PM_seg segment para public "CODE" use32
    assume cs:PM_seg

load_segment_registry PROC

    mov ax, SEL_16bitDS
    mov ds, ax
    mov ax, SEL_flatDS
    mov es, ax


    ret
load_segment_registry ENDP


add_new_symbol PROC
    mov eax, offset ds:message
    add eax, ds:message_l

    mov byte ptr [eax], dl
    inc eax
    mov byte ptr [eax], 7

    inc ds:message_l
    inc ds:message_l

    ret
add_new_symbol ENDP


OutputWriter PROC
    mov ax, 0
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
        CALL load_segment_registry

        CALL PiFunc
        fstp ds:output
        CALL OutputWriter

        CALL print_first_n_empty_lines
        mov        esi,offset message      ; DS:ESI - сообщение
        mov        ecx, ds:message_l           ; ECX - длина
        rep        movsb                   ; вывод на экран
        CALL clear_rested_screen


    ; load selectors and jump back
            db 0EAh                 ; far jump command
            dd offset RM_return     ; 32bit shift
            dw SEL_16bitCS

PM_seg ends


RM_stack segment para stack "STACK" use16
    db 100h dup(?)
RM_stack ends

end start
