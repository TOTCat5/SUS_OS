
; In EDX
%define SSE_Available      (1<<25)
%define SSE2_Available     (1<<26)
; In ECX
%define SSE3_Available     (1<<0)
%define SSSE3_Available    (1<<9)
%define SSE4v1_Available   (1<<19)
%define SSE4v2_Available   (1<<20)

activateSSE:
    mov eax,cr0
    and ax,0xFFFB		; clear coprocessor emulation  CR0.EM
    or ax,0x2			; set   coprocessor monitoring CR0.MP
    mov cr0,eax
    mov eax,cr4
    or ax,3<<9		    ; set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
    mov cr4,eax
    ret

activateAVX:

    ret
