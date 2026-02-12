[org 0x7C00]
[BITS 16]

start:

    mov si,hello
    call printStringReal

    mov ah, 0x02        ; BIOS read sectors
    mov al, 16          ; number of sectors
    mov ch, 0           ; cylinder
    mov cl, 2           ; sector 2 onwards
    mov dh, 0           ; head
    mov dl, 0x80        ; boot drive
    mov bx, 0x0000      ; offset
    mov es, 0x1000      ; segment → physical 0x10000
    int 0x13
    jc disk_error       ; optional: jump if error

    gdt_start:

    gdt_code:
        dw 0xffff
        dw 0x0
        db 0x0
        db 10011010b ; i hope you can now see i have no idea of wtf im doing
        db 11001111b
        db 0x0

    gdt_data:
        dw 0xffff
        dw 0x0
        db 0x0
        db 10010010b ; still coping code here
        db 11001111b
        db 0x0

    gdt_end:

    gdt_descriptor:
        dw gdt_end-gdt_start-1
        dd gdt_start

    cli
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax,1
    mov cr0,eax

    mov ax,0x10
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov esp,0x90000  ; setup stack

    jmp 0x08:OS_Begin

    ; jmp OS_Beginning

hello: db "Please Wait,The OS is Loading...",10,13,0

; loadingThing: db 13,"-",0
; loadingThingsPreloaded: db "\|/-\|/-"



; all the real mode functions are defined


disk_error:
    hlt
printStringReal:
    lodsb         ; load byte at DS:SI into AL
    cmp al,0
    je endPrintStringRealFunction
    mov ah,0x0e   ; BIOS teletype
    int 0x10
    jmp printStringReal
    endPrintStringRealFunction:

ret
    ;End Of The Real Mode Stuff
    times 510-($-$$) db 0
    dw 0xaa55

; Go to actual 32 bit code
    times 0x1000-($-$$) db 0

[BITS 32]
OS_Begin:
    


    hang:
        jmp hang

