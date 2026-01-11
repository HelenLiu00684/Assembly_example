extern print_strz
extern newline_out
extern colon_out
extern readline

extern string2integer
extern integer2string

extern MESSAGES, MESSAGES_count
extern BUFFERS, BUF_LENS
extern buf_result, size_string

extern SYS_exit, EXIT_OK


section	.text
	global _start
_start:

   	mov     rbx, 0						; The index of table is from 0
	mov     r12, MESSAGES_count 
repeat:                 				 
	mov     rsi, [MESSAGES + rbx*8]
	call    print_strz
	call	newline_out					;add a newline
	mov		rsi, [BUFFERS + rbx*8]		; read input to buffer at r13
	mov 	rdx, size_string			; set the length of input
	call	readline					;invoke three read buffer to save name,age,years.When check the ACSII 10 jump out
	mov 	[BUF_LENS + rbx*8], rax	
	mov		rsi, [BUFFERS + rbx*8]		; read input to buffer at rbx,reset the rbx is the begin pointer of the address
	call	print_strz
	call	newline_out	
    add     rbx,1
	dec     r12
    jnz	repeat						; Here change to r12-r15 rbx,rbp(private);rax,rcx,rdx,rdi,rsi,r8-r11(systematic)	

; convert string into age and year, separated saved in r14 and r13 as the counter
	xor 	r13,r13					;clear r13 as a counter
	or		r13,1

	xor 	r14,r14					;clear r14 as a year
	or		r14,0

repeatcal:	
	mov		rsi, [BUFFERS + r13*8]		; read input to buffer at r13
	push	r13
	call	string2integer			; convert string to integer
	pop		r13
	cmp		rax, 0					; test to see if junk input
	jle		exit					; if it is not digital then quit
	add		r14,rax
	mov 	rcx,r14					; save result to rcx
	inc		r13						; the first time take the age and the second time take the year
; assign input value and loop
	cmp		r13,2				; repeat this many times,default only loop 2 times.
	jle		repeatcal


repeat2string:
; convert the value in rbx to a string	
	mov		rbx, rcx				; 
	mov		rsi, buf_result
	call	integer2string			; convert rbx into decimal and save the string to the register rsi
; output the string	
	mov rsi, [BUFFERS]
	call	print_strz	
	call	colon_out			; output buffer
	mov		rsi, buf_result
	call	print_strz				; output buffer
	call	newline_out					;add a newline
exit:									
    mov		rax, SYS_exit				; exit program
	mov		rdi, EXIT_OK
	syscall