
;Declaración de los comandos existentes
.MODEL SMALL
.386
include macros.asm
include mshell.asm
public verificador
public ejecutador
extrn des4:near
extrn comparaciones:near
.DATA

outhandle dw ?
cexit 	db "exit-"
ccd		db "cd-"
ctouch	db "touch-"
cdir	db "dir-"
cmkdir 	db "mkdir-"	
crm		db "rm-"
crmdir	db "rmdir-"
ccls	db "cls-"

help 	db "&&help-"
helpt 	db "&help-"
patron 	db "*.*",0
BIEN   	db ">"
DTAI	db 21 dup(0)
attr 	db 0
time 	dw 0
date 	dw 0
sizel 	dw 0
sizeh 	dw 0
fname 	db 13 dup(0)

counter db ?
lenfname dw ?

divsizeH db 0
divsizeL db 0
renglon db 0
columna db 0

.STACK
.CODE

;comando [bp+4], lencomando [bp+6], flagverifica [bp+8], instrucciones [bp+10], leninstrucciones [bp+12]
verificador:
		push bp 
		mov bp, sp

		cld
		mov si,[bp+4]
		mov di,offset cexit
		mov cx,[bp+6]
		repe cmpsb 						;Se detendrá en dos posibles casos:
		jne com_cd					; -encontró una diferencia				; -CX llegó a 0.			
		
		mov bx, [bp+8]
		mov word ptr [bx], 1h
        jmp ret_ver

 com_cd:
		cld 
		mov si, [bp+4]
		mov di, offset ccd
		mov cx, [bp+6]
		repe cmpsb
		jne com_dir

		mov bx, [bp+8]
		mov word ptr [bx], 2h
		;jmp ret_ver

 help_cd:		
 		cld 
		mov si, [bp+10]
		mov di, offset help
		mov cx, 6
		repe cmpsb
		jne ret_ver
		mov bx, [bp+8]
		mov word ptr [bx], 21h

		jmp ret_ver
 com_dir:
		cld 
		mov si, [bp+4]
		mov di, offset cdir
		mov cx, [bp+6]
		repe cmpsb
		jne com_touch

		mov bx, [bp+8]
		mov word ptr [bx], 3h

  help_dir:		
 		cld 
		mov si, [bp+10]
		mov di, offset help
		mov cx, 6
		repe cmpsb
		jne ret_ver

		mov bx, [bp+8]
		mov word ptr [bx], 31h

		jmp ret_ver
 com_touch:
		cld 
		mov si, [bp+4]
		mov di, offset ctouch
		mov cx, [bp+6]
		repe cmpsb
		jne com_mkdir

		
		mov bx, [bp+8]
		mov word ptr [bx], 4h

  help_touch:		
 		cld 
		mov si, [bp+10]
		mov di, offset help
		mov cx, 6
		repe cmpsb
		jne ret_ver

		mov bx, [bp+8]
		mov word ptr [bx], 41h

		jmp ret_ver
 com_mkdir:
		cld 
		mov si, [bp+4]
		mov di, offset cmkdir
		mov cx, [bp+6]
		repe cmpsb
		jne com_rm
		
		mov bx, [bp+8]
		mov word ptr [bx], 5h
  help_mkdir:		
 		cld 
		mov si, [bp+10]
		mov di, offset help
		mov cx, 6
		repe cmpsb
		jne ret_ver


		mov bx, [bp+8]
		mov word ptr [bx], 51h

		jmp ret_ver
 com_rm:
		cld 
		mov si, [bp+4]
		mov di, offset crm
		mov cx, [bp+6]
		repe cmpsb
		jne com_rmdir
		
		mov bx, [bp+8]
		mov word ptr [bx], 6h
  help_rm:		
 		cld 
		mov si, [bp+10]
		mov di, offset help
		mov cx, 6
		repe cmpsb
		jne ret_ver


		mov bx, [bp+8]
		mov word ptr [bx], 61h

		
		jmp ret_ver

 com_rmdir:
		cld 
		mov si, [bp+4]
		mov di, offset crmdir
		mov cx, [bp+6]
		repe cmpsb
		jne com_cls

		mov bx, [bp+8]
		mov word ptr [bx], 7h

  help_rmdir:		
 		cld 
		mov si, [bp+10]
		mov di, offset help
		mov cx, 6
		repe cmpsb
		jne ret_ver


		mov bx, [bp+8]
		mov word ptr [bx], 71h

		jmp ret_ver


 com_cls:
		cld 
		mov si, [bp+4]
		mov di, offset ccls
		mov cx, [bp+6]
		repe cmpsb
		jne com_help

		mov bx, [bp+8]
		mov word ptr [bx], 8h

  help_cls:		
 		cld 
		mov si, [bp+10]
		mov di, offset help
		mov cx, 6
		repe cmpsb
		jne ret_ver


		mov bx, [bp+8]
		mov word ptr [bx], 81h

		jmp ret_ver

 com_help:
		cld 
		
		mov si, [bp+4]
		mov di, offset helpt
		mov cx, 5
		repe cmpsb
		jne ret_ver
		
		mov bx, [bp+8]
		mov word ptr [bx], 9h

 ret_ver:
		mov sp, bp
		pop bp
 		ret

;flagverifica [bp+4], instrucciones [bp+6], renglon [bp+8]

