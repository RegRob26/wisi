    mov al, 1
	mov bh, 0
	mov bl, 00001111b
	mov cx, msg1end - offset msg1 ; calculate message size. 
	mov dl, 0
	mov dh, 0
	push cs
	pop es
	mov bp, offset msg1
	mov ah, 13h
	int 10h
	jmp msg1end
	msg1 db " hello, world! "
	msg1end:



        ; mov ch, 32
        ; mov ah, 1
        ; int 10h

        ; mov ch, 6
        ; mov cl, 7
        ; mov ah, 1
        ; int 10h

        ; mov dh, 10    Estas líneas hacen 
	; mov dl, 20    set cursor position
	; mov bh, 0     
	; mov ah, 2
	; int 10h



	        mov ah, 0Ah
        mov al, 'R'
        mov bh, 00h
        mov bl, 00001111b
        mov cx, 1
        int 10h