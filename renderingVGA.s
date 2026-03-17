
%define VGA_TerminalBuffer 0xb8000
%define VGA_TerminalSizeX 80
%define VGA_TerminalSizeY 25
%define VGA_TerminalArea (VGA_TerminalSizeX*VGA_TerminalSizeY)
%define VGA_TerminalBufferSize (VGA_TerminalArea*2)
%define VGA_TerminalEndBuffer (0xb8000+VGA_TerminalBufferSize)
%define VGA_ColorWhiteOnBlack 15


; use bx as input
; modifies ax
; %macro setCursorPos 0
setCursorPos:
    mov dx, 0x03D4
    mov al, 0x0F
    out dx, al

    mov dx, 0x03D5
    mov al, bl
    out dx, al

    mov dx, 0x03D4
    mov al, 0x0E
    out dx, al

    mov dx, 0x03D5
    mov al, bh
    out dx, al
    ret
; %endmacro


; uses al
; modifiy edi
putChar:

    cmp al,13
    jnz .returnLine
        call endLineOS
        ret
    .returnLine:
        mov dword edi,[cursorPos]
        add edi,edi
        add edi,VGA_TerminalBuffer

        mov [edi],al

        inc dword [cursorPos]
        mov edi,[cursorPos]
        cmp edi,VGA_TerminalArea
        jl .scroll 
            call scrollScreenOS
        .scroll:
        
    ret

; esi as string and ecx as size
; modifies edi,esi,al,edx and ecx
printStringOS:
    .next:
        test ecx,ecx
        jz .done
        mov al,[ecx]
        call putChar

        inc esi
        dec ecx
        jmp .next
    .done:
        call setCursorPos
        ret

; esi as string
; modifies esi,edi and al
printC_StringOS:
    mov dword edi,[cursorPos]
    add edi,edi
    add edi,VGA_TerminalBuffer

    .next:
        mov al,[esi]
        test al,al
        jz .done

        call putChar

        inc esi
        jmp .next
    .done:
        mov ebx,[cursorPos]
        call setCursorPos
        ret


; modifies ecx,eax,edx and bx
endLineOS:
    mov eax,[cursorPos]
    xor edx,edx
    mov ecx,VGA_TerminalSizeX
    div ecx              ; eax=cursorPos/80

    inc eax              ; next line
    mul ecx              ; eax=eax*80

    mov [cursorPos],eax

    cmp eax,VGA_TerminalArea
    jl .scroll 
        call scrollScreenOS
    .scroll:

    mov bx,ax
    call setCursorPos
    ret


; modifies eax, edi and ecx
clearScreenOS:
    mov eax,0x0f200f20          ; 2x ' ' + white on black
    mov edi,VGA_TerminalBuffer
    mov ecx,VGA_TerminalArea/2
    rep stosd

    xor ebx,ebx
    mov [cursorPos],ebx
    call setCursorPos
    ret



scrollScreenOS:
    mov edi,VGA_TerminalBuffer
    mov esi,VGA_TerminalBuffer+VGA_TerminalSizeX*2
    mov ecx,(VGA_TerminalArea-VGA_TerminalSizeX)/2
    rep movsd

    mov eax,0x0f200f20
    mov edi,VGA_TerminalEndBuffer-VGA_TerminalSizeX*2
    mov ecx,VGA_TerminalSizeX*2
    rep stosd


    mov ebx,[cursorPos]
    sub ebx,VGA_TerminalSizeX
    mov [cursorPos],ebx
    call setCursorPos

    ret

