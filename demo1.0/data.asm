section .data
; ---------- messages ----------
	msg1 db "What is your name? ", 0
	msg2 db "How old are you now? ", 0
	msg3 db "How many years need to be added? ", 0
	MESSAGES dq msg1, msg2, msg3
    MESSAGES_count equ ($ - MESSAGES) / 8	; the number of the message
	
; ---------- constants ----------
	response			db		"The final age will be, ",0
	newline				db		10			; '\n' ascii code
	colon				db		58			; ':' ascii code
	BUFFERS dq buf_name, buf_old, buf_year
	size_string			equ		32			; buffer size
	ten					dq		10			; value 10 for multiplication
	size_age			equ		5			; string size
	size				equ	    1			; the length of each inputs
	azero				equ		0x30		; ASCII zero character, '0'
	anine				equ		0x39		; ASCII nine character, '9'
	nullchar			equ		0x0			; null character (terminating)
	STDIN				equ		0			; standard input device
	STDOUT				equ		1			; standard output device
	SYS_read			equ		0			; system call to read input
	SYS_write			equ		1			; system call to write message
	SYS_exit			equ		60			; system call to terminate program
	EXIT_OK				equ		0			; OK exit status
; uninitialized data	
section .bss
	buf_name	resb	size_string		; string input_name buffer
	buf_old		resb	size_string		; string input_old buffer
	buf_year	resb	size_string		; string input_add_value buffer
	BUF_LENS 	resq 3    				; 3 * 64-bit length，inital 0
	buf_result	resb 	size_string		; string output value
    ; ---------- exports ----------
global msg1, msg2, msg3
global MESSAGES, MESSAGES_count
global response, newline, colon
global size_string, ten
global azero, anine, nullchar
global STDIN, STDOUT, SYS_read, SYS_write, SYS_exit, EXIT_OK
global buf_name, buf_old, buf_year, BUFFERS, BUF_LENS, buf_result
