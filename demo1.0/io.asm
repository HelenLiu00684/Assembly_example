section .text
global print_strz
global newline_out
global colon_out
global readline

extern SYS_write, SYS_read
extern STDIN, STDOUT
extern newline, colon


print_strz:
	cmp		byte [rsi], 0			; end-of-string test
	je		print_strz_exit			; bail on null char
	mov		rdx, 1					; number of characters to write
	mov		rdi, STDOUT				; to standard output
	mov		rax, SYS_write			; Write characters(s)
	syscall
	inc		rsi						; next character
	jmp		print_strz				; keep looping

print_strz_exit:
	ret

;--------;
; Function------outupt a '\n'
newline_out:
	mov		rsi, newline			; /n char's location
	mov		rdx, 1					; size to write
	mov		rax, SYS_write			; write character
	mov		rdi, STDOUT				; to standard output
	syscall
	ret
;--------;
; Function------outupt a ':'
colon_out:
	mov		rsi, colon			; /n char's location
	mov		rdx, 1					; size to write
	mov		rax, SYS_write			; write character
	mov		rdi, STDOUT				; to standard output
	syscall
	ret
;--------;
; Function------Grab standard input in the buffer
; 				rsi=input buffer pointer 
; 				rdx=the max_size of the buffer
; 				r12:source buffer pointer, r8:current length
; 				syscall 'read' return rax:output length
;						> 0  : actually character
;						= 0  : EOF
;						< 0  : error
readline:
    	push 		r12
    	push 		r9
	xor		r8,	r8					; len r8 = 0
	mov		r12, rsi				; buffer[i] pointer
	mov     	r9,rdx-1					; the length of max-1 save to r9, becasue the last character is '\0'
read_loop:
	mov		rsi, r12				; soure buffer pointer
	mov		rdx, 1					; character count
	mov		rdi, STDIN				; from standard input
	mov		rax, SYS_read			; read into rsi (rbx)
	syscall

	test    rax, rax				; if (bytes_read <= 0) break;
    jle     .done        ; EOF / error

    cmp     byte [r12], 10   ; if the last position is '\n' then change to '0' line 174
    je      .done

    inc     r12
    inc     r8
    cmp     r8, r9
    jl      read_loop
.done:
    mov     byte [r12], 0    ; null-terminate
    mov     rax, r8          ; return len
	pop 	r9
    pop 	r12
    ret    