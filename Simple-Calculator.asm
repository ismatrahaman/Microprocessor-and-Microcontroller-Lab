; Simple Calculator (+ - * /)
org 100h

.data
m1 db 0Dh,0Ah,'Enter first number: $'
m2 db 0Dh,0Ah,'Enter second number: $'
m3 db 0Dh,0Ah,'Choose (+,-,*,/): $'
m4 db 0Dh,0Ah,'Result: $'
m5 db 0Dh,0Ah,'Remainder: $'
m6 db 0Dh,0Ah,'Error: Division by zero!$'

a dw ? 
b dw ? 
r dw ? 
rem dw ? 
op db ?

.code
start:
    mov ax,@data
    mov ds,ax

    lea dx,m1       ; input a
    mov ah,9
    int 21h
    call read_num
    mov a,ax

    lea dx,m2       ; input b
    mov ah,9
    int 21h
    call read_num
    mov b,ax

    lea dx,m3       ; input op
    mov ah,9
    int 21h
    mov ah,1
    int 21h
    mov op,al

    mov ax,a        ; calc
    mov bx,b
    cmp op,'+'
    je LADD
    cmp op,'-'
    je LSUB
    cmp op,'*'
    je LMUL
    cmp op,'/'
    je LDIV
    jmp DONE

LADD: add ax,bx
      jmp STORE
LSUB: sub ax,bx
      jmp STORE
LMUL: imul bx
      jmp STORE
LDIV: cmp bx,0
      je DIVZERO
      cwd
      idiv bx
      mov rem,dx
      jmp STORE

DIVZERO:
    lea dx,m6
    mov ah,9
    int 21h
    jmp DONE

STORE:
    mov r,ax
    lea dx,m4       ; print result
    mov ah,9
    int 21h
    mov ax,r
    call print_num

    cmp op,'/'      ; print remainder
    jne DONE
    lea dx,m5
    mov ah,9
    int 21h
    mov ax,rem
    call print_num

DONE:
    mov ah,4Ch
    int 21h

; ----- read_num -----
read_num proc
    mov bx,0
.read:
    mov ah,1
    int 21h
    cmp al,13
    je .end
    cmp al,'0'
    jb .read
    cmp al,'9'
    ja .read
    sub al,'0'
    mov ah,0
    mov si,ax
    mov ax,bx
    mov cx,10
    mul cx
    add ax,si
    mov bx,ax
    jmp .read
.end:
    mov ax,bx
    ret
read_num endp

; ----- print_num -----
print_num proc
    cmp ax,0
    jne .nz
    mov dl,'0'
    mov ah,2
    int 21h
    ret
.nz:
    push bx
    push cx
    mov cx,0
    mov bx,10
.loop1:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne .loop1
.loop2:
    pop dx
    add dl,'0'
    mov ah,2
    int 21h
    loop .loop2
    pop cx
    pop bx
    ret
print_num endp

end start