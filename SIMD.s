
; In EDX
%define SSE_Available      (1<<25)
%define SSE2_Available     (1<<26)
; In ECX
%define SSE3_Available     (1<<0)
%define SSSE3_Available    (1<<9)
%define SSE4v1_Available   (1<<19)
%define SSE4v2_Available   (1<<20)

activateSSE:
    
    ret

activateAVX:

    ret
