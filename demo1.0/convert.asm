global string2integer
global integer2string

extern ten
extern azero, anine, nullchar

;--------;
; Function------ Translate string input from string buffer using register rsi into binary value saved in the register rax
; buffer context['1','2','3'] 
; loop '1':
;	rax=0,
;	r13=1,
;	rax=mulqword [10]*rax=0*10=0
;	rax=rax+r13=0+1=1
; loop '2':
;	rax=1,
;	r13=2,
;	rax=mulqword [10]*rax=1*10=10
;	rax=rax+r13=10+2=12
; loop '3':
;	rax=12,
;	r13=3,
;	rax=mulqword [10]*rax=12*10=120
;	rax=rax+r13=120+3=123
string2integer:
	mov		rax, 0					; initialize value
	xor		r13,r13
	or		r13,r13
d2b0:

	mov		r13, 0					; initialize rbx
	mov		bl, byte [rsi]			; character, digit

; filter out non-digit values
	cmp		bl, azero
	jl		d2b_exit				; exit on character < '0'
	cmp		bl, anine
	jg		d2b_exit				; exit on character > '9'
	sub		bl, azero				; convert from ASCII to binary
	movzx   	r13, bl 
	mul		qword [ten]				; multiply rax by 10
	add		rax, r13				; add new value
	inc		rsi						; next char
	cmp		byte [rsi], nullchar	; end of string?
	jnz		d2b0					; if not, keep looping
d2b_exit:	
	ret



;--------;
; Function------ generate a string at rsi representing the value in rbx,using div 10 to save remainder first, then need to reverse the order
;	
integer2string:
	mov rdi, rsi        ; save the start point of buffer (start)
.loop:
	xor		rdx, rdx
	mov		rax, rbx				; rdx:rax=0:N
	mov		rcx, 10
	div		rcx						; rdx:rax/rbx------> rax(Quotient) rdx=remainder
	add 	dl, '0'					; 0000 0011 ------> 0011 0011
	mov		[rsi],dl				; to save the output_buffer as char
	inc		rsi
	mov		rbx,rax
	test	rax,rax
	jnz		.loop

    lea rdx, [rsi - 1]  ; right = end - 1
    mov rcx, rdi        ; left  = start

.reverse_loop:						;swap leftmost ↔ rightmost using register rax and rbx 
    cmp rcx, rdx
    jge .done_reverse

    mov al, [rcx]					;must using two registers becasue 'mov [] []' is illegal
    mov bl, [rdx]
    mov [rcx], bl
    mov [rdx], al

    inc rcx
    dec rdx
    jmp .reverse_loop

.done_reverse:
    mov byte [rsi], 0   ; 
    ret