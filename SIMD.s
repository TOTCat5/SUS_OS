
; In EDX
%define SSE_Available       0x2000000
%define SSE2_Available      0x4000000
; In ECX
%define SSE3_Available      0x0000001
%define SSSE3_Available     0x0000200
%define SSE4v1_Available    0x0080000
%define SSE4v2_Available    0x0100000


activateSSE:
    
    ret

activateAVX:

    ret
