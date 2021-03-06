

.MODEL SMALL
.386
include macros.asm
include mshell.asm
extrn verificador:near
extrn ejecutador:near
extrn desdir:near


.STACK
.DATA
DTA 	db 21 dup(0)
attr 	db 0
time 	dw 0
date 	dw 0
sizel 	dw 0
sizeh 	dw 0
fname 	db 13 dup(0)


BIEN 		db "> \"
ndir 		db 164 dup('-')
lendir 		dw ?
renglon 	db ?
lencomando 	dw ?
flagverifi	dw ?


pre_cad 	db 2 dup(?)
cadena 		db 30 dup('-')
comando 	db 6 dup('-')
instrucciones db 25 dup('-'), 0


.CODE

main:   
		mov ax, @data
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

		mov flagverifi, 0 		;0 será el neutro para nuestras ejecuciones
		;Obtener la ruta del directorio en donde estamos
		;47 Obtiene el directorio actual Disco DL = numero de la unidad del disco; DS:SI = puntador
		; al área del usuario de 64 bytes, la que contiene el
		; directorio; AX contiene el código de error
		;call lectu
cic:	
		mov dl,0 ;unidad actual
    	mov si,offset ndir ;ds:si buffer
    	mov ah,47h ;Código para obtener ruta
    	int 21h ;Obtener ruta
    	jc erro;Saltar en caso de error

		; mov sp, 8

		;Calcular el tamaño de la cadena en que se almacenó el dato de la ruta
		
		mov cx, 0
        lenar ndir lendir cx

		mov di, 3
		mov dl, 0

		cadprint di renglon dl BIEN
		cadprint lendir renglon 3 ndir

		;Preparamos la lectura de la terminal y la guardamos dentro del arreglo con  nombre cadena
		;Tiene 
		mov cl, 30
		mov dx, offset cadena		
		call leecad

		mov cx, 0
		lenar cadena lendir cx
        sepcom cadena comando instrucciones  

		mov bx, offset instrucciones
		push bx
		mov bx, offset flagverifi			;[bp+8]
		push bx
		mov dx, lencomando			;[bp + 6]
		push dx					
		mov dx, offset comando		;[bp+4]
		push dx
		call verificador
		add sp, 8

		mov dx, offset renglon			;[bp + 8]
		push dx					
		mov dx, offset instrucciones ;[bp+6]
		push dx
		mov dx, flagverifi		;[bp+4]
		push dx
		call ejecutador
		add sp, 6
		mov flagverifi, 0
continua:

		clean_arr comando 6 '-'
		clean_arr cadena 30 '-'
		clean_arr instrucciones 25 '-'
		clean_arr ndir 164 '-'
		
		add renglon, 02h		;25 renglones como máximo, después de eso se tiene que comenzar a 
								;desplazar la ventana hacia arriba para que se pueda seguir escribiendo
		cmp renglon, 25
		jge despan
		jmp cic

;Esta función desplaza la pantalla hacia arroba cuando se alcanza el tamaño
;máximo de renglones, guardando la misma configuración que cuando los renglones
;son permitidos
despan:	
		; mov dl, renglon
		; sub dl, 24

		mov ah, 6               
    	mov al, 2              ; Líneas a hacer scroll
    	mov bh, 0               ; attribute
    	mov ch, 0               ; renglon superior
    	mov cl, 0               ; columna izquierda
    	mov dh, 0             	; renglon inferior
    	mov dl, 80              ; columna derecha
    	int 10h

		sub renglon, 02h
		cmp renglon, 25
		jge despan
		jmp cic
;verificador se va a encargar de la interpretación del comando y la correcta elección del comando ingresado
;puesto que los comando están previamente definidos se opta por directamente referenciarlos en la función
;para reducir los parámetros. Además de la nula variación del lugar donde se encuentra comando se opta por seguir
;la misma relación que para los demás parámetros
;!Posiblemente comando sea pasado mediante la pila a esta función
;!Agregar un parámetro a la función para que retorne un código según el comando interpretado
;! HECHAS: exit, dir, mkdir, touch, rm, rmdir
;!TODO cd

;leecad es la función utilizada para leer la cadena dada por el usuario. Tiene un tamaño máximo restringido
;de 18 caracteres puesto que no se permiten cadenas demasiado largas por simplicidad del funcionamiento
;del programa. Hace uso de la función 0Ah de la interrupción 21
leecad: 
		mov bx, dx
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
