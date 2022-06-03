.MODEL SMALL
.386
.STACK
.DATA

DTA db 21 dup(0)
attr db 0
time dw 0
date dw 0
sizel dw 0
sizeh dw 0
fname db 13 dup(0)


BIEN db "root> $"
ndir db 164 dup('"')
lendir dw ?

renglon db ?


.CODE
lenar macro cad, len
local cic1
        pusha
        mov bx, 0h
 cic1:  mov dl, cad[bx]
        inc bx
        cmp dl, '"'
        jne cic1
        dec bx
		mov len, bx
		mov lendir, bx

        popa

endm

main:   mov ax, @data
        mov es, ax
        mov ds, ax

		mov ah,1Ah
        mov dx,offset DTA
        int 21h
        mov bx, 0

 		;leer configuración de pantalla y guardarla en la pila
		mov ah,0fh
		int 10h
		push ax

		;definir pantalla 640x480, 16 colores
		mov ah,0
		mov al,03h
		int 10h
		mov renglon, 0
		;Obtener la ruta del directorio en donde estamos
		;47 Obtiene el directorio actual Disco DL = numero de la unidad del disco; DS:SI = puntador
		; al área del usuario de 64 bytes, la que contiene el
		; directorio; AX contiene el código de error

cic:	mov dl,0 ;unidad actual
    	mov si,offset ndir ;ds:si buffer
    	mov ah,47h ;Código para obtener ruta
    	int 21h ;Obtener ruta
    	jc erro;Saltar en caso de error

		;Calcular el tamaño de la cadena en que se almacenó el dato de la ruta
		mov cx, 0
        lenar ndir cx
        mov dx, cx

		;Desplegar ruta en la pantalla creada para emular lo que se muestra en dosbox al inicio
		mov ah, 13h
		mov al, 1
		mov bh, 00h
		mov bl, 1
		mov cx, lendir
		mov dh, renglon
		mov dl, 0
		mov bp, offset ndir
		int 10h

		;esperar usuario
		mov ah,00h
		int 16h
		inc renglon
		jmp cic
		
		
salida: 		
		pop ax
		mov ah,0
		int 10h
    	.exit 0

erro: .exit 1

end	