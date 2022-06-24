.model small
.386
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
extrn desdec:near

.STACK

.data
temporal db ?
narchivo db "helpfile.txt",0h

fid dw ?

lendata dw 0
resultado db 1 dup (0)
contador dw 0
bufer db ?


.code
fopen  macro dir, nombre, type
local  error, read, create, sal1, write
       mov dx, offset nombre
       cmp type, 'w'
       je create
       cmp type, 'r'
       je read
       cmp type, 'r+'
       je write
       jmp error

 create:mov ah, 3Ch
       mov al, 0
       mov cx, 0
       int 21h
       jc error
       mov dir, ax
       jmp sal1
 read: mov ah, 3Dh
       mov al, 0
       int 21h
       jc error
       mov dir, ax
       jmp sal1
 write: mov ah, 3Dh
        mov al, 2
        int 21h
        jc error
        mov dir, ax
        jmp sal1
       
 error:mov dx, ax
       call des4
       .exit 1
 sal1: 
endm


main:   mov ax,@data
        mov ds,ax
        mov es,ax

        ;fopen  macro dir, nombre, type
        mov ax, 'r+'
        fopen fid narchivo ax
        

 lectu: 
        mov ah,3Fh ;Código para leer archivo
        mov bx,fid ;Identificador
        mov cx,0fffh ;Tamaño deseado
        mov dx,offset bufer ;Dirección búfer
        int 21h ;Leer archivo
        jc error_main ;Si hubo error, procesar
        ;Colocar símbolo $ al final de cadena leída
        mov bx,ax
        add bx,offset bufer
        mov byte ptr[bx],'$'

        ;ubicar el bloque que nos interesa
 comparaciones:
        mov si, 0
  cic_comp:
        mov dl, bufer[si]
        cmp dl, '%'
        jne continua

        inc contador
        cmp contador, 2         ;Este indica la cantidad de bloque que se desean 
                                ;omitir para la lectura del archivo
        jl continua
       
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
 
        call reto
        mov dx, offset temporal
        mov ah, 09h
        int 21h

        jmp sal_file

 continua:
        inc si
        jmp cic_comp

 sal_file:
        .exit 0
 error_main:
        .exit 1

end