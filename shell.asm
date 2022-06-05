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


pre_cad db 2 dup(?)
cadena db 18

comando db 50 dup(?)


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
		mov bl, 00000111b
		mov cx, lendir
		mov dh, renglon
		mov dl, 0
		mov bp, offset ndir
		int 10h


		; mov ah,00h
		; int 16h

		;esperar usuario
		
		call leecad
		
		;Por ahora se incrementa el renglón cuando se presiona cualquiere tecla
		;se cambiará a cuando sea enter lo que se presione
		add renglon, 02h		;25 renglones como máximo, después de eso se tiene que comenzar a 
								;desplazar la ventana hacia arriba para que se pueda seguir escribiendo
		cmp renglon, 25
		jge despan
		jmp cic

despan:	
		;Esta función desplaza la pantalla hacia arroba cuando se alcanza el tamaño
		;máximo de renglones, guardando la misma configuración que cuando los renglones
		;son permitidos
		mov ah, 06h
		mov al, 2
		mov ch, 1
		mov cl, 0		;mov dl, 80
		mov dh, 0
		int 10h
		;Decrementamos el renglón para mantener la última línea del directorio
		;en el último renglón permitido
		sub renglon, 02h

		jmp cic	


leecad: mov bx, dx
        sub dx, 02
        mov [bx-2], cl
        mov ah, 0Ah
        int 21h
        mov al, [bx-1]
        ret	

salida: 	
		pop ax
		mov ah,0
		int 10h
    	.exit 0

erro: .exit 1

end	