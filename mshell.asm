lenar macro cad, lendir
local cic1
        pusha
        mov bx, 0h
 cic1:  
 		mov dl, cad[bx]
        inc bx
        cmp dl, '-'
        jne cic1
        dec bx
		mov lendir, bx
        popa
endm

;sepcom es una macro que recibe dos cadenas y un registro de longitud de nombre len (este último se podría)
; (omitir puesto que realmente no tiene tanta importancia ya que el resultado se guarda en una variable)
;para separar el comando de los argumentos. cad es la cadena leída que incluye juntos el comando y sus 
;argumentos, se busca el factor de separación que es 0D o 20, es decir '\n' o ' '. para luego copiar
;el comando en una variable previamente definida y posteriormente copiará los argumentos
sepcom 	macro cad, com, instr
local 	cic1, sep_sal, copy
        pusha
        mov bx, 0h

 cic1:  
 		mov dl, cad[bx]
        inc bx
        cmp dl, ' '
		je sep_sal
		cmp dl, 0DH
		je sep_sal
		jmp cic1
 sep_sal:	

 		mov cx, bx
		dec cx
		mov lencomando, bx
		mov bx, 0h
		cld

		cmp cx, 0
		jg copy
		
		inc cx
		
 copy:	
		mov si, offset cad
		mov di, offset com
		rep movsb

		mov dx, lencomando
		mov cx, lendir
		sub cx, dx	
		cld
		mov si, offset cad
		add si, lencomando
		mov di, offset instr
		rep movsb
		
		mov bx, lendir
		mov cx, lencomando
		sub bx, cx
		dec bx
		mov instr[bx], 0h


        popa
endm



clean_arr macro cadena, tam, reinicio
local cic_cle
		cld
		mov di, offset cadena
		mov cx, tam
		mov ax, reinicio

 cic_cle:
		stosb
		loop cic_cle

endm
