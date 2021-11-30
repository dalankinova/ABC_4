section .text

ProcSwap:
    push rax
    push rbx 
    push rcx
    push rdx
    
    mov rax,r14 ; r14 - index 1
    mul r11
    mov r14,rax
    
    mov rax,r15 ; r15 - index 2
    mul r11
    mov r15,rax
    
    ; pos1 -> tmp
    mov rsi,r10    
    add rsi,r14 
    mov rdi,r12
    mov rcx,r11
    rep movsb 

    ; pos2 -> pos1
    mov rsi,r10
    add rsi,r15
    mov rdi,r10
    add rdi,r14
    mov rcx,r11
    rep movsb 

    ; tmp -> pos2
    mov rsi,r12
    mov rdi,r10
    add rdi,r15
    mov rcx,r11
    rep movsb 

    pop rdx
    pop rcx
    pop rbx
    pop rax    
    ret

calcSquareVirtual:    
    push rsi
    push rax
    
    mov rax,rcx ; rcx - index
    mul r11
    mov rsi,r10
    add rsi,rax    
    %ifdef USEWINDOWS
    mov rcx,rsi        
    %else
    mov rdi,rsi
    %endif
    add rsi,28    
    lodsd
        
    cmp eax,0
    je scircle
    cmp eax,1
    je srect
    call calcSquareTriangleS
    jmp sfin
scircle:    
    call calcSquareCircleS
    jmp sfin
srect:    
    call calcSquareRectS
    
sfin:    
    pop rax
    pop rsi    
    ret

    global ProcSort:function
ProcSort:
    push rsi
    push rdi

    %ifdef USEWINDOWS
    mov r10,rcx ; r10-array start
    mov r11,rdx ; r11-record size 
    %else
    mov r10,rdi ; r10-array start
    mov r11,rsi ; r11-record size 
    %endif
    
    %ifndef USEWINDOWS ; r8 - count in array
    mov r8,rdx
    %endif    
    
    mov r12,rsp ; r12-buf in stack
    sub r12,r11    
    sub rsp,r11 ; inc stack    
                    
mainloop:    
    mov r9,0
    mov rax,0
    mov rbx,r8
    dec rbx
forward:    
    mov r14,rax
    mov rcx,r14
    call calcSquareVirtual
    movss xmm9,xmm0
    
    mov r15,rax
    inc r15        
    mov rcx,r15
    call calcSquareVirtual
   
    cmpss xmm9,xmm0,6
    movmskps edx,xmm9
    cmp edx,0
    je noswap 
    call ProcSwap
    mov r9,1
noswap:    
    inc rax
    cmp rax,rbx
    jl forward 
        
    cmp r9,1
    je mainloop
        
    add rsp,r11
    pop rdi
    pop rsi    
    ret

    global calcSquareCircleS:function
calcSquareCircleS:
    push rsi
    
    %ifdef USEWINDOWS
    mov rsi,rcx
    %else
    mov rsi,rdi
    %endif

    lodsd 
    lodsd 
    lodsd 
    cvtsi2ss xmm0, eax 
    mov eax,__float32__(3.14159)
    movd xmm1,eax
    mulss xmm0, xmm0
    mulss xmm0, xmm1
        
    pop rsi
    ret

    global calcSquareRectS:function
calcSquareRectS:
    push rsi
    
    %ifdef USEWINDOWS
    mov rsi,rcx
    %else
    mov rsi,rdi
    %endif

    lodsd 
    cvtsi2ss xmm3, eax ; arg 0 - x1
    lodsd
    cvtsi2ss xmm2, eax ; arg 1 - y1
    lodsd
    cvtsi2ss xmm1, eax ; arg 2 - x2
    lodsd
    cvtsi2ss xmm0, eax ; arg 2 - y2
    subss xmm1,xmm3 ; x2 - x1
    subss xmm0,xmm2 ; y2 - y1
    mulss xmm0,xmm1 ; 
    mov eax,__float32__(0.0) ; abs = max(-xmm0,xmm0) 
    movd xmm1,eax
    subss xmm1,xmm0
    maxss xmm0,xmm1    

    pop rsi
    ret

    global calcSquareTriangleS:function
calcSquareTriangleS:
    push rsi

    %ifdef USEWINDOWS
    mov rsi,rcx
    %else
    mov rsi,rdi
    %endif

    lodsd 
    cvtsi2ss xmm7, eax ; arg 0 - x1
    lodsd
    cvtsi2ss xmm6, eax ; arg 1 - y1
    lodsd
    cvtsi2ss xmm5, eax ; arg 2 - x2
    lodsd
    cvtsi2ss xmm4, eax ; arg 2 - y2
    subss xmm7,xmm5
    mulss xmm7,xmm7
    subss xmm6,xmm4
    mulss xmm6,xmm6
    addss xmm7,xmm6
    sqrtss xmm1,xmm7 ; a
	
    %ifdef USEWINDOWS
    mov rsi,rcx
    %else
    mov rsi,rdi
    %endif

    lodsd 
    cvtsi2ss xmm7, eax ; arg 0 - x1
    lodsd
    cvtsi2ss xmm6, eax ; arg 1 - y1
    lodsd
    lodsd
    lodsd
    cvtsi2ss xmm5, eax ; arg 2 - x3
    lodsd
    cvtsi2ss xmm4, eax ; arg 2 - y3
    subss xmm7,xmm5
    mulss xmm7,xmm7
    subss xmm6,xmm4
    mulss xmm6,xmm6
    addss xmm7,xmm6
    sqrtss xmm2,xmm7 ; b
    
    %ifdef USEWINDOWS
    mov rsi,rcx
    %else
    mov rsi,rdi
    %endif

    lodsd
    lodsd    
    lodsd 
    cvtsi2ss xmm7, eax ; arg 0 - x2
    lodsd
    cvtsi2ss xmm6, eax ; arg 1 - y2
    lodsd
    cvtsi2ss xmm5, eax ; arg 2 - x3
    lodsd
    cvtsi2ss xmm4, eax ; arg 2 - y3
    subss xmm7,xmm5
    mulss xmm7,xmm7
    subss xmm6,xmm4
    mulss xmm6,xmm6
    addss xmm7,xmm6
    
    sqrtss xmm3,xmm7 ; c
	
    movss xmm4,xmm1
    addss xmm4,xmm2
    addss xmm4,xmm3
    mov eax,__float32__(2.0)
    movd xmm0,eax
    divss xmm4,xmm0 ; p
	
    movss xmm0,xmm4
    movss xmm5,xmm4
    subss xmm5,xmm1 ; p-a
    mulss xmm0,xmm5
    movss xmm5,xmm4
    subss xmm5,xmm2 ; p-b
    mulss xmm0,xmm5
    movss xmm5,xmm4
    subss xmm5,xmm3 ; p-c
    mulss xmm0,xmm5
    sqrtss xmm0,xmm0
	
    pop rsi	
    ret
