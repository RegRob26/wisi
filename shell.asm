

.MODEL SMALL
.386
include ..\fun\macros.asm
extrn verificador:near
extrn ejecutador:near
.STACK
.DATA

DTA 	db 21 dup(0)
attr 	db 0
time 	dw 0
date 	dw 0
sizel 	dw 0
sizeh 	dw 0
fname 	db 13 dup(0)


BIEN 		db ">"
ndir 		db 164 dup('-')
lendir 		dw ?
renglon 	db ?
lencomando 	dw ?
flagverifi	dw ?


pre_cad 	db 2 dup(?)
cadena 		db 19 dup('-')
comando 	db 6 dup('-')
instrucciones db 14 dup('-'), 0


.CODE

;lenar es una macro que nos permite obtener la longitud de una cadena leída mediante la comparación 
;con un caracter del tipo ", este caracter es utilizado puesto que en la declaración de la cadena
;se hace uso de este caracter para la inicialización.

;Posiblemente en una futura versión se permita ingresar también el caracter que se busca para facilitar
;la reutilización de la macro
lenar 	macro cad, len
local cic1
        pusha
        mov bx, 0h
 cic1:  
 		mov dl, cad[bx]
        inc bx
        cmp dl, '-'
        jne cic1

        dec bx
		mov len, bx
		mov lendir, bx

        popa
endm

;sepcom es una macro que recibe dos cadenas y un registro de longitud de nombre len (este último se podría)
; (omitir puesto que realmente no tiene tanta importancia ya que el resultado se guarda en una variable)
;para separar el comando de los argumentos. cad es la cadena leída que incluye juntos el comando y sus 
;argumentos, se busca el factor de separación que es 0D o 20, es decir '\n' o ' '. para luego copiar
;el comando en una variable previamente definida y posteriormente copiará los argumentos
sepcom 	macro cad, com, instr, len
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

cic:	
		mov dl,0 ;unidad actual
    	mov si,offset ndir ;ds:si buffer
    	mov ah,47h ;Código para obtener ruta
    	int 21h ;Obtener ruta
    	jc erro;Saltar en caso de error

		;Calcular el tamaño de la cadena en que se almacenó el dato de la ruta
		mov cx, 0
        lenar ndir cx
		
		;Desplegar ruta en la pantalla creada para emular lo que se muestra en dosbox al inicio
		mov ah, 13h
		mov al, 1
		mov bh, 00h
		mov bl, 00000111b
		mov cx, 1
		mov dh, renglon
		mov dl, 0
		mov bp, offset BIEN
		int 10h

		mov ah, 13h
		mov al, 1
		mov bh, 00h
		mov bl, 00000111b
		mov cx, lendir
		mov dh, renglon
		mov dl, 2
		mov bp, offset ndir
		int 10h

		;Preparamos la lectura de la terminal y la guardamos dentro del arreglo con  nombre cadena
		;Tiene 
		mov cl, 19
		mov dx, offset cadena		
		call leecad

		mov cx, 0
		lenar cadena cx


		mov cx, 0
        sepcom cadena comando instrucciones cx 


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
		call clean_arr
		add renglon, 02h		;25 renglones como máximo, después de eso se tiene que comenzar a 
								;desplazar la ventana hacia arriba para que se pueda seguir escribiendo
		cmp renglon, 25
		jge despan
		jmp cic


;Esta función desplaza la pantalla hacia arroba cuando se alcanza el tamaño
;máximo de renglones, guardando la misma configuración que cuando los renglones
;son permitidos
despan:	
		mov ah, 6               ; http://www.ctyme.com/intr/rb-0096.htm
    	mov al, 2               ; number of lines to scroll
    	mov bh, 0               ; attribute
    	mov ch, 0               ; row top
    	mov cl, 0               ; col left
    	mov dh, 0             ; row bottom
    	mov dl, 80              ; ckittyol right
    	int 10h

		sub renglon, 02h
		jmp cic
;verificador se va a encargar de la interpretación del comando y la correcta elección del comando ingresado
;puesto que los comando están previamente definidos se opta por directamente referenciarlos en la función
;para reducir los parámetros. Además de la nula variación del lugar donde se encuentra comando se opta por seguir
;la misma relación que para los demás parámetros
;!Posiblemente comando sea pasado mediante la pila a esta función
;!Agregar un parámetro a la función para que retorne un código según el comando interpretado
;! HECHAS: exit, dir, mkdir, touch, rm, rmdir
;!TODO cd




ejecucionComandos:



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

;Desar permite desplegar una cadena dada su dirección y tamaño. Nos la muestra en valores hexadecimales

desar: 
 		cld
        mov si, offset instrucciones
        mov cx, 14
 cic1:  
 		lodsb
        mov dx, ax
        ;call des2
        ;call spc
        loop cic1
        ret

;El principal funcionamiento de clean_array es limpiar el arreglo que lee los comandos y sus 
;argumentos para posteriormente dejarlo como si recien hubiera sido creado, de esta manera
;evitamos que hay sobreposición de datos
clean_arr:

		cld
		mov di, offset comando
		mov cx, 6
		mov ax, '-'

 cic_cle:
		stosb
		loop cic_cle

		cld 
		mov di, offset cadena
		mov cx, 18
		mov ax, '-'

 cic_cals:
		stosb
		loop cic_cals

		cld 
		mov di, offset instrucciones
		mov cx, 12
		mov ax, '-'
 cic_ins:
 		stosb
		loop cic_ins
 cic_ndir:
		cld
		mov di, offset ndir
		mov cx, 164
		mov ax, '-'

 cic_cdir:
		stosb
		loop cic_cdir	
		ret


salida: 	
		pop ax
		mov ah,0
		int 10h
    	.exit 0

erro: .exit 1

end	