ejecutador:

		push bp
		mov bp, sp
		sub sp, 2

		mov bx, 0
		cmp [bp+4], bx
		jne flag_exit

		jmp ret_eje
 flag_exit:
		mov bx, 1
		cmp [bp+4], bx
		jne flag_cd
		.exit 0
 flag_cd:
		mov bx, 2
		cmp [bp+4], bx
		jne flag_helpcd
	
		mov ah, 3BH
		mov dx, [bp+6]
		int 21h
		jmp ret_eje
 flag_helpcd:
		mov bx, 21h
		cmp [bp+4], bx
		jne flag_dir

		mov dx, 4  
		call comparaciones
		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20

		jmp ret_eje
 flag_dir:
		cmp word ptr[bp+4], 3h
		jne flag_helpdir
		
		mov ah, 1Ah
		mov dx, offset DTAI
		int 21h
		call desdir

  desdir:

		mov dx, offset patron 
		mov cx, 10h
		mov ah, 4EH
		int 21h
		jc error_ex

		mov bx, [bp+8]
		mov dx, [bx]

		add dl, 1
		mov al, dl
		mov ah, dh
		mov dh, dl
		inc dh
		mov dl, ah
		sub dl, 3
		mov renglon, dh

		mov si,bp
		
		cadprint 2 dh dl fname

		mov dx, sizeh
		mov divsizeH, dh
		mov divsizeL, dl
		mov columna, 14

		mov dx, sizel
		mov divsizeH, dh
		mov divsizeL, dl
		mov columna, 18

		mov bp, offset fname
		
		;int 10h
		mov bp, si
		
		mov counter, 2		
 nf:    
 		clean_arr fname 13 0
 		mov ah,4Fh
        int 21h
        jc exit_dir
		mov dx, 1
		lenar fname lenfname dx
		
		mov bx, [bp+8]
		mov dx, [bx]

		add dl, counter
		mov al, dl

		mov ah, dh
		mov dh, dl
		inc dh
		mov dl, ah
		sub dl, 3
		mov renglon, dh

		mov si,bp

		cadprint lenfname dh dl fname
		

		;Para evitar imprimir el tamaño de los directorios . y ..
		cmp counter, 2
		jg ot_dir
		jmp con_dir


 ot_dir:
 		mov dx, sizeh
		mov divsizeH, dh
		mov divsizeL, dl
		mov columna, 15
		despnum divsizeL, divsizeH, renglon, columna
		
		mov dx, sizel
		mov divsizeH, dh
		mov divsizeL, dl
		mov columna, 19
		despnum divsizeL, divsizeH, renglon, columna
		
 con_dir:
		mov bp, si
		add counter, 1
		jmp nf

 exit_dir:
 		mov bx, [bp+8]
		mov dl, counter

		add byte ptr [bx], dl
		jmp ret_eje
 
 flag_helpdir:
		mov bx, 31h
		cmp [bp+4], bx
		jne flag_touch

		mov dx, 6  
		call comparaciones

		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20
		jmp ret_eje

 flag_touch:

		cmp word ptr[bp+4], 4h
		jne flag_helptouch

		mov dx, offset [bp+6]
    	mov cx, 0
    	mov ah, 3Ch
    	int 21h
    	mov outhandle, ax
    	jc  error_ex ;Aquí va salto a error
    	mov ah, 3Eh
    	mov bx, outhandle
	    int 21h

		jmp ret_eje


  flag_helptouch:
		mov bx, 41h
		cmp [bp+4], bx
		jne flag_mkdir

		mov dx, 8  
		call comparaciones

		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20
		jmp ret_eje

 flag_mkdir:
		cmp word ptr[bp+4], 5h
		jne flag_helpmkdir

		mov ah, 39h
		mov dx, [bp+6]
		int 21h
		jc error_ex

		jmp ret_eje
 flag_helpmkdir:
		mov bx, 51h
		cmp [bp+4], bx
		jne flag_rm

		mov dx, 10  
		call comparaciones

		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20
		jmp ret_eje
 flag_rm:
		cmp word ptr[bp+4], 6h
		jne flag_helprm

		mov ah, 41h
		mov dx,[bp+6]
		int 21h
		jc error_ex

		jmp ret_eje

 flag_helprm:
		mov bx, 61h
		cmp [bp+4], bx
		jne flag_rmdir

		mov dx, 12  
		call comparaciones

		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20
		jmp ret_eje
 flag_rmdir:
		cmp word ptr[bp+4], 7h
		jne flag_helprmdir

		mov ah, 3Ah
		mov dx,[bp+6]
		int 21h
		jc error_ex

		jmp ret_eje

 flag_helprmdir:
		mov bx, 71h
		cmp [bp+4], bx
		jne flag_cls

		mov dx, 14  
		call comparaciones

		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20
		jmp ret_eje
 flag_cls:
		cmp word ptr[bp+4], 8h
		jne flag_helpcls

		mov ax, 3
		int 10h

		mov bx, [bp+8]
		mov byte ptr [bx], -2
		int 10h
		
		jmp ret_eje
 
 flag_helpcls:
		mov bx, 81h
		cmp [bp+4], bx
		jne flag_helphelp

		mov dx, 16  
		call comparaciones

		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20
		jmp ret_eje

 flag_helphelp:

		mov bx, 9h
		cmp [bp+4], bx
		jne ret_eje

		mov dx, 18  
		call comparaciones

		mov bx, [bp+8]
		mov dl, counter
		add byte ptr [bx], 20
		jmp ret_eje

 ret_eje:
		mov sp, bp
		pop bp
		ret

 error_ex:
		print "error de ejecución"
		mov sp, bp
		pop bp
		ret

end
