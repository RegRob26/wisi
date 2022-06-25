.model small
.386
include mshell.asm
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
extrn desdec:near
public comparaciones
.STACK

.data
dirupa db "\", 0
setdir db "\SHELL\", 0
ndirtemp db 64 dup('$'), 0
setloc db 64 dup('$')
narchivo db "helpfile.txt",0h
fid dw ?

lendirint dw ?

lendata dw 0
resultado db 1 dup (0)
contador dw 0
elegido dw 0
temporal db ?
bufer db ?
bufer2 db ?


.code
comparaciones:
        mov ax, @data
        mov ds, ax
        mov es, ax

        mov elegido, dx


        mov dl,0 ;unidad actual
    	mov si,offset ndirtemp ;ds:si buffer
    	mov ah,47h ;Código para obtener ruta
    	int 21h ;Obtener ruta
        call reto

        mov dx, offset dirupa
        mov ah, 3bh
        int 21h
        
        mov dx, offset setdir
        mov ah, 3bh
        int 21h

        mov dx, offset narchivo
        mov ah, 3Dh
        mov al, 0
        int 21h
        jc error_primero
        mov fid, ax

        mov ah,3Fh ;Código para leer archivo
        mov bx,fid ;Identificador
        mov cx,0fffh ;Tamaño deseado
        mov dx,offset bufer ;Dirección búfer
        int 21h ;Leer archivo
        jc error_segundo ;Si hubo error, procesar
        ;Colocar símbolo $ al final de cadena leída
        mov bx,ax
        add bx,offset bufer
        mov byte ptr[bx],'$'
        mov dx, offset bufer

        mov contador, 0
        mov si, 0
  cic_comp:
        mov dl, bufer[si]
        cmp dl, '%'
        jne continua

        inc contador
        mov bx, elegido
        cmp contador, bx         ;Este indica la cantidad de bloque que se desean 
                                ;omitir para la lectura del archivo
                                ;será un paso por pila puesto que todos los registros están siendo utilizados 
        jl continua             ;Olvidamos lo de paso de parámetros por pila, mejor en una variable para ser felices
       
        add si, 4
        
        mov bx, si
        mov di, 0
  copiar:
        
        mov dl, bufer[bx]
        mov temporal[di], dl

        inc bx
        inc di

        cmp dl, '%'
        jne copiar
        
        sub di, 1
        mov temporal[di], '$'
 
        mov dx, offset temporal
        mov ah, 09h
        int 21h
       

        jmp sal_file

 continua:
        inc si
        jmp cic_comp
 sal_file:
        
       ;clean_arr bufer 0fffh '?'  

        
        
        mov dx, offset narchivo
        mov ah, 3Dh
        mov al, 0
        int 21h


        mov si, 0
        mov setloc[si], "\"
        
        
 cic_chn:
        mov dl, ndirtemp[si]
        cmp dl, '$'
        je chn_dir
        inc si
        mov setloc[si], dl
        
        jmp cic_chn
 chn_dir:
        inc si
        mov setloc[si], 0h
   
        mov dx, offset setloc
        mov ah, 3bh
        int 21h
        
       ret
 error_primero:
        mov dx, 'A'
        call des4
        call reto
        .exit 1
 error_segundo:
        mov dx, 'B'
        call des4
        .exit 1
 error_main:
        .exit 1

end