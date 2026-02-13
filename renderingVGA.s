; string arg in eax and use edi and bl
printStringOS:
    mov edi,0xb8000
    
    .next:

    mov bl,[eax]            ; Load the character
    cmp bl,0                ;Check for '\0'
    je .done

    mov byte [edi],   bl    ; load on the screen the character
    mov byte [edi+1], 15

    add edi,2               ; go to next character
    inc eax
    jmp .next

    .done:
        ret

clearScreenOS:

    xor edi,edi
    .next:
        mov byte [edi+0xb8000],    0x20
        mov byte [edi+1+0xb8000], 0x0f

        add edi,2
        cmp edi,4000
    jl .next

    ret