print	macro cadena
local dbcad,dbfin,salta
	pusha			;respalda todo
	push ds			;respalda DS, porque vamos a usar segmento de c�digo
	mov dx,cs		;segmento de c�digo ser� tambi�n de datos
	mov ds,dx
	
	mov dx,offset dbcad	;direcci�n de cadena (en segmento de c�digo)
	mov ah,09h
	int 21h			;desplegar
	jmp salta		;saltar datos para que no sean ejecutados
	dbcad db cadena		;aqu� estar� la cadena pasada en la sustituci�n
	dbfin db 24h		;fin de cadena
salta:	pop ds			;etiqueta local de salto, recuperar segmento de datos
	popa			;recuperar registros
endm

printat macro x, y, attrib, sdat
LOCAL   s_dcl, skip_dcl, s_dcl_end
    pusha
    mov dx, cs
    mov es, dx
    mov ah, 13h
    mov al, 1
    mov bh, 0
    mov bl, attrib
    mov cx, offset s_dcl_end - offset s_dcl
    mov dl, x
    mov dh, y
    mov bp, offset s_dcl
    int 10h                 ;Interrupción de bios
    
    mov dx,ds
    mov es,dx
    popa
    jmp skip_dcl
    s_dcl DB sdat
    s_dcl_end DB 0
 skip_dcl:
endm

fopen  macro dir, nombre, type
local  error, sal1
       mov ah, 3Ch
       mov cx, 0
       mov dx, offset nombre
       int 21h
       jc error
       mov dir, ax
       jmp sal1
 error:mov dx, ax
       call des4
       .exit 1
 sal1: 
endm

fwrite  macro dir, dato, tam
 local error, sal1
       mov ah, 40h
       mov bx, dir
       mov cx, tam
       mov dx, offset dato
       int 21h
       jc error
       jmp sal1
 
  error:mov dx, ax
       call des4
       .exit 1
 sal1: 
endm

fclose macro dir
local error, sal1
      mov ah, 3Eh
       mov bx, dir
       int 21h
       jc error
       jmp sal1
 error:mov dx, ax
       call des4
       .exit 1
 sal1: 
endm