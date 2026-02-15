
%define VGA_TerminalBuffer 0xb8000
%define VGA_TerminalSizeX 80
%define VGA_TerminalSizeY 25
%define VGA_TerminalArea 2000
%define VGA_TerminalBufferSize 4000
%define VGA_ColorWhiteOnBlack 15

; string arg in eax
; modifies eax,edx and bx
printC_StringOS:
    movzx edx, word [cursorPos]
    shl edx,1
    add edx,VGA_TerminalBuffer

    mov bh,VGA_ColorWhiteOnBlack

    .next:
    mov bl,[eax]                                    ; Load the character
    cmp bl,0                                        ; Check for '\0'
    je .done

    mov word [edx],bx                               ; load on the screen the character

    add edx,2                                       ; go to next character
    inc word [cursorPos]
    inc eax
    jmp .next

    .done:
        mov bx,[cursorPos]
        call setCursorPos
        ret

; take eax as the string and ebx as its size in characters
; modify cx,edx,eax and ebx
printStringOS:
    movzx edx, word[cursorPos]
    shl edx,1
    add edx,VGA_TerminalBuffer
    shl ebx,1
    add ebx,VGA_TerminalBuffer      ; Transform size into pointer

    mov ch,VGA_ColorWhiteOnBlack

    .next:
    test ecx,ecx                    ; check if reached end pointer
    jz .done

    mov cl,[eax]                    ; get character
    mov word [edx],cx

    add edx,2                       ; increment stuff
    inc eax
    inc word [cursorPos]
    dec ecx
    jmp .next

    .done:
        mov bx,[cursorPos]
        mov bx,[cursorPos]
        call setCursorPos
        ret


; modifies eax, edi and ecx
clearScreenOS:
    mov ax,0x0f20              ; ' ' + white on black
    mov edi,VGA_TerminalBuffer
    mov ecx,VGA_TerminalArea
    rep stosw

    mov word [cursorPos], 0
    ret



; use bx as input
; modifies ax
setCursorPos:
    mov dx, 0x03d4
	mov al, 0x0f
	out dx, al

	inc dl
	mov al, bl
	out dx, al

	dec dl
	mov al, 0x0E
	out dx, al

	inc dl
	mov al, bh
	out dx, al
    ret